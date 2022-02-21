public typealias Token = String

/// Response data-transfer-object holding a session `Token`
struct TokenResponseTO {
    let token: Token
}

extension TokenResponseTO: Decodable {}
