//
//  SmoothieView.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import SwiftUI

struct SmoothieView: View {
    @EnvironmentObject var store: AppStore
    
    private enum texts: String {
        case title = " Reverse Engineering a Smoothie"
        case body = "Think of your favorite smoothie. It's a perfect blend of various fruits, each contributing its unique flavor.\n\nNow, imagine if you could separate each flavor back out, identifying every single fruit that went into the mix. The Fourier Transform does just this, but with signals! It 'decomposes' them into basic sine and cosine waves, revealing the 'ingredients' of any signal."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            
            Group {
                Text(Image(systemName: "mug.fill"))
                    .foregroundColor(Color("FourierLineStroke"))
                + Text(texts.title.rawValue)
            }
            .minimumScaleFactor(0.8)
            .font(.system(size: 64))
            .fontWeight(.bold)
            .foregroundStyle(Color("PrimaryText"))
            .padding()
            
            Text(texts.body.rawValue)
                .font(.system(size: 28))
                .minimumScaleFactor(0.5)
                .foregroundStyle(Color("SecondaryText"))
                .padding(.horizontal)
            
            ZStack {
                Image("smoothie")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                VStack {
                    Spacer()
                    HStack {
                        Text("2 of 6")
                            .font(.system(size: 21))
                            .padding(.leading)
                            .foregroundStyle(Color("SecondaryText"))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy(duration: 0.4)) {
                                store.dispatch(.navigateToFrequency)
                            }
                        } label: {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(Color("FourierLineStroke"))
                            .fontWeight(.black)
                            .font(.system(size: 21))
                            .padding(.trailing)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding([.horizontal, .top], 32)
        .padding(.bottom, 64)
        .background(Color("Background"))
    }
}

#Preview {
    SmoothieView()
}
