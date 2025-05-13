//
//  WeatherViewModel.swift
//  testWeatherApp
//
//  Created by Иван Семенов on 13.05.2025.
//

import Foundation

final class WeatherViewModel: ObservableObject {
    @Published var cityName = "Moscow"
    @Published var currentWeather: CurrentWeatherResponse?
    @Published var forecast: ForecastResponse?
    
    init() {
        fetchCurrentWeather()
    }
    
    func fetchCurrentWeather() {
        Task {
            do {
                let weather = try await NetworkService.shared.getCurrentWeather(city: self.cityName)
                await MainActor.run {
                    self.currentWeather = weather
                    self.cityName = ""
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
