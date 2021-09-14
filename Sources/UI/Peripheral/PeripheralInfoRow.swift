import Foundation
import SwiftUI

struct PeripheralInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(self.title)
            Spacer()
            Text(self.value)
        }.padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 8))
    }
}
