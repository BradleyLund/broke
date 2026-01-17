//
//  AppBlocker.swift
//  Broke
//
//  Created by Oz Tamir on 22/08/2024.
//
import SwiftUI
import ManagedSettings
import FamilyControls

class AppBlocker: ObservableObject {
    let store = ManagedSettingsStore()
    @Published var isBlocking = false
    @Published var isAuthorized = false
    @Published var blockingStartTime: Date?

    init() {
        loadBlockingState()
        Task {
            await requestAuthorization()
        }
    }
    
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        } catch {
            print("Failed to request authorization: \(error)")
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
    
    func toggleBlocking(for profile: Profile) {
        guard isAuthorized else {
            print("Not authorized to block apps")
            return
        }

        isBlocking.toggle()

        if isBlocking {
            // Starting blocking - record the start time
            blockingStartTime = Date()
        } else {
            // Stopping blocking - we can calculate duration in the view
            // Keep the start time for now, view will clear it after showing confetti
        }

        saveBlockingState()
        applyBlockingSettings(for: profile)
    }

    func getBlockedDuration() -> TimeInterval? {
        guard let startTime = blockingStartTime else {
            return nil
        }
        return Date().timeIntervalSince(startTime)
    }

    func clearBlockingStartTime() {
        blockingStartTime = nil
        saveBlockingState()
    }
    
    func applyBlockingSettings(for profile: Profile) {
        if isBlocking {
            NSLog("Blocking \(profile.appTokens.count) apps")
            store.shield.applications = profile.appTokens.isEmpty ? nil : profile.appTokens
            store.shield.applicationCategories = profile.categoryTokens.isEmpty ? ShieldSettings.ActivityCategoryPolicy.none : .specific(profile.categoryTokens)
        } else {
            store.shield.applications = nil
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.none
        }
    }
    
    private func loadBlockingState() {
        isBlocking = UserDefaults.standard.bool(forKey: "isBlocking")
        blockingStartTime = UserDefaults.standard.object(forKey: "blockingStartTime") as? Date
    }

    private func saveBlockingState() {
        UserDefaults.standard.set(isBlocking, forKey: "isBlocking")
        if let startTime = blockingStartTime {
            UserDefaults.standard.set(startTime, forKey: "blockingStartTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "blockingStartTime")
        }
    }
}