//
//  File.swift
//  
//
//  Created by Teddy Moussignac on 12/28/21.
//

import Foundation
import Vapor

extension Stream {
    enum Types: String, Content, Hashable {
        case movie
        case series
    }
}
