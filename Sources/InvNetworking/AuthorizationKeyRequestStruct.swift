//
//  AuthorizationKeyRequestStruct.swift
//  InvNetworking
//
//  Created by Enxhi Qemalli on 2/25/19.
//

import Foundation
public struct AuthorizationKeyRequestStruct : Codable {
    
    var client_id : String? = ""
    var client_secret : String? = ""
    var grant_type :  String? = ""
    var refresh_token :  String? = ""
    var scope: String? = ""
    var username : String? = ""
    var password : String? = ""
    
    init (json: [String:Any]){
        client_id = json["client_id"] as? String ?? "Constants.CLIENT_ID"
        client_secret = json["client_secret"] as? String ?? "Constants.CLIENT_SECRET"
        grant_type = json["access_token"] as? String ?? "Constants.GRANT_TYPE_REFRESH"
        refresh_token   = json["refresh_token"] as? String ?? ""
        scope = json["scope"] as? String ?? "Constants.SCOPE"
        username = ""
        password = ""
    }
    
    init (){
    }
}

