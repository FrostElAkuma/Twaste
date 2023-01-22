import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //Firebase
    Firebase.configure()

    //IOS Google maps key
    GMSServices.provideAPIKey("AIzaSyABY2MyXcI74Osrje2nejugdYPyvH1gBk0")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  //This I adeed as well cuz I need notification device token for IOS 
  //For IOS notifications it does not work on emulator, To test IOS notification I need to test it on real device. Check Other Tutoriols for this
  override func application(_ application: UIApplication,
  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    Messaging.Messaging().apnsToken = deviceToken
      print("Token: \(deviceToken)")
      super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
