import Foundation
import AsyncBluetooth

@MainActor
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
        
        Task { @MainActor [centralManager] in
            do {
                try await centralManager.waitUntilReady()
                
                let scanDataStream = try await centralManager.scanForPeripherals(withServices: nil)
                for await scanData in scanDataStream {
                    let identifier = scanData.peripheral.identifier
                    guard !self.peripherals.contains(where: { $0.identifier == identifier }) else { continue }
                    
                    let name = scanData.peripheral.name
                        ?? scanData.advertisementData["kCBAdvDataLocalName"] as? String
                        ?? "-"
                    
                    let peripheral = ScanViewPeripheralListItem(identifier: identifier, name:  name)
                    
                    self.peripherals.append(peripheral)
                }
            } catch {
                self.error = error.localizedDescription
                self.isScanning = false
            }
        }
    }
    
    func stopScan() {
        Task {
            if await self.centralManager.isScanning {
                await self.centralManager.stopScan()
            }
            
            DispatchQueue.main.async {
                self.isScanning = false
            }
        }
    }
}
