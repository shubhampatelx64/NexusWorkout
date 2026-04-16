//
//  PrimaryLiftDiagrams.swift
//  NexusWorkout
//
//  ASCII stick-figure diagrams for the 11 primary lifts.  Stored as a
//  separate dictionary so PrimaryLifts.swift stays scannable, and so
//  the diagrams (which use raw strings to keep backslashes literal)
//  don't have to be inlined in every Exercise initializer.
//
//  Each diagram is a 2-pane sketch — start position on the left, end
//  position on the right — drawn for an iPhone-readable ~28 columns.
//  Render with a monospaced font (DS.Font.code).
//
//  Use `PrimaryLiftDiagrams.diagram(for:)` from the seeder to attach
//  the right text to each Exercise's `formDiagramText` field.
//

import Foundation

enum PrimaryLiftDiagrams {

    static func diagram(for exerciseName: String) -> String {
        diagrams[exerciseName] ?? ""
    }

    /// Keyed on the exercise `name` exactly as defined in PrimaryLifts.swift.
    /// If you rename a lift there, update the key here too.
    static let diagrams: [String: String] = [

        "Barbell Back Squat": #"""
        START                BOTTOM
          ___                  ___
         (   )                (   )
        ==|=|==              ==|=|==
          | |                  | |
         /   \                / _ \
        /     \              |/   \|
        ‾‾‾‾‾‾‾              ‾‾‾‾‾‾‾
        bar on traps         hip below knee
        chest up             knees out
        """#,

        "Romanian Deadlift": #"""
        TOP                  BOTTOM
         ___                  ___
        (   )                (   )
         |||                  ||
         |||                  ||\
         | |==               =|=
         | |                  | \
        / | \                / | |
        ‾‾‾‾‾                ‾‾‾‾‾
        soft knees           hips back
        bar at hip           bar mid-shin
        """#,

        "Barbell Bench Press": #"""
        TOP                  BOTTOM
        ===|===              ===|===
           |                    |
         __|__                __|__
        |     |              |  |  |
        |  o  |              |  o==|=
        |_____|              |_____|
        ‾‾‾‾‾‾‾              ‾‾‾‾‾‾‾
        elbows ~45°          bar at sternum
        feet planted         shoulder blades
                             pinned to bench
        """#,

        "Overhead Press": #"""
        START                LOCKOUT
          ___                  ===|===
         (   )                    |
         =====                  __|__
        ==|=|==                (     )
          | |                   =====
         /   \                 ==|=|==
        /     \                  | |
        ‾‾‾‾‾‾‾                 /   \
        bar at front rack       ‾‾‾‾‾‾‾
                               head through window
        """#,

        "Lat Pulldown": #"""
        TOP                  BOTTOM
        ====|====            ====|====
            |                    |
            |                  __|__
          __|__               (     )
         (     )              ==|=|==
        =|=====|=               | |
          | |                  / | \
         /   \                 ‾‾‾‾‾
        torso ~15°           bar to upper chest
        leaned back          elbows down + back
        """#,

        "Barbell Row": #"""
        TOP OF PULL          BOTTOM
            ___                  ___
           (   )                (   )
        \  ==|==               =|=|=
         \_| |                  | |
          ‾‾|‾‾                 |||
            |                   |||
        ===|=|==              ===|=|==
        torso ~45°           arms straight
        bar at lower chest    bar over mid-foot
        """#,

        "Bulgarian Split Squat": #"""
        TOP                  BOTTOM
          ___                  ___
         (   )                (   )
          |||                  |||
          |||                  | |
         /| |\                / | \
        /_|_|_\__bench       /__|__\__bench
                            back knee just
                            above floor
        """#,

        "Barbell Hip Thrust": #"""
        BOTTOM               TOP (LOCKOUT)
         ___bench             ___bench
        |   |                |   |
        |  o|—\              |  o|══════
         \_/   \              \_/      \
                |__floor                \__floor
        knees ~90°           shins vertical
        bar low on hips      glutes locked
        """#,

        "Leg Press": #"""
        TOP                  BOTTOM
         _____                _____
        |     |              |     |
        |     |              |/   \|
        |  o  |              |  o  |
        |__|__|              |__|__|
           |                    |
          / \                  /=\
         /===\                /===\
        knees ~slight bend   knees ~90°
        butt seated          butt stays seated
        """#,

        "Plank": #"""
        SIDE VIEW
              ___
             (   )
              ||
        ______||________________
        |     ||             /|
        |    [||]___________//
        |____||‾‾‾‾‾‾‾‾‾‾‾‾//___
              ‾‾‾‾‾‾‾‾‾‾‾‾‾
        elbows under shoulders
        head→heels straight line
        glutes + quads tight
        """#,

        "Hanging Leg Raise": #"""
        START                TOP
        =====bar=====        =====bar=====
           | |                  | |
          /   \                 |||
         /     \                | |
        |   o   |              |   o   |
         \     /              ___\     /___
          \___/              |   ‾‾‾‾‾    |
           |||                ‾‾‾‾‾‾‾‾‾‾‾‾
           |||
           ||| straight        legs to horizontal
        active hang            curl pelvis at top
        """#,
    ]
}
