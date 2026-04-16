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
        //    Form diagrams (ASCII) for the 11 primary lifts are attached
        //    here so PrimaryLifts.swift stays free of long raw strings.
        let exercises = ExerciseCatalog.all()
        for ex in exercises {
            let diagram = PrimaryLiftDiagrams.diagram(for: ex.name)
            if !diagram.isEmpty { ex.formDiagramText = diagram }
            context.insert(ex)
        }
        let byName = Dictionary(uniqueKeysWithValues: exercises.map { ($0.name, $0) })

        // 2. Workouts — 5-day and 6-day templates, with their TemplateExercise
        //    rows resolved by name from the dict above.
        let workouts = WorkoutCatalog.all(using: byName)
        for wt in workouts { context.insert(wt) }

        // 3. Meals — 35 templates, 7 days × 5 slots.
        for meal in MealCatalog.all() { context.insert(meal) }

        // 4. Supplements — 6 schedules with default reminder times.
        for supp in SupplementCatalog.all() { context.insert(supp) }

        // 5. Baseline blood report — the panel the plan was written against.
        //    Cascades to ~25 markers via the report's `markers` relationship.
        context.insert(BaselineBloodReport.make())

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
