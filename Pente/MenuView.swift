//
//  MenuView.swift
//  Pente
//
//  Created by Christopher Yoon on 4/5/24.
//

import SwiftUI

struct MenuView: View {
    @State private var showingRulesSheet = false
    @Binding var playGame: Bool
    var body: some View {
        VStack {
            Text("Pente")
                .font(.largeTitle)
            Button {
                playGame = true
            } label: {
                Text("Play Game")
            }
            Button {
                showingRulesSheet.toggle()
            } label: {
                Text("How to Play?")
            }
            .sheet(isPresented: $showingRulesSheet, content: {
                RulesView()
            })
        }
    }
}

struct RulesView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Rules Here")
                .font(.title)
            Button {
                dismiss()
            } label: {
                Text("Dismiss")
            }

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
    @Binding var playGame: Bool
    var body: some View {
        VStack {
            BoardView()
        }
        .toolbar(content: {
            ToolbarItem(placement: .bottomBar) {
                Button("Quit") {
                    playGame = false
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
