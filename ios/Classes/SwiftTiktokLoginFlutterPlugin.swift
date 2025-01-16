import Flutter
import TikTokOpenAuthSDK
import TikTokOpenSDKCore
import UIKit

public class SwiftTiktokLoginFlutterPlugin: NSObject, FlutterPlugin {
  private let authRequest = TikTokAuthRequest(
    scopes: ["user.info.basic", "user.info.profile", "user.info.stats", "video.list"],
    redirectURI: "https://syngency.page.link")

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "tiktok_login_flutter", binaryMessenger: registrar.messenger())
    let instance: SwiftTiktokLoginFlutterPlugin = SwiftTiktokLoginFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initializeTiktokLogin":
      self.initializeTiktokLogin(call: call, result: result)
    case "authorize":
      self.authorize(call: call, result: result)
    default:
      result(FlutterMethodNotImplemented)

    }
  }

  private func initializeTiktokLogin(call: FlutterMethodCall, result: @escaping FlutterResult) {
    return result(true)
  }

  private func authorize(call: FlutterMethodCall, result: @escaping FlutterResult) {
    // ?
    let viewController: UIViewController =
      (UIApplication.shared.delegate?.window??.rootViewController)!

    let args = call.arguments as! [String: Any]
    let agencyId = args["agencyId"] as! number
    let talentId = args["talentId"] as! number

    authRequest.send { response in
      guard let authResponse = response as? TikTokAuthResponse else {
        result("error")
        return
      }
      if authResponse.errorCode == .noError {
        let url = URL(
          string: "https://l8po137o7b.execute-api.us-west-1.amazonaws.com/Prod/tiktok_auth")!
        var tokenRequest = URLRequest(url: url)
        tokenRequest.httpMethod = "POST"
        tokenRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let postData: [String: String] = [
          "agency_id": agencyId,
          "talent_id": talentId,
          "code": authResponse.authCode!,
          "code_verifier": self.authRequest.pkce.codeVerifier,
        ]
        tokenRequest.httpBody = try? JSONSerialization.data(withJSONObject: postData)
        URLSession.shared.dataTask(with: tokenRequest) { data, tokenResponse, error in
          if let error = error {
            result(
              FlutterError(
                code: "POST_REQUEST_FAILED",
                message: error.localizedDescription,
                details: nil))
            return
          }
          if let data = data {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let json = json as? [String: Any] {
              result(json["access_token"] ?? "")
            } else {
              result(
                FlutterError(
                  code: "POST_REQUEST_FAILED",
                  message: "Failed to parse JSON",
                  details: nil))
            }
          } else {
            result(
              FlutterError(
                code: "POST_REQUEST_FAILED",
                message: "No data",
                details: nil))
          }
        }.resume()
      } else {
        result(
          FlutterError(
            code: "AUTHORIZATION_REQUEST_FAILED",
            message: authResponse.error,
            details: nil))
      }
    }
  }

  // app delegate functions
  //
  //
  public func application(
    _ application: UIApplication, continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([Any]) -> Void
  ) -> Bool {
    NSLog("application continue userActivity")
    if let url = userActivity.webpageURL {
      if TikTokURLHandler.handleOpenURL(url.absoluteURL) {
        return true
      } else {
        NSLog("toktok url handler failed")
      }
    }
    return false
  }

  public func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]
  ) -> Bool {
    return true
  }

  public func application(
    _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]
  ) -> Bool {
    print("TikTokURLHandler.handleOpenURL")
    if TikTokURLHandler.handleOpenURL(url) {
      return true
    }
    return false  //?
  }

  public func application(
    _ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any
  ) -> Bool {
    if TikTokURLHandler.handleOpenURL(url) {
      print("TikTokURLHandler.handleOpenURL")
      return true
    }
    return false
  }

  public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    if TikTokURLHandler.handleOpenURL(url) {
      print("TikTokURLHandler.handleOpenURL")
      return true
    }
    return false
  }
}
