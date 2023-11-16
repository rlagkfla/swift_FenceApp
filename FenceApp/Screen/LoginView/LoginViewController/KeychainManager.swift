import Foundation
import Security

struct KeychainManager {
    
    static let service = "com.FenceApp.credentials"
    
    static func saveEmail(email: String) -> Bool {
        
        let emailData = email.data(using: .utf8)!
    
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email,
            kSecValueData as String: emailData  // saving email data here
        ]
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    static func deleteEmail() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
    
    static func retrieveEmail() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let existingItem = item as? [String: Any],
              let emailData = existingItem[kSecValueData as String] as? Data,
              let email = String(data: emailData, encoding: .utf8) else {
            return nil
        }
        
        return email
    }
    
    static func printAllKeychainItems() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var items: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &items)

        guard status == errSecSuccess else {
            print("Error fetching keychain items: \(status)")
            return
        }

        guard let array = items as? [[String: Any]] else {
            print("Unexpected data format in keychain")
            return
        }

        for item in array {
            if let data = item[kSecValueData as String] as? Data,
               let string = String(data: data, encoding: .utf8),
               let account = item[kSecAttrAccount as String] as? String {
                print("Account: \(account), Data: \(string)")
            }
        }
    }
    
    static func deleteAllItems() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }


}
