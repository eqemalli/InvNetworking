import Foundation
import SystemConfiguration

public var failedTokenCount = 0
public var failedRefreshTokenCount = 0
public var authStruct = AuthorizationKeyRequestStruct()

public var accessToken = ""
public var clientId = ""
public var clientSecret = ""
public var scope = ""
public var refreshToken = ""
public var expiresIn: Int32 = 0
public var tokenType = ""
public var accountUsername = ""
public var accountPassword = ""

public var tokenPasswordType = ""
public var tokenRefreshType = ""

public var authTokenUrl = ""
public var refreshTokenUrl = ""

public var notificationCenter = NotificationCenter.default
public var tokenNotificationCenter = NotificationCenter.default

public func oauthConfig(clientId: String = "", clientSecret: String = "", scope: String = "", tokenPasswordType: String = "", tokenRefreshType: String = "", accessTokenUrl: String = "", refreshTokenUrl: String = ""){
    setClientId(id: clientId)
    setClientSecret(secret: clientSecret)
    setScope(sc: scope)
    setPasswordType(type: tokenPasswordType)
    setRefreshTokenType(type: tokenRefreshType)
    setAuthTokenUrl(url: accessTokenUrl)
    setRefreshTokenUrl(url: refreshTokenUrl)
    setPassword(password: "")
    setUsername(username: "")
    
}

public func setScope(sc: String){
    scope = sc
}

public func getScope()->String{
    return scope
}

public func setExpiresIn(ex: Int32){
    expiresIn = ex
}

public func getExpiresIn()->Int32{
    return expiresIn
}

public func setTokenType(type: String){
    tokenType = type
}

public func getTokenType()->String{
    return tokenType
}

public func setUsername(username: String){
    accountUsername = username
}

public func getUsername()->String{
    return accountUsername
}

public func setPassword(password: String){
    accountPassword = password
}

public func getPassword()->String{
    return accountPassword
}

public func setPasswordType(type: String){
    tokenPasswordType = type
}

public func getPasswoddType()->String{
    return tokenPasswordType
}

public func setRefreshTokenType(type: String){
    tokenRefreshType = type
}
public func getRefreshTokenType()->String{
    return tokenRefreshType
}

public func setAuthTokenUrl(url: String){
    authTokenUrl = url
}
public func getAuthTokenUrl()->String{
    return authTokenUrl
}

public func setRefreshTokenUrl(url: String){
    refreshTokenUrl = url
}

public func getRefreshTokenUrl()->String{
    return refreshTokenUrl
}

public func getIsLoggedIn()->Bool{
    
    if let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool {
        return isLoggedIn
    }
    return false
}

public func setIsLoggedIn(isLoggedIn: Bool){
    UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
}

public func getAccessToken()->String{
    if let token = UserDefaults.standard.value(forKey: "accessToken") as? String {
        return token
    }
    return ""
}

public func setAccessToken(token: String){
    UserDefaults.standard.set(token, forKey: "accessToken")
}

public func getRefreshToken()->String{
    if let token = UserDefaults.standard.value(forKey: "refreshToken") as? String {
        return token
    }
    return ""
}

public func setRefreshToken(token: String){
    UserDefaults.standard.set(token, forKey: "refreshToken")
}

public func getClientId()->String{
    if let id = UserDefaults.standard.value(forKey: "clientId") as? String {
        return id
    }
    return ""
}

public func setClientId(id: String){
    UserDefaults.standard.set(id, forKey: "clientId")
}

public func getClientSecret()->String{
    if let secret = UserDefaults.standard.value(forKey: "clientSecret") as? String {
        return secret
    }
    return ""
}

public func setClientSecret(secret: String){
    UserDefaults.standard.set(secret, forKey: "clientSecret")
}

public func getIsConfirmed()->Bool{
    if let isConfirmed = UserDefaults.standard.value(forKey: "isConfirmed") as? Bool {
        return isConfirmed
    }
    return false
}

public func setIsConfirmed(isConfirmed: Bool){
    UserDefaults.standard.set(isConfirmed, forKey: "isConfirmed")
}

public func get<T:Codable, P:Codable>(url: String, request: P, callback:@escaping (T)->()){
    GenericsApi().fetchApiResults(urlString: url, requestBody: request, method: "GET", callback: callback)
}

public func post<T:Codable, P:Codable>(url: String, request: P, callback:@escaping (T)->()){
    GenericsApi().fetchApiResults(urlString: url, requestBody: request, method: "POST", callback: callback)
}

public func delete<T:Codable, P:Codable>(url: String, request: P, callback:@escaping (T)->()){
    GenericsApi().fetchApiResults(urlString: url, requestBody: request, method: "DELETE", callback: callback)
}
public func put<T:Codable, P:Codable>(url: String, request: P, callback:@escaping (T)->()){
    GenericsApi().fetchApiResults(urlString: url, requestBody: request, method: "PUT", callback: callback)
}

public func oauth(username: String, password: String){
    GenericsApi().getAuthorizationKey(username: username, password: password)
}

public func oauthClear(){
    setAccessToken(token: "")
}

