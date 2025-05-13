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
                //Search
                HStack(spacing: 20) {
                    TextField("Введите город", text: $viewModel.cityName)
                        .padding(8)
                        .background(.white)
                        .cornerRadius(8)
                        .font(FontManager.bold)
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.fetchCurrentWeather()
                        }
                    if !viewModel.cityName.isEmpty {
                        Button("Найти") {
                            viewModel.fetchCurrentWeather()
                        }
                        .font(FontManager.bold)
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 10)
                
                //CurrentWeather
                if let weather = viewModel.currentWeather {
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
                //HourlyForecast
                if !viewModel.hourlyForecast.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.hourlyForecast) { hour in
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
            //forecast 7 day(3 in free api plan)
            if let forecast = viewModel.forecast {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Прогноз на 7 дней")
                        .font(FontManager.bold)
                        .foregroundColor(.white)

                    ForEach(forecast.forecast.forecastday) { day in
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

                            //tempBar
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
