//
//  VM.swift
//  Pente
//
//  Created by Christopher Yoon on 4/1/24.
//

import Foundation
import SwiftUI

@Observable
class VM {
    var spacing: CGFloat = 5
    private var engine = Engine()
    
    var rowMax: Int  {
        engine.rowMax
    }
    var colMax: Int {
        engine.colMax
    }
    
    var playerXCapCounter: Int {
        engine.numberCapturedByX
    }
    var playerOCapCounter: Int {
        engine.numberCapturedByO
    }
    
    var isGameOver: Bool {
        engine.currentGameState != .running
    }
    func resetGame() {
        engine.resetGame()
    }
    func getAlertText() -> String {
        engine.currentGameState.text
    }
    
    func tileView(row: Int, col: Int) -> some View {
        TileView(tile: engine.board[row][col])
            .onTapGesture {
                self.engine.handleTap(row: row, col: col)
            }
    }
    
    func capCounter() -> some View {
        HStack {
            VStack {
                HStack {
                    Text("Red Player:  \(playerXCapCounter) ")
                    ForEach(0..<playerXCapCounter, id: \.self) { _ in
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                    Spacer()
                }
                HStack {
                    Text("Blue Player: \(playerOCapCounter) ")
                    ForEach(0..<playerOCapCounter, id: \.self) { _ in
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                    }
                    Spacer()
                }
            }
            Spacer()
            Button {
                self.resetGame()
            } label: {
                Text("Reset")
            }

        }
    }
}
