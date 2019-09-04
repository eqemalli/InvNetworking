//
//  AuthorizationKeyStruct.swift
//  InvNetworking
//
//  Created by Enxhi Qemalli on 2/25/19.
//

import Foundation
public struct AuthorizationKeyStruct : Codable {
    
    let token_type : String
    let expires_in : Int32
    let access_token :  String
    let refresh_token :  String
    
    init (json: [String:Any]){
        token_type = json["token_type"] as? String ?? ""
        expires_in = json["expires_in"] as? Int32 ?? 0
        access_token = json["access_token"] as? String ?? ""
        refresh_token   = json["refresh_token"] as? String ?? ""
    }
}
