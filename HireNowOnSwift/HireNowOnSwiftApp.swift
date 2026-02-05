import SwiftUI

@main
struct HireNowOnSwiftApp: App {
    @StateObject private var store = DataStore()

    var body: some Scene {
        WindowGroup {
            RegistrationView()
                .environmentObject(store)
        }
    }
}
