//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

import HandyJSON

class WeatherViewModel: NSObject {
    typealias SuccessAction = ((_ successMsg: String) -> Void)
    typealias FailureAction = ((_ errorMsg: String) -> Void)
    
    var successClosure: SuccessAction?
    var failureClosure: FailureAction?
    var selectIndex: Int     = 0
    //北京、上海、广州、深圳、苏州、沈阳
    var weatherUrl: [String] = ["110000","310000","440100","440300","320500","210100"]
    var livesModels: [LivesModel]?
    var forecastModels: [ForecastModel]?

    convenience init(success: @escaping SuccessAction,
                     failure: @escaping FailureAction) {
        self.init()
        self.successClosure = success
        self.failureClosure = failure
        
    }
    
    func loadDataSource(_ type: String) {
        var city = weatherUrl.first!
        if selectIndex < weatherUrl.count {
            city = weatherUrl[selectIndex]
        }
        let model: HandyJSON.Type = type == "base" ? LivesModel.self : ForecastModel.self
        WeatherNetworkLoading.requestLivesArr(target:
                .WeatherForLivesOrForecast(key: AmapKey,
                                           city: city,
                                           extensions: type,
                                           output: "JSON"),
                                              model: model)
        { returnData, returnCode, error in
            if returnCode == ReturnCode.dataSuccess.rawValue {
                self.successClosure?("Success")
                if type == "base" {
                    self.livesModels = returnData as? [LivesModel]
                } else {
                    self.forecastModels = returnData as? [ForecastModel]
                }
            } else {
                self.failureClosure?("Failure")
            }
        }
    }
}
