//
//  Engine.swift
//  Pente
//
//  Created by Christopher Yoon on 4/1/24.
//

import Foundation

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
            "xmark"
        case .o:
            "circle"
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
    private (set) var board = [
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
    ]
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
        updateGameState()
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
        if (row + 3 <= 0) && (col - 3 >= 0) {
            if (tempBoard[row+1][col-1].player.isOpposite(player: currentPlayer)) && (tempBoard[row+2][col-2].player.isOpposite(player: currentPlayer)) && (tempBoard[row+3][col-3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row+1][col-1].player = .none
                tempBoard[row+2][col-2].player = .none
                captureCounter()
            }
        }
        
        // diagonal down right
        // (row + 3 <= 0) && (col + 3 <= 0)
        if (row + 3 <= 0) && (col + 3 >= 0) {
            if (tempBoard[row+1][col+1].player.isOpposite(player: currentPlayer)) && (tempBoard[row+2][col+2].player.isOpposite(player: currentPlayer)) && (tempBoard[row+3][col+3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row+1][col+1].player = .none
                tempBoard[row+2][col+2].player = .none
                captureCounter()
            }
        }
        // diagonal up right
        // (row - 3 >= 0) && (col + 3 <= 0)
        if (row - 3 <= 0) && (col + 3 >= 0) {
            if (tempBoard[row-1][col+1].player.isOpposite(player: currentPlayer)) && (tempBoard[row-2][col+2].player.isOpposite(player: currentPlayer)) && (tempBoard[row-3][col+3].player == currentPlayer) {
                // Capture occurs
                tempBoard[row-1][col+1].player = .none
                tempBoard[row-2][col+2].player = .none
                captureCounter()
            }
        }
        
        board = tempBoard
    }
    
    func updateGameState() {
        // check for a win
        
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
    func checkDiagonalWin() -> Player {
        
        return .none
    }
    func checkVerticalWin() -> Player {
        return .none
    }
    func checkHorizontalWin() -> Player {
        return .none
    }
    func checkForDraw() {
        
    }
    
    func resetGame() {
        print("Resetting Game")
        board = [
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
            [Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile(), Tile()],
        ]
        currentPlayer = .x
        currentGameState = .running
    }
}
