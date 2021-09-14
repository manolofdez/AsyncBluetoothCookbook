import Foundation
import AsyncBluetooth

class ConnectingViewModel: ObservableObject {
    let peripheralID: UUID
    private let centralManager: CentralManager

    @Published var isConnected = false
    @Published private(set) var error: String?
    
    private var peripheral: Peripheral? {
        self.centralManager.retrievePeripherals(withIdentifiers: [self.peripheralID]).first
    }
    
    init(peripheralID: UUID, centralManager: CentralManager = CentralManager.shared) {
        self.peripheralID = peripheralID
        self.centralManager = centralManager
    }

    func connect() {
        guard let peripheral = self.peripheral else {
            self.error = "Unknown peripheral. Did you forget to scan?"
            return
        }
        Task {
            do {
                try await self.centralManager.connect(peripheral)

                DispatchQueue.main.async {
                    self.isConnected = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
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
