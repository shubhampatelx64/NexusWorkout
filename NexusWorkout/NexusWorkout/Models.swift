//
//  Models.swift
//  NexusWorkout
//
//  All SwiftData @Model definitions.  Kept in one file in Phase 1 for ease of
//  iteration; split into separate files if/when this grows past ~600 lines.
//
//  Conventions:
//    - All models have a UUID `id` field initialised to UUID() by default.
//    - Relationships use explicit `@Relationship` with sensible delete rules.
//    - Default values on every property so SwiftData migrations stay simple.
//    - Weights in kg, distances in cm, energy in kcal.
//

import Foundation
import SwiftData

// MARK: - Workout domain

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var name: String
    var primaryMuscles: String      // comma-separated
    var formCues: String            // markdown
    var commonMistakes: String      // markdown
    var formDiagramText: String     // ASCII, monospaced
    var category: String            // "compound" | "isolation" | "core"

    init(
        id: UUID = UUID(),
        name: String,
        primaryMuscles: String,
        formCues: String = "",
        commonMistakes: String = "",
        formDiagramText: String = "",
        category: String = "compound"
    ) {
        self.id = id
        self.name = name
        self.primaryMuscles = primaryMuscles
        self.formCues = formCues
        self.commonMistakes = commonMistakes
        self.formDiagramText = formDiagramText
        self.category = category
    }
}

@Model
final class WorkoutTemplate {
    @Attribute(.unique) var id: UUID
    var name: String                // "Upper Push", "Lower A", ...
    var dayOfWeek: Int?             // 1=Mon..7=Sun, nil if flexible
    var split: String               // "5-day" | "6-day"
    var notes: String?

    @Relationship(deleteRule: .cascade, inverse: \TemplateExercise.template)
    var exercises: [TemplateExercise] = []

    init(
        id: UUID = UUID(),
        name: String,
        dayOfWeek: Int? = nil,
        split: String,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.dayOfWeek = dayOfWeek
        self.split = split
        self.notes = notes
    }
}

@Model
final class TemplateExercise {
    @Attribute(.unique) var id: UUID
    var order: Int
    var targetSets: Int
    var repRangeLow: Int
    var repRangeHigh: Int
    var restSeconds: Int
    var notes: String?

    var exercise: Exercise?
    var template: WorkoutTemplate?

    init(
        id: UUID = UUID(),
        exercise: Exercise,
        order: Int,
        targetSets: Int,
        repRangeLow: Int,
        repRangeHigh: Int,
        restSeconds: Int,
        notes: String? = nil
    ) {
        self.id = id
        self.exercise = exercise
        self.order = order
        self.targetSets = targetSets
        self.repRangeLow = repRangeLow
        self.repRangeHigh = repRangeHigh
        self.restSeconds = restSeconds
        self.notes = notes
    }
}

// MARK: - Workout logging

@Model
final class WorkoutSession {
    @Attribute(.unique) var id: UUID
    var date: Date
    var template: WorkoutTemplate?
    var notes: String?
    var durationMinutes: Int?
    var completed: Bool

    @Relationship(deleteRule: .cascade, inverse: \LoggedExercise.session)
    var loggedExercises: [LoggedExercise] = []

    init(
        id: UUID = UUID(),
        date: Date = .now,
        template: WorkoutTemplate? = nil,
        notes: String? = nil,
        durationMinutes: Int? = nil,
        completed: Bool = false
    ) {
        self.id = id
        self.date = date
        self.template = template
        self.notes = notes
        self.durationMinutes = durationMinutes
        self.completed = completed
    }
}

@Model
final class LoggedExercise {
    @Attribute(.unique) var id: UUID
    var order: Int
    var exercise: Exercise?
    var session: WorkoutSession?

    @Relationship(deleteRule: .cascade, inverse: \LoggedSet.loggedExercise)
    var sets: [LoggedSet] = []

    init(id: UUID = UUID(), exercise: Exercise, order: Int) {
        self.id = id
        self.exercise = exercise
        self.order = order
    }
}

@Model
final class LoggedSet {
    @Attribute(.unique) var id: UUID
    var setNumber: Int
    var weight: Double              // kg
    var reps: Int
    var rir: Int?                   // reps in reserve
    var isWarmup: Bool
    var completedAt: Date

    var loggedExercise: LoggedExercise?

    init(
        id: UUID = UUID(),
        setNumber: Int,
        weight: Double,
        reps: Int,
        rir: Int? = nil,
        isWarmup: Bool = false,
        completedAt: Date = .now
    ) {
        self.id = id
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.rir = rir
        self.isWarmup = isWarmup
        self.completedAt = completedAt
    }
}

// MARK: - Nutrition

@Model
final class MealTemplate {
    @Attribute(.unique) var id: UUID
    var name: String
    var dayOfWeek: Int              // 1..7
    var mealType: String            // breakfast | snack | lunch | snack | pre | post | dinner
    var items: String
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var suggestedTime: String       // "HH:mm"

    init(
        id: UUID = UUID(),
        name: String,
        dayOfWeek: Int,
        mealType: String,
        items: String,
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        suggestedTime: String
    ) {
        self.id = id
        self.name = name
        self.dayOfWeek = dayOfWeek
        self.mealType = mealType
        self.items = items
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.suggestedTime = suggestedTime
    }
}

@Model
final class MealLog {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mealType: String
    var items: String
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var template: MealTemplate?
    @Attribute(.externalStorage) var photoData: Data?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        mealType: String,
        items: String,
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        template: MealTemplate? = nil,
        photoData: Data? = nil
    ) {
        self.id = id
        self.date = date
        self.mealType = mealType
        self.items = items
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.template = template
        self.photoData = photoData
    }
}

