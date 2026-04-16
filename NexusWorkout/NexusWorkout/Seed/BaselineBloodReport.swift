//
//  BaselineBloodReport.swift
//  NexusWorkout
//
//  Shubham's baseline blood panel — the numbers the 12-week plan was
//  written against.  Source: section 1 of the plan (Reality Check +
//  Blood Report Summary).  Reference ranges are general adult ranges,
//  not lab-specific; the Labs tab compares user values to these.
//
//  The PDF blob is unset — user can attach the actual lab PDF later.
//

import Foundation

enum BaselineBloodReport {

    /// Date the baseline panel was drawn.  Roughly 6 months before the
    /// app's first launch — adjust if the user uploads a real PDF later.
    private static var baselineDate: Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.date(from: DateComponents(year: 2025, month: 10, day: 16)) ?? .now
    }

    static func make() -> BloodReport {
        let report = BloodReport(
            date: baselineDate,
            labName: "Baseline (pre-plan)",
            pdfData: nil,
            summaryNotes: """
            Classic young-male central-adiposity profile. No disease, but \
            triglycerides, ALT, hs-CRP, free testosterone, B12, folate, and \
            calcium-oxalate crystals all need work — every one of them \
            improves with the same intervention: lose fat, lift, hydrate, \
            sleep 7+ hrs.  Re-test at 4–6 months.
            """
        )

        let markers: [BloodMarker] = [
            // Lipids
            .init(name: "Triglycerides",  value: 211,  unit: "mg/dL",   referenceLow: nil, referenceHigh: 150, category: "lipids"),
            .init(name: "HDL",            value: 41,   unit: "mg/dL",   referenceLow: 50,  referenceHigh: nil, category: "lipids"),
            .init(name: "LDL",            value: 102,  unit: "mg/dL",   referenceLow: nil, referenceHigh: 100, category: "lipids"),
            .init(name: "Non-HDL",        value: 144,  unit: "mg/dL",   referenceLow: nil, referenceHigh: 130, category: "lipids"),

            // Liver
            .init(name: "ALT (SGPT)",     value: 43,   unit: "U/L",     referenceLow: nil, referenceHigh: 30,  category: "liver"),

            // Kidney
            .init(name: "Creatinine",     value: 0.77, unit: "mg/dL",   referenceLow: 0.7, referenceHigh: 1.3, category: "kidney"),
            .init(name: "eGFR",           value: 126,  unit: "mL/min",  referenceLow: 90,  referenceHigh: nil, category: "kidney"),
            .init(name: "Uric Acid",      value: 7.1,  unit: "mg/dL",   referenceLow: nil, referenceHigh: 6.0, category: "kidney"),
            .init(name: "Calcium Oxalate Crystals", value: 29.90, unit: "/hpf", referenceLow: nil, referenceHigh: 1.0, category: "kidney"),

            // Diabetes / glycemic
            .init(name: "HbA1c",          value: 5.3,  unit: "%",       referenceLow: nil, referenceHigh: 5.7, category: "diabetes"),
            .init(name: "Fasting Glucose",value: 81,   unit: "mg/dL",   referenceLow: 70,  referenceHigh: 100, category: "diabetes"),
            .init(name: "Fasting Insulin",value: 9.4,  unit: "µIU/mL",  referenceLow: 2.6, referenceHigh: 24.9, category: "diabetes"),

            // Vitamins
            .init(name: "Vitamin D (25-OH)", value: 42.6, unit: "ng/mL", referenceLow: 30, referenceHigh: 100, category: "vitamins"),
            .init(name: "Vitamin B12",    value: 273,  unit: "pg/mL",   referenceLow: 400, referenceHigh: 900, category: "vitamins"),
            .init(name: "Folate (B9)",    value: 3.50, unit: "ng/mL",   referenceLow: 8.0, referenceHigh: 20,  category: "vitamins"),

            // Hormones
            .init(name: "TSH",                value: 2.28, unit: "µIU/mL", referenceLow: 0.4,  referenceHigh: 4.0, category: "hormones"),
            .init(name: "Free T4",            value: 1.08, unit: "ng/dL",  referenceLow: 0.8,  referenceHigh: 1.8, category: "hormones"),
            .init(name: "Free T3",            value: 2.92, unit: "pg/mL",  referenceLow: 2.3,  referenceHigh: 4.2, category: "hormones"),
            .init(name: "Free Testosterone",  value: 13.02, unit: "pg/mL", referenceLow: 15.0, referenceHigh: 50, category: "hormones"),
            .init(name: "SHBG",               value: 25.10, unit: "nmol/L", referenceLow: 30, referenceHigh: 50, category: "hormones"),

            // Inflammation
            .init(name: "hs-CRP",         value: 2.65, unit: "mg/L",    referenceLow: nil, referenceHigh: 1.0, category: "inflammation"),
            .init(name: "Homocysteine",   value: 16.33, unit: "µmol/L", referenceLow: nil, referenceHigh: 10,  category: "inflammation"),

            // Electrolytes
            .init(name: "Sodium",         value: 146,  unit: "mmol/L",  referenceLow: 135, referenceHigh: 145, category: "electrolytes"),
            .init(name: "Chloride",       value: 109,  unit: "mmol/L",  referenceLow: 98,  referenceHigh: 107, category: "electrolytes"),
            .init(name: "Magnesium",      value: 2.4,  unit: "mg/dL",   referenceLow: 1.7, referenceHigh: 2.4, category: "electrolytes"),
        ]

        for m in markers {
            m.report = report
            report.markers.append(m)
        }
        return report
    }
}
