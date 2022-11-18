//
//  WeatherModel.swift
//  Weather
//
//  Created by Andy Vu on 8/23/22.
//

import Foundation
import SwiftUI

//struct Main: Codable {
//    var temp: Float
//    var feels_like: Float
//    var pressure: Float
//    var humidity: Float
//}

//struct List: Codable {
//    var main: Main
//    var weather: [Weather]
//    var dt_txt: String
//}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Current: Codable {
    var temp: Float
    var weather: [Weather]
    var wind_speed: Float
    var wind_deg: Float
    var humidity: Int
}

struct Temp: Codable {
    var day: Float
    var min: Float
    var max: Float
}

struct HourlyForecast: Codable {
    var temp: Float
    var dt: Double
    var weather: [Weather]
}

struct DailyForecast: Codable {
    var dt: Double
    var temp: Temp
    var weather: [Weather]
    var pop: Float
    var humidity: Int
}

struct OneCallEntry: Codable {
    var hourly: [HourlyForecast]
    var daily: [DailyForecast]
    var current: Current
}





//struct ForecastEntry: Codable {
//    var list: [List]
//}
