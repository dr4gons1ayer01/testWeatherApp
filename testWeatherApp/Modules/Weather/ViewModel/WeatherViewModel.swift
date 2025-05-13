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
    @Published var hourlyForecast: [ForecastResponse.Hour] = []
    
    init() {
        fetchCurrentWeather()
    }
    
    func fetchCurrentWeather() {
        Task {
            do {
                let weather = try await NetworkService.shared.getCurrentWeather(city: self.cityName)
                await MainActor.run {
                    let city = self.cityName
                    self.cityName = ""
                    self.currentWeather = weather
                    self.fetchForecast(for: city)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
        
    func fetchForecast(for city: String) {
        Task {
            do {
                let forecastData = try await NetworkService.shared.getForecast(city: city)
                await MainActor.run {
                    self.forecast = forecastData
                    self.extractHourlyForecast()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func extractHourlyForecast() {
        guard let forecast = forecast else { return }

        _ = Calendar.current
        let now = Date()

        ///day 1: current time
        let todayHours = forecast.forecast.forecastday.first?.hour.filter {
            guard let hourDate = $0.date else { return false }
            return hourDate > now
        } ?? []

        ///day 2: all time
        let tomorrowHours = forecast.forecast.forecastday.dropFirst().first?.hour ?? []

        self.hourlyForecast = todayHours + tomorrowHours
    }
}
