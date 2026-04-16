//
//  ExerciseCatalog.swift
//  NexusWorkout
//
//  Thin aggregator.  Exercise data lives in the per-group catalogs under
//  Seed/Catalog/ so each file stays under a few hundred lines and is easy
//  to skim / edit without merge noise.
//

import Foundation

enum ExerciseCatalog {
    /// All exercises referenced by the seeded workouts.  Order here is the
    /// order they're inserted into the store; downstream code looks them up
    /// by `name`, so order doesn't affect workouts, only default listings.
    static func all() -> [Exercise] {
        PrimaryLifts.all + AccessoryLifts.all
    }
}
