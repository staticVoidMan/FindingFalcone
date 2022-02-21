/// Protocol returning a list of `Planet`s
public protocol PlanetListProvider {
    typealias CompletionResult = Result<[Planet],Error>
    typealias Completion = (CompletionResult)->Void
    
    func getList(completion: @escaping Completion)
}
