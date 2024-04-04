//
//  Engine.swift
//  Pente
//
//  Created by Christopher Yoon on 4/1/24.
//

import Foundation
import SwiftUI

enum GameState: Int {
    case running = 0, xwin, owin, draw
    var text: String {
        switch self {
        case .running:
            "Game in Progress"
        case .xwin:
            "X has Won the Game"
        case .owin:
            "O has Won the Game"
        case .draw:
            "Game Results in a Tie"
        }
    }
}
enum Player: Int {
    case none = 0, x, o
    var text: String {
        switch self {
        case .none:
            "none"
        case .x:
            "X"
        case .o:
            "O"
        }
    }
    var symbol: String {
        switch self {
        case .none:
            ""
        case .x:
            "circle.fill"
        case .o:
            "circle.fill"
        }
    }
    var color: Color {
        switch self {
        case .none:
            Color.clear
        case .x:
            Color.red
        case .o:
            Color.blue
        }
    }
    func isOpposite(player: Player) -> Bool {
        if self == .none {
            return false
        }
        return self != player
    }
}

struct Tile: Identifiable {
    var id : UUID = UUID()
    var player : Player = .none
}

@Observable
class Engine {
    private (set) var board = Array(repeating: Array(repeating: Tile(), count: 19), count: 19)
    
    let rowMax: Int = 19
    let colMax: Int = 19
    
    var currentGameState : GameState = .running
    var numberCapturedByX: Int = 0
    var numberCapturedByO: Int = 0
    
    var currentPlayer : Player = .x
    func changeTurn() {
        guard currentGameState == .running else { return }
        if currentPlayer == .x {
            currentPlayer = .o
        } else {
            currentPlayer = .x
        }
    }
    
    func handleTap(row: Int, col: Int) {
        guard currentGameState == .running else { return }
        let selectedTile = board[row][col]
        guard selectedTile.player == .none else { return }
        changeTile(row: row, col: col)
        capturePiece(row: row, col: col)
        // check for win
        updateGameState(row: row, col: col)
    }
    func changeTile(row: Int, col: Int) {
        board[row][col].player = currentPlayer
    }
    
    func captureCounter() {
        if currentPlayer == .x {
            numberCapturedByX += 2
        }
        if currentPlayer == .o {
            numberCapturedByO += 2
        }
    }
    func capturePiece(row: Int, col: Int) {
        var tempBoard = board
        // Must be 4 from 0 and max
        
        // row
        // (row - 3 >= 0) (up)
        if (row - 3 >= 0) {
            if (tempBoard[row-1][col].player.isOpposite(player: currentPlayer)) && (tempBoard[row-2][col].player.isOpposite(player: currentPlayer)) && (tempBoard[row-3][col].player == currentPlayer) {
                // Capture occurs
                tempBoard[row-1][col].player = .none
                tempBoard[row-2][col].player = .none
                captureCounter()
            }
        }
        
        // (row + 3 <= rowMax) (down)
        if (row + 3 <= rowMax) {
            if (tempBoard[row+1][col].player.isOpposite(player: currentPlayer)) && (tempBoard[row+2][col].player.isOpposite(player: currentPlayer)) && (tempBoard[row+3][col].player == currentPlayer) {
                // Capture occurs
                tempBoard[row+1][col].player = .none
                tempBoard[row+2][col].player = .none
                captureCounter()
            }
        }
        
        // col
        // (col - 3 >= 0) (left)
        if (col - 3 >= 0) {
            if (tempBoard[row][col-1].player.isOpposite(player: currentPlayer)) && (tempBoard[row][col-2].player.isOpposite(player: currentPlayer)) && (tempBoard[row][col-3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row][col-1].player = .none
                tempBoard[row][col-2].player = .none
                captureCounter()
            }
        }
        // (col + 3 <= rowMax) (right)
        if (col + 3 <= rowMax) {
            if (tempBoard[row][col+1].player.isOpposite(player: currentPlayer)) && (tempBoard[row][col+2].player.isOpposite(player: currentPlayer)) && (tempBoard[row][col+3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row][col+1].player = .none
                tempBoard[row][col+2].player = .none
                captureCounter()
            }
        }
        
        // diagonal up left
        // (row - 3 >= 0) && (col - 3 >= 0)
        if (row - 3 >= 0) && (col - 3 >= 0) {
            if (tempBoard[row-1][col-1].player.isOpposite(player: currentPlayer)) && (tempBoard[row-2][col-2].player.isOpposite(player: currentPlayer)) && (tempBoard[row-3][col-3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row-1][col-1].player = .none
                tempBoard[row-2][col-2].player = .none
                captureCounter()
            }
        }
        // diagonal down left
        // (row + 3 <= 0) && (col - 3 >= 0)
        if (row + 3 <= rowMax) && (col - 3 >= 0) {
            if (tempBoard[row+1][col-1].player.isOpposite(player: currentPlayer)) && (tempBoard[row+2][col-2].player.isOpposite(player: currentPlayer)) && (tempBoard[row+3][col-3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row+1][col-1].player = .none
                tempBoard[row+2][col-2].player = .none
                captureCounter()
            }
        }
        
        // diagonal down right
        // (row + 3 <= rowMax) && (col + 3 <= colMax)
        if (row + 3 <= rowMax) && (col + 3 <= colMax) {
            if (tempBoard[row+1][col+1].player.isOpposite(player: currentPlayer)) && (tempBoard[row+2][col+2].player.isOpposite(player: currentPlayer)) && (tempBoard[row+3][col+3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row+1][col+1].player = .none
                tempBoard[row+2][col+2].player = .none
                captureCounter()
            }
        }
        // diagonal up right
        // (row - 3 >= 0) && (col + 3 <= colMax)
        if (row - 3 >= 0) && (col + 3 <= colMax) {
            if (tempBoard[row-1][col+1].player.isOpposite(player: currentPlayer)) && (tempBoard[row-2][col+2].player.isOpposite(player: currentPlayer)) && (tempBoard[row-3][col+3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row-1][col+1].player = .none
                tempBoard[row-2][col+2].player = .none
                captureCounter()
            }
        }
        
        board = tempBoard
    }
    
