//
//  MenuView.swift
//  Pente
//
//  Created by Christopher Yoon on 4/5/24.
//

import SwiftUI

struct MenuView: View {
    @State private var showingRulesSheet = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Pente")
                    .font(.largeTitle)
                Button {
                    
                } label: {
                    Text("Play")
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

#Preview {
    MenuView()
}
