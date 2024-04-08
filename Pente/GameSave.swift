//
//  GameSave.swift
//  Pente
//
//  Created by Christopher Yoon on 4/7/24.
//

import Foundation
import SwiftData
import SwiftUI

struct Move: Codable {
    var timestamp: Date = Date()
    var row: Int
    var col: Int
}
@Model
class GameData {
    var id: UUID = UUID()
    var timestamp : Date
    var player1: String
    var player2: String
    var moves : [Move]
    
    init(timestamp: Date = Date(), player1: String = "Player 1", player2: String = "Player 2", moves: [Move] = []) {
        self.timestamp = timestamp
        self.player1 = player1
        self.player2 = player2
        self.moves = moves
    }
    
    func addMove(row: Int, col: Int) {
        moves.append(Move(row: row, col: col))
    }
}



struct SaveListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var games: [GameData]
    var body: some View {
        List {
            ForEach(games) { game in
                HStack {
                    NavigationLink {
                        BoardView(game: game, save: save, delete: { _ in })
                    } label: {
                        Text("Game \(game.player1) vs \(game.player2)" )
                    }
                }
            }
        }
        .navigationTitle("Save List")
    }
    
    
    private func save(_ game: GameData) {
        withAnimation {
            try? self.modelContext.save()
        }
    }
}
