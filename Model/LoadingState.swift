//
//  LoadingState.swift
//  
//
//  Created by Gustavo Munhoz Correa on 19/02/24.
//

enum LoadingState {
    case idle
    case loading
    case loaded
    case failed(Error)
}
