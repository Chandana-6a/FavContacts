import SwiftUI

struct NoContactsView: View {
    var body: some View {
        VStack {
            Text("No contacts")
                .font(.largeTitle.bold())
            Text("It's empty, create some contacts now")
                .font(.callout)
        }
    }
}

#Preview {
    NoContactsView()
}
