//
//  CustomGauge.swift
//  Demo
//
//  Created by Ezequiel Santos on 19/12/2022.
//

import SwiftUI

import SwiftUI
import Foundation

struct CustomGauge: View {
 
    @Binding var currentSpeed: Double
 
    var body: some View {
        if #available(macOS 13.0, *) {
            Gauge(value: currentSpeed, in: 0...200) {
                Image(systemName: "gauge.medium")
                    .font(.system(size: 50.0))
            } currentValueLabel: {
                Text("\(currentSpeed.fixed().formatted(.number))")
                
            }
            .gaugeStyle(SpeedometerGaugeStyle())
        } else {
            // Fallback on earlier versions
        }
 
    }
}

struct SpeedometerGaugeStyle: GaugeStyle {
    private var purpleGradient = LinearGradient(gradient: Gradient(colors: [ Color(red: 207/255, green: 150/255, blue: 207/255), Color(red: 107/255, green: 116/255, blue: 179/255) ]), startPoint: .trailing, endPoint: .leading)
 
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
 
            Circle()
                .foregroundColor(Color(.lightGray))
 
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(purpleGradient, lineWidth: 20)
                .rotationEffect(.degrees(135))
 
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0))
                .rotationEffect(.degrees(135))
 
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                Text("KM/H")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.gray)
            }
 
        }
        .frame(width: 300, height: 300)
 
    }
 
}

struct Gauge_Previews: PreviewProvider {
    static var previews: some View {
        CustomGauge(currentSpeed: .constant(100))
    }
}

extension Double {
    
    func fixed() -> Double {
        Double(String(format:"%.2f", self)) ?? self
    }
}

