//
//  BoardView.swift
//  Pente
//
//  Created by Christopher Yoon on 4/1/24.
//

import SwiftUI

struct BoardView: View {
    @Bindable var game: GameData
    var save: (GameData) -> ()
    var delete: (GameData) -> ()
    
    @State var vm = VM()
    @State var showAlert = false
    var body: some View {
        VStack(spacing: vm.spacing) {
            vm.capCounter()
            ForEach(0..<vm.rowMax, id: \.self) { row in
                HStack(spacing: vm.spacing) {
                    ForEach(0..<vm.colMax, id: \.self) { col in
                        vm.tileView(row: row, col: col)
                            .onTapGesture {
                                print("Adding Move row: \(row), col: \(col)")
                                game.addMove(row: row, col: col)
                            }
                    }
                }
            }
            HStack {
                Spacer()
                Button("Save Moves") {
                    for move in vm.tempMoveList {
                        print("Adding Move row: \(move.0), col: \(move.1)")
                        game.addMove(row: move.0, col: move.1)
                    }
                }
                Spacer()
                Button("Save Game") {
                    save(game)
                }
                Spacer()
            }
            List {
                Text("Move List")
                ForEach(game.moves, id: \.self) { move in
                    Text("Row: \(move.row), Col: \(move.col)")
                }
            }
        }
        .onChange(of: vm.isGameOver) {
            if vm.isGameOver {
                showAlert = true
            }
        }
        .alert("Game Over", isPresented: $showAlert) {
            Button {
                vm.resetGame()
            } label: {
                Text("OK")
            }
        } message: {
            Text(vm.getAlertText())
        }
    }
}
struct TileView: View {
    var tile: Tile
    var body: some View {
        Image(systemName: tile.player.symbol)
            .resizable()
            .scaledToFit()
            .foregroundColor(tile.player.color)
            .background {
                ZStack {
                    Rectangle().opacity(0.001)
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke()
                }
            }
    }
}

#Preview {
    BoardView(game: GameData(), save: { _ in }, delete: { _ in })
}
