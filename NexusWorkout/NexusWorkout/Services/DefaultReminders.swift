//
//  DefaultReminders.swift
//  NexusWorkout
//
//  Factory for the out-of-the-box notification schedule.  Ten
//  reminders covering the daily rhythm:
//
//      08:00  Breakfast
//      10:00  Water check
//      11:00  Mid-morning snack
//      13:30  Lunch
//      14:00  Water check
//      16:00  Water check
//      17:00  Afternoon snack
//      18:00  Workout (Mon/Tue/Wed/Fri/Sat — the 5-day split)
//      20:00  Dinner
//      22:30  Wind-down
//
//  Supplement reminders are generated separately from the live
//  SupplementSchedule rows (same HH:mm grouping collapses a stack
//  into one ping, e.g. D3 + B-Complex both at 08:30).
//

import Foundation

enum DefaultReminders {

    // MARK: - Daily rhythm

    static func all() -> [ReminderConfig] {
        [
            // Meals
            ReminderConfig(
                type: "meal",
                title: "Breakfast",
                body: "Breakfast slot — hit your protein target.",
                time: "08:00"
            ),
            ReminderConfig(
                type: "meal",
                title: "Mid-morning snack",
                body: "Small snack — keep energy steady.",
                time: "11:00"
            ),
            ReminderConfig(
                type: "meal",
                title: "Lunch",
                body: "Lunch time — aim for 40-50 g protein.",
                time: "13:30"
            ),
            ReminderConfig(
                type: "meal",
                title: "Afternoon snack",
                body: "Quick snack — pre-workout fuel.",
                time: "17:00"
            ),
            ReminderConfig(
                type: "meal",
                title: "Dinner",
                body: "Dinner — close out today's macros.",
                time: "20:00"
            ),

            // Workout — 5-day split lands Mon/Tue/Wed/Fri/Sat.
            ReminderConfig(
                type: "workout",
                title: "Time to train",
                body: "Today's lift is waiting in the Today tab.",
                time: "18:00",
                daysOfWeek: [1, 2, 3, 5, 6]
            ),

            // Water — three nudges through the day to hit 4 L.
            ReminderConfig(
                type: "water",
                title: "Water check",
                body: "Halfway to 4 L by noon?",
                time: "10:00"
            ),
            ReminderConfig(
                type: "water",
                title: "Water check",
                body: "Keep sipping — kidney-stone risk, remember.",
                time: "14:00"
            ),
            ReminderConfig(
                type: "water",
                title: "Water check",
                body: "Afternoon top-up.",
                time: "16:00"
            ),

            // Sleep
            ReminderConfig(
                type: "sleep",
                title: "Wind-down",
                body: "Screens down — 7.5 h sleep window starts now.",
                time: "22:30"
            ),
        ]
    }

    // MARK: - Supplement reminders (derived)

    /// One reminder per distinct timeOfDay — multiple supplements
    /// scheduled for the same minute collapse into a single ping
    /// whose body lists them all.
    static func supplementReminders(from schedules: [SupplementSchedule]) -> [ReminderConfig] {
        let active = schedules.filter { $0.enabled && $0.timeOfDay != nil }
        let grouped = Dictionary(grouping: active) { $0.timeOfDay! }

        return grouped
            .map { time, list in
                let names = list.map(\.name).joined(separator: ", ")
                return ReminderConfig(
                    type:  "supplement",
                    title: list.count == 1 ? list[0].name : "Supplements",
                    body:  names,
                    time:  time
                )
            }
            .sorted { $0.time < $1.time }
    }
}
