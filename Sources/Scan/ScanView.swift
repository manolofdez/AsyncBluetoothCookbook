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
            List(self.viewModel.peripherals, id: \.self) { peripheral in
                Text(peripheral)
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
            } else {
                Button("Stop Scan") { self.viewModel.onStopScanButtonPressed() }
                    .font(.title2)
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
    class MockViewModel: ScanViewModel {
        @Published private var _isScanning = false
        @Published private var _peripherals: [String] = []
        @Published private var _error: String?
        
        override var isScanning: Bool {
            self._isScanning
        }
        
        override var peripherals: [String] {
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
                self._peripherals.append("Item #\(self._peripherals.count + 1)")
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
