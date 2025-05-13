//
//  DailyForecastView.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import SwiftUI

struct DailyForecastView: View {
    let forecastDays: [ForecastResponse.ForecastDay]

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Прогноз на 7 дней")
                .font(FontManager.bold)
                .foregroundColor(.white)

            ForEach(forecastDays) { day in
                HStack {
                    Text(day.weekdayShort)
                        .font(FontManager.regular)
                        .frame(width: 40, alignment: .leading)
                        .foregroundColor(.white)

                    AsyncImage(url: URL(string: "https:\(day.day.condition.icon)")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 24, height: 24)

                    Text(day.day.condition.text)
                        .font(FontManager.regular)
                        .foregroundColor(.white)

                    Spacer()

                    Text("\(day.minTemp)°")
                        .font(FontManager.regular)
                        .foregroundColor(.white)

                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(width: 60, height: 4)
                            .foregroundColor(.white.opacity(0.3))

                        let range = CGFloat(max(day.maxTemp - day.minTemp, 1))
                        Capsule()
                            .frame(width: range * 3, height: 4)
                            .foregroundColor(.cyan)
                    }

                    Text("\(day.maxTemp)°")
                        .font(FontManager.regular)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            LinearGradient(colors: [Color("componentBg"), .white.opacity(0.1), Color("componentBg")],
                           startPoint: .topLeading,
                           endPoint: .bottom))
        .cornerRadius(24)
    }
}
