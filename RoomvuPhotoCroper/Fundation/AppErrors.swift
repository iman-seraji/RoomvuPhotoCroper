//
//  AppErrors.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import Foundation

enum AppErrors : LocalizedError {
    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    
    var errorDescription : String?{
        switch self{
            
        case .errorDecoding:
            return "Response Could Not Be Decoded"
        case .unknownError:
            return "Unknown Errore !!!!!!??????"
        case .invalidUrl:
            return "Please Use A Valid URL "
        case .serverError(let serverErrore):
            return serverErrore
        }
    }
    
    
}
