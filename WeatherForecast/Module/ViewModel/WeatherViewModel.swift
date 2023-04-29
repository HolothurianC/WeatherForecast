//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

import HandyJSON

class WeatherViewModel: NSObject {
    typealias LivesAction    = ((_ lives:[LivesModel]?) -> Void)
    typealias ForecastAction = ((_ forecasts:[[ForecastModel]]?) -> Void)
    typealias FailureAction  = ((_ errorMsg: String) -> Void)
    typealias DidSelectIndex = ((_ indexPath: IndexPath) -> Void)
    var livesClosure: LivesAction?
    var forecastClosure: ForecastAction?
    var failureClosure: FailureAction?
    var didSelectIndex: DidSelectIndex?
    var selectIndex: Int     = 0
    var livesModels: [LivesModel]?
    var forecastModels: [[ForecastModel]]?
    var weatherCode: [String] = ["110000","310000","440100","440300","320500","210100"]
    var weatherCity: [String] = ["北京", "上海", "广州", "深圳", "苏州", "沈阳"]
    private var tempData: [String: [ForecastModel]] = [:]
    
    convenience init(lives: @escaping LivesAction,
                     forecast: @escaping ForecastAction,
                     failure: @escaping FailureAction,
                     indexPath: @escaping DidSelectIndex) {
        self.init()
        self.livesClosure    = lives
        self.forecastClosure = forecast
        self.failureClosure  = failure
        self.didSelectIndex  = indexPath
    }
    
    func mergeConcurrency() {
        self.forecastModels = []
        let queue = DispatchQueue.global(qos: .default)
        let group = DispatchGroup()
        for i in 0..<self.weatherCode.count {
            PrintLog(message: "all index = \(i)")
            group.enter()
            self.loadDataSource(index: i, group: group)
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async() {[weak self] in
                self?.sortedData()
                if (self?.forecastModels?.count ?? 0) > 0 {
                    self?.forecastClosure?(self?.forecastModels)
                    self?.didSelectIndex?(IndexPath(row: 0, section: 0))
                } else {
                    self?.failureClosure?("Load Data Fail")
                }
            }
        }
    }
    
    // Sorted Data in order
    fileprivate func sortedData() {
        for item in weatherCode {
            self.forecastModels?.append(tempData[item] ?? [])
        }
    }
    
    func loadDataSource(index: Int,
                        group: DispatchGroup) {
        var city = weatherCode.first!
        if index < weatherCode.count {
            city = weatherCode[index]
        }
        WeatherNetworkProvider.requestForecastArr(target:
                .WeatherForLivesOrForecast(key: AmapKey,
                                           city: city,
                                           extensions: "all",
                                           output: "JSON"),
                                              model: ForecastModel.self)
        {[weak self] returnData, returnCode, error in
            if returnCode == ReturnCode.dataSuccess.rawValue {
                NSLog("currentIndex = \(index)")
                self?.tempData.updateValue(returnData ?? [], forKey: city)
            }
            group.leave()
        }
    }
}
