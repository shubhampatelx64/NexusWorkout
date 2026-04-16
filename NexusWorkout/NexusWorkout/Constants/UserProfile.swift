//
//  UserProfile.swift
//  NexusWorkout
//
//  Single-user app — the subject is Shubham.  Keeping profile as
//  constants (not a SwiftData @Model) means views can read them
//  without a fetch and there's nothing editable that could drift
//  out of sync with the 12-week plan these numbers were derived
//  against.  If this ever becomes multi-user, promote to a @Model
//  with a singleton row.
//

import Foundation

enum UserProfile {
    static let name              = "Shubham"
    static let sex               = "Male"
    static let age: Int          = 27
    static let heightCm: Double  = 170
    static let startingWeightKg: Double = 89
    static let goalWeightKg:     Double = 78
    static let location          = "Mumbai"

    /// Starting-to-goal delta in kg — negative because we're cutting.
    static var deltaKg: Double { goalWeightKg - startingWeightKg }

    static var heightDisplay: String {
        String(format: "%.0f cm", heightCm)
    }
}
