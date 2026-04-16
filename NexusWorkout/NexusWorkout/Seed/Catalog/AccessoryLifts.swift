//
//  AccessoryLifts.swift
//  NexusWorkout
//
//  Accessory / isolation / conditioning movements used by the 5-day and
//  6-day splits.  Form cues here are intentionally short — enough to
//  glance at between sets, not an instructional manual.  For the 11
//  primary lifts with the full plan-length form guides, see PrimaryLifts.
//

import Foundation

enum AccessoryLifts {

    static let all: [Exercise] = [

        // MARK: Push

        Exercise(
            name: "Seated Dumbbell Shoulder Press",
            primaryMuscles: "Shoulders, Triceps",
            formCues: "Seat back upright. Elbows slightly forward of shoulder line. Press straight up; stop just short of lockout. Squeeze shoulders at the top.",
            commonMistakes: "Flaring elbows straight out (shoulder strain). Arching low back.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Incline Dumbbell Press",
            primaryMuscles: "Upper Chest, Anterior Delts, Triceps",
            formCues: "Bench at 30°. Dumbbells start at chest level, palms forward. Press up and slightly in; full stretch on the descent.",
            commonMistakes: "Bench too steep — turns it into shoulder press. Elbows flaring to 90°.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Cable Lateral Raise",
            primaryMuscles: "Lateral Deltoid",
            formCues: "Cable from low pulley, across the body. Lead with the elbow; raise to just above shoulder height. Slight forward lean keeps tension on the delt, not traps.",
            commonMistakes: "Shrugging with traps. Using momentum. Raising too high (traps take over).",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Triceps Rope Pushdown",
            primaryMuscles: "Triceps",
            formCues: "Elbows pinned to sides. Rope to hips; split the ends at the bottom. Full stretch at the top, squeeze at the bottom.",
            commonMistakes: "Elbows flaring. Leaning too far forward. Short ROM.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Overhead Triceps Extension",
            primaryMuscles: "Triceps (long head)",
            formCues: "Dumbbell or rope overhead. Elbows pointed up, close to ears. Lower behind the head; press back to full extension.",
            commonMistakes: "Elbows drifting out — long head doesn't get the stretch. Arching low back.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Dumbbell Bench Press",
            primaryMuscles: "Pectorals, Anterior Deltoids, Triceps",
            formCues: "Dumbbells at lower chest, palms forward. Press up and in; stop just short of the tops touching. Control the eccentric.",
            commonMistakes: "Elbows flared 90° — shoulder strain. Butt off bench. Bouncing at the bottom.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Cable Fly",
            primaryMuscles: "Pectorals",
            formCues: "Slight forward lean, soft elbows held at that angle. Squeeze the chest at the midline; control the stretch.",
            commonMistakes: "Bending elbows mid-rep — becomes a press. Using momentum.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Dumbbell Fly",
            primaryMuscles: "Pectorals",
            formCues: "Flat bench. Soft elbows, DBs in a shallow arc. Stop before shoulders feel strain on the stretch; squeeze chest at the top.",
            commonMistakes: "Straight arms — biceps tendon strain. Going too deep on the stretch.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Close-Grip Bench Press",
            primaryMuscles: "Triceps, Chest",
            formCues: "Grip shoulder-width (not narrower — wrist pain). Elbows tucked close. Lower to lower chest; press straight up.",
            commonMistakes: "Grip too narrow. Elbows flaring on the press.",
            formDiagramText: "",
            category: "compound"
        ),

        // MARK: Pull

        Exercise(
            name: "Chest-Supported Dumbbell Row",
            primaryMuscles: "Lats, Rhomboids, Mid-Traps",
            formCues: "Chest on an incline bench (~30°). Pull dumbbells to hips; drive elbows up and back. Squeeze shoulder blades at top.",
            commonMistakes: "Using biceps to pull — lead with elbows. Short ROM.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Seated Cable Row",
            primaryMuscles: "Lats, Rhomboids, Mid-Traps",
            formCues: "Chest up, slight lean back (~10°). Pull handle to upper abdomen; squeeze shoulder blades at the end. Let lats stretch on the return.",
            commonMistakes: "Excessive torso rock — energy leak. Pulling with biceps only.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "One-Arm Dumbbell Row",
            primaryMuscles: "Lats, Rhomboids, Rear Delts",
            formCues: "Hand and knee on bench, flat back. Pull DB to hip; drive elbow up and back. Do not rotate the torso to lift.",
            commonMistakes: "Twisting the torso to cheat the rep. Using momentum.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Face Pull",
            primaryMuscles: "Rear Delts, Rhomboids, Mid-Traps",
            formCues: "Rope at eye height. Pull toward the forehead; externally rotate so knuckles face the ceiling at the end. Shoulder health — never skip.",
            commonMistakes: "Pulling with biceps. Pulling too low (becomes a row).",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Rear Delt Fly",
            primaryMuscles: "Rear Delts",
            formCues: "Chest on an incline bench or machine. Light weight. Lead with the elbows in a wide arc; squeeze rear delts at top.",
            commonMistakes: "Using too much weight — traps take over. Straight arms.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Incline Dumbbell Curl",
            primaryMuscles: "Biceps (long head)",
            formCues: "Bench at ~60°; arms hang straight down. Curl without swinging the elbow forward. Full stretch at bottom, squeeze at top.",
            commonMistakes: "Elbows drifting forward — cuts the stretch. Kipping.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Hammer Curl",
            primaryMuscles: "Biceps, Brachialis, Forearms",
            formCues: "Neutral grip (palms face each other). Elbows pinned at sides. Curl to shoulder; control the descent.",
            commonMistakes: "Swinging the DBs. Elbows drifting out in front.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Barbell Curl",
            primaryMuscles: "Biceps",
            formCues: "Shoulder-width grip. Elbows pinned. Curl without leaning back; squeeze at the top.",
            commonMistakes: "Cheating with the lower back. Short ROM.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Conventional Deadlift",
            primaryMuscles: "Hamstrings, Glutes, Erectors, Lats",
            formCues: "Bar over mid-foot, feet hip-width. Hip hinge to grip. Flat back, lats tight. Push floor away; hips and shoulders rise together.",
            commonMistakes: "Rounded lower back — drop the weight. Hips shooting up first (turns it into a stiff-leg). Bar drifting away from shins.",
            formDiagramText: "",
            category: "compound"
        ),

        // MARK: Legs

        Exercise(
            name: "Walking Dumbbell Lunge",
            primaryMuscles: "Quadriceps, Glutes, Hamstrings",
            formCues: "Long stride; front knee stops over ankle. Back knee taps just above floor. Drive through front heel to step forward.",
            commonMistakes: "Short stride — knee shoots past toes. Torso leaning forward.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Leg Extension",
            primaryMuscles: "Quadriceps",
            formCues: "Shin pad at the top of the ankle. Extend to full lockout; squeeze quads. Control the return.",
            commonMistakes: "Using momentum. Slamming the weight down.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Seated Leg Curl",
            primaryMuscles: "Hamstrings",
            formCues: "Pad just above the ankle. Curl heels under the bench; squeeze hamstrings. Resist on the way up.",
            commonMistakes: "Lifting hips off the pad. Short ROM.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Standing Calf Raise",
            primaryMuscles: "Gastrocnemius, Soleus",
            formCues: "Ball of foot on the platform; full stretch at the bottom. Press to full plantar flexion; pause at the top.",
            commonMistakes: "Half ROM. Bouncing out of the bottom.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Cable Pull-Through",
            primaryMuscles: "Glutes, Hamstrings",
            formCues: "Face away from low pulley; rope between legs. Hip hinge — push hips back, not down. Stand by squeezing glutes forward.",
            commonMistakes: "Squatting the weight. Overextending the low back at the top.",
            formDiagramText: "",
            category: "isolation"
        ),

        Exercise(
            name: "Goblet Squat",
            primaryMuscles: "Quadriceps, Glutes, Core",
            formCues: "Hold a single dumbbell at chest height, elbows tucked under. Squat straight down between the feet; chest up.",
            commonMistakes: "Heels lifting. Rounding the upper back.",
            formDiagramText: "",
            category: "compound"
        ),

        // MARK: Core & conditioning

        Exercise(
            name: "Ab Wheel Rollout",
            primaryMuscles: "Rectus Abdominis, Obliques, Lats",
            formCues: "Kneel; wheel under shoulders. Brace core HARD. Roll forward; keep hips neutral (don't let them sag). Return by pulling abs back.",
            commonMistakes: "Hips sagging — low back takes the load. Going further than you can control.",
            formDiagramText: "",
            category: "core"
        ),

        Exercise(
            name: "Cable Woodchopper",
            primaryMuscles: "Obliques, Core",
            formCues: "Cable from high to low across the body. Rotate from the torso, not the arms. Keep hips square or pivot slightly.",
            commonMistakes: "Bending elbows mid-rep. Using arms instead of obliques.",
            formDiagramText: "",
            category: "core"
        ),

        Exercise(
            name: "Kettlebell Swing",
            primaryMuscles: "Glutes, Hamstrings, Core",
            formCues: "Hip hinge — not a squat. Explosive hip drive sends the bell up to chest height. Bell floats at the top; gravity brings it down.",
            commonMistakes: "Using arms to lift the bell. Squatting it. Overextending the low back at the top.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Farmer's Carry",
            primaryMuscles: "Traps, Forearms, Core, Glutes",
            formCues: "Heavy DBs or trap bar. Stand tall, ribs down, walk with purpose. 30 m / ~45 sec per set.",
            commonMistakes: "Shrugging shoulders up. Leaning side to side.",
            formDiagramText: "",
            category: "compound"
        ),

        Exercise(
            name: "Incline Treadmill Walk",
            primaryMuscles: "Glutes, Calves, Heart",
            formCues: "6% grade, 5.5 km/h. No holding the rails. Zone 2 effort — can carry a conversation.",
            commonMistakes: "Grade too low — just walking. Holding the rails — wastes the effort.",
            formDiagramText: "",
            category: "compound"
        ),
    ]
}
