//
//  ExerciseLibraryView.swift
//  NexusWorkout
//
//  Searchable list of all 39 catalog exercises.  Filter chips by
//  category (compound / isolation / core); search matches name OR
//  primary muscles.  Each row pushes ExerciseDetailView.
//

import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Query(sort: \Exercise.name)
    private var exercises: [Exercise]

    @State private var search:   String  = ""
    @State private var category: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: DS.Spacing.md) {
                searchField
                categoryChips
                LazyVStack(spacing: DS.Spacing.xs) {
                    ForEach(filtered, id: \.id) { ex in
                        NavigationLink(value: ex) {
                            ExerciseRow(exercise: ex)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(DS.Spacing.md)
        }
    }

    // MARK: - Subviews

    private var searchField: some View {
        HStack(spacing: DS.Spacing.xs) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(DS.Color.textSecondary)
            TextField("Search exercises…", text: $search)
                .textFieldStyle(.plain)
                .foregroundStyle(DS.Color.textPrimary)
                .autocorrectionDisabled()
        }
        .padding(DS.Spacing.sm)
        .background(DS.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.Spacing.xs) {
                Chip(label: "All", isSelected: category == nil) { category = nil }
                ForEach(categories, id: \.self) { c in
                    Chip(label: c.capitalized, isSelected: category == c) { category = c }
                }
            }
        }
    }

    // MARK: - Derived

    private var categories: [String] {
        Array(Set(exercises.map(\.category))).sorted()
    }

    private var filtered: [Exercise] {
        exercises.filter { ex in
            let matchesSearch =
                search.isEmpty
                || ex.name.localizedCaseInsensitiveContains(search)
                || ex.primaryMuscles.localizedCaseInsensitiveContains(search)
            let matchesCat = category == nil || ex.category == category
            return matchesSearch && matchesCat
        }
    }
}

// MARK: - Row + chip

private struct Chip: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(DS.Font.captionEmphasised)
                .padding(.horizontal, DS.Spacing.sm)
                .padding(.vertical, 6)
                .background(isSelected ? DS.Color.accentPrimary : DS.Color.surfaceElevated)
                .foregroundStyle(isSelected ? DS.Color.background : DS.Color.textPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: DS.Spacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name)
                    .font(DS.Font.bodyEmphasised)
                    .foregroundStyle(DS.Color.textPrimary)
                Text(exercise.primaryMuscles)
                    .font(DS.Font.caption)
                    .foregroundStyle(DS.Color.textSecondary)
                    .lineLimit(1)
            }
            Spacer()
            Text(exercise.category)
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textSecondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(DS.Color.surfaceElevated)
                .clipShape(Capsule())
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(DS.Color.textSecondary)
        }
        .padding(DS.Spacing.sm)
        .background(DS.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
    }
}
