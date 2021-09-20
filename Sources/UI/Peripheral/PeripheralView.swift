import SwiftUI
import CoreBluetooth

struct PeripheralView: View {
    
    var body: some View {
        VStack {
            Text("Info")
                .font(.title)
                .padding(.top, 20)

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
            Spacer()
        }
            .navigationTitle("Peripheral")
            .navigationBarBackButtonHidden(true)
    }
    
    @ObservedObject private var viewModel: PeripheralViewModel

    init(peripheralID: UUID) {
        self.init(viewModel: PeripheralViewModel(peripheralID: peripheralID))
    }
    
    fileprivate init(viewModel: PeripheralViewModel) {
        self.viewModel = viewModel
    }
}

struct PeripheralInformationView_Previews: PreviewProvider {
    class MockViewModel: PeripheralViewModel {
        override var services: [ServiceListItem] {
            [
                ServiceListItem(
                    id: UUID(),
                    characteristics: "\(UUID()), \(UUID()), \(UUID())"
                ),
                ServiceListItem(
                    id: UUID(),
                    characteristics: "char4, char4"
                ),
            ]
        }
    }
    
    static var previews: some View {
        NavigationView {
            PeripheralView(viewModel: MockViewModel(peripheralID: UUID()))
                .preferredColorScheme(.dark)
        }
    }
}

