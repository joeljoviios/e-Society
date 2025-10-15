import SwiftUI

struct FamiliesListView: View {
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @State private var showAdd = false

    var body: some View {
        List {
            ForEach(familiesVM.families) { family in
                NavigationLink(destination: FamilyDetailView(family: family)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(family.name).font(.headline)
                            Text(family.apartmentNo).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Families")
        .toolbar {
            Button(action: { showAdd.toggle() }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showAdd) {
            AddFamilyView(show: $showAdd)
        }
    }
}

struct AddFamilyView: View {
    @EnvironmentObject var familiesVM: FamiliesViewModel
    @Binding var show: Bool
    @State private var name = ""
    @State private var apt = ""
    @State private var head = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Family Name", text: $name)
                TextField("Apartment No", text: $apt)
                TextField("Head Name", text: $head)
            }
            .navigationTitle("Add Family")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let f = Family(name: name, apartmentNo: apt, headName: head, phone: nil)
                        familiesVM.add(f)
                        show = false
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { show = false }
                }
            }
        }
    }
}
