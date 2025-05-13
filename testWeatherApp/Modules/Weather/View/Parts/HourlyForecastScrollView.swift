//
//  HourlyForecastScrollView.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import SwiftUI

struct HourlyForecastScrollView: View {
    let hours: [ForecastResponse.Hour]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(hours) { hour in
                    VStack(spacing: 4) {
                        Text(hour.hourString)
                            .font(FontManager.regular)
                            .foregroundColor(.white)

                        AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 32, height: 32)

                        Text("\(Int(hour.tempC))°")
                            .font(FontManager.regular)
                            .foregroundColor(.white)
                    }
                    .frame(width: 44)
                }
            }
            .padding(.horizontal)
        }
        .background(
            LinearGradient(colors: [Color("componentBg"), .white.opacity(0.1), Color("componentBg")],
                           startPoint: .topLeading,
                           endPoint: .bottom))
        .cornerRadius(24)
    }
}
