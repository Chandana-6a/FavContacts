import SwiftUI

@main
struct FavContactsApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContactsView()
                .environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
        }
    }
}
