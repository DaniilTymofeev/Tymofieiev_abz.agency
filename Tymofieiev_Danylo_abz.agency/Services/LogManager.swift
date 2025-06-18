//
//  LogManager.swift
//  Tymofieiev_Danylo_abz.agency
//
//  Created by Danil Tymofeev on 16.06.2025.
//

import SwiftUI

final class LogManager {
    static func logRequest(_ url: String, method: String) {
        print("🌐 API Request → \(method.uppercased()): \(url)")
    }
    
    static func logError(_ error: Error, url: String) {
        print("❌ API Error for \(url): \(error.localizedDescription)")
    }
    
    static func logFullRequest(_ request: URLRequest, model: Encodable? = nil) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "Unknown URL"
        var log = "📤 API Request: \(method) \(url)\n"
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            log += "🔸 Headers:\n"
            for (key, value) in headers {
                log += "    \(key): \(value)\n"
            }
        } else {
            log += "🔸 Headers: nil\n"
        }
        
        if let model {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            if let data = try? encoder.encode(model),
               let jsonString = String(data: data, encoding: .utf8) {
                log += "📝 Body Model (Encoded):\n\(jsonString)\n"
            } else {
                log += "📝 Body Model: <Failed to encode>\n"
            }
        } else if let body = request.httpBody {
            log += "📝 Body: <Data present but no model provided>\n"
        } else {
            log += "📝 Body: nil\n"
        }
        
        print(log)
    }
    
    static func logResponse(_ data: Data, url: String) {
        if let pretty = prettyPrintedJSON(from: data) {
            print("✅ API Response from \(url):\n\(pretty)")
        } else {
            print("❌ Failed to pretty print response from \(url)")
        }
    }
}
