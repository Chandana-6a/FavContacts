import Foundation
import CoreData

final class EditContactViewModel: ObservableObject {
    @Published var contact: Contact
    let isNew: Bool
    private let provider: ContactsProvider
    private let context: NSManagedObjectContext
    
    init(provider: ContactsProvider, contact: Contact? = nil) {
        self.provider = provider
        self.context = provider.newContext
        if let contact,
           let existingContantCopy = provider.exists(contact, in: context) {
            self.contact = existingContantCopy
            self.isNew = false
        } else {
            self.contact = Contact(context: self.context)
            self.isNew = true

        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
    
}
