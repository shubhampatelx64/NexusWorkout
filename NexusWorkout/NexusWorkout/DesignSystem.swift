//
//  DesignSystem.swift
//  NexusWorkout
//
//  Single source of truth for colours, type, spacing, radii, motion, haptics.
//  Every view reads from `DS.*` — never inline hex / fixed numbers in views.
//

import SwiftUI

/// Short alias so call sites stay terse: `DS.Color.accentPrimary`, `DS.Spacing.md`.
enum DS {

    // MARK: - Colour

    enum Color {
        // Backgrounds
        static let background        = SwiftUI.Color(hex: 0x0B0F14)
        static let surface           = SwiftUI.Color(hex: 0x141B22)
        static let surfaceElevated   = SwiftUI.Color(hex: 0x1C242D)

        // Brand accents
        static let accentPrimary     = SwiftUI.Color(hex: 0x00E5A0)   // mint - "done", PRs
        static let accentSecondary   = SwiftUI.Color(hex: 0xFF7A59)   // coral - warnings, missed targets

        // Text
        static let textPrimary       = SwiftUI.Color(hex: 0xF5F7FA)
        static let textSecondary     = SwiftUI.Color(hex: 0x8A94A1)

        // Semantic
        static let success           = accentPrimary
        static let warning           = SwiftUI.Color(hex: 0xFFC857)
        static let danger            = accentSecondary
        static let neutral           = textSecondary

        // Chart palette derived from accents
        static let chartPrimary      = accentPrimary
        static let chartSecondary    = accentSecondary
        static let chartTertiary     = SwiftUI.Color(hex: 0x6FA8FF)
        static let chartQuaternary   = SwiftUI.Color(hex: 0xC084FF)

        /// Reference-range fills used in the Labs tab.
        static let inRangeFill       = accentPrimary.opacity(0.18)
        static let outOfRangeFill    = accentSecondary.opacity(0.18)
    }

    // MARK: - Typography

    enum Font {
        // Display numbers (weight, reps, calories) — SF Pro Rounded looks right for data.
        static let displayLarge      = SwiftUI.Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let displayMedium     = SwiftUI.Font.system(.title, design: .rounded, weight: .bold)
        static let displaySmall      = SwiftUI.Font.system(.title2, design: .rounded, weight: .semibold)

        // UI text — system SF Pro
        static let titleLarge        = SwiftUI.Font.system(.title2, design: .default, weight: .bold)
        static let titleMedium       = SwiftUI.Font.system(.headline, design: .default, weight: .semibold)
        static let titleSmall        = SwiftUI.Font.system(.subheadline, design: .default, weight: .semibold)

        static let body              = SwiftUI.Font.system(.body, design: .default, weight: .regular)
        static let bodyEmphasised    = SwiftUI.Font.system(.body, design: .default, weight: .semibold)
        static let caption           = SwiftUI.Font.system(.caption, design: .default, weight: .regular)
        static let captionEmphasised = SwiftUI.Font.system(.caption, design: .default, weight: .semibold)

        // Mono — used for ASCII form diagrams in the exercise library.
        static let mono              = SwiftUI.Font.system(.footnote, design: .monospaced, weight: .regular)
    }

    // MARK: - Spacing (8pt grid)

    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs:  CGFloat = 8
        static let sm:  CGFloat = 12
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner radius

    enum Radius {
        static let small:  CGFloat = 8     // chips, buttons, small fields
        static let medium: CGFloat = 16    // cards
        static let large:  CGFloat = 24    // sheets, modals
    }

    // MARK: - Motion

    enum Motion {
        /// Default for layout / position transitions.
        static let standard: Animation = .spring(response: 0.4, dampingFraction: 0.8)
        /// Quick UI feedback (toggle flips, chip presses).
        static let snappy:   Animation = .snappy(duration: 0.2)
        /// Celebratory bounce (PRs, streaks). Pair with success haptic + particles.
        static let celebrate: Animation = .spring(response: 0.45, dampingFraction: 0.55)
        /// Cap on functional transitions — never animate longer than this.
        static let maxFunctionalDuration: Double = 0.6
    }

    // MARK: - Shadows

    enum Shadow {
        static let card  = SwiftUI.Color.black.opacity(0.35)
        static let lift  = SwiftUI.Color.black.opacity(0.55)
    }
}

// MARK: - Color hex initialiser

extension Color {
    /// Initialise from a 0xRRGGBB int. Alpha defaults to 1.
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >>  8) & 0xFF) / 255.0
        let b = Double( hex        & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// MARK: - Common modifiers

extension View {
    /// Standard card surface used across all tabs.
    func dsCard(elevated: Bool = false) -> some View {
        self
            .padding(DS.Spacing.md)
            .background(elevated ? DS.Color.surfaceElevated : DS.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.medium, style: .continuous))
            .shadow(color: DS.Shadow.card, radius: 12, y: 4)
    }

    /// Apply the app background to a full-screen view.
    func dsBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DS.Color.background.ignoresSafeArea())
    }

    /// Light haptic on tap — wrap any tappable surface.
    func dsTapHaptic(_ trigger: some Equatable) -> some View {
        self.sensoryFeedback(.impact(weight: .light), trigger: trigger)
    }
}
