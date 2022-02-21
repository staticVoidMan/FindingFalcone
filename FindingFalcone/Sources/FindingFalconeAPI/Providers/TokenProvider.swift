/// Protocol returning a Session Token
public protocol TokenProvider {
    typealias Completion = (Result<Token,Error>) -> Void
    func getToken(_ completion: @escaping Completion)
}
