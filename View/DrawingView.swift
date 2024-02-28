//
//  DrawingView.swift
//
//
//  Created by Gustavo Munhoz Correa on 21/02/24.
//

import SwiftUI

struct DrawingView: View {
    @EnvironmentObject var store: AppStore
    
    @State private var localScale: CGFloat = 0.0
    @State private var localMax: CGFloat = 340.0
    
    var drawing: ModelSVG

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            store.dispatch(.navigateToGallery)
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 12, height: 20)
                                .padding(.trailing, 6)
                            
                            Text("Gallery")
                                .font(.title)
                        }
                    }
                    .foregroundStyle(Color("FourierLineStroke"))
                    .padding(24)
                    .background(Color("Background").opacity(0.7))
                    
                    Spacer()
                }
                .padding(.top)
                .zIndex(2)
                
                VStack {
                    Group {
                        if let viewModel = store.state.fourierData.viewModel {
                            VStack {
                                FourierDrawingView(viewModel: viewModel)
                                    .scaleEffect(viewModel.scale)
                                    .padding()
                                    .offset(y: -100)
                            }
                            
                        } else {
                            ProgressView()
                        }
                    }
                    .scaleEffect(0.8)
                    
                    HStack {
                        VStack {
                            HStack {
                                Text("Current epicycle count: \(NSDecimalNumber(decimal: pow(2, store.state.currentExpOfTwo) - 1))")
                                    .font(.title)
                                    .foregroundStyle(Color("PrimaryText"))
                                
                                Spacer()
                                
                                HStack{
                                    Button(action: {
                                        store.dispatch(.decreaseCircleNumber)
                                    }) {
                                        Image(systemName: "minus")
                                            .padding(8)
                                            .fontWeight(.bold)
                                            .foregroundStyle(
                                                store.state.currentExpOfTwo == 2 ? Color.gray : Color("FourierLineStroke")
                                            )
                                    }
                                    .padding(.leading, 8)
                                    .disabled(store.state.currentExpOfTwo == 2)
                                    
                                    Rectangle()
                                        .frame(width: 2)
                                        .frame(maxHeight: 30)
                                        .foregroundStyle(Color("SecondaryText"))
                                    
                                    Button(action: {
                                        store.dispatch(.increaseCircleNumber)
                                    }) {
                                        Image(systemName: "plus")
                                            .padding(8)
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
                            }
                            
                            Divider()
                                .frame(height: 1.5)
                                .overlay(content: {
                                    Color("SecondaryText")
                                })
                                .padding(.vertical, 4)
                            
                            HStack {
                                Text("Control camera zoom")
                                    .font(.title)
                                    .padding(.trailing, 64)
                                    .foregroundStyle(Color("PrimaryText"))
                                
                                Spacer()
                                
                                Slider(value: $localScale, in: log(1)...log(pow(2, CGFloat(store.state.currentExpOfTwo / 2))))
                                    .padding(4)
                                    .tint(Color("FourierLineStroke"))
                                    .onChange(of: localScale) { logValue in
                                        let linearValue = exp(logValue)
                                        
                                        store.state.fourierData.viewModel?.scale = linearValue
                                    }
                                    .frame(width: 200)
                            }
                            
                            Divider()
                                .frame(height: 1.5)
                                .overlay(content: {
                                    Color("SecondaryText")
                                })
                                .padding(.vertical, 4)
                            
                            HStack {
                                Text("Control trace length: \(store.state.fourierData.viewModel!.maxPathPoints)")
                                    .font(.title)
                                    .padding(.trailing, 64)
                                    .foregroundStyle(Color("PrimaryText"))
                                
                                Spacer()
                                
                                Slider(value: $localMax, in: 39...501)
                                    .padding(4)
                                    .tint(Color("FourierLineStroke"))
                                    .onChange(of: localMax) { rawValue in
                                        let value = Int(floor(rawValue))
                                        store.state.fourierData.viewModel?.setMaxPathPoints(to: value)
                                    }
                                    .frame(width: 200)
                            }
                        }
                    }
                    .frame(width: geo.size.width * 0.7)
                    .padding(18)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("PrimaryText"))
                    }
                    .background(Color("Background").opacity(0.85))
                }
                .padding(64)
                .background(Color("Background"))
            }
        }
    }
}

