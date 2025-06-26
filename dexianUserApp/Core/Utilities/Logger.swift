//
//  Logger.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

struct Logger {
    static func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
//        print("[\(fileName):\(line)] \(function) - \(message)")
        #endif
    }
}
