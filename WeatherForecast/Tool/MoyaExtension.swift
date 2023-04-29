//
//  MoyaExtension.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/29.
//

import Moya
import HandyJSON
import MBProgressHUD

struct BaseError: LocalizedError {
    var desc = ""
    init(_ str: String) {
        self.desc = ""
    }
    var errorDescription: String? {
        return self.desc
    }
}

enum ReturnCode: Int {
    case dataFailure  = 0
    case dataSuccess  = 10000
    case pageNotFound = 404
    case serviceError = 500
}

struct ResponseData<T: HandyJSON>: HandyJSON {
    var status: Int?   //返回状态
    var count: Int?    //返回结果总数目
    var info: String?     //返回的状态信息
    var infocode: Int? //返回状态说明,10000代表正确
    var data: T?
}

struct ResponseForecastData<T: HandyJSON> : HandyJSON {
    var status: Int?   //返回状态
    var count: Int?    //返回结果总数目
    var info: String?     //返回的状态信息
    var infocode: Int? //返回状态说明,10000代表正确
    var forecasts: [T]?    = []
}

struct ResponseLivesData<T: HandyJSON> : HandyJSON {
    var status: Int?   //返回状态
    var count: Int?    //返回结果总数目
    var info: String?     //返回的状态信息
    var infocode: Int? //返回状态说明,10000代表正确
    var lives: [T]?    = []
}

let TimeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 15
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let LoadingPlugin = NetworkActivityPlugin{(type,target) in
    guard let vc = topViewController() else {return}
    switch type {
    case .began:
        MBProgressHUD.hide(for: vc.view, animated: false)
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    case  .ended:
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonStr = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonStr) else {
            throw MoyaError.jsonMapping(self)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
        } catch {
            
        }
        let headers: [String: Any] = response?.allHeaderFields as? [String: Any] ?? [:]
        if let _ = headers["Authorization"] as? String {
            // get information
        }
        return model
    }
}

extension MoyaProvider {
    @discardableResult
    func request<T: HandyJSON>(target: Target,
                               model: T.Type,
                               completion: ((_ returnData: T?,
                                             _ returnCode: Int?,
                                             _ error: Error?)
                                            -> Void)?) -> Cancellable? {
        return request(target) { result in
            switch result {
            case .success(_):
                guard let completion = completion else{return }
                guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                    return
                }
                if let returnCode = returnData.infocode {
                    completion(returnData.data, returnCode, BaseError(returnData.info ?? "Something Wrong"))
                }
            case .failure(let error):
                guard let completion = completion else{return }
                completion(nil,nil,error)
            }
        }
    }
    
    @discardableResult
    func requestLivesArr<T: HandyJSON>(target: Target,
                               model: T.Type,
                               completion: ((_ returnData: [T]?,
                                             _ returnCode: Int?,
                                             _ error: Error?)
                                            -> Void)?) -> Cancellable? {
        return request(target) { result in
            switch result {
            case .success(_):
                guard let completion = completion else{return }
                guard let returnData = try? result.value?.mapModel(ResponseLivesData<T>.self) else {
                    return
                }
                if let returnCode = returnData.infocode {
                    completion(returnData.lives, returnCode, BaseError(returnData.info ?? "Something Wrong"))
                }
            case .failure(let error):
                guard let completion = completion else{return }
                completion([],nil,error)
            }
        }
    }
    
    @discardableResult
    func requestForecastArr<T: HandyJSON>(target: Target,
                               model: T.Type,
                               completion: ((_ returnData: [T]?,
                                             _ returnCode: Int?,
                                             _ error: Error?)
                                            -> Void)?) -> Cancellable? {
        return request(target) { result in
            switch result {
            case .success(_):
                guard let completion = completion else{return }
                guard let returnData = try? result.value?.mapModel(ResponseForecastData<T>.self) else {
                    return
                }
                if let returnCode = returnData.infocode {
                    completion(returnData.forecasts, returnCode, BaseError(returnData.info ?? "Something Wrong"))
                }
            case .failure(let error):
                guard let completion = completion else{return }
                completion([],nil,error)
            }
        }
    }
}

