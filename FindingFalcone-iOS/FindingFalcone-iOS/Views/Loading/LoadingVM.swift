import FindingFalconeCore

/// ViewModel protocol for `LoadingVC`
protocol LoadingVM {
    var loadingText: String { get }
    
    /// Callback providing the final `FindFalcone` resource
    var didFinishLoading: ((FindFalcone)->Void)? { get set }
    
    func load()
}
