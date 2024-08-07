import SwiftUI
import Combine

struct ScanView: View {
        
    var body: some View {
        VStack {
            Text("Scan Test")
                .font(.largeTitle)
            
            ProgressView()
                .opacity(self.viewModel.isScanning ? 1 : 0)

            Spacer()
            List(self.viewModel.peripherals, id: \.self.identifier) { peripheral in
                
                NavigationLink(
                    peripheral.name,
                    destination: ConnectingView(peripheralID: peripheral.identifier)
                )
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            Spacer()
            
            if let error = self.viewModel.error {
                Text("ERROR: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(10)
            }
            
            if !self.viewModel.isScanning {
                Button("Start Scan") { self.viewModel.startScan() }
                    .font(.title2)
                    .padding(10)
            } else {
                Button("Stop Scan") { self.viewModel.stopScan()
                }
                    .font(.title2)
                    .padding(10)
            }
        }
            .onDisappear {
                self.viewModel.stopScan()
            }
    }
    
    @ObservedObject private var viewModel: ScanViewModel
    
    init() {
        self.init(viewModel: ScanViewModel())
    }
    
    fileprivate init(viewModel: ScanViewModel) {
        self.viewModel = viewModel
    }
}

struct ScanView_Previews: PreviewProvider {
    
    class MockViewModel: ScanViewModel {
        @Published private var _isScanning = false
        @Published private var _peripherals: [ScanViewPeripheralListItem] = []
        @Published private var _error: String?
        
        override var isScanning: Bool {
            self._isScanning
        }
        
        override var peripherals: [ScanViewPeripheralListItem] {
            self._peripherals
        }
        
        override var error: String? {
            self._error
        }
        
        private var timer: Timer?
        
        override func startScan() {
            self._isScanning = true
            
            self._peripherals.removeAll()
            
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                Task { [weak self] in
                    guard let self else { return }
                    
                    let peripheral = ScanViewPeripheralListItem(
                        identifier: UUID(),
                        name: "Item #\(await self._peripherals.count + 1)"
                    )
                    await self.appendPeripheral(peripheral)
                }
            }
        }
        
        override func stopScan() {
            self._isScanning = false
            self.timer?.invalidate()
            self.timer = nil
        }
        
        private func appendPeripheral(_ peripheral: ScanViewPeripheralListItem) {
            self._peripherals.append(peripheral)
        }
    }
    
    static var previews: some View {
        NavigationView {
            ScanView(viewModel: MockViewModel())
                .preferredColorScheme(.dark)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
