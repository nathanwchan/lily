//
//  Globals.swift
//  lily
//
//  Created by Nathan Chan on 9/15/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

enum Globals {
    static let environment = Environments.Localhost
}

enum Environments: String {
    case Localhost = "http://localhost:8080"
    case Dev = "http://contestguru-contestguru-dev.azurewebsites.net"
    case Staging = "http://contestguru-contestguru-stage.azurewebsites.net"
    case Production = "http://www.contest.guru"
}
