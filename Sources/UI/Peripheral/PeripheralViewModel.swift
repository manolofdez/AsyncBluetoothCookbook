import Foundation
import AsyncBluetooth
import CoreBluetooth

class PeripheralViewModel: ObservableObject {

    @Published private(set) var isDiscovering = false
    @Published private(set) var services: [ServiceListItem] = []
    
    var name: String {
        self.peripheral?.name ?? "-"
    }
    
    var ancsAuthorized: String {
        self.peripheral?.ancsAuthorized == true ? "Yes" : "No"
    }
    
    var state: String {
        Self.descriptionOfState(self.peripheral?.state ?? .disconnected)
    }
    
    private let centralManager: CentralManager
    private let peripheral: Peripheral?
    
    init(peripheralID: UUID, centralManager: CentralManager = CentralManager.shared) {
        self.centralManager = centralManager
        self.peripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheralID]).first
    }
    
    func discoverServices() {
        self.isDiscovering = true
        self.services.removeAll()
        
        Task {
            self.discoverServices()
        }
    }
    
    private func discoverServices() async {
        guard let peripheral = self.peripheral else { return }
        
        do {
            try await peripheral.discoverServices(nil)
            
            for service in peripheral.discoveredServices ?? [] {
                try await peripheral.discoverCharacteristics(nil, for: service)
                
                guard let serviceUUID = UUID(uuidString: service.id.uuidString) else { return }
                let characteristics = service.discoveredCharacteristics?.map {
                    "\($0.id)"
                }.joined(separator: ", ") ?? "-"
                self.services.append(ServiceListItem(id: serviceUUID, characteristics: characteristics))
            }
        } catch { return }
        
        DispatchQueue.main.async {
            self.isDiscovering = false
        }
    }
    
    private static func descriptionOfState(_ state: CBPeripheralState) -> String {
        switch state {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .disconnected:
            return "Disconnected"
        case .disconnecting:
            return "Disconnecting"
        @unknown default:
            return "Unknown"
        }
    }
}
