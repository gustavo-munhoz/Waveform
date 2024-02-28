//
//  FrequencyView.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import SwiftUI

struct FrequencyView: View {
    @EnvironmentObject var store: AppStore
    
    private enum texts: String {
        case title = "  Frequencies: The Ingredients"
        case body = "Just as a smoothie is more than just a mash-up of fruits, a signal is not just a jumble of frequencies. Each 'ingredient' adds a unique layer, a single note to the overall melody.\n\nThe low frequencies are like the rich, mellow flavors of banana or mango, forming the smooth, sustaining base. On the other end, high frequencies are akin to the zesty bursts of berries or citrus, adding a sharpness that cuts through, much like the crisp notes from a guitar's string."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            
            Group {
                Text(Image(systemName: "apple.logo"))
                    .foregroundColor(Color("FourierLineStroke"))
                + Text(texts.title.rawValue)
            }
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
                Image("lemon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                VStack {
                    Spacer()
                    HStack {
                        Text("3 of 6")
                            .font(.system(size: 21))
                            .padding(.leading)
                            .foregroundStyle(Color("SecondaryText"))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy(duration: 0.4)) {
                                store.dispatch(.navigateToEpicycle)
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
    FrequencyView()
}
