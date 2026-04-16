//
//  PrimaryLifts.swift
//  NexusWorkout
//
//  The 11 primary lifts that the plan documents with full form cues.
//  Form cues and common mistakes here are distilled from the plan's
//  "Exercise Form Library" section — keep them short enough to scan
//  between sets.  ASCII form diagrams are injected in a follow-up
//  (they ship as a separate Swift dictionary to keep this file tidy).
//

import Foundation

enum PrimaryLifts {

    static let all: [Exercise] = [

        Exercise(
            name: "Barbell Back Squat",
            primaryMuscles: "Quadriceps, Glutes, Adductors",
            formCues: """
            - Bar across upper traps (not neck); elbows pulled under, chest up.
            - Feet shoulder-width, toes out 15–30°.
            - Big breath into belly, brace like you're about to be punched.
            - Break at hips AND knees together. Descend ~2 sec.
            - Hip crease below top of knee.
            - Drive through mid-foot; hips and chest rise together.
            """,
            commonMistakes: """
            - Knees caving inward — push knees OUT over toes.
            - Heels lifting — shift weight to mid-foot; try flat shoes.
            - Butt wink — stop where back stays neutral; work hip mobility.
            - Half-squats — parallel or deeper, always.
            - Looking up — keep neck neutral, eyes on horizon.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Romanian Deadlift",
            primaryMuscles: "Hamstrings, Glutes, Lower Back",
            formCues: """
            - Bar at hip crease, feet hip-width, double-overhand grip.
            - Soft knees — they stay at that angle the whole rep.
            - Push hips BACKWARD (not down); bar slides along thighs.
            - Descend until strong hamstring stretch, ~just below kneecap.
            - Drive hips forward; squeeze glutes at the top.
            - Shoulders over the bar throughout.
            """,
            commonMistakes: """
            - Squatting the weight — knees stay fixed.
            - Rounding the back — stop earlier, work mobility.
            - Bar drifting off the legs — keep it sliding along thighs.
            - Overextending at top — finish upright, not hyperextended.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Barbell Bench Press",
            primaryMuscles: "Pectorals, Anterior Deltoids, Triceps",
            formCues: """
            - Eyes under the bar, feet flat and planted.
            - Grip slightly wider than shoulders; wrists stacked over forearms.
            - Shoulder blades pinched together and DOWN into the bench.
            - Slight lumbar arch; butt stays on bench.
            - Lower bar to lower chest / sternum (NOT neck), ~2 sec.
            - Elbows ~45–60° from torso; press up and slightly back.
            """,
            commonMistakes: """
            - Flared elbows (90°) — shoulder pain over months.
            - Bouncing the bar off the chest — no control, injury risk.
            - Butt lifting off the bench — disqualifies the rep.
            - Bar path to throat — dangerous.
            - No leg drive — feet firm, pushing into floor.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Overhead Press",
            primaryMuscles: "Deltoids, Triceps, Upper Chest",
            formCues: """
            - Bar in front rack on front delts, hands just outside shoulders.
            - Feet hip-width; glutes + core braced tight.
            - Elbows slightly in front of the bar.
            - Press straight up; shift head through the window as bar passes forehead.
            - Finish with bar stacked over mid-foot, arms locked, traps shrugged.
            """,
            commonMistakes: """
            - Excessive back arch — hurts low back; stays standing press.
            - Bar drifting forward — shoulder strain.
            - Half lockouts — finish fully overhead.
            - Core not braced — energy leaks, low back absorbs load.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Lat Pulldown",
            primaryMuscles: "Latissimus Dorsi, Biceps, Rhomboids",
            formCues: """
            - Grip slightly wider than shoulders, overhand.
            - Secure thighs under the pad; torso leans back ~15°.
            - Chest up; initiate by pulling shoulder blades DOWN first.
            - Pull bar to upper chest / collarbone — elbows drive down and back.
            - Control the return (~3 sec); full stretch without shrugging.
            """,
            commonMistakes: """
            - Leaning too far back — turns it into a row.
            - Pulling to chin or behind the neck — impingement risk.
            - Using momentum — no swinging.
            - Dropping the negative — loses half the benefit.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Barbell Row",
            primaryMuscles: "Lats, Rhomboids, Mid-Traps, Rear Delts",
            formCues: """
            - Bar over mid-foot; hinge to ~45° torso.
            - Knees slightly bent, back flat, shoulders slightly ahead of bar.
            - Grip just outside knees; arms straight to start.
            - Pull to lower chest / upper stomach — drive elbows up and back.
            - Squeeze shoulder blades at the top; lower under control.
            - Beginners: use chest-supported DB row for first 8 weeks.
            """,
            commonMistakes: """
            - Jerking with the lower back / standing up mid-rep.
            - Rounded back — drop the weight.
            - Pulling with biceps only — lead with elbows.
            - Torso too upright — becomes a shrug.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Bulgarian Split Squat",
            primaryMuscles: "Quadriceps, Glutes, Hamstrings",
            formCues: """
            - Rear foot on bench (laces down or toe curled — whichever is stable).
            - Front foot 2–3 feet ahead; front shin close to vertical at bottom.
            - Torso slightly forward; descend straight down.
            - Back knee tracks toward floor, stops just above.
            - Drive through the front heel.
            """,
            commonMistakes: """
            - Front knee caving inward on the drive up.
            - Front foot too close — knee strain.
            - Leaning too far forward — low back load.
            - Jerky reps — keep them slow, controlled.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Barbell Hip Thrust",
            primaryMuscles: "Glutes, Hamstrings",
            formCues: """
            - Upper back on bench; feet flat, shoulder-width.
            - Heels positioned so shins are VERTICAL at the top.
            - Bar over hips on a pad; chin tucked, ribs down.
            - Drive through heels; squeeze glutes hard to lift.
            - Pause 1 sec at top — body straight from knees to shoulders.
            """,
            commonMistakes: """
            - Hyperextending lower back instead of finishing with glutes.
            - Stopping short of lockout.
            - Feet too far from hips — hamstrings take over.
            - Feet too close — quads take over.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Leg Press",
            primaryMuscles: "Quadriceps, Glutes, Hamstrings",
            formCues: """
            - Back flat against pad; butt stays seated the whole rep.
            - Mid-plate, shoulder-width foot placement for balanced work.
            - High on plate = more glute/hamstring; low = more quad.
            - Lower slowly until knees reach ~90°.
            - Press through mid-foot; slight bend at top — don't hard-lock.
            """,
            commonMistakes: """
            - Going too deep — lumbar rounds off pad (disc risk).
            - Locking knees hard at the top.
            - Half reps for ego weight.
            - Hands on knees pushing — wastes the movement.
            """,
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Plank",
            primaryMuscles: "Rectus Abdominis, Transverse Abdominis, Obliques",
            formCues: """
            - Forearms on floor; elbows directly under shoulders.
            - Straight line from head to heels — no sag, no pike.
            - Squeeze glutes HARD. Quads tight. Ribs pulled toward hips.
            - Neck neutral; eyes on floor between forearms.
            - Breathe normally; hold for time.
            - Past 60 sec comfortably? Move to harder variants (ab wheel).
            """,
            commonMistakes: """
            - Hips sagging — no benefit, injury risk.
            - Butt in the air — becomes a stretch.
            - Neck craning up.
            - Chasing minutes — 45 s perfect > 3 min sloppy.
            """,
            formDiagramText: "",
            category: "core"
        ),

        Exercise(
            name: "Hanging Leg Raise",
            primaryMuscles: "Rectus Abdominis, Hip Flexors, Obliques",
            formCues: """
            - Hang from pull-up bar, neutral or overhand grip.
            - Active hang: shoulder blades pulled down slightly.
            - Beginner: knees to chest. Advanced: straight legs to horizontal.
            - Control the descent — don't drop.
            - Exhale at the top of each rep.
            """,
            commonMistakes: """
            - Swinging / using momentum.
            - Dead hang with shoulders relaxed — impingement risk.
            - Only using hip flexors — curl the pelvis at the top.
            """,
            formDiagramText: "",
            category: "core"
        ),
    ]
}
