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
    
    
    @State private var alertTitle = "Error"
    @State private var alertMessage = "Sorry, there was a problem calculating your bedtime."
    @State private var showingAlert = false
    
    
    static var defaultWakeTime : Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
   
    static var defaultBedTime : Date{
        var components = DateComponents()
        components.hour = 10
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
    
    
    var recomendedBedTime : String{
        
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let str = sleepTime.formatted(date: .omitted, time: .shortened)
            return str
            
        }catch{
            
            showingAlert = true
        }
        
        return ContentView.defaultBedTime.formatted(date:.omitted, time: .shortened)
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
                        .fontWeight(.bold)
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
                
                
                Section{
                    Text(recomendedBedTime)
                        //.foregroundColor(.secondary)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                }header: {
                    Text("Ideal Bed time")
                        .font(.headline)
                        .fontWeight(.heavy)
                }
              
                
                
                
            }
            .navigationTitle("Better Rest")
            
            
            .alert(alertTitle,isPresented: $showingAlert){
                Button("OK"){}
            }message: {
                Text(alertMessage)
            }
        }
        
    }
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
