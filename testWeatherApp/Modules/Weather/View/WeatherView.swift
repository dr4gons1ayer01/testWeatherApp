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
        VStack(spacing: 12) {
            //Search
            HStack(spacing: 20) {
                TextField("Введите город", text: $viewModel.cityName)
                    .padding(8)
                    .background(.secondary)
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
                    Text(weather.location.name)
                        .font(FontManager.bold)
                    Text("\(Int(weather.current.tempC))˚C")
                        .font(FontManager.largeBold)
                    VStack {
                        Text("\(weather.current.humidity)% влажность")
                            .font(FontManager.regular)
                        Text(weather.current.condition.text)
                            .font(FontManager.bold)
                        Text("Ветер: \(Int(weather.current.windKph / 3.6)) м/с")
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
            
            //TableView
            List {
                Text("")
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .foregroundColor(.white)
            }.listStyle(.plain)
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
