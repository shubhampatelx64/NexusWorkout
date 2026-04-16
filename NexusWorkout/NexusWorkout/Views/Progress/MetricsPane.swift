//
//  MetricsPane.swift
//  NexusWorkout
//
//  Weight + waist trends over time.  Two charts (weight in kg, waist
//  in cm) share the same time axis so you can eyeball whether waist
//  is dropping faster than weight — which is what you WANT during a
//  recomp.  Delta card up top compares the latest reading against
//  the first baseline.
//
//  Tapping the "Log measurement" button opens a sheet that inserts
//  a new BodyMetric row.
//

import SwiftUI
import SwiftData
import Charts

struct MetricsPane: View {
    @Query(sort: \BodyMetric.date) private var metrics: [BodyMetric]
    @State private var showLogSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                summaryCard
                weightChartCard
                waistChartCard
                logButton
            }
            .padding(DS.Spacing.md)
        }
        .sheet(isPresented: $showLogSheet) { LogMetricSheet() }
    }

    // MARK: - Subviews

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("Since baseline")
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .textCase(.uppercase)
            HStack(spacing: DS.Spacing.lg) {
                delta(
                    label: "Weight",
                    unit: "kg",
                    first: metrics.first?.weightKg,
                    latest: latestWeight,
                    goodIfDown: true
                )
                delta(
                    label: "Waist",
                    unit: "cm",
                    first: metrics.first?.waistCm,
                    latest: latestWaist,
                    goodIfDown: true
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    private func delta(
        label: String,
        unit: String,
        first: Double?,
        latest: Double?,
        goodIfDown: Bool
    ) -> some View {
        let diff: Double? = (first != nil && latest != nil) ? (latest! - first!) : nil
        let isGood: Bool = {
            guard let d = diff else { return true }
            return goodIfDown ? d <= 0 : d >= 0
        }()
        return VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textSecondary)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(latest.map { String(format: "%.1f", $0) } ?? "—")
                    .font(DS.Font.displaySmall)
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
                Text(unit)
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
            }
            if let d = diff {
                Text(String(format: "%+.1f %@", d, unit))
                    .font(DS.Font.captionEmphasised)
                    .foregroundStyle(isGood ? DS.Color.accentPrimary : DS.Color.accentSecondary)
                    .monospacedDigit()
            } else {
                Text("no baseline")
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
            }
        }
    }

    private var weightChartCard: some View {
        chartCard(
            title: "Weight",
            unit: "kg",
            samples: metrics.compactMap { m in
                m.weightKg.map { (m.date, $0) }
            }
        )
    }

    private var waistChartCard: some View {
        chartCard(
            title: "Waist",
            unit: "cm",
            samples: metrics.compactMap { m in
                m.waistCm.map { (m.date, $0) }
            }
        )
    }

    @ViewBuilder
    private func chartCard(
        title: String,
        unit: String,
        samples: [(Date, Double)]
    ) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            HStack {
                Text(title)
                    .font(DS.Font.titleMedium)
                    .foregroundStyle(DS.Color.textPrimary)
                Spacer()
                Text("\(samples.count) readings")
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
            }
            if samples.count < 2 {
                Text("Log at least two measurements to see a trend.")
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .padding(.vertical, DS.Spacing.md)
            } else {
                Chart {
                    ForEach(samples, id: \.0) { date, value in
                        LineMark(
                            x: .value("Date", date),
                            y: .value(title, value)
                        )
                        .foregroundStyle(DS.Color.accentPrimary)
                        .interpolationMethod(.monotone)
                        PointMark(
                            x: .value("Date", date),
                            y: .value(title, value)
                        )
                        .foregroundStyle(DS.Color.accentPrimary)
                    }
                }
                .chartYAxisLabel(unit)
                .frame(height: 160)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    private var logButton: some View {
        Button { showLogSheet = true } label: {
            Label("Log measurement", systemImage: "plus.circle.fill")
                .font(DS.Font.bodyEmphasised)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Spacing.sm)
                .background(DS.Color.accentPrimary)
                .foregroundStyle(DS.Color.background)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Derived

    private var latestWeight: Double? {
        metrics.reversed().first(where: { $0.weightKg != nil })?.weightKg
    }

    private var latestWaist: Double? {
        metrics.reversed().first(where: { $0.waistCm != nil })?.waistCm
    }
}
