//
//  ApiRequest.swift
//  InvNetworking
//
//  Created by Enxhi Qemalli on 2/25/19.
//

import Foundation

open class ApiRequest: NSObject {
    /**
     This function creates a URL request
     -Parameter url : the url of the request
     -Parameter requestBody :  a struct conforming to the codableProtocol
     -Returns URLRequest
     */
    
    open class func prepareUrlRequest<P:Codable>(urlString url:String, requestBody: P, method:String)->URLRequest{
        let requestURL = URL(string: url)!
        //now create the NSMutableRequest object using the url object
        var request = URLRequest(url: requestURL)
        request.httpMethod = method //set http method
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let body = try encoder.encode(requestBody)
            request.httpBody = body
            printJsonRequest(data: body)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let authorizationKey = "Bearer " + getAccessToken()
        request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    /**
     This function constructs a OAuthParamters Struct
     -Returns AuthorizationKeyRequestStruct
     */
    open class func constructOAuthParameters(username: String = "", password: String = "")->AuthorizationKeyRequestStruct{
        //check if a refresh token is needed
        var authKeyStruct = AuthorizationKeyRequestStruct()
        authKeyStruct.client_id = getClientId()
        authKeyStruct.client_secret = getClientSecret()
        authKeyStruct.grant_type = getPasswoddType()
        authKeyStruct.refresh_token = ""
        authKeyStruct.username = username
        authKeyStruct.scope = getScope()
        authKeyStruct.password = password
        return authKeyStruct
    }
    
    /**
     This function constructs a refreshToken  Struct
     -Returns AuthorizationKeyRequestStruct
     */
    open class func constructRefreshTokenParameters()->AuthorizationKeyRequestStruct{
        var authKeyStruct = AuthorizationKeyRequestStruct()
        authKeyStruct.client_id = getClientId()
        authKeyStruct.client_secret = getClientSecret()
        authKeyStruct.grant_type = getRefreshTokenType()
        authKeyStruct.refresh_token = getRefreshToken()
        authKeyStruct.scope = getScope()
        return authKeyStruct
    }
    
    /**
     This function prints JSON request to the console
     */
    open class func printJsonRequest(data: Data){
        do {
            guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return
            }
            print("Request \(jsonString)")
        }
    }
}

