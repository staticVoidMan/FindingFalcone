/// Protocol returning a list of `Vehicle`s
public protocol VehicleListProvider {
    typealias CompletionResult = Result<[Vehicle],Error>
    typealias Completion = (CompletionResult)->Void
    
    func getList(completion: @escaping Completion)
}
