//
//  NotificationService.swift
//  NexusWorkout
//
//  Thin wrapper over UNUserNotificationCenter that turns a set of
//  ReminderConfig rows into scheduled local notifications.
//
//  Core guarantees:
//    * Idempotent — calling `sync` twice with the same configs ends
//      with exactly the same set of pending requests.
//    * Subset-aware — a config whose `daysOfWeek` covers all 7 days
//      is scheduled as ONE daily trigger; subsets get one trigger
//      per day so iOS's weekday filter applies.
//    * Self-cleaning — any previously-issued identifiers stored on a
//      config are cancelled before new ones are added, so disabling
//      and re-enabling a reminder never leaves ghosts behind.
//

import Foundation
import SwiftData
import UserNotifications

enum NotificationService {

    // MARK: - Authorization

    /// Requests alert + sound + badge.  Returns the granted state.
    /// Silently returns false on error — the caller's fallback is
    /// "just don't schedule anything" which is the safe behaviour.
    static func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    static func authorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    // MARK: - Sync

    /// Rebuilds all pending notifications from the given configs.
    /// Mutates each config's `notificationIds` in place so the next
    /// sync knows what to cancel — caller is responsible for saving
    /// the context afterwards.
    @MainActor
    static func sync(configs: [ReminderConfig], context: ModelContext) async {
        let center = UNUserNotificationCenter.current()

        // 1. Cancel everything we previously scheduled.
        let previous = configs.flatMap { $0.notificationIds }
        if !previous.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: previous)
        }
        for config in configs { config.notificationIds = [] }

        // 2. Rebuild.
        for config in configs where config.enabled {
            guard let (hour, minute) = parseTime(config.time) else { continue }
            let ids = await schedule(
                config: config,
                hour: hour,
                minute: minute,
                center: center
            )
            config.notificationIds = ids
        }

        try? context.save()
    }

    // MARK: - Scheduling

    private static func schedule(
        config: ReminderConfig,
        hour: Int,
        minute: Int,
        center: UNUserNotificationCenter
    ) async -> [String] {
        let content = UNMutableNotificationContent()
        content.title = config.title
        content.body  = config.body
        content.sound = .default

        // One daily trigger when all 7 days are selected, otherwise
        // one per weekday.
        if Set(config.daysOfWeek) == Set(1...7) {
            var comps = DateComponents()
            comps.hour   = hour
            comps.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
            let id = config.id.uuidString
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            do {
                try await center.add(request)
                return [id]
            } catch {
                return []
            }
        }

        var added: [String] = []
        for day in config.daysOfWeek {
            var comps = DateComponents()
            comps.hour    = hour
            comps.minute  = minute
            comps.weekday = isoToCalendarWeekday(day)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
            let id = "\(config.id.uuidString)-\(day)"
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            do {
                try await center.add(request)
                added.append(id)
            } catch {
                continue
            }
        }
        return added
    }

    // MARK: - Helpers

    private static func parseTime(_ s: String) -> (Int, Int)? {
        let parts = s.split(separator: ":")
        guard parts.count == 2,
              let h = Int(parts[0]), (0...23).contains(h),
              let m = Int(parts[1]), (0...59).contains(m) else {
            return nil
        }
        return (h, m)
    }

    /// ISO weekday (1=Mon..7=Sun) → Calendar.weekday (1=Sun..7=Sat).
    private static func isoToCalendarWeekday(_ iso: Int) -> Int {
        (iso % 7) + 1
    }
}
