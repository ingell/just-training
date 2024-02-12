import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
                NavigationLink(destination: WorkoutView()) {
                    Text("Go to WorkoutView")
                        .font(.largeTitle)
                        .fontWeight(.ultraLight)
                }
            }
        }
    }
}

// Assuming you have a preview provider, it should look something like this:
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
