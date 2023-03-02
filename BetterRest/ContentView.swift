//
//  ContentView.swift
//  BetterRest
//
//  Created by Jay Bhensdadia on 02/03/23.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter time",selection: $wakeUp,displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours",value: $sleepAmount,in: 4...12, step: 0.25)
                    .padding()
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups",value: $coffeeAmount, in: 1...20)
                
            }
            .navigationTitle("Better Rest")
            .toolbar{
                Button("Calculate",action: calculateBedtime)
            }
        }
    }
    
    func calculateBedtime() {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
