//
//  PlanTargets.swift
//  NexusWorkout
//
//  Single source of truth for the 12-week plan's daily targets.
//  Kept separate from Models so views / tests can read targets without
//  pulling in SwiftData, and so we have one place to bump numbers if
//  the plan ever updates.
//

import Foundation

enum PlanTargets {

    // MARK: - Daily macros (constant across the 12 weeks)

    static let calories: Int    = 1980
    static let protein:  Double = 180   // g
    static let carbs:    Double = 180   // g
    static let fat:      Double = 60    // g

    // MARK: - Hydration

    /// Aggressive vs. typical guidance — Mumbai climate plus elevated
    /// calcium-oxalate crystals on the baseline panel. See section 1.
    static let waterLiters: Double = 4.0
    static let waterCups:   Int    = 8     // 500 ml each

    // MARK: - Recovery / activity

    static let sleepHoursTarget: Double = 7.5
    static let stepsTarget:      Int    = 10_000

    // MARK: - Plan calendar

    static let planLengthWeeks: Int = 12
    static let planLengthDays:  Int = 84

    /// First-launch date is recorded in UserDefaults so `dayOfPlan`
    /// stays anchored across app restarts.  Reset by deleting + reinstalling.
    private static let startDateKey = "PlanTargets.planStartDate"

    static var planStartDate: Date {
        if let stored = UserDefaults.standard.object(forKey: startDateKey) as? Date {
            return stored
        }
        let today = Calendar.current.startOfDay(for: .now)
        UserDefaults.standard.set(today, forKey: startDateKey)
        return today
    }

    static var dayOfPlan: Int {
        let cal   = Calendar.current
        let start = cal.startOfDay(for: planStartDate)
        let now   = cal.startOfDay(for: .now)
        let days  = cal.dateComponents([.day], from: start, to: now).day ?? 0
        return max(1, days + 1)
    }

    static var weekOfPlan: Int {
        max(1, (dayOfPlan + 6) / 7)
    }
}
