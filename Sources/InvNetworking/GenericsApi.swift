//
//  GenericsApi.swift
//  InvNetworking
//
//  Created by Enxhi Qemalli on 2/25/19.
//

import Foundation
import UIKit

open class GenericsApi: UIViewController{
    
    /**
     This functions i used to make an api call to a specific url and get back the results
     -Parameter urlString : the string representation of the url that you want to make a request to
     -Parameter requestBody : a struct confirming to the codable protocol
     -Parameter callback :  returns the results of the api call to its initial caller function
     -Parameter method : the type of request we want to perform (GET, POST, PUT, DELETE, ETC)
     -Parameter event : optional parameter that should be filled if we want to listen for a specific notification event with that name
     -Return callback : return a generic type
     */
    
    open func fetchApiResults<T:Codable, P:Codable>(urlString: String, requestBody: P, method: String, model:String = "",callback:@escaping (T)->()){
        if Device.hasNetConnection(){
            let request = ApiRequest.prepareUrlRequest(urlString: urlString, requestBody: requestBody, method: method)
            let session = URLSession.shared
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    self.performUIUpdatesOnMain {
                        if httpResponse.statusCode == 401{
                            failedTokenCount += 1
                            if failedTokenCount >= 6{
                                self.performLogoutActions()
                                return
                            }
                            let queue = DispatchQueue(label: "InvNetworking.getRefreshToken",attributes: .concurrent)
                            queue.async {
                                self.waitForRefreshTokenKey()
                            }
                            self.registerTokenExpiredEvent()
                            return
                        }
                    }
                }
                self.performUIUpdatesOnMain {
                    guard error == nil else {
                        self.registerApiErrorEvent(error: error!,url: urlString)
                        return
                    }
                    
                    guard let data = data else {
                        self.registerApiErrorEvent(error: error!,url: urlString)
                        return
                    }
                    do {
                        try print("RESPONSE \(JSONSerialization.jsonObject(with: data, options: .mutableContainers))")
                        let json = try JSONDecoder().decode(T.self, from: data)
                        failedTokenCount = 0
                        callback(json)
                    } catch {
                        self.registerApiErrorEvent(error:error,url: urlString)
                        return
                    }
                }
            }
            task.resume()
        }
        else {
            print("No internet connection")
        }
    }
    
    /**
     This method returns to the main que and performs all operations on that queue
     
     -Parameter: updates : the updates that you want to perform on main
     */
    public func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    /**
     -This function makes a request to get the refresh token key
     */
    public func waitForRefreshTokenKey() {
        self.performUIUpdatesOnMain {
            failedRefreshTokenCount += 1
            if failedRefreshTokenCount >= 5{
                self.performLogoutActions()
                return
            }
        }
        let requestBody = ApiRequest.constructRefreshTokenParameters()
        self.fetchApiResults(urlString: getRefreshTokenUrl(), requestBody: requestBody, method: "POST", callback: {(response : AuthorizationKeyStruct)->()
            in
            setTokenType(type: response.token_type)
            setAccessToken(token: response.access_token)
            setExpiresIn(ex: response.expires_in)
            setRefreshToken(token: response.refresh_token)
            setIsLoggedIn(isLoggedIn: true)
        })
    }
    
    public func performLogoutActions(){
        setIsConfirmed(isConfirmed: false)
        setIsLoggedIn(isLoggedIn: false)
        setAccessToken(token: "")
        setRefreshToken(token: "")
        notificationCenter.post(name: NSNotification.Name(rawValue: "refresh_token_expired"), object: nil)
    }
    /**
     - This function gets a new authorization key from the server
     */
    public func getAuthorizationKey(username: String, password: String) {
        let parameters = ApiRequest.constructOAuthParameters(username: username, password:  password)
        self.fetchApiResults(urlString: getAuthTokenUrl(), requestBody: parameters, method: "POST", callback: {(results : AuthorizationKeyStruct)->()
            in
            setTokenType(type: results.token_type)
            setAccessToken(token: results.access_token)
            setExpiresIn(ex: results.expires_in)
            setRefreshToken(token: results.refresh_token)
            setIsLoggedIn(isLoggedIn: true)
            tokenNotificationCenter.post(name: NSNotification.Name(rawValue: "token_is_registerd"), object: nil)
        })
    }
    
    /**
     This method presents a popup that notifies the user that the token expired and registers an event to notify observers for this event
     **/
    public func registerTokenExpiredEvent(){
        print("Token error")
    }
    
    /**
     This method presents a popup that notifies the user that the api returned an error and registers an event to notify observers for this event
     **/
    public func registerApiErrorEvent(error : Error, url:String = ""){
        print("Api Error \(error.localizedDescription) ")
        print("Error URL : \(url)")
    }
    
}

