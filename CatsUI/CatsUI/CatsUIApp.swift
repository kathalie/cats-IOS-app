//
//  CatsUIApp.swift
//  CatsUI
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseCrashlytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct CatsUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("FirstStart") var firstStart = true
    @AppStorage("CrashlyticsAllowed") var crashlyticsAllowed = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert(isPresented: $firstStart) {
                    Alert(
                        title: Text("Allow crashlitic reports?"),
                        message: Text("Would you like to enable crash reporting to help improve the app?"),
                        primaryButton: .default(Text("Allow")) {
                            crashlyticsAllowed = true
                            firstStart = false
                            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
                            print("Crashlytics enabled")
                        },
                        secondaryButton: .cancel(Text("Deny")) {
                            crashlyticsAllowed = false
                            firstStart = false
                            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
                            print("Crashlytics disabled")
                        }
                    )
                }
                .onAppear {
                    if crashlyticsAllowed {
                        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
                        print("Crashlytics enabled")
                    } else {
                        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
                        print("Crashlytics disabled")
                    }
                }
        }
    }
}
