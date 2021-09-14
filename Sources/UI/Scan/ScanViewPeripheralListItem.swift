import Foundation
import AsyncBluetooth

protocol ScanViewPeripheralListItem {
    var id: UUID { get }
    var name: String? { get }
}

extension Peripheral: ScanViewPeripheralListItem {}
