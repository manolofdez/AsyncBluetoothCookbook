import SwiftUI
import CoreBluetooth

struct PeripheralView: View {
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                PeripheralInfoRow(title: "Name", value: self.viewModel.name)
                Divider()
                PeripheralInfoRow(
                    title: "ANCS protocol",
                    value: self.viewModel.ancsAuthorized
                )
                Divider()
                PeripheralInfoRow(title: "State", value: self.viewModel.state)
            }
                .background(.white.opacity(0.1))
                .cornerRadius(8)

            Text("Services")
                .font(.title)
                .padding(.top, 20)
            if self.viewModel.isDiscovering {
                ProgressView()
            } else {
                VStack(spacing: 0) {
                    ForEach(self.viewModel.services) { service in
                        VStack {
                            ServiceListItemRow(item: service)
                            Divider()
                        }
                    }
                }
                    .background(.white.opacity(0.1))
                    .cornerRadius(8)
            }
            Spacer()
        }
            .navigationTitle("Peripheral")
    }
    
    @ObservedObject private var viewModel: PeripheralViewModel

    init(peripheralID: UUID) {
        self.init(viewModel: PeripheralViewModel(peripheralID: peripheralID))
    }
    
    fileprivate init(viewModel: PeripheralViewModel) {
        self.viewModel = viewModel
        self.viewModel.discoverServices()
    }
}

struct PeripheralInformationView_Previews: PreviewProvider {
    class MockViewModel: PeripheralViewModel {
        override var services: [ServiceListItem] {
            [
                ServiceListItem(
                    id: UUID(),
                    characteristics: "char1, char2"
                ),
                ServiceListItem(
                    id: UUID(),
                    characteristics: "char4, char4"
                ),
            ]
        }
        
        override func discoverServices() {}
    }
    
    static var previews: some View {
        NavigationView {
            PeripheralView(viewModel: MockViewModel(peripheralID: UUID()))
                .preferredColorScheme(.dark)
        }
    }
}

