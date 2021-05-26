
import UIKit
import GoogleMaps
//import Firebase
import Network
import UserNotifications

let googleApiKey = "AIzaSyDTZr_DH0s__4WICenPjG8RLmZtiX-RpxI"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    //var monitor: NWPathMonitor!

    
      func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey(googleApiKey)
       /* FirebaseApp.configure()*/
        /*monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)*/

        // [START set_messaging_delegate]
       /* Messaging.messaging().delegate = self*/
        
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "initial", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "splashViewID") as! SplashViewController
        let centerController = UINavigationController(rootViewController: viewController)
        
        /*window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
          window.rootViewController = Menu
          window.makeKeyAndVisible()
        }*/
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = centerController
        return true
      }

      // [START receive_message]
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
      }

      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
      }
      // [END receive_message]
      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
      }

      // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
      // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
      // the FCM registration token.
      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")

        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
      }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("I'm WILL ENTER FOREGROUND !!")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("I'm DidBecome ACTIVE !!")
       /* DispatchQueue.main.async {
            if self.onActive() {
                if Connectivity.isConnectedToInternet {
                    
                    let offlineTemp = AppSettings.offlineMarks
                    EasyMarkSingleton.offlineMarksGlobal = AppSettings.offlineMarks
                    while EasyMarkSingleton.offlineMarksGlobal.count > 0 {
                        let lastElement = EasyMarkSingleton.offlineMarksGlobal.last!
                        EasyMarkSingleton.loadAttendanceRecord(dictMark: EasyMarkSingleton.offlineMarksGlobal.last!)
                        sleep(5)
                    }
                    
                }
            }
        }*/
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func onActive() -> Bool {
        let state = UIApplication.shared.applicationState
        if state == .active {
           print("I'm active")
           return true
        } else{
            print("I'm a BAD INACTIVE APPLICATION !!! ")
            return false
        }
    }
    
   /* func hasInternetConnection() -> Bool {
        var networkFlag = false
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in

            if path.status == .satisfied {
                print("Yay! We have internet!")
                /*if path.usesInterfaceType(.wifi) {
                    print("It's WiFi!")
                    AppSettings.connectionType = "w"
                    networkFlag = true
                } else if path.usesInterfaceType(.cellular) {
                    print("3G/4G FTW!!!")
                    AppSettings.connectionType = "m"
                    networkFlag = true
                }*/
                
                EasyMarkSingleton.offlineMarksGlobal = AppSettings.offlineMarks
                while EasyMarkSingleton.offlineMarksGlobal.count > 0 {
                    EasyMarkSingleton.loadAttendanceRecord(dictMark: EasyMarkSingleton.offlineMarksGlobal.last!)
                    sleep(3)
                }
                
                
                
                /*for (index, dictMark) in AppSettings.offlineMarks.enumerated() {
                    EasyMarkSingleton.loadAttendanceRecord(index: index, dictMark: dictMark)
                    sleep(3)
                }*/
                /*while EasyMarkSingleton.nMarks < 0 {
                    EasyMarkSingleton.loadAttendanceRecord()
                }*/
                
            } else{
                print("There isn't internet.")
                networkFlag = false
            }
        }
        return networkFlag
    }*/
    
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
// [END ios_10_message_handling]

/*extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    AppSettings.fcmToken = fcmToken
    
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
}*/

