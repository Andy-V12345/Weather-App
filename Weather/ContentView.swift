//
//  ContentView.swift
//  Weather
//
//  Created by Andy Vu on 8/23/22.
//

import SwiftUI
import CoreLocation
import Combine

// retrieves the city name based on current lat and long
extension LocationManager {
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}

// gets user location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}

// takes JSON data and maps it to the appropriate data structure

func parse(jsonData: Data) -> (current: Current?, hourly: [HourlyForecast]?, daily: [DailyForecast]?) {
    do {
        let decoder = try JSONDecoder().decode(OneCallEntry.self, from: jsonData)
        return (decoder.current, decoder.hourly, decoder.daily)
    } catch let error {
        print(error)
        return (nil, nil, nil)
    }
}

// gets the current time

func getTime(timeStamp: Double, format: String) -> String {
    
    let date = Date(timeIntervalSince1970: timeStamp)
    
    let dateFormatter = DateFormatter()
    
    let timezone = TimeZone.current.abbreviation()
    
    dateFormatter.timeZone = TimeZone(abbreviation: timezone!)
    dateFormatter.locale = NSLocale.current
    
    dateFormatter.dateFormat = format
    
    return dateFormatter.string(from: date)
}

// loads JSON data from given url

func loadJson(fromURLString urlString: String,
                      completion: @escaping (Result<Data, Error>) -> Void) {
    if let url = URL(string: urlString) {
        let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        
        urlSession.resume()
    }
}



struct ContentView: View {
    
    @State var currentWeather: Current? = nil
    @State var hourly: [HourlyForecast]? = nil
    @State var daily: [DailyForecast]? = nil
    @ObservedObject var manager = LocationManager()
    @State var cityName = ""
    
    private var twoColumnGrid = Array(repeating: GridItem(.flexible()), count: 2)
    
    var lat: Double {
        return manager.lastLocation?.coordinate.latitude ?? 0
    }
    var lon: Double {
        return manager.lastLocation?.coordinate.longitude ?? 0
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 8) {
                
                Text(cityName)
                    .font(.title)
                    .fontWeight(.light)
                    .padding()
                
                Text("\(Int(currentWeather?.temp ?? 0))°")
                    .font(.largeTitle)
                    .fontWeight(.light)
                
                HStack(spacing: 20) {
                    HStack(spacing: 2) {
                        Image(systemName: "h.circle.fill")
                        Text(": \(Int(daily?[0].temp.max ?? 100))°")
                        
                    }
                    
                    HStack(spacing: 2) {
                        Image(systemName: "l.circle.fill")
                        Text(": \(Int(daily?[0].temp.min ?? 0))°")
                        
                    }
                }
                
                Text(currentWeather?.weather[0].main ?? "")
                    .font(.title2)
                    .padding()
                
                // shows hourly forecast
                GroupBox(content: {
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 25) {
                            ForEach(0..<12, id: \.self) { item in
                                HourlyForecastView(time: getTime(timeStamp: hourly?[item].dt ?? 1661450400, format: "h a"), temp: "\(Int(hourly?[item].temp ?? 87))°", icon: hourly?[item].weather[0].icon ?? "01d")
                                    .frame(height: 80)
                                    .padding(.vertical)
                            }
                        }
                    }
                }, label: {
                    HStack {
                        Image(systemName: "clock")
                        Text("The next 12 hours")
                            .font(.subheadline)
                    }
                })
                
                // shows daily forecast
                GroupBox(content: {
                    VStack() {
                        ForEach(1..<(daily?.count ?? 1), id: \.self) { item in
                            Divider()
                            DailyForecastView(date: getTime(timeStamp: daily?[item].dt ?? 1661450400, format: "E"), icon: daily?[item].weather[0].icon ?? "01d", low: Int(daily?[item].temp.min ?? 0), high: Int(daily?[item].temp.max ?? 100))
                                .frame(height: 30)
                                .padding(.vertical, 3)
                        }
                    }
                    
                }, label: {
                    HStack {
                        Image(systemName: "calendar")
                        Text("7-day forecast")
                            .font(.subheadline)
                    }
                })
                
                LazyVGrid(columns: twoColumnGrid, content: {
                    
                    // displays percentage of precipitation
                    GroupBox(content: {
                        ProgressCircleView(progress: Int((daily?[0].pop ?? 0)*100), color: .blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }, label: {
                        HStack {
                            Image(systemName: "cloud.rain")
                                .imageScale(.small)
                            Text("Precipitation")
                                .font(.footnote)
                        }
                    })
                    
                    // displays humidity
                    GroupBox(content: {
                        ProgressCircleView(progress: currentWeather?.humidity ?? 0, color: .red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }, label: {
                        HStack {
                            Image(systemName: "humidity")
                                .imageScale(.small)
                            Text("Humidity")
                                .font(.footnote)
                        }
                    })
                    
                    // shows wind speed and wind direction
                    GroupBox(content: {
                        CompassView(speed: Int(currentWeather?.wind_speed ?? 0), windDir: Int(currentWeather?.wind_deg ?? 0))
                    }, label: {
                        HStack {
                            Image(systemName: "wind")
                                .imageScale(.small)
                            Text("Wind")
                                .font(.footnote)
                        }
                    })
            
                })
                
                Spacer()
            }
        .padding(.horizontal)
        }
        // refreshes data when scroll view is pulled
        .refreshable {
            self.manager.getPlace(for: CLLocation(latitude: lat, longitude: lon)) { placemark in
                guard let placemark = placemark else { return }
                cityName = placemark.locality ?? "Kearney"
            }
            
            let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=imperial&exclude=minutely,alerts&appid=09d0633ce71de0947bbf6fa862f7cead"
            
            loadJson(fromURLString: urlString) { (result) in
                switch result {
                case .success(let data):
                    let results = parse(jsonData: data)
                    hourly = results.hourly
                    currentWeather = results.current
                    daily = results.daily
                case .failure(let error):
                    print(error)
                }
            }
        }
        // loads data when view first appears
        .onAppear {
            self.manager.getPlace(for: CLLocation(latitude: lat, longitude: lon)) { placemark in
                guard let placemark = placemark else { return }
                cityName = placemark.locality ?? ""
            }
            
            let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=imperial&exclude=minutely,alerts&appid=09d0633ce71de0947bbf6fa862f7cead"
            
            loadJson(fromURLString: urlString) { (result) in
                switch result {
                case .success(let data):
                    let results = parse(jsonData: data)
                    hourly = results.hourly
                    currentWeather = results.current
                    daily = results.daily
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
