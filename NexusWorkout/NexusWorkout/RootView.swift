//
//  RootView.swift
//  NexusWorkout
//
//  5-tab shell.  Each tab is its own NavigationStack.
//

import SwiftUI

enum AppTab: Hashable {
    case today, train, eat, progress, labs
}

struct RootView: View {
    @State private var selection: AppTab = .today

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { TodayView() }
                .tabItem { Label("Today", systemImage: "sun.max.fill") }
                .tag(AppTab.today)

            NavigationStack { TrainView() }
                .tabItem { Label("Train", systemImage: "dumbbell.fill") }
                .tag(AppTab.train)

            NavigationStack { EatView() }
                .tabItem { Label("Eat", systemImage: "fork.knife") }
                .tag(AppTab.eat)

            NavigationStack { ProgressTabView() }
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(AppTab.progress)

            NavigationStack { LabsView() }
                .tabItem { Label("Labs", systemImage: "drop.fill") }
                .tag(AppTab.labs)
        }
        .tint(DS.Color.accentPrimary)
        .sensoryFeedback(.selection, trigger: selection)
    }
}

#Preview {
    RootView()
        .preferredColorScheme(.dark)
}
