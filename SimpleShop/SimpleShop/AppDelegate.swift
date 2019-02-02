//
//  AppDelegate.swift
//  SimpleShop
//
//  Created by Anton Ihnatovich on 1/16/19.
//  Copyright © 2019 Ihnatovich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        UINavigationBar.appearance().isTranslucent = false
        
        setupCacheDirectory()
        return true
    }

    private func setupCacheDirectory() {
        guard var directoryPath = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            Swift.print("[ImageService] failed to retrieve url for cache directory")
            return
        }
        directoryPath.appendPathComponent("cachedImages/")
        var isDirectory : ObjCBool = false
        FileManager.default.fileExists(atPath: directoryPath.path, isDirectory: &isDirectory)
        if !isDirectory.boolValue {
            try? FileManager.default.createDirectory(atPath: directoryPath.path, withIntermediateDirectories: false, attributes: nil)
            Swift.print("created directory")
        }
    }
}

