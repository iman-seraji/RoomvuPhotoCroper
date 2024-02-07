//
//  ApiResponse.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import Foundation

struct ApiResponse : Decodable{
    let status : String?
    let data : EnhancedUserImage?
    let message : String?
    let errors : String?
    
   
    
}
struct EnhancedUserImage : Decodable{
    let enhanced_user_image : String?
 
}
