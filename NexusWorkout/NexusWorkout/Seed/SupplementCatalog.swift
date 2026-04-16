//
//  SupplementCatalog.swift
//  NexusWorkout
//
//  Six supplements the plan recommends.  Doses are conservative,
//  evidence-supported defaults — anything aggressive (SARMs, fat
//  burners, nootropic stacks) is intentionally absent.
//
//  `timing` tokens (see SupplementSchedule in Models.swift):
//      "morning" | "with-food" | "pre-workout" | "post-workout" | "bed"
//
//  `timeOfDay` is the default reminder time; the user can change it
//  in Settings later.
//

import Foundation

enum SupplementCatalog {

    static func all() -> [SupplementSchedule] {
        [
            SupplementSchedule(
                name: "Whey Isolate",
                dose: "1 scoop (~30 g protein)",
                timing: "post-workout",
                timeOfDay: "19:00"
            ),
            SupplementSchedule(
                name: "Creatine Monohydrate",
                dose: "5 g daily",
                timing: "with-food",
                timeOfDay: "13:30"
            ),
            SupplementSchedule(
                name: "Vitamin D3",
                dose: "2,000 IU",
                timing: "morning",
                timeOfDay: "08:30"
            ),
            SupplementSchedule(
                name: "B-Complex (Methyl B12 + Folate)",
                dose: "1 tablet",
                timing: "morning",
                timeOfDay: "08:30"
            ),
            SupplementSchedule(
                name: "Omega-3 (EPA + DHA)",
                dose: "2 g combined EPA + DHA",
                timing: "with-food",
                timeOfDay: "13:30"
            ),
            SupplementSchedule(
                name: "Electrolyte Mix",
                dose: "1 sachet in 500 ml water",
                timing: "post-workout",
                timeOfDay: "19:00"
            ),
        ]
    }
}
