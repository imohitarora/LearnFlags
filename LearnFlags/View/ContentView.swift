//
//  ContentView.swift
//  LearnFlags
//
//  Created by Mohit Arora on 2024-05-07.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = DataLoader.loadCountries().shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    @State private var currentStreak = 0
    @State private var longestStreak = UserDefaults.standard.integer(forKey: "LongestStreak")
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var selectedFlag: Int? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Tap the flag of")
                .font(.headline)
                .padding(.top)
            Text(countries[correctAnswer].name)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            ForEach(0..<3, id: \.self) { number in
                Button(action: {
                    self.flagTapped(number)
                }) {
                    Image(self.countries[number].id.lowercased())
                        .resizable()
                        .frame(width: 250, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(selectedFlag == number && number != correctAnswer ? Color.red : Color.black, lineWidth: 1))
                        .shadow(radius: 5)
                        .opacity(selectedFlag != nil && number != correctAnswer && number != self.correctAnswer ? 0.25 : 1) // Dim other flags
                }
            }
            VStack {
                Text("Current Streak: \(currentStreak)")
                Text("Longest Streak: \(longestStreak)")
            }
            .font(.title)
            Spacer()
        }
        .padding(.horizontal)
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                askQuestion()
            })
        }
        .navigationBarTitle("Guess the Flag", displayMode: .inline)
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentStreak += 1
            scoreMessage = "Your streak is \(currentStreak)."
            if currentStreak > longestStreak {
                longestStreak = currentStreak
                UserDefaults.standard.set(longestStreak, forKey: "LongestStreak")
            }
            askQuestion() // Immediate question update for correct answer
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That’s the flag of \(countries[number].name)."
            currentStreak = 0 // Reset streak on wrong answer
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<3)
        selectedFlag = nil // Reset the selected flag
    }
}






#Preview {
    ContentView()
}
