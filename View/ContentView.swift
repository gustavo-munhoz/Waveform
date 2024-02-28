//
//  ContentView.swift
//
//
//  Created by Gustavo Munhoz Correa on 10/02/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VStack {
            switch store.state.viewState {
                case .start:
                    StartView()
                    
                case .guide:
                    GuideView()
                    
                case .gallery:
                    DrawingGridView()
                    
                case .drawing(let svg):
                    DrawingView(drawing: svg)
            }
        }
        .onAppear {
            store.dispatch(.setupParser)
        }
        .background(Color("Background"))
        .ignoresSafeArea()
    }
}
