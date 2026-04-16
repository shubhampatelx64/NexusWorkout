//
//  PlanSeeder.swift
//  NexusWorkout
//
//  One-time bootstrap of the local SwiftData store from the 12-week recomp
//  plan.  Called from `NexusWorkoutApp.task` on every launch; guarded by a
//  UserDefaults flag so it runs exactly once per install.
//
//  Bump `seedVersion` when the seed content changes in a way that should
//  re-hydrate an existing install.
//

import Foundation
import SwiftData

enum PlanSeeder {

    /// Increment when seed content changes materially (e.g. form cues rewritten,
    /// new exercises added, meal plan revised).  This is a one-time migration
    /// key — not a per-launch version check.
    private static let seedVersion = 1
    private static let seededKey   = "PlanSeeder.hasSeeded.v\(seedVersion)"

    // MARK: - Entry point

    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: seededKey) else { return }
        seed(into: context)
        UserDefaults.standard.set(true, forKey: seededKey)
    }

    // MARK: - Seed

    @MainActor
    static func seed(into context: ModelContext) {
        // 1. Exercises — must come first; workouts reference these.
        let exercises = ExerciseCatalog.all()
        for ex in exercises { context.insert(ex) }
        let byName = Dictionary(uniqueKeysWithValues: exercises.map { ($0.name, $0) })

        // 2. Workouts — wired up in P1.2b.
        //    let workouts = WorkoutCatalog.all(using: byName)
        //    workouts.forEach { context.insert($0) }

        // 3. Meals — wired up in P1.2b.
        //    MealCatalog.all().forEach { context.insert($0) }

        // 4. Supplements — wired up in P1.2b.
        //    SupplementCatalog.all().forEach { context.insert($0) }

        // 5. Baseline blood report — wired up in P1.2b.
        //    let baseline = BaselineBloodReport.make()
        //    context.insert(baseline)

        _ = byName  // silence unused until P1.2b wires the rest

        do {
            try context.save()
        } catch {
            assertionFailure("PlanSeeder save failed: \(error)")
        }
    }

    // MARK: - Debug helpers

    /// Wipes the seed flag so the next launch re-runs the seeder.
    /// Bound to a hidden gesture in Settings later.
    static func resetFlag() {
        UserDefaults.standard.removeObject(forKey: seededKey)
    }

    /// True iff the seeder has already run on this install.
    static var hasSeeded: Bool {
        UserDefaults.standard.bool(forKey: seededKey)
    }
}
