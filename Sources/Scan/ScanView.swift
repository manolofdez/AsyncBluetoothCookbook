import SwiftUI
import Combine

struct ScanView: View {
    
    @ObservedObject private var viewModel: ScanViewModel
    
    var body: some View {
        VStack {
            Text("Scan Test")
                .font(.largeTitle)
            Text("AsyncBluetooth")
            
            ProgressView()
                .opacity(self.viewModel.isScanning ? 1 : 0)

            Spacer()
            List(self.viewModel.peripherals, id: \.self.id) { peripheral in
                Text(peripheral.name ?? "-")
            }
            Spacer()
            
            if let error = self.viewModel.error {
                Text("ERROR: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(10)
            }
            
            if !self.viewModel.isScanning {
                Button("Start Scan") { self.viewModel.onStartScanButtonPressed() }
                    .font(.title2)
                    .padding(10)
            } else {
                Button("Stop Scan") { self.viewModel.onStopScanButtonPressed() }
                    .font(.title2)
                    .padding(10)
            }
        }
    }
    
    init() {
        self.init(viewModel: ScanViewModel())
    }
    
    fileprivate init(viewModel: ScanViewModel) {
        self.viewModel = viewModel
    }
}

struct ScanView_Previews: PreviewProvider {
    struct Peripheral: ScanViewPeripheralListItem {
        let id: UUID
        let name: String?
    }
    
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
        
        override func onStartScanButtonPressed() {
            self._isScanning = true
            
            self._peripherals.removeAll()
            
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                let peripheral = Peripheral(
                    id: UUID(),
                    name: "Item #\(self._peripherals.count + 1)"
                )
                self._peripherals.append(peripheral)
            }
        }
        
        override func onStopScanButtonPressed() {
            self._isScanning = false
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    static var previews: some View {
        ScanView(viewModel: MockViewModel())
            .preferredColorScheme(.dark)
    }
}
