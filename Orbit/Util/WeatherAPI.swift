//
//  WeatherAPI.swift
//  Orbit
//
//  Created by David Koo on 09/09/2018.
//  Copyright © 2018 orbit. All rights reserved.
//

import Foundation
import Alamofire

class WeatherAPI {
    func call(lati : Float, longi : Float , complete: @escaping (Error?, Model.WeatherModel?) -> Void) {
        
        let endPointURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lati)&lon=\(longi)"
        let apiKey = "367e5e831ef3e343cb9c0e2547a9df3e"
        
        let stringURL = "\(endPointURL)&appid=\(apiKey)&_type=json"
        let url = URL(string: stringURL)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        //request.addValue("Authorization", forHTTPHeaderField: serviceKey)
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
//        let param = ["regId": "\(regId)",
//                     "_type": "json"]

//        let params = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//        request.httpBody = params
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if let error = error {
                log.error(error)
                complete(error, nil)
            } else {
                if let httpStatus = res as? HTTPURLResponse, httpStatus.statusCode != 200, httpStatus.statusCode != 201 {
                    complete(error, nil)
                } else {
                    if let data = data {
                        do {
                            let weather = try JSONDecoder().decode(Model.WeatherModel.self, from: data)
                            complete(nil, weather)
                        } catch {
                            log.error(error)
                            complete(error, nil)
                        }
                    } else {
                        log.error("data is nil")
                        complete(nil, nil)
                    }
                }
            }
        }.resume()
    }
    
    func callWeatherAPI() {
        
    }
}
