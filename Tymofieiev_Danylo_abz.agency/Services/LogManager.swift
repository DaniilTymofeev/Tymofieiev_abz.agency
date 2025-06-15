//
//  LogManager.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

enum LogManager {
    static func logRequest(_ url: String, method: String = "GET") {
        #if DEBUG
        print("🌐 Request → [\(method)] \(url)")
        #endif
    }

    static func logResponse<T: Decodable>(_ type: T.Type, data: Data) {
        #if DEBUG
        let jsonString = String(data: data, encoding: .utf8) ?? "<Non-UTF8 data>"
        print("✅ Response → Decoded as \(type):\n\(jsonString)")
        #endif
    }

    static func logError(_ error: Error, url: String) {
        #if DEBUG
        print("❌ Error → \(url): \(error.localizedDescription)")
        #endif
    }
}

func prettyPrintedJSON(from data: Data) -> String? {
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        return String(decoding: prettyData, as: UTF8.self)
    } catch {
        return nil
    }
}

