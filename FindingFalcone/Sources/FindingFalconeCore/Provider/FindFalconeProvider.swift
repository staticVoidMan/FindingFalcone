/// Protocol returning the core `FindFalcone`
public protocol FindFalconeProvider {
    typealias Completion = (FindFalcone) -> Void
    func getCore(completion: @escaping Completion)
}
