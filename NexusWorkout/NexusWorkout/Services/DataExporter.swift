//
//  DataExporter.swift
//  NexusWorkout
//
//  JSON snapshot of everything the user has logged.  Seed data
//  (exercises, workout templates, meal templates, the baseline blood
//  report) is deliberately excluded — it's reproducible from the
//  catalogs, so including it would bloat the file and slow down
//  human-readable diffing.
//
//  Photo data is excluded too; this is a text export, and anyone
//  actually wanting photos can AirDrop the originals.
//

import Foundation
import SwiftData

enum DataExporter {

    // MARK: - Public API

    /// Returns a pretty-printed JSON blob of all user-logged data.
    /// Returns nil if fetch/encode fails — not expected in practice.
    @MainActor
    static func exportJSON(from context: ModelContext) -> Data? {
        let doc = buildDocument(from: context)
        let encoder = JSONEncoder()
        encoder.outputFormatting    = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(doc)
    }

    /// Writes the JSON to a temp file and returns the URL so a
    /// SwiftUI `ShareLink` can hand it to the share sheet.
    @MainActor
    static func writeTemporaryFile(from context: ModelContext) -> URL? {
        guard let data = exportJSON(from: context) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmm"
        let fileName = "nexusworkout-\(formatter.string(from: .now)).json"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            return nil
        }
    }

    // MARK: - Build

    @MainActor
    private static func buildDocument(from context: ModelContext) -> ExportDocument {
        let metrics  = (try? context.fetch(FetchDescriptor<BodyMetric>()))      ?? []
        let sessions = (try? context.fetch(FetchDescriptor<WorkoutSession>()))  ?? []
        let meals    = (try? context.fetch(FetchDescriptor<MealLog>()))         ?? []
        let sups     = (try? context.fetch(FetchDescriptor<SupplementLog>()))   ?? []
        let dailies  = (try? context.fetch(FetchDescriptor<DailyLog>()))        ?? []

        return ExportDocument(
            exportedAt: .now,
            profile: .init(
                name:             UserProfile.name,
                sex:              UserProfile.sex,
                age:              UserProfile.age,
                heightCm:         UserProfile.heightCm,
                startingWeightKg: UserProfile.startingWeightKg,
                goalWeightKg:     UserProfile.goalWeightKg
            ),
            bodyMetrics: metrics.sorted { $0.date < $1.date }.map(BodyMetricDTO.init),
            workoutSessions: sessions.sorted { $0.date < $1.date }.map(WorkoutSessionDTO.init),
            mealLogs: meals.sorted { $0.date < $1.date }.map(MealLogDTO.init),
            supplementLogs: sups.sorted { $0.date < $1.date }.map(SupplementLogDTO.init),
            dailyLogs: dailies.sorted { $0.date < $1.date }.map(DailyLogDTO.init)
        )
    }
}

// MARK: - DTOs

struct ExportDocument: Codable {
    struct Profile: Codable {
        let name: String
        let sex: String
        let age: Int
        let heightCm: Double
        let startingWeightKg: Double
        let goalWeightKg: Double
    }

    let exportedAt: Date
    let profile: Profile
    let bodyMetrics: [BodyMetricDTO]
    let workoutSessions: [WorkoutSessionDTO]
    let mealLogs: [MealLogDTO]
    let supplementLogs: [SupplementLogDTO]
    let dailyLogs: [DailyLogDTO]
}

struct BodyMetricDTO: Codable {
    let date: Date
    let weightKg: Double?
    let waistCm: Double?
    let chestCm: Double?
    let hipsCm: Double?
    let thighCm: Double?
    let notes: String?

    init(_ m: BodyMetric) {
        self.date     = m.date
        self.weightKg = m.weightKg
        self.waistCm  = m.waistCm
        self.chestCm  = m.chestCm
        self.hipsCm   = m.hipsCm
        self.thighCm  = m.thighCm
        self.notes    = m.notes
    }
}

struct LoggedSetDTO: Codable {
    let setNumber: Int
    let weightKg: Double
    let reps: Int
    let rir: Int?
    let isWarmup: Bool
    let completedAt: Date

    init(_ s: LoggedSet) {
        self.setNumber   = s.setNumber
        self.weightKg    = s.weight
        self.reps        = s.reps
        self.rir         = s.rir
        self.isWarmup    = s.isWarmup
        self.completedAt = s.completedAt
    }
}

struct LoggedExerciseDTO: Codable {
    let order: Int
    let exerciseName: String?
    let sets: [LoggedSetDTO]

    init(_ lx: LoggedExercise) {
        self.order        = lx.order
        self.exerciseName = lx.exercise?.name
        self.sets         = lx.sets
            .sorted { $0.setNumber < $1.setNumber }
            .map(LoggedSetDTO.init)
    }
}

struct WorkoutSessionDTO: Codable {
    let date: Date
    let templateName: String?
    let notes: String?
    let durationMinutes: Int?
    let completed: Bool
    let loggedExercises: [LoggedExerciseDTO]

    init(_ s: WorkoutSession) {
        self.date             = s.date
        self.templateName     = s.template?.name
        self.notes            = s.notes
        self.durationMinutes  = s.durationMinutes
        self.completed        = s.completed
        self.loggedExercises  = s.loggedExercises
            .sorted { $0.order < $1.order }
            .map(LoggedExerciseDTO.init)
    }
}

struct MealLogDTO: Codable {
    let date: Date
    let mealType: String
    let items: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double

    init(_ m: MealLog) {
        self.date     = m.date
        self.mealType = m.mealType
        self.items    = m.items
        self.calories = m.calories
        self.protein  = m.protein
        self.carbs    = m.carbs
        self.fat      = m.fat
    }
}

struct SupplementLogDTO: Codable {
    let date: Date
    let supplementName: String?
    let taken: Bool

    init(_ l: SupplementLog) {
        self.date           = l.date
        self.supplementName = l.supplement?.name
        self.taken          = l.taken
    }
}

struct DailyLogDTO: Codable {
    let date: Date
    let sleepHours: Double?
    let sleepQuality: Int?
    let energy: Int?
    let hunger: Int?
    let waterLiters: Double?
    let steps: Int?
    let mood: String?
    let proteinHit: Bool?
    let workoutCompleted: Bool?

    init(_ d: DailyLog) {
        self.date             = d.date
        self.sleepHours       = d.sleepHours
        self.sleepQuality     = d.sleepQuality
        self.energy           = d.energy
        self.hunger           = d.hunger
        self.waterLiters      = d.waterLiters
        self.steps            = d.steps
        self.mood             = d.mood
        self.proteinHit       = d.proteinHit
        self.workoutCompleted = d.workoutCompleted
    }
}
