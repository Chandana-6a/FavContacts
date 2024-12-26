import SwiftUI

struct SearchConfig: Equatable {
    
    enum Filter {
        case all, fav
    }
    
    var query: String = ""
    var filter: Filter = .all
}

enum Sort {
    case asc, desc
}

struct ContactsView: View {
    
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    
    @State private var contactToEdit: Contact?
    @State private var searchConfig: SearchConfig = .init()
    @State private var sort: Sort = .asc
    
    var provider = ContactsProvider.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                if contacts.isEmpty {
                    NoContactsView()
                } else {
                    List {
                        ForEach(contacts) { contact in
                            
                            ZStack(alignment: .leading) {
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                ContactRowView(contact: contact,
                                               provider: provider)
                                .swipeActions(allowsFullSwipe: true) {
                                    
                                    Button(role: .destructive) {
                                        
                                        do {
                                            try provider.delete(contact,
                                                                in: provider.newContext)
                                        } catch {
                                            print(error)
                                        }
                                        
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                    
                                    Button {
                                        contactToEdit = contact
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.orange)
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
            .searchable(text: $searchConfig.query)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        contactToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu {
                        
                        Section {
                            Text("Filter")
                            Picker(selection: $searchConfig.filter) {
                                
                                Text("All").tag(SearchConfig.Filter.all)
                                Text("Favourites").tag(SearchConfig.Filter.fav)

                            } label: {
                                Text("Filter Faves")
                            }
                        }
                        
                        Section {
                            Text("Sort")
                            Picker(selection: $sort) {
                                
                                Label("Asc", systemImage: "arrow.up").tag(Sort.asc)
                                Label("Desc", systemImage: "arrow.down").tag(Sort.desc)
                                
                            } label: {
                                Text("Sort By")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                            .font(.title2)
                    }
                }
            }
            .sheet(item: $contactToEdit,
                   onDismiss: {
                contactToEdit = nil
            }, content: { contact in
                NavigationStack {
                    CreateContactView(vm: .init(provider: provider,
                                                contact: contact))
                }
            })
            .navigationTitle("Contacts")
            .onChange(of: searchConfig) { _, newConfig in
                contacts.nsPredicate = Contact.filter(with: newConfig)
            }
            .onChange(of: sort) { _, newSort in
                contacts.nsSortDescriptors = Contact.sort(order: newSort)
            }
        }
    }
}



#Preview("Contacts With Data") {
    let preview = ContactsProvider.shared
    ContactsView(provider: preview)
        .environment(\.managedObjectContext, preview.viewContext)
        .onAppear { Contact.makePreview(count: 5, in: preview.viewContext)
        }
}

#Preview("Contacts With No Data") {
    let emptyPreview = ContactsProvider.shared
    ContactsView(provider: emptyPreview)
        .environment(\.managedObjectContext, emptyPreview.viewContext)
}
