//
//  MovieProtocol.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//

import Foundation
protocol ListenerGetCategories {
    func successGetCategories(_ response : Category)
    func failureGetCategories(_ loginError : String)
}

protocol ListenerGetTrailers {
    func successGetTrailers(_ response : Trailer)
    func failureGetTrailers(_ loginError : String)
}
