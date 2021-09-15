import Foundation
import AsyncBluetooth

protocol ScanViewPeripheralListItem {
    var identifier: UUID { get }
    var name: String? { get }
}

extension Peripheral: ScanViewPeripheralListItem {}
