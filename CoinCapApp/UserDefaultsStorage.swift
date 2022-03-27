//
//  UserDefaultsStorage.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import Foundation

class UserDefaultsStorage {
    
    private enum Keys {
        static let favoritesAssets = "kFavoritesIds"
        static let appIcon = "kAppIcon"
    }
    
    private var userDefaults = UserDefaults.standard
    
    var favoritesIds: [String] {
        (userDefaults.object(forKey: Keys.favoritesAssets) as? [String]) ?? []
    }
    
    var appIcon: String? {
        get { userDefaults.object(forKey: Keys.appIcon) as? String }
        set { userDefaults.set(newValue, forKey: Keys.appIcon) }
    }
    
    func isFavoriteAsset(assetId: String) -> Bool {
        favoritesIds.contains(assetId)
    }
    
    private func addToFavoriteAsset(assetId: String) {
        var result = favoritesIds
        result.append(assetId)
        userDefaults.set(result, forKey: Keys.favoritesAssets)
    }
    
    private func removeFromFavorites(assetId: String) {
        var result = favoritesIds
        guard let index = result.firstIndex(of: assetId) else { return }
        result.remove(at: index)
        userDefaults.set(result, forKey: Keys.favoritesAssets)
    }
    
    func toggleFavoriteForAsset(assetId: String) {
        if isFavoriteAsset(assetId: assetId) {
            removeFromFavorites(assetId: assetId)
        } else {
            addToFavoriteAsset(assetId: assetId)
        }
    }
}
