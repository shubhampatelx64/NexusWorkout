//
//  WorkoutCatalog.swift
//  NexusWorkout
//
//  The 11 workout templates that anchor the 12-week plan:
//
//    5-day split  (default — Upper/Lower + accessory Saturday)
//      Mon — Upper Push
//      Tue — Lower A (squat focus)
//      Wed — Upper Pull
//      Fri — Lower B (deadlift focus)
//      Sat — Full Body / Conditioning
//
//    6-day split  (alternate — Push/Pull/Legs × 2)
//      Push A, Pull A, Legs A, Push B, Pull B, Legs B
//
//  Volume / rep ranges follow the plan's beginner-recomp rubric:
//    primary compound : 4 × 5–8,   180 s rest
//    secondary lift   : 3 × 8–12,  120 s rest
//    isolation        : 3 × 10–15,  75 s rest
//    core / carry     : 3 × 10–15,  60 s rest
//
//  All exercises here MUST exist in `ExerciseCatalog.all()` — the helper
//  `tx(_:_:sets:low:high:rest:notes:)` will trap loudly if a name is
//  misspelled, which is exactly what we want at seed time.
//

import Foundation

enum WorkoutCatalog {

    /// Build all 11 templates, wiring TemplateExercise rows to the Exercise
    /// instances in `byName`. Caller (PlanSeeder) inserts the returned
    /// templates into the model context — the cascade rule on
    /// `WorkoutTemplate.exercises` brings the children along.
    static func all(using byName: [String: Exercise]) -> [WorkoutTemplate] {
        // Tiny shim so the workout definitions below read like a table.
        func tx(
            _ template: WorkoutTemplate,
            _ name: String,
            sets: Int,
            low: Int,
            high: Int,
            rest: Int,
            notes: String? = nil
        ) {
            guard let ex = byName[name] else {
                fatalError("WorkoutCatalog: missing exercise '\(name)'")
            }
            let order = template.exercises.count + 1
            let row = TemplateExercise(
                exercise: ex,
                order: order,
                targetSets: sets,
                repRangeLow: low,
                repRangeHigh: high,
                restSeconds: rest,
                notes: notes
            )
            row.template = template
            template.exercises.append(row)
        }

        var out: [WorkoutTemplate] = []

        // MARK: - 5-day split

        let upperPush = WorkoutTemplate(
            name: "Upper Push",
            dayOfWeek: 1,
            split: "5-day",
            notes: "Chest / shoulders / triceps. Bench is the headliner."
        )
        tx(upperPush, "Barbell Bench Press",          sets: 4, low: 5,  high: 8,  rest: 180)
        tx(upperPush, "Overhead Press",               sets: 4, low: 5,  high: 8,  rest: 180)
        tx(upperPush, "Incline Dumbbell Press",       sets: 3, low: 8,  high: 12, rest: 120)
        tx(upperPush, "Cable Lateral Raise",          sets: 3, low: 12, high: 15, rest: 75)
        tx(upperPush, "Triceps Rope Pushdown",        sets: 3, low: 10, high: 15, rest: 75)
        tx(upperPush, "Overhead Triceps Extension",   sets: 3, low: 10, high: 15, rest: 75)
        out.append(upperPush)

        let lowerA = WorkoutTemplate(
            name: "Lower A",
            dayOfWeek: 2,
            split: "5-day",
            notes: "Squat-focused. Quads first, hamstrings second, calves + core to finish."
        )
        tx(lowerA, "Barbell Back Squat",     sets: 4, low: 5,  high: 8,  rest: 180)
        tx(lowerA, "Romanian Deadlift",      sets: 3, low: 8,  high: 10, rest: 150)
        tx(lowerA, "Walking Dumbbell Lunge", sets: 3, low: 10, high: 12, rest: 90,
            notes: "Reps per leg.")
        tx(lowerA, "Leg Extension",          sets: 3, low: 12, high: 15, rest: 75)
        tx(lowerA, "Standing Calf Raise",    sets: 4, low: 10, high: 15, rest: 60)
        tx(lowerA, "Plank",                  sets: 3, low: 30, high: 60, rest: 60,
            notes: "Hold for time (sec); stop a rep short of form failing.")
        out.append(lowerA)

        let upperPull = WorkoutTemplate(
            name: "Upper Pull",
            dayOfWeek: 3,
            split: "5-day",
            notes: "Back / rear delts / biceps. Lead with elbows, not biceps."
        )
        tx(upperPull, "Barbell Row",                   sets: 4, low: 6,  high: 10, rest: 150,
            notes: "Beginners: chest-supported DB row for the first 8 weeks.")
        tx(upperPull, "Lat Pulldown",                  sets: 4, low: 8,  high: 12, rest: 120)
        tx(upperPull, "Chest-Supported Dumbbell Row",  sets: 3, low: 10, high: 12, rest: 90)
        tx(upperPull, "Face Pull",                     sets: 3, low: 12, high: 15, rest: 60,
            notes: "Shoulder health — never skip.")
        tx(upperPull, "Barbell Curl",                  sets: 3, low: 8,  high: 12, rest: 75)
        tx(upperPull, "Hammer Curl",                   sets: 3, low: 10, high: 12, rest: 75)
        out.append(upperPull)

        let lowerB = WorkoutTemplate(
            name: "Lower B",
            dayOfWeek: 5,
            split: "5-day",
            notes: "Deadlift-focused. Posterior chain priority."
        )
        tx(lowerB, "Conventional Deadlift",   sets: 3, low: 5,  high: 6,  rest: 180,
            notes: "Stop one rep short of form breakdown. No grinders.")
        tx(lowerB, "Barbell Hip Thrust",      sets: 4, low: 8,  high: 12, rest: 120)
        tx(lowerB, "Bulgarian Split Squat",   sets: 3, low: 8,  high: 10, rest: 90,
            notes: "Reps per leg.")
        tx(lowerB, "Seated Leg Curl",         sets: 3, low: 10, high: 15, rest: 75)
        tx(lowerB, "Standing Calf Raise",     sets: 4, low: 10, high: 15, rest: 60)
        tx(lowerB, "Hanging Leg Raise",       sets: 3, low: 8,  high: 12, rest: 60,
            notes: "Sub knee-raises if straight-leg is too hard.")
        out.append(lowerB)

        let fullBody = WorkoutTemplate(
            name: "Full Body / Conditioning",
            dayOfWeek: 6,
            split: "5-day",
            notes: "Lighter touch — accumulate volume, finish with a Zone 2 walk."
        )
        tx(fullBody, "Goblet Squat",            sets: 3, low: 10, high: 12, rest: 90)
        tx(fullBody, "Dumbbell Bench Press",    sets: 3, low: 10, high: 12, rest: 90)
        tx(fullBody, "One-Arm Dumbbell Row",    sets: 3, low: 10, high: 12, rest: 90,
            notes: "Reps per side.")
        tx(fullBody, "Cable Lateral Raise",     sets: 3, low: 12, high: 15, rest: 60)
        tx(fullBody, "Cable Pull-Through",      sets: 3, low: 12, high: 15, rest: 75)
        tx(fullBody, "Farmer's Carry",          sets: 3, low: 1,  high: 1,  rest: 90,
            notes: "30 m / ~45 sec per set. Heavy.")
        tx(fullBody, "Ab Wheel Rollout",        sets: 3, low: 8,  high: 12, rest: 60,
            notes: "Drop to kneeling tucks if hips sag.")
        tx(fullBody, "Incline Treadmill Walk",  sets: 1, low: 1,  high: 1,  rest: 0,
            notes: "20 min @ 6% / 5.5 km/h. Zone 2.")
        out.append(fullBody)

        // MARK: - 6-day split (PPL × 2)

        let pushA = WorkoutTemplate(
            name: "Push A",
            dayOfWeek: 1,
            split: "6-day",
            notes: "Heavy bench day."
        )
        tx(pushA, "Barbell Bench Press",         sets: 4, low: 5,  high: 8,  rest: 180)
        tx(pushA, "Overhead Press",              sets: 3, low: 6,  high: 8,  rest: 150)
        tx(pushA, "Incline Dumbbell Press",      sets: 3, low: 8,  high: 12, rest: 120)
        tx(pushA, "Cable Lateral Raise",         sets: 3, low: 12, high: 15, rest: 75)
        tx(pushA, "Triceps Rope Pushdown",       sets: 3, low: 10, high: 15, rest: 75)
        tx(pushA, "Overhead Triceps Extension",  sets: 3, low: 10, high: 15, rest: 75)
        out.append(pushA)

        let pullA = WorkoutTemplate(
            name: "Pull A",
            dayOfWeek: 2,
            split: "6-day",
            notes: "Heavy row day."
        )
        tx(pullA, "Barbell Row",                  sets: 4, low: 6,  high: 8,  rest: 150)
        tx(pullA, "Lat Pulldown",                 sets: 3, low: 8,  high: 12, rest: 120)
        tx(pullA, "Chest-Supported Dumbbell Row", sets: 3, low: 10, high: 12, rest: 90)
        tx(pullA, "Face Pull",                    sets: 3, low: 12, high: 15, rest: 60)
        tx(pullA, "Barbell Curl",                 sets: 3, low: 8,  high: 12, rest: 75)
        tx(pullA, "Incline Dumbbell Curl",        sets: 3, low: 10, high: 12, rest: 75)
        out.append(pullA)

        let legsA = WorkoutTemplate(
            name: "Legs A",
            dayOfWeek: 3,
            split: "6-day",
            notes: "Squat-focused leg day."
        )
        tx(legsA, "Barbell Back Squat",     sets: 4, low: 5,  high: 8,  rest: 180)
        tx(legsA, "Romanian Deadlift",      sets: 3, low: 8,  high: 10, rest: 150)
        tx(legsA, "Walking Dumbbell Lunge", sets: 3, low: 10, high: 12, rest: 90,
            notes: "Reps per leg.")
        tx(legsA, "Leg Extension",          sets: 3, low: 12, high: 15, rest: 75)
        tx(legsA, "Standing Calf Raise",    sets: 4, low: 10, high: 15, rest: 60)
        tx(legsA, "Hanging Leg Raise",      sets: 3, low: 8,  high: 12, rest: 60)
        out.append(legsA)

        let pushB = WorkoutTemplate(
            name: "Push B",
            dayOfWeek: 4,
            split: "6-day",
            notes: "Hypertrophy push — incline / DBs / cables."
        )
        tx(pushB, "Incline Dumbbell Press",         sets: 4, low: 8,  high: 10, rest: 120)
        tx(pushB, "Seated Dumbbell Shoulder Press", sets: 3, low: 8,  high: 12, rest: 120)
        tx(pushB, "Dumbbell Bench Press",           sets: 3, low: 10, high: 12, rest: 90)
        tx(pushB, "Cable Fly",                      sets: 3, low: 12, high: 15, rest: 75)
        tx(pushB, "Close-Grip Bench Press",         sets: 3, low: 8,  high: 10, rest: 90)
        tx(pushB, "Cable Lateral Raise",            sets: 3, low: 12, high: 15, rest: 60,
            notes: "Drop set on the last set.")
        out.append(pushB)

        let pullB = WorkoutTemplate(
            name: "Pull B",
            dayOfWeek: 5,
            split: "6-day",
            notes: "Deadlift + width-focused pull."
        )
        tx(pullB, "Conventional Deadlift", sets: 3, low: 5,  high: 6,  rest: 180,
            notes: "Stop one rep short of form breakdown.")
        tx(pullB, "Lat Pulldown",          sets: 4, low: 8,  high: 12, rest: 120)
        tx(pullB, "Seated Cable Row",      sets: 3, low: 10, high: 12, rest: 90)
        tx(pullB, "One-Arm Dumbbell Row",  sets: 3, low: 10, high: 12, rest: 90,
            notes: "Reps per side.")
        tx(pullB, "Hammer Curl",           sets: 3, low: 10, high: 12, rest: 75)
        tx(pullB, "Rear Delt Fly",         sets: 3, low: 12, high: 15, rest: 60)
        out.append(pullB)

        let legsB = WorkoutTemplate(
            name: "Legs B",
            dayOfWeek: 6,
            split: "6-day",
            notes: "Glute / hamstring biased."
        )
        tx(legsB, "Barbell Hip Thrust",     sets: 4, low: 8,  high: 12, rest: 120)
        tx(legsB, "Leg Press",              sets: 3, low: 10, high: 12, rest: 120)
        tx(legsB, "Bulgarian Split Squat",  sets: 3, low: 8,  high: 10, rest: 90,
            notes: "Reps per leg.")
        tx(legsB, "Seated Leg Curl",        sets: 3, low: 10, high: 15, rest: 75)
        tx(legsB, "Cable Pull-Through",     sets: 3, low: 12, high: 15, rest: 75)
        tx(legsB, "Plank",                  sets: 3, low: 30, high: 60, rest: 60,
            notes: "Hold for time (sec).")
        out.append(legsB)

        return out
    }
}
