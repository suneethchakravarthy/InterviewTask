//
//  UserDefaultUtils.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case token
}

struct UserDefaultUtils {
    private let defaults = UserDefaults.standard
    public static var shared: UserDefaultUtils = UserDefaultUtils()
    private init() {
    }
    func resetUserDefaults() {
        if let appDomain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: appDomain)
        }
        defaults.synchronize()
    }
    func removeObject(for key: UserDefaultKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
    func removeObjects(for keys: [UserDefaultKeys]) {
        keys.forEach { (key) in
            defaults.removeObject(forKey: key.rawValue)
        }
    }

    // MARK: - Getters
    func getBoolValue(for key: UserDefaultKeys) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
    func getIntegerValue(for key: UserDefaultKeys) -> Int {
        return defaults.integer(forKey: key.rawValue)
    }
    func getFloatValue(for key: UserDefaultKeys) -> Float {
        return defaults.float(forKey: key.rawValue)
    }
    func getDoubleValue(for key: UserDefaultKeys) -> Double {
        return defaults.double(forKey: key.rawValue)
    }
    func getStringValue(for key: UserDefaultKeys) -> String {
        return defaults.value(forKey: key.rawValue) as? String ?? ""
    }
    func getURLValue(for key: UserDefaultKeys) -> URL? {
        if let url = defaults.url(forKey: key.rawValue) {
            return url
        }
        return nil
    }
    func getAnyValue(for key: UserDefaultKeys) -> Any? {
        return defaults.value(forKey: key.rawValue)
    }
    // MARK: - Setters
    func setBoolValue(for key: UserDefaultKeys, value: Bool) {
        defaults.set(value, forKey: key.rawValue)
    }
    func setIntegerValue(for key: UserDefaultKeys, value: Int) {
        defaults.set(value, forKey: key.rawValue)
    }
    func setDoubleValue(for key: UserDefaultKeys, value: Double) {
        defaults.set(value, forKey: key.rawValue)
    }
    func setFloatValue(for key: UserDefaultKeys, value: Float) {
        defaults.set(value, forKey: key.rawValue)
    }
    func setStringValue(for key: UserDefaultKeys, value: String) {
        defaults.set(value, forKey: key.rawValue)
    }
    func setURLValue(for key: UserDefaultKeys, value: URL) {
        defaults.set(value, forKey: key.rawValue)
    }
    func setAnyValue(for key: UserDefaultKeys, value: Any?) {
        defaults.set(value, forKey: key.rawValue)
    }
}

