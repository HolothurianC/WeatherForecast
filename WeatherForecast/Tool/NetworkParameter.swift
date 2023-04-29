//
//  NetworkParameter.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/28.
//

protocol NetworkParameter {
    func headerParameters() -> [String: String]
    func configureEncryption(param: [String:Any]?) -> [String: Any]
    func logRequestURL(_ baseUrl: String,
                       _ parameters:[String : Any],
                       _ path:String)
}


extension NetworkParameter {
    // to set info to header
    func headerParameters() -> [String: String] {
        return [:]
    }
    //to encrypt parameter
    func configureEncryption(param: [String:Any]?) -> [String: Any] {
        guard let para = param else { return [:] }
        return para
    }

    /// 打印请求地址及参数
    ///
    /// - Parameter parameters: 传入的参数public
    func logRequestURL(_ baseUrl: String,
                       _ parameters:[String: Any],
                       _ path:String){
        var parametersStr = ""
        for (key,value) in parameters {
            parametersStr += "\(key)=\(value)"
        }
        var finalUrlStr = baseUrl + path + "?" + parametersStr
        if finalUrlStr.hasSuffix("&") {
            let end = finalUrlStr.index(finalUrlStr.endIndex, offsetBy: -1)
            finalUrlStr = String(finalUrlStr[..<end])
        }
        PrintLog(message: "请求地址及参数：\(finalUrlStr)")
    }

}
