//
//  ConsulKeyValuePair.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 19.06.17.
//

import Foundation
import Quack
import SwiftyJSON

public class ConsulKeyValuePair: QuackModel {
    
    public var key: String
    public var value: String
    
    public required init?(json: JSON) {
        guard
            let jsonArray = json.array,
            let firstJsonEntry = jsonArray.first,
            let key = firstJsonEntry["Key"].string,
            let value = firstJsonEntry["Value"].string
        else { return nil }
        
        self.key = key
        self.value = value
    }
    
    public func decodedValue() -> String? {
        guard let decodedData = Data(base64Encoded: value) else { return nil }
        return String(data: decodedData, encoding: String.Encoding.utf8)
    }

}
