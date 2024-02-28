import SwiftUI
import Combine

/// `AppStore` is a generic class designed to hold your application's state and handle actions.
/// It uses the Redux pattern to manage state changes in a predictable way.
/// The store receives actions, sends them through a reducer to compute a new state, and then publishes the state changes to subscribers.

typealias AppStore = Store<AppState, AppAction>

class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State
    
    private let reducer: Reducer<State, Action>
    private let queue = DispatchQueue(
        label: "dev.mnhz.wavetrace.store",
        qos: .userInitiated)
    
    private let middlewares: [Middleware<State, Action>]
    private var cancellables = Set<AnyCancellable>()

    /// Initializes a new store with the given initial state, reducer, and optionally, middlewares.
    /// - Parameters:
    ///   - initial: The initial state of the store.
    ///   - reducer: The reducer function that will be used to handle actions and update the state.
    ///   - middlewares: An array of middleware functions that can intercept actions, perform asynchronous tasks, and dispatch new actions.
    init(initial: State, reducer: @escaping Reducer<State, Action>, middlewares: [Middleware<State, Action>] = []) {
        self.state = initial
        self.reducer = reducer
        self.middlewares = middlewares
    }

    /// Dispatches an action to the store. This is the primary way to trigger state changes in your app.
    /// - Parameter action: The action to be handled by the store.
    func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }

    /// A private method that applies the reducer and middlewares to compute and publish a new state.
    /// - Parameters:
    ///   - currentState: The current state of the store.
    ///   - action: The action to be handled.
    private func dispatch(_ currentState: State, _ action: Action) {
        let newState = reducer(currentState, action)
        
        middlewares.forEach { middleware in
            let publisher = middleware(newState, action)
            publisher.receive(on: DispatchQueue.main).sink(receiveValue: dispatch).store(in: &cancellables)
        }
        
        state = newState
    }
}
