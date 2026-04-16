//
//  AddPhotoSheet.swift
//  NexusWorkout
//
//  Modal sheet for capturing a ProgressPhoto.  Uses PhotosPicker so
//  you can pull from the library (easier than a custom camera UI for
//  a v1) and downsamples to ~1200px on the long edge before writing
//  to SwiftData so the store doesn't balloon with 12-MP originals.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPhotoSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss)      private var dismiss

    @State private var pickerItem: PhotosPickerItem?
    @State private var previewImage: UIImage?
    @State private var compressedData: Data?
    @State private var pose: String = "front"
    @State private var date: Date = .now

    private let poses = ["front", "side", "back", "flexed"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    PhotosPicker(
                        selection: $pickerItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text(previewImage == nil ? "Choose from library" : "Change photo")
                            Spacer()
                        }
                    }
                    if let previewImage {
                        Image(uiImage: previewImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 260)
                            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small, style: .continuous))
                    }
                }
                Section("Pose") {
                    Picker("Pose", selection: $pose) {
                        ForEach(poses, id: \.self) { Text($0.capitalized).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(compressedData == nil)
                }
            }
        }
        .onChange(of: pickerItem) { _, newItem in
            Task { await load(newItem) }
        }
    }

    private func load(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        guard let raw = try? await item.loadTransferable(type: Data.self) else { return }
        guard let ui = UIImage(data: raw) else { return }
        let resized = downsample(ui, maxEdge: 1200)
        await MainActor.run {
            previewImage   = resized
            compressedData = resized.jpegData(compressionQuality: 0.8)
        }
    }

    private func downsample(_ image: UIImage, maxEdge: CGFloat) -> UIImage {
        let longest = max(image.size.width, image.size.height)
        guard longest > maxEdge else { return image }
        let scale = maxEdge / longest
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    private func save() {
        guard let data = compressedData else { return }
        let photo = ProgressPhoto(date: date, pose: pose, imageData: data)
        context.insert(photo)
        try? context.save()
        dismiss()
    }
}
