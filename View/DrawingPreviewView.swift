//
//  DrawingPreviewView.swift
//
//
//  Created by Gustavo Munhoz Correa on 21/02/24.
//

import SwiftUI

struct DrawingPreviewView: View {
    @EnvironmentObject var store: AppStore
    var previewImageName: ModelSVG
    
    var body: some View {
        VStack {
            Image(previewImageName.rawValue)
                .resizable()
                .frame(width: 250, height: 300)
                .aspectRatio(contentMode: .fit)
                .padding()
        }
        .padding()
        .background(Color("Background"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("SecondaryText"), lineWidth: 3)
        )
        .onTapGesture {
            withAnimation {
                store.dispatch(.navigateToDrawing(previewImageName))
            }
        }
    }
}
