import Combine

/// Middleware is used in the Redux architecture to handle side effects.
/// It is a function that takes the current state and an action, and returns a `Publisher` that can emit actions.
/// Middleware can be used for logging, handling asynchronous operations, navigation, and more.

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>
