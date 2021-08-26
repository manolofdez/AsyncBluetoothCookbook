import Foundation
import AsyncBluetooth

class ScanViewModel: ObservableObject {
    @Published private(set) var isScanning = false
    @Published private(set) var peripherals: [String] = []
    @Published private(set) var error: String?

    private let centralManager = CentralManager()
    
    func onStartScanButtonPressed() {
        Task {
            do {
                try await self.startScan()
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    func onStopScanButtonPressed() {
        self.centralManager.stopScan()
    }
    
    private func startScan() async throws {
        self.error = nil
        
        try await self.centralManager.waitUntilReady()
        
        let peripheralScanDataList = try self.centralManager.scanForPeripherals(withServices: nil)
        for await peripheralScanData in peripheralScanDataList {
            self.peripherals.append(peripheralScanData.peripheral.name ?? "-")
        }
    }
}
