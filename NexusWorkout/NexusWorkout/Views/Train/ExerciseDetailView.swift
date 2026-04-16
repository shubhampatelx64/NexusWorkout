//
//  ExerciseDetailView.swift
//  NexusWorkout
//
//  Read-only detail screen for an exercise.  Shows primary muscles,
//  form cues, common mistakes, and (for the 11 primary lifts) the
//  ASCII form diagram in DS.Font.mono inside a horizontal scroll so
//  wide diagrams don't get clipped on smaller phones.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                header

                if !exercise.formCues.isEmpty {
                    section(
                        title: "Form Cues",
                        text: exercise.formCues,
                        accent: DS.Color.accentPrimary
                    )
                }

                if !exercise.commonMistakes.isEmpty {
                    section(
                        title: "Common Mistakes",
                        text: exercise.commonMistakes,
                        accent: DS.Color.accentSecondary
                    )
                }

                if !exercise.formDiagramText.isEmpty {
                    diagramCard
                }
            }
            .padding(DS.Spacing.md)
        }
        .dsBackground()
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text(exercise.primaryMuscles)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
            Text(exercise.category.capitalized)
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .padding(.horizontal, DS.Spacing.xs)
                .padding(.vertical, 2)
                .background(DS.Color.surfaceElevated)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func section(title: String, text: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text(title)
                .font(DS.Font.titleMedium)
                .foregroundStyle(accent)
            Text(text)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }

    private var diagramCard: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text("Form Diagram")
                .font(DS.Font.titleMedium)
                .foregroundStyle(DS.Color.textPrimary)
            ScrollView(.horizontal, showsIndicators: false) {
                Text(exercise.formDiagramText)
                    .font(DS.Font.mono)
                    .foregroundStyle(DS.Color.textPrimary)
                    .padding(DS.Spacing.sm)
                    .background(DS.Color.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dsCard()
    }
}
