//
//  BaseUtils.swift
//  WeatherForecast
//
//  Created by Holothurian on 2023/4/29.
//

import UIKit


let ScreenWidth  = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height


func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
    }
    if let presented = base?.presentedViewController {
        return topViewController(base: presented)
    }
    return base
}

//日志打印
func PrintLog<N>(message:N,
                 fileName:String = #file,
                 methodName:String = #function,
                 lineNumber:Int = #line){
#if DEBUG || BETA
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.short
    dateFormatter.dateFormat = "HH:mm:ss:SSSS"
    let str = dateFormatter.string(from:Date.init())
    let file = (fileName as NSString).lastPathComponent
    print("File：\(file)\nTime：\(str)\nMethod：\(methodName)\nLine：\(lineNumber)\nMessage：\(message)");
#else
    //置空、不占调用时间
#endif
}
