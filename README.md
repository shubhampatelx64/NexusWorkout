# NexusWorkout

Personal iOS app for a 12-week body recomposition plan. SwiftUI + SwiftData, iOS 17+,
dark-first, offline-only. Built around `shubham_body_recomp_plan.md`.

## Open in Xcode

```bash
open NexusWorkout/NexusWorkout.xcodeproj
```

Requires **Xcode 16+** (the project uses `PBXFileSystemSynchronizedRootGroup` so any
`.swift` file dropped into `NexusWorkout/NexusWorkout/` is auto-included in the build —
no manual project edits needed).

Run on the **iPhone 15** simulator (or any iOS 17+ device).

## Build status (Phase 1.1)

Scaffold only. The 5 tabs each show a placeholder. The next subsections (P1.2 seed
loader, P1.3 Today, P1.4 Train, ...) hydrate them. See the original Claude Code prompt
for the phase plan.

## Layout

```
NexusWorkout/
├── NexusWorkout.xcodeproj/             # Xcode project (synchronized-folder format)
└── NexusWorkout/                       # everything in here is auto-compiled
    ├── NexusWorkoutApp.swift           # @main entry, ModelContainer wiring
    ├── DesignSystem.swift              # DS.* — colours, type, spacing, motion, haptics
    ├── Models.swift                    # all SwiftData @Model definitions
    ├── RootView.swift                  # 5-tab TabView shell
    ├── TabStubs.swift                  # placeholder Today / Train / Eat / Progress / Labs views
    └── Assets.xcassets/                # AccentColor + AppIcon (placeholder)
```

## Source of truth

`shubham_body_recomp_plan.md` is the plan that everything is built around. The
runtime data (exercises, workouts, meals, supplements, baseline blood report) is
hardcoded in Swift seeders rather than parsed from the markdown — the markdown is
documentation of provenance, not a runtime input.
