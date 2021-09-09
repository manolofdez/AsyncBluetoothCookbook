import Foundation
import AsyncBluetooth

class ScanViewModel: ObservableObject {
    @Published private(set) var isScanning = false
    @Published private(set) var peripherals: [ScanViewPeripheralListItem] = []
    @Published private(set) var error: String?

    private let centralManager = CentralManager()
    
    func onStartScanButtonPressed() {
        self.isScanning = true
        self.peripherals.removeAll()
        
        Task {
            do {
                try await self.startScan()
            } catch {
                self.error = error.localizedDescription
                
                DispatchQueue.main.async {
                    self.isScanning = false
                }
            }
        }
    }
    
    func onStopScanButtonPressed() {
        self.centralManager.stopScan()
        
        self.isScanning = false
    }
    
    private func startScan() async throws {
        DispatchQueue.main.async {
            self.error = nil
        }
        
        try await self.centralManager.waitUntilReady()
        
        let peripheralScanDataList = try self.centralManager.scanForPeripherals(withServices: nil)
        for await peripheralScanData in peripheralScanDataList {
            guard !self.peripherals.contains(where: { $0.id == peripheralScanData.peripheral.id }) else {
                return
            }
            DispatchQueue.main.async {
                self.peripherals.append(peripheralScanData.peripheral)
            }
        }
    }
}
