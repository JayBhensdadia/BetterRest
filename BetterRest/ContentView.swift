//
//  ContentView.swift
//  BetterRest
//
//  Created by Jay Bhensdadia on 02/03/23.
//

import CoreML
import SwiftUI


struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime : Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var coffeeString : String{
        var str = ""
        for i in 1...coffeeAmount{
            if i > 5{
                return str+"..."
            }
            str = str + "☕️"
        }
        return str
    }
    
    var body: some View {
        NavigationStack{
            Form{
                
                Section{
                    DatePicker("Please enter time",selection: $wakeUp,displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding()
                }header: {
                    Text("WakeUp Time ⏰ ?")
                        .font(.headline)
                }
                
                Section{
                    
                    Stepper("\(sleepAmount.formatted()) hours",value: $sleepAmount,in: 4...12, step: 0.25)
                        .padding()
                        
                }header: {
                    Text("Desired sleep 🛌 ?")
                        .font(.headline)
                    
                }
                
                Section{
                    
                    
                    Stepper(coffeeAmount == 1 ? "1 \(coffeeString)" : "\(coffeeAmount) \(coffeeString)",value: $coffeeAmount, in: 1...20)
                        .padding()
                    
                }header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                }
                
            }
            .navigationTitle("Better Rest")
            .toolbar{
                Button("Calculate",action: calculateBedtime)
            }
            
            .alert(alertTitle,isPresented: $showingAlert){
                Button("OK"){}
            }message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        }catch{
            
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
