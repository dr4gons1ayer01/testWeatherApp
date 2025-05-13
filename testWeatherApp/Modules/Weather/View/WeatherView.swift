//
//  WeatherView.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                SearchBarView(cityName: $viewModel.cityName) {
                    viewModel.fetchCurrentWeather()
                }
                if let weather = viewModel.currentWeather {
                    CurrentWeatherCardView(weather: weather)
                }
                if !viewModel.hourlyForecast.isEmpty {
                    HourlyForecastScrollView(hours: viewModel.hourlyForecast)
                }
                if let forecast = viewModel.forecast {
                    DailyForecastView(forecastDays: forecast.forecast.forecastday)
                }
            }
        }
        .padding()
        .background(Image("bg")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
        )
        .animation(.easeInOut(duration: 1.1), value: viewModel.cityName.isEmpty)
    }
}

#Preview {
    WeatherView()
}
