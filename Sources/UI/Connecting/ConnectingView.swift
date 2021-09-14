import SwiftUI

struct ConnectingView: View {
        
    var body: some View {
        VStack {
            NavigationLink(
                "",
                destination: PeripheralView(peripheralID: self.viewModel.peripheralID),
                isActive: self.$viewModel.isConnected
            )
            
            Spacer()
            Text("Connecting")
                .font(.largeTitle)
            Text(self.viewModel.peripheralID.uuidString)
                .font(.callout)
            
            if let error = self.viewModel.error {
                Text("ERROR: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(1)
            } else {
                ProgressView()
            }
            Spacer()
            
            Button("Cancel") { self.onCancelTapped() }
                .font(.title2)
                .padding(10)
        }
            .navigationBarBackButtonHidden(true)
    }
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: ConnectingViewModel
    
    init(peripheralID: UUID) {
        let viewModel = ConnectingViewModel(peripheralID: peripheralID)
        self.init(viewModel: viewModel)
    }
    
    fileprivate init(viewModel: ConnectingViewModel) {
        self.viewModel = viewModel
        self.viewModel.connect()
    }
    
    private func onCancelTapped() {
        self.viewModel.cancel()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct ConnectingView_Previews: PreviewProvider {
    class MockViewModel: ConnectingViewModel {
        override func connect() {}
    }
    
    static var previews: some View {
        ConnectingView(viewModel: MockViewModel(peripheralID: UUID()))
            .preferredColorScheme(.dark)
    }
}
