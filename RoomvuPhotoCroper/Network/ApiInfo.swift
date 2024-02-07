//
//  ApiInfo.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import Foundation

enum ApiInfo   {
    
    static   let baseApiAddress = "https://www.roomvu.com/api/v1/"
    static   let apiToken = "AHpzZnQjHfPaRd9NMCq8"


    case UserImage
   
    
    var Value : String{
        switch self{
            
        case .UserImage:
            return ApiInfo.baseApiAddress + "agent-dashboard/user-image/enhance"
   
 
        
        }
    }
}
