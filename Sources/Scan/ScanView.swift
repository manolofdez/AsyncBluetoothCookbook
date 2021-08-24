import SwiftUI
import Combine

struct ScanView: View {
    
    @State private var showStopScanButton = false
    
    var body: some View {
        VStack {
            Text("Scan Test")
                .font(.largeTitle)
            Text("AsyncBluetooth")
            
            Spacer()
            
            if !self.showStopScanButton {
                Button("Scan") { self.onStartScanButtonPressed() }
                    .font(.title2)
            } else {
                Button("Stop") { self.onStopScanButtonPressed() }
                    .font(.title2)
            }
        }
    }
    
    private func onStartScanButtonPressed() {}
    
    private func onStopScanButtonPressed() {}
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
