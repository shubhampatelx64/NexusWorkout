//
//  TabStubs.swift
//  NexusWorkout
//
//  Placeholder views for tabs whose real implementations haven't shipped
//  yet.  Each is replaced as the relevant Phase-1 subsection lands:
//    Today       -> P1.3   ✅ Views/Today/TodayView.swift
//    Train       -> P1.4
//    Eat         -> P1.5
//    Progress    -> P1.6
//    Labs        -> P2  (out of Phase-1 scope)
//

import SwiftUI

private struct StubScreen: View {
    let title: String
    let subtitle: String
    let symbol: String

    var body: some View {
        VStack(spacing: DS.Spacing.lg) {
            Image(systemName: symbol)
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(DS.Color.accentPrimary)
                .padding(DS.Spacing.lg)
                .background(
                    Circle()
                        .fill(DS.Color.accentPrimary.opacity(0.12))
                )

            VStack(spacing: DS.Spacing.xs) {
                Text(title)
                    .font(DS.Font.titleLarge)
                    .foregroundStyle(DS.Color.textPrimary)
                Text(subtitle)
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.Spacing.xl)
            }
        }
        .dsBackground()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TrainView: View {
    var body: some View {
        StubScreen(
            title: "Train",
            subtitle: "Workout browser, active logger, rest timer and exercise library ship in P1.4.",
            symbol: "dumbbell.fill"
        )
    }
}

struct EatView: View {
    var body: some View {
        StubScreen(
            title: "Eat",
            subtitle: "Meal plan, one-tap logging and supplement checklist ship in P1.5.",
            symbol: "fork.knife"
        )
    }
}

struct ProgressTabView: View {
    var body: some View {
        StubScreen(
            title: "Progress",
            subtitle: "Weight / waist trends, PRs and progress photos ship in P1.6.",
            symbol: "chart.line.uptrend.xyaxis"
        )
    }
}

struct LabsView: View {
    var body: some View {
        StubScreen(
            title: "Labs",
            subtitle: "Blood report entry, summary and comparison ship in Phase 2.",
            symbol: "drop.fill"
        )
    }
}
