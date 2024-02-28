//
//  TryYourselfView.swift
//
//
//  Created by Gustavo Munhoz Correa on 20/02/24.
//

import SwiftUI

struct TryYourselfView: View {
    @EnvironmentObject var store: AppStore
    @State var localScale: CGFloat = 1.0
    
    private enum texts: String {
        case title = " Try It Yourself!"
        case body = "Now that you've glimpsed the power of the Fourier Transform, it's time to experience it firsthand.\n\nIn the next section, you'll step into a virtual lab where you can play with signals and watch as they combine to form complex patterns.\n\nThis hands-on experience will solidify your understanding and showcase the transformative power of the Fourier Transform.\n\nTry changing the number of circles of the image below to see how the signal changes!"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 48) {
            
            Group {
                Text(Image(systemName: "pencil.and.outline"))
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
                Group {
                    if let viewModel = store.state.fourierData.viewModel {
                        VStack {
                            FourierDrawingView(viewModel: viewModel)
                                .scaleEffect(0.9)
                                .offset(y: -175)
                                .zIndex(-10)
                                .minimumScaleFactor(0.8)
                        }
                    } else {
                        ProgressView()
                    }
                }

                VStack {
                    VStack {
                        HStack {
                            HStack{
                                Button(action: {
                                    store.dispatch(.decreaseCircleNumber)
                                }) {
                                    Image(systemName: "minus")
                                        .padding()
                                        .fontWeight(.bold)
                                        .foregroundStyle(
                                            store.state.currentExpOfTwo == 2 ? Color.gray : Color("FourierLineStroke")
                                        )
                                }
                                .padding(.leading, 8)
                                .disabled(store.state.currentExpOfTwo == 2)
                                
                                Rectangle()
                                    .frame(width: 2)
                                    .frame(maxHeight: 35)
                                
                                Button(action: {
                                    store.dispatch(.increaseCircleNumber)
                                }) {
                                    Image(systemName: "plus")
                                        .padding()
                                        .fontWeight(.bold)
                                        .foregroundStyle(
                                            store.state.currentExpOfTwo == 10 ? Color.gray : Color("FourierLineStroke")
                                        )
                                }
                                .padding(.trailing, 8)
                                .disabled(store.state.currentExpOfTwo == 10)
                            }
                            .font(.title)
                            .background(Color("PrimaryText").opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Spacer()
                        }
                        HStack {
                            Text("Epicycles: \(NSDecimalNumber(decimal: pow(2, store.state.currentExpOfTwo) - 1))")
                                .foregroundStyle(Color("PrimaryText"))
                                .fontWeight(.medium)
                                .font(.system(size: 24))
                            
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Text("6 of 6")
                            .font(.system(size: 21))
                            .padding(.leading)
                            .foregroundStyle(Color("SecondaryText"))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy(duration: 0.4)) {
                                store.dispatch(.navigateToGallery)
                            }
                        } label: {
                            HStack {
                                Text(store.state.viewState.isGuide ? "Gallery" : "Start Over")
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
        .onAppear {
            store.dispatch(.loadSVG(named: .Ipad, resetExpoent: true))
        }
        .padding([.horizontal, .top], 32)
        .padding(.bottom, 64)
        .background(Color("Background"))
    }
}

#Preview {
    TryYourselfView()
        .environmentObject(AppStore(initial: AppState(), reducer: appReducer, middlewares: [svgLogic]))
}
