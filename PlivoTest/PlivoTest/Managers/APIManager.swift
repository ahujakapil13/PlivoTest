//
//  APIManager.swift
//  PlivoTest
//
//  Created by Kapil Ahuja on 15/03/17.
//  Copyright © 2017 Kapil Ahuja. All rights reserved.
//

import Foundation

class APIManager {
    
    // Singelton Instance
    public static let Instance = APIManager()
    
    /**
     * PlivoEndpoint Constant.
     */
    let constant = Constants.Instance
    let endpoint = PlivoEndpoint()
    
    /**
     * PlivoIncoming Variable.
     */
    var inCall = PlivoIncoming()
    
    /**
     * connectEndpoint implementation.
     */
    func connectEndpoint() {
        endpoint?.login(constant.Username, andPassword: constant.Password)
    }

}
