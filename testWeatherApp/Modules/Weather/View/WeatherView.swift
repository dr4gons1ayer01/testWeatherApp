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
        switch viewModel.state {
        case .idle, .loading:
            VStack {
                ProgressView("Загрузка...")
                    .foregroundColor(.white)
                    .font(FontManager.bold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("bg").resizable().ignoresSafeArea())
            
        case .failed(let error):
            VStack(spacing: 12) {
                Text("Ошибка:")
                    .font(FontManager.bold)
                    .foregroundColor(.red)
                Text(error.localizedDescription)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(FontManager.regular)
                Button("Повторить") {
                    let query = viewModel.cityName.isEmpty ? "Moscow" : viewModel.cityName
                    viewModel.fetchWeather(for: query)
                }
                .font(FontManager.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(.white)
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("bg").resizable().ignoresSafeArea())
            
        case .loaded:
            WeatherContentBody(viewModel: viewModel)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
    }
}

struct WeatherContentBody: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                SearchBarView(cityName: $viewModel.cityName) {
                    viewModel.fetchWeather(for: viewModel.cityName)
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
            .padding()
        }
        .background(
            Image("bg")
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
