//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

import HandyJSON

class WeatherViewModel: NSObject {
    typealias LivesAction = ((_ lives:[LivesModel]?) -> Void)
    typealias ForecastAction = ((_ forecasts:[[ForecastModel]]?) -> Void)
    typealias FailureAction = ((_ errorMsg: String) -> Void)
    var livesClosure: LivesAction?
    var forecastClosure: ForecastAction?
    var failureClosure: FailureAction?
    var selectIndex: Int     = 0
    var livesModels: [LivesModel]?
    var forecastModels: [[ForecastModel]]?
    //北京、上海、广州、深圳、苏州、沈阳
    var weatherUrl: [String] = ["110000","310000","440100","440300","320500","210100"]

    convenience init(lives: @escaping LivesAction,
                     forecast: @escaping ForecastAction,
                     failure: @escaping FailureAction) {
        self.init()
        self.livesClosure    = lives
        self.forecastClosure = forecast
        self.failureClosure  = failure
    }
    
    func mergeConcurrency() {
        self.forecastModels = []
        let queue = DispatchQueue.global(qos: .default)
        let group = DispatchGroup()
        
        for i in 0..<self.weatherUrl.count {
            PrintLog(message: "all index = \(i)")
            group.enter()
            self.loadDataSource(index: i, group: group)
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async() {
                if self.forecastModels != nil {
                    self.forecastClosure?(self.forecastModels)
                } else {
                    self.failureClosure?("Load Data Fail")
                }
            }
        }
    }
    
    func loadDataSource(index: Int,
                        group: DispatchGroup) {
        var city = weatherUrl.first!
        if index < weatherUrl.count {
            city = weatherUrl[index]
        }
        WeatherNetworkProvider.requestForecastArr(target:
                .WeatherForLivesOrForecast(key: AmapKey,
                                           city: city,
                                           extensions: "all",
                                           output: "JSON"),
                                              model: ForecastModel.self)
        { returnData, returnCode, error in
            if returnCode == ReturnCode.dataSuccess.rawValue {
                NSLog("currentIndex = \(index)")
                self.forecastModels?.append(returnData ?? [])
            }
            group.leave()
        }
    }
}
