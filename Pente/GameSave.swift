//
//  GameSave.swift
//  Pente
//
//  Created by Christopher Yoon on 4/7/24.
//

import Foundation
import SwiftData

struct Move: Codable {
    var timestamp: Date = Date()
    var row: Int
    var col: Int
}
@Model
class GameData {
    var timestamp : Date
    var player1: String
    var player2: String
    var moves : [Move]
    
    init(timestamp: Date = Date(), player1: String = "", player2: String = "", moves: [Move] = []) {
        self.timestamp = timestamp
        self.player1 = player1
        self.player2 = player2
        self.moves = moves
    }
    
    func addMove(row: Int, col: Int) {
        moves.append(Move(row: row, col: col))
    }
}
