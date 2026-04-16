//
//  NexusWorkoutApp.swift
//  NexusWorkout
//
//  Personal 12-week body recomp tracking app.
//

import SwiftUI
import SwiftData

@main
struct NexusWorkoutApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(
                for:
                    Exercise.self,
                    WorkoutTemplate.self,
                    TemplateExercise.self,
                    WorkoutSession.self,
                    LoggedExercise.self,
                    LoggedSet.self,
                    MealTemplate.self,
                    MealLog.self,
                    BodyMetric.self,
                    ProgressPhoto.self,
                    DailyLog.self,
                    SupplementSchedule.self,
                    SupplementLog.self,
                    BloodReport.self,
                    BloodMarker.self,
                    ReminderConfig.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
                .tint(DS.Color.accentPrimary)
                .task {
                    // One-time seed of exercises / workouts / meals / etc.
                    // Guarded by a UserDefaults flag — see PlanSeeder.
                    PlanSeeder.seedIfNeeded(context: modelContainer.mainContext)
                }
        }
        .modelContainer(modelContainer)
    }
}
