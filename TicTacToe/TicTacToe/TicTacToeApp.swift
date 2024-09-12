//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by James Wegner on 9/12/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    let game: Game = Game()!

    var body: some Scene {
        WindowGroup {
            GameView(game: game)
        }
    }
}