// MARK: - Body metrics

@Model
final class BodyMetric {
    @Attribute(.unique) var id: UUID
    var date: Date
    var weightKg: Double?
    var waistCm: Double?
    var chestCm: Double?
    var hipsCm: Double?
    var thighCm: Double?
    var notes: String?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        weightKg: Double? = nil,
        waistCm: Double? = nil,
        chestCm: Double? = nil,
        hipsCm: Double? = nil,
        thighCm: Double? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.weightKg = weightKg
        self.waistCm = waistCm
        self.chestCm = chestCm
        self.hipsCm = hipsCm
        self.thighCm = thighCm
        self.notes = notes
    }
}

@Model
final class ProgressPhoto {
    @Attribute(.unique) var id: UUID
    var date: Date
    var pose: String                // "front" | "side" | "back" | "flexed"
    @Attribute(.externalStorage) var imageData: Data

    init(id: UUID = UUID(), date: Date = .now, pose: String, imageData: Data) {
        self.id = id
        self.date = date
        self.pose = pose
        self.imageData = imageData
    }
}

// MARK: - Daily journal

@Model
final class DailyLog {
    @Attribute(.unique) var id: UUID
    var date: Date                  // unique per calendar day
    var sleepHours: Double?
    var sleepQuality: Int?          // 1-10
    var energy: Int?                // 1-10
    var hunger: Int?                // 1-10
    var waterLiters: Double?
    var steps: Int?
    var mood: String?
    var proteinHit: Bool?
    var workoutCompleted: Bool?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        sleepHours: Double? = nil,
        sleepQuality: Int? = nil,
        energy: Int? = nil,
        hunger: Int? = nil,
        waterLiters: Double? = nil,
        steps: Int? = nil,
        mood: String? = nil,
        proteinHit: Bool? = nil,
        workoutCompleted: Bool? = nil
    ) {
        self.id = id
        self.date = date
        self.sleepHours = sleepHours
        self.sleepQuality = sleepQuality
        self.energy = energy
        self.hunger = hunger
        self.waterLiters = waterLiters
        self.steps = steps
        self.mood = mood
        self.proteinHit = proteinHit
        self.workoutCompleted = workoutCompleted
    }
}

// MARK: - Supplements

@Model
final class SupplementSchedule {
    @Attribute(.unique) var id: UUID
    var name: String
    var dose: String
    var timing: String              // "morning" | "with-food" | "pre-workout" | "post-workout" | "bed"
    var timeOfDay: String?          // "HH:mm" if a notification time is set
    var enabled: Bool

    init(
        id: UUID = UUID(),
        name: String,
        dose: String,
        timing: String,
        timeOfDay: String? = nil,
        enabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.dose = dose
        self.timing = timing
        self.timeOfDay = timeOfDay
        self.enabled = enabled
    }
}

@Model
final class SupplementLog {
    @Attribute(.unique) var id: UUID
    var date: Date
    var supplement: SupplementSchedule?
    var taken: Bool

    init(
        id: UUID = UUID(),
        date: Date = .now,
        supplement: SupplementSchedule,
        taken: Bool = false
    ) {
        self.id = id
        self.date = date
        self.supplement = supplement
        self.taken = taken
    }
}

// MARK: - Blood reports

@Model
final class BloodReport {
    @Attribute(.unique) var id: UUID
    var date: Date
    var labName: String?
    @Attribute(.externalStorage) var pdfData: Data?
    var summaryNotes: String?

    @Relationship(deleteRule: .cascade, inverse: \BloodMarker.report)
    var markers: [BloodMarker] = []

    init(
        id: UUID = UUID(),
        date: Date = .now,
        labName: String? = nil,
        pdfData: Data? = nil,
        summaryNotes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.labName = labName
        self.pdfData = pdfData
        self.summaryNotes = summaryNotes
    }
}

@Model
final class BloodMarker {
    @Attribute(.unique) var id: UUID
    var name: String
    var value: Double
    var unit: String
    var referenceLow: Double?
    var referenceHigh: Double?
    var category: String            // "lipids" | "liver" | "kidney" | "diabetes" | "vitamins" | "hormones" | "inflammation" | "electrolytes"

    var report: BloodReport?

    init(
        id: UUID = UUID(),
        name: String,
        value: Double,
        unit: String,
        referenceLow: Double? = nil,
        referenceHigh: Double? = nil,
        category: String
    ) {
        self.id = id
        self.name = name
        self.value = value
        self.unit = unit
        self.referenceLow = referenceLow
        self.referenceHigh = referenceHigh
        self.category = category
    }
}

// MARK: - Reminders

@Model
final class ReminderConfig {
    @Attribute(.unique) var id: UUID
    var type: String                // "meal" | "workout" | "water" | "sleep" | "supplement"
    var title: String
    var body: String
    var time: String                // "HH:mm"
    var daysOfWeek: [Int]           // 1..7
    var enabled: Bool
    var notificationIds: [String]   // for cancellation

    init(
        id: UUID = UUID(),
        type: String,
        title: String,
        body: String,
        time: String,
        daysOfWeek: [Int] = [1,2,3,4,5,6,7],
        enabled: Bool = true,
        notificationIds: [String] = []
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.time = time
        self.daysOfWeek = daysOfWeek
        self.enabled = enabled
        self.notificationIds = notificationIds
    }
}
