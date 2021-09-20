import Foundation
import AsyncBluetooth
import CoreBluetooth

class PeripheralViewModel: ObservableObject {

    var services: [ServiceListItem] {
        guard let peripheral = self.peripheral else { return [] }
        
        var services = [ServiceListItem]()
        
        for service in peripheral.discoveredServices ?? [] {
            guard let serviceUUID = UUID(uuidString: service.uuid.uuidString) else { return [] }
            let characteristics = service.discoveredCharacteristics?.map {
                "\($0.uuid)"
            }.joined(separator: ", ") ?? "-"
            
            services.append(ServiceListItem(id: serviceUUID, characteristics: characteristics))
        }
        
        return services
    }
    
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
    private let peripheralID: UUID
    private var peripheral: Peripheral? {
        centralManager.retrievePeripherals(withIdentifiers: [peripheralID]).first
    }
    
    init(peripheralID: UUID, centralManager: CentralManager = CentralManager.shared) {
        self.centralManager = centralManager
        self.peripheralID = peripheralID
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
