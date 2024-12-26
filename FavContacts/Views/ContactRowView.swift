import SwiftUI

struct ContactRowView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var contact: Contact
    let provider : ContactsProvider
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(contact.formattedName)
                .font(.system(size: 26, design: .rounded).bold())
            Text(contact.email)
                .font(.callout.bold())
            Text(contact.phoneNumber)
                .font(.callout.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button{
                toggleFav()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundStyle(contact.isFavourite ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension ContactRowView {
    
    func toggleFav() {
        contact.isFavourite.toggle()
        do {
            try provider.persist(in: moc)
        } catch {
            print(error)
        }
    }
}

#Preview(){
    let previewProvider = ContactsProvider.shared
    ContactRowView(contact: .preview(context: previewProvider.viewContext), provider: previewProvider)
}
