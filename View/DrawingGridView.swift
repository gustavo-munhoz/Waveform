//
//  DrawingGridView.swift
//
//
//  Created by Gustavo Munhoz Correa on 21/02/24.
//

import SwiftUI

struct DrawingGridView: View {
    @State private var selectedTab = "gallery"
        
    var body: some View {
        VStack {
            HStack {
                Text("Wavetrace")
                    .font(.system(size: 52, weight: .heavy))
                    .padding(.leading, 48)
                    .padding(.top, 28)
                
                Spacer()
            }
            .foregroundStyle(Color("PrimaryText"))
            
            TabView(selection: $selectedTab) {
                GalleryView()
                    .tabItem {
                        Label("Gallery", systemImage: "photo.on.rectangle.angled")
                    }
                    .tag("gallery")
                
                GuideView()
                    .tabItem {
                        Label("Guide", systemImage: "book.closed")
                    }
                    .tag("guide")
            }
            .onAppear {
                UITabBar.appearance().barTintColor = UIColor(Color("Background"))
                UITabBar.appearance().backgroundColor = UIColor(Color("Background"))
            }
            .tint(Color("FourierLineStroke"))
            
            Spacer()
        }
    }
}

struct GalleryView: View {
    @EnvironmentObject var store: AppStore
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(store.state.drawingTitles, id: \.self) { title in
                    DrawingPreviewView(previewImageName: title)
                        .padding(.bottom, 24)
                }
            }
            .padding()
        }
        .background(Color("Background"))
    }
}

#Preview {
    DrawingGridView()
}
