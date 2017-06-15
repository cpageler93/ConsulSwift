//
//  ConsulCatalogDatacenter.swift
//  ConsulSwift
//
//  Created by Christoph on 15.06.17.
//
//

import Foundation
import Quack
import SwiftyJSON

public class ConsulCatalogDatacenter: QuackModel {
    
    var name: String
    
    public required init?(json: JSON) {
        guard let name = json.string else { return nil }
        self.name = name
    }
    
}
