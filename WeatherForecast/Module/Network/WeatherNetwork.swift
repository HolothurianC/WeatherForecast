//
//  WeatherNetwork.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

import Moya

let WeatherNetworkProvider = MoyaProvider<WeatherNetwork>(requestClosure: TimeoutClosure)
let WeatherNetworkLoading  = MoyaProvider<WeatherNetwork>(requestClosure: TimeoutClosure, plugins: [LoadingPlugin])

enum WeatherNetwork {
    //key: 请求服务权限标识
    //city: 城市编码
    //extensions: 可选值：base/all; base:返回实况天气,all:返回预报天气
    //output: 返回格式,可选值：JSON,XML
    case WeatherForLivesOrForecast(key: String,
                                   city: String,
                                   extensions: String?,
                                   output: String)
}

extension WeatherNetwork: TargetType, NetworkParameter {
    var baseURL: URL {
        return URL(string: WeatherURL)!
    }
    
    var path: String {
        switch self {
        case .WeatherForLivesOrForecast(key: _, city: _, extensions: _, output: _):
            return "v3/weather/weatherInfo"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using:String.Encoding.utf8)!
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        switch self {
        case .WeatherForLivesOrForecast(key: let key,
                                        city: let city,
                                        extensions: let extensions,
                                        output: let output):
            parameters["key"]        = key
            parameters["city"]       = city
            parameters["extensions"] = extensions
            parameters["output"]     = output
        }
        logRequestURL(baseURL.absoluteString, parameters, path)
        let encryptDic: [String: Any] = configureEncryption(param: parameters)
        return .requestParameters(parameters: encryptDic, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
       return headerParameters()
    }
    
    
}
