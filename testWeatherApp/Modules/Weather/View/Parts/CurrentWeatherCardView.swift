//
//  CurrentWeatherCardView.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import SwiftUI

struct CurrentWeatherCardView: View {
    let weather: CurrentWeatherResponse

    var body: some View {
        VStack(spacing: 12) {
            Text(weather.location.name ?? "Город")
                .font(FontManager.bold)
            Text("\(Int(weather.current.tempC ?? 0))˚C")
                .font(FontManager.largeBold)
            VStack {
                Text("\(weather.current.humidity ?? 0)% влажность")
                    .font(FontManager.regular)
                Text(weather.current.condition?.text ?? "—")
                    .font(FontManager.bold)
                Text("Ветер: \(Int((weather.current.windKph ?? 0) / 3.6)) м/с")
                    .font(FontManager.regular)
            }
        }
        .foregroundColor(.white).opacity(0.9)
        .frame(width: 240)
        .padding()
        .background(
            LinearGradient(colors: [Color("componentBg"), .white.opacity(0.1), Color("componentBg")],
                           startPoint: .topLeading,
                           endPoint: .bottom))
        .cornerRadius(24)
    }
}
