import SwiftUI

struct CookbookView: View {
        
    var body: some View {
        NavigationView {
            VStack {
                Text("Cookbook")
                    .font(.largeTitle)
                Text("AsyncBluetooth")
                
                Spacer()
                NavigationLink("Scan", destination: ScanView())
                    .font(.title2)
                    .foregroundColor(.blue)
                Spacer()
            }
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CookbookView_Previews: PreviewProvider {
    static var previews: some View {
        CookbookView()
            .preferredColorScheme(.dark)
    }
}
