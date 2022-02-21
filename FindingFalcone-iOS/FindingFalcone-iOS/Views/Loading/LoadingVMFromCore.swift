import FindingFalconeCore

class LoadingVMFromCore: LoadingVM {
    let provider: FindFalconeProvider
    var loadingText: String { LocalizedStringKey.loadingResources }
    
    var didFinishLoading: ((FindFalcone) -> Void)?
    
    init(provider: FindFalconeProvider) {
        self.provider = provider
    }
    
    func load() {
        guard let didFinishLoading = didFinishLoading else { return }
        provider.getCore(completion: didFinishLoading)
    }
}
