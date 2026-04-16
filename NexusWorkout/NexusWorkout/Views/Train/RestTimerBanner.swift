//
//  RestTimerBanner.swift
//  NexusWorkout
//
//  Floating bottom banner that counts down between sets.  Uses
//  TimelineView(.periodic) so the countdown updates without a
//  manually-managed Timer.  Fires a success haptic on completion.
//
//  Owned by ActiveSessionView — that view manages the endTime / total
//  state and dismisses the banner via the `onSkip` callback.
//

import SwiftUI

struct RestTimerBanner: View {
    let endTime: Date
    let totalSeconds: Int
    let onSkip: () -> Void

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.5)) { context in
            let remaining = max(0, Int(endTime.timeIntervalSince(context.date).rounded()))
            let progress  = totalSeconds > 0
                ? min(1, max(0, 1 - Double(remaining) / Double(totalSeconds)))
                : 1

            HStack(spacing: DS.Spacing.sm) {
                Image(systemName: remaining == 0 ? "checkmark.circle.fill" : "timer")
                    .font(.title2)
                    .foregroundStyle(remaining == 0 ? DS.Color.accentPrimary : DS.Color.warning)

                VStack(alignment: .leading, spacing: 2) {
                    Text(remaining == 0 ? "Ready" : "Rest")
                        .font(DS.Font.captionEmphasised)
                        .foregroundStyle(DS.Color.textSecondary)
                        .textCase(.uppercase)
                    Text(formatTime(remaining))
                        .font(DS.Font.displaySmall)
                        .foregroundStyle(DS.Color.textPrimary)
                        .monospacedDigit()
                }

                Spacer()

                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                    .tint(remaining == 0 ? DS.Color.accentPrimary : DS.Color.warning)

                Button(action: onSkip) {
                    Text(remaining == 0 ? "Done" : "Skip")
                        .font(DS.Font.bodyEmphasised)
                        .foregroundStyle(DS.Color.accentPrimary)
                        .padding(.horizontal, DS.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(DS.Color.surfaceElevated)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(DS.Spacing.sm)
            .frame(maxWidth: .infinity)
            .background(DS.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.medium, style: .continuous))
            .shadow(color: DS.Shadow.lift, radius: 16, y: 6)
            .sensoryFeedback(.success, trigger: remaining == 0)
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}