    func updateGameState(row: Int, col: Int) {
        // check for a win
        flagWin(player: checkTotalCountForWin())
        flagWin(player: checkDiagonalWin(row: row, col: col))
        flagWin(player: checkHorizontalWin(row: row, col: col))
        flagWin(player: checkVerticalWin(row: row, col: col))
        // else, check for a draw (all tiles filled)
//        checkForDraw()
        // else, game continues (only change turn if game continues)
        changeTurn()
    }
    func flagWin(player: Player) {
        guard currentGameState == .running else { return }
        if player.text == "X" {
            // X Wins
            currentGameState = .xwin
        } else if player.text == "O" {
            // O Wins
            currentGameState = .owin
        } else {
            // No Win Detected
            currentGameState = .running
        }
    }
    func checkTotalCountForWin() -> Player {
        if numberCapturedByX >= 10 {
            return .x
        }
        if numberCapturedByO >= 10 {
            return .o
        }
        return .none
    }
    func checkDiagonalWin(row: Int, col: Int) -> Player {
        // Check diagonals, shift over one for each
        
        // No winning conditions found
        return .none
    }
    func checkVerticalWin(row: Int, col: Int) -> Player {
        // Check Verticals, shift over one for each
        
        // No winning conditions found
        return .none
    }
    func checkHorizontalWin(row: Int, col: Int) -> Player {
        // Check Horizontals, shift over one for each
        let player = board[row][col].player
        for startOffset in -4...0 {
            let newCol = col + startOffset
            guard (newCol >= 0) && (newCol < colMax) else { continue }
            var numberMatching = 0
            for offset in 0...4 {
                let c = newCol + offset
                guard (c >= 0) && (c < colMax) else { break }
                if board[row][c].player == player {
                    numberMatching += 1
                }
            }
            if numberMatching == 5 {
                return player
            }
        }
        // No winning conditions found
        return .none
    }
    func checkForDraw() {
        
    }
    
    func resetGame() {
        print("Resetting Game")
        board = Array(repeating: Array(repeating: Tile(), count: 19), count: 19)
        currentPlayer = .x
        currentGameState = .running
        numberCapturedByX = 0
        numberCapturedByO = 0
    }
}
