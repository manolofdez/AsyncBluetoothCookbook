import Foundation
import SwiftUI

struct ServiceListItemRow: View {
    let item: ServiceListItem
    
    var body: some View {
        VStack {
            HStack {
                Text("UUID")
                Spacer()
                Text("\(item.id)")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
            Divider()
            HStack(alignment: .top) {
                Text("Characteristics")
                Spacer()
                Text(item.characteristics)
                    .font(.caption)
            }
        }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 8))
    }
}
