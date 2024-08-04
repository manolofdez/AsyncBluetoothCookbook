import Foundation
import AsyncBluetooth

@MainActor
class ConnectingViewModel: ObservableObject {
    let peripheralID: UUID

    @Published private(set) var isConnected = false
    @Published private(set) var error: String?
    
    private let centralManager: CentralManager
    
    private lazy var peripheral: Peripheral? = {
        self.centralManager.retrievePeripherals(withIdentifiers: [self.peripheralID]).first
    }()
    
    init(peripheralID: UUID, centralManager: CentralManager = CentralManager.shared) {
        self.peripheralID = peripheralID
        self.centralManager = centralManager
    }

    func connect() {
        guard let peripheral = self.peripheral else {
            self.error = "Unknown peripheral. Did you forget to scan?"
            return
        }
        Task { @MainActor [centralManager] in
            do {
                if await centralManager.isScanning {
                    await centralManager.stopScan()
                }
                
                try await centralManager.connect(peripheral)
                
                try await peripheral.discoverServices(nil)
                
                for service in peripheral.discoveredServices ?? [] {
                    try await peripheral.discoverCharacteristics(nil, for: service)
                }

                self.isConnected = true
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    func cancel() {
        guard let peripheral = self.peripheral else {
            self.error = "Unknown peripheral. Did you forget to scan?"
            return
        }
        Task {
            do {
                try await self.centralManager.connect(peripheral)
            } catch {}
        }
    }
}
