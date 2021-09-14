import Foundation
import AsyncBluetooth

class ScanViewModel: ObservableObject {
    private let centralManager: CentralManager
    
    @Published private(set) var isScanning = false
    @Published private(set) var peripherals: [ScanViewPeripheralListItem] = []
    @Published private(set) var error: String?

    init(centralManager: CentralManager = CentralManager.shared) {
        self.centralManager = centralManager
    }
    
    func startScan() {
        self.error = nil
        self.peripherals.removeAll()
        self.isScanning = true
        
        Task {
            do {
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
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isScanning = false
                }
            }
        }
    }
    
    func stopScan() {
        self.centralManager.stopScan()
        
        self.isScanning = false
    }
}
