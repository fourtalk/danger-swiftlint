enum Severity: String, Codable {
    case warning = "Warning"
    case error = "Error"
}
    
public struct Violation: Codable {
    let ruleID: String
    let reason: String
    let line: Int
    let character: Int?
    let severity: Severity
    let type: String
    var inline: Bool
    
    private(set) var file: String

    enum CodingKeys: String, CodingKey {
        case ruleID = "rule_id"
        case reason, line, character, file, severity, type, inline
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ruleID = try values.decode(String.self, forKey: .ruleID)
        reason = try values.decode(String.self, forKey: .reason)
        line = try values.decode(Int.self, forKey: .line)
        character = try values.decode(Int?.self, forKey: .character)
        file = try values.decode(String.self, forKey: .file)
        severity = try values.decode(Severity.self, forKey: .severity)
        type = try values.decode(String.self, forKey: .type)
        inline = false
    }

    public func toMarkdown() -> String {
        let formattedFile = file.split(separator: "/").last! + ":\(line)"
        return "| \(severity.emojiSeverity) | \(formattedFile) | \(reason) |"
    }

    mutating func update(file: String) {
        self.file = file
    }
}

extension Severity {
    var emojiSeverity: String {
        switch self {
        case .warning:
            return "⚠️"
        case .error:
            return "❗️"
        }
    }
}


/*
 "rule_id" : "opening_brace",
 "reason" : "Opening braces should be preceded by a single space and on the same line as the declaration.",
 "character" : 39,
 "file" : "\/Users\/ash\/bin\/Harvey\/Sources\/Harvey\/Harvey.swift",
 "severity" : "Warning",
 "type" : "Opening Brace Spacing",
 "line" : 8
*/
