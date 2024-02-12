//
//  workoutpage.swift
//  Tracker
//
//  Created by Elena on 07/02/2024.
//
import SwiftUI
import SwiftData
import Foundation

class DataManager {
    static let shared = DataManager() 
    var workouts: [Workout] = []
    func loadWorkouts() { /* ... */ }
    func saveWorkouts() { /* ... */ }
}

struct Workout {
    let id = UUID() 
    var name: String
    var date: Date = Date()
    var bodyPart: String
    var exercises: [Exercise] = []
}

struct Exercise {
    let name: String
    var sets: Int
    var reps: Int  
    // Potentially add weight, notes, etc.
}
struct WorkoutView: View {
    @StateObject var dataManager = DataManager.shared

    var body: some View {
        NavigationView {
            List(dataManager.workouts) { workout in
                NavigationLink {
                    // WorkoutDetailView (We'll create this later)
                } label: {
                    WorkoutRow(workout: workout) 
                } 
            }
            .navigationTitle("Past Workouts")
            // Add toolbar item for creating new workouts 
        }
        .onAppear { 
            dataManager.loadWorkouts()
        }
    }
}

struct WorkoutRow: View { 
    var workout: Workout
    var body: some View {
        // Display workout name, date, body part
    }
}

#Preview {
    WorkoutView()
        .modelContainer(for: Item.self, inMemory: true)
}
