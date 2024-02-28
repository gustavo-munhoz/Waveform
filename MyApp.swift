import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(
                    AppStore(
                        initial: AppState(),
                        reducer: appReducer,
                        middlewares: [svgLogic]
                    ))
        }
    }
}
