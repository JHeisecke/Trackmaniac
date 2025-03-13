//
//  MotorTrackApp.swift
//  MotorTrack
//
//  Created by Javier Heisecke on 2025-03-11.
//

import SwiftUI
import GoogleMaps

@main
struct MotorTrackApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        GMSServices.provideAPIKey(Keys.googleMapsApiKey)
        return true
    }
}
