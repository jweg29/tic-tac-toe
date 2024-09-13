//
//  ContentView.swift
//  TicTacToe
//
//  Created by James Wegner on 9/12/24.
//

import SwiftUI

struct GameView: View {
    @State var game: Game

    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)

            if let winner = game.winner {
                Text("\(winner.marker) wins!")
                    .font(.title)
                    .padding()
            } else if game.isTieGame {
                Text("Cats game")
                    .font(.title)
                    .padding()
            }

            BoardView(game: $game)

            if game.winner != nil || game.isTieGame {
                Button(action: {
                    game.resetGame()
                }) {
                    Text("New game")
                }
                .padding()
            }
        }
        .padding()
    }
}

struct BoardView: View {
    @Binding var game: Game

    var body: some View {
        ForEach(0..<game.board.count, id: \.self) { rowIndex in
            HStack {
                ForEach(0..<game.board[rowIndex].count, id: \.self) { colIndex in
                    Button(action: {
                        if game.board[rowIndex][colIndex] == nil && game.winner == nil {
                            game.board[rowIndex][colIndex] = game.currentPlayer
                            game.advanceTurn()
                        }
                    }) {
                        Text(game.board[rowIndex][colIndex]?.marker ?? "")
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.1))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .tint(game.board[rowIndex][colIndex]?.color)
                    }
                }
            }
        }
    }
}

struct Game {
    var board: [[Player?]]

    var currentPlayer: Player {
        return players[currentPlayerIndex]
    }
    var winner: Player?
    var isTieGame: Bool = false

    private let rows: Int
    private let cols: Int
    private let players: [Player]
    private var currentPlayerIndex: Int = 0

    mutating func advanceTurn() {
        checkGameState()

        if winner != nil {
            return
        }

        currentPlayerIndex += 1
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
        }
    }

    mutating func resetGame() {
        winner = nil
        isTieGame = false
        for i in board.indices {
            for j in board[i].indices {
                board[i][j] = nil
            }
        }
    }

    private mutating func checkGameState() {
        // Check all rows going across
        for i in 0..<rows {
            var potentialWinner = board[i][0]
            for j in 0..<cols {
                if board[i][j] != potentialWinner {
                    potentialWinner = nil
                    break
                }
            }

            if potentialWinner != nil {
                winner = potentialWinner
                return
            }
        }

        // Check all columns going down
        for j in 0..<cols {
            var potentialWinner = board[0][j]
            for i in 0..<rows {
                if board[i][j] != potentialWinner {
                    potentialWinner = nil
                    break
                }
            }

            if potentialWinner != nil {
                winner = potentialWinner
                return
            }
        }

        // Check diagonal from top left
        var potentialWinner = board[0][0]
        for i in 0..<cols {
            if board[i][i] != potentialWinner {
                potentialWinner = nil
                break
            }
        }
        if potentialWinner != nil {
            winner = potentialWinner
            return
        }

        // Check diagonal from top right
        potentialWinner = board[0][cols-1]
        for i in 0..<rows {
            let j = cols - 1 - i
            if board[i][j] != potentialWinner {
                potentialWinner = nil
                break
            }
        }
        if potentialWinner != nil {
            winner = potentialWinner
            return
        }

        // Check if there is a tie
        var tieGameCheck = true
        for i in 0..<rows {
            for j in 0..<cols {
                if board[i][j] == nil {
                    tieGameCheck = false
                    break
                }
            }
        }

        isTieGame = tieGameCheck
    }

    init?(rows: Int = 3,
          cols: Int = 3,
          players: [Player] =
          [.init(color: .red, marker: "X"),
           .init(color: .blue, marker: "O")]) {
               var standardBoard = [[Player?]].init(repeating: [Player?](), count: rows)

               for i in 0 ..< rows {
                   standardBoard[i] = [Player?].init(repeating: nil, count: cols)
               }

               self.rows = rows
               self.cols = cols
               self.players = players
               self.board = standardBoard
           }
}

struct Player: Equatable {
    let color: Color
    let marker: String

    init(color: Color, marker: String) {
        self.color = color
        self.marker = marker
    }
}

#Preview {
    GameView(game: Game()!)
}
