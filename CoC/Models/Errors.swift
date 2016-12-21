//
//  Errors.swift
//  CoC
//
//  Created by Robin Somlette on 11-Dec-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
	case invalidNetwork(code: Int, message: String)
}
