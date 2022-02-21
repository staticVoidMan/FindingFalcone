import UIKit

class LoadingVC: UIViewController {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "finding-falcone")
        return view
    }()
    
    let loadingLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(named: "primary")
        return view
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = UIColor(named: "primary")
        view.startAnimating()
        return view
    }()
    
    var viewModel: LoadingVM!
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupImageView()
        setupLoadingLabel()
        setupLoadingIndicator()
        
        setupObservers()
        viewModel.load()
    }
    
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 196),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    func setupLoadingLabel() {
        loadingLabel.text = viewModel.loadingText
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingLabel)
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func setupObservers() {
        viewModel.didFinishLoading = { [weak self] core in
            self?.coordinator?.showFindFalconeScreen(with: core)
        }
    }
}
