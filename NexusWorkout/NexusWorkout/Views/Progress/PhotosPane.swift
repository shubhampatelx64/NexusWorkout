//
//  PhotosPane.swift
//  NexusWorkout
//
//  Progress-photo grid grouped by date.  Each photo is tagged with a
//  pose (front / side / back / flexed) so you can compare the SAME
//  angle across weeks — that's the only comparison that actually
//  tells you anything.
//
//  Photos are stored in SwiftData with @Attribute(.externalStorage)
//  so large images don't bloat the store file.
//

import SwiftUI
import SwiftData

struct PhotosPane: View {
    @Query(sort: \ProgressPhoto.date, order: .reverse)
    private var photos: [ProgressPhoto]

    @Environment(\.modelContext) private var context
    @State private var showAddSheet = false

    private let gridColumns = [
        GridItem(.flexible(), spacing: DS.Spacing.xs),
        GridItem(.flexible(), spacing: DS.Spacing.xs),
        GridItem(.flexible(), spacing: DS.Spacing.xs),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                addButton
                if photos.isEmpty {
                    emptyState
                } else {
                    ForEach(grouped, id: \.key) { group in
                        dateSection(title: group.key, photos: group.photos)
                    }
                }
            }
            .padding(DS.Spacing.md)
        }
        .sheet(isPresented: $showAddSheet) { AddPhotoSheet() }
    }

    // MARK: - Subviews

    private var addButton: some View {
        Button { showAddSheet = true } label: {
            Label("Add photo", systemImage: "camera.fill")
                .font(DS.Font.bodyEmphasised)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Spacing.sm)
                .background(DS.Color.accentPrimary)
                .foregroundStyle(DS.Color.background)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: DS.Spacing.xs) {
            Image(systemName: "photo.stack")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(DS.Color.accentPrimary)
            Text("No photos yet")
                .font(DS.Font.titleMedium)
                .foregroundStyle(DS.Color.textPrimary)
            Text("Shoot front / side / back weekly in the same light. Consistency beats quality.")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.lg)
        .dsCard()
    }

    @ViewBuilder
    private func dateSection(title: String, photos: [ProgressPhoto]) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text(title)
                .font(DS.Font.captionEmphasised)
                .foregroundStyle(DS.Color.textSecondary)
                .textCase(.uppercase)
            LazyVGrid(columns: gridColumns, spacing: DS.Spacing.xs) {
                ForEach(photos, id: \.id) { photo in
                    photoTile(photo)
                }
            }
        }
    }

    @ViewBuilder
    private func photoTile(_ photo: ProgressPhoto) -> some View {
        ZStack(alignment: .bottomLeading) {
            if let image = UIImage(data: photo.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()
            } else {
                Rectangle()
                    .fill(DS.Color.surfaceElevated)
                    .frame(height: 120)
            }
            Text(photo.pose)
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textPrimary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.55))
                .clipShape(Capsule())
                .padding(6)
        }
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
        .contextMenu {
            Button(role: .destructive) {
                context.delete(photo)
                try? context.save()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    // MARK: - Derived

    private struct Group {
        let key: String
        let photos: [ProgressPhoto]
    }

    private var grouped: [Group] {
        let f = DateFormatter()
        f.dateFormat = "EEE, d MMM yyyy"
        let buckets = Dictionary(grouping: photos) { photo in
            f.string(from: Calendar.current.startOfDay(for: photo.date))
        }
        return buckets
            .map { Group(key: $0.key, photos: $0.value) }
            .sorted { ($0.photos.first?.date ?? .distantPast) > ($1.photos.first?.date ?? .distantPast) }
    }
}
