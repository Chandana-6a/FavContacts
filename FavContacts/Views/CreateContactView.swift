import SwiftUI

struct CreateContactView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: EditContactViewModel
    @State private var hasError: Bool = false
        
    var body: some View {
        List {
            Section("General") {
                TextField("Name", text: $vm.contact.name)
                    .keyboardType(.namePhonePad)
                TextField("Email", text: $vm.contact.email)
                    .keyboardType(.emailAddress)
                TextField("Phone Number", text: $vm.contact.phoneNumber)
                    .keyboardType(.phonePad)
                DatePicker("Birthday", selection: $vm.contact.dob, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                Toggle("Favourite", isOn: $vm.contact.isFavourite)
            }
            
            Section("Notes") {
                TextField("", text: $vm.contact.notes,
                axis: .vertical)
                
            }
        }
        .navigationTitle(vm.isNew ? "New Contact" : "Update Contact")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    validate()
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Something ain't right", isPresented: $hasError) {
            Text("It looks like your form is invalid ")
        }
    }
}

private extension CreateContactView {
    func validate() {
        if vm.contact.isValid {
            do {
                try vm.save()
                dismiss()
            } catch {
                print(error)
            }
        } else {
            hasError = true
        }
    }
}

#Preview {
    NavigationStack {
        let preview = ContactsProvider.shared
        CreateContactView(vm: .init(provider: preview))
            .environment(\.managedObjectContext, preview.viewContext)
    }
}
