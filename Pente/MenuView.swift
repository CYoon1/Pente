//
//  MenuView.swift
//  Pente
//
//  Created by Christopher Yoon on 4/5/24.
//

import SwiftUI
import SwiftData

struct MenuView: View {
    @State private var showingRulesSheet = false
    @Binding var playGame: Bool
    var body: some View {
        VStack {
            Spacer()
            Text("Pente")
                .font(.largeTitle)
            Spacer()
            Group {
                Button {
                    playGame = true
                } label: {
                    Text("Play Game")
                }
                NavigationLink {
                    SaveListView()
                } label: {
                    Text("Saved Games")
                }
                Button {
                    showingRulesSheet.toggle()
                } label: {
                    Text("How to Play?")
                }
            }
            Spacer()
        }
        .sheet(isPresented: $showingRulesSheet, content: {
            RulesView()
        })
    }
}

struct RulesView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Rules")
                .font(.title)
            Spacer()
            Group {
                Text("Goal of the Game")
                    .font(.headline)
                Text("Get 5 in a row (horizontal/diagonal/vertical).")
                Text("Or capture 10 of the opposing pieces.")
            }
            Group {
                Text("How to Capture?")
                    .font(.headline)
                Text("The targets for capture must be 2 pieces positioned adjacent to each other")
                Text("To capture the targets, a piece must placed on either end of the targets")
                Text("X O O X --> X _ _ X")
                Text("With 'O' being the target for capture")
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Dismiss")
            }
            Spacer()
        }
    }
}

struct ContentView: View {
    @State var playGame: Bool = false
    var body: some View {
        NavigationStack {
            if playGame {
                GameView(playGame: $playGame)
            } else {
                MenuView(playGame: $playGame)
            }
        }
    }
}

struct GameView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var playGame: Bool
    var body: some View {
        VStack {
            BoardView(game: GameData(), save: add, delete: { _ in })
        }
        .toolbar(content: {
            ToolbarItem(placement: .bottomBar) {
                Button("Quit") {
                    playGame = false
                }
            }
        })
    }
    private func add(_ game: GameData) {
        withAnimation {
            modelContext.insert(game)
        }
    }
}

#Preview {
    ContentView()
}
