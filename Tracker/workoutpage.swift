import SwiftUI
import Foundation

// Define a model for workout items
struct WorkoutItem: Identifiable {
    var id = UUID()
    var exerciseName: String
    var reps: Int
    var sets: Int
    var weight: Double // Weight can be in lbs or kgs
}

// Observable object to manage workout items
class ModelContext: ObservableObject {
    @Published var items: [WorkoutItem] = []

    func insert(_ item: WorkoutItem) {
        items.append(item)
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

// Main view for displaying and adding workouts
struct WorkoutView: View {
    @StateObject var modelContext = ModelContext()
    @State private var showingAddWorkoutSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(modelContext.items) { item in
                    VStack(alignment: .leading) {
                        Text(item.exerciseName).font(.headline)
                        Text("Sets: \(item.sets), Reps: \(item.reps), Weight: \(item.weight, specifier: "%.1f")")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                // Conditional toolbar item based on the platform
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
                #elseif os(macOS)
                ToolbarItem {
                    addButton
                }
                #endif
            }
            .sheet(isPresented: $showingAddWorkoutSheet) {
                AddWorkoutView(modelContext: modelContext)
            }
        }
    }
    
    private var addButton: some View {
        Button(action: { showingAddWorkoutSheet = true }) {
            Label("Add Workout", systemImage: "plus")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            modelContext.delete(at: offsets)
        }
    }
}
struct AddWorkoutView: View {
    @ObservedObject var modelContext: ModelContext
    @Environment(\.dismiss) var dismiss

    @State private var exerciseName = ""
    @State private var repsString = "" // Keep as String for TextField
    @State private var setsString = "" // Use String to capture input, then convert
    @State private var weightString = "" // Use String to capture input, then convert

    var body: some View {
        NavigationView {
            Form {
                TextField("Exercise Name", text: $exerciseName)

                #if os(iOS)
                TextField("Reps", text: $repsString)
                    .keyboardType(.numberPad)
                TextField("Sets", text: $setsString)
                    .keyboardType(.numberPad)
                TextField("Weight (kg)", text: $weightString)
                    .keyboardType(.numberPad)
                #else
                TextField("Reps", text: $repsString)
                TextField("Sets", text: $setsString)
                TextField("Weight (kg)", text: $weightString)
                #endif
            }
            .navigationTitle("Add Workout")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        // Convert String values to the appropriate numeric types
                        let reps = Int(repsString) ?? 0
                        let sets = Int(setsString) ?? 0
                        let weight = Double(weightString) ?? 0.0
                        // Ensure newItem creation matches the expected types
                        let newItem = WorkoutItem(exerciseName: exerciseName, reps: reps, sets: sets, weight: weight)
                        modelContext.insert(newItem)
                        dismiss()
                    }
                }
            }
        }
    }
}

// Preview provider for WorkoutView
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
