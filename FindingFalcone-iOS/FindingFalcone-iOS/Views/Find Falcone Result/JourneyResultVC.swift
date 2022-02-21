import UIKit

class JourneyResultVC: UIViewController {
    weak var coordinator: JourneyResultCoordinator?
    var viewModel: JourneyResultVM!
    
    let resultLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = UIColor(named: "primary")
        view.font = UIFont.preferredFont(forTextStyle: .title3)
        view.textAlignment = .center
        return view
    }()
    
    let resultImageView: UIImageView = UIImageView()
    
    let websiteLinkButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.link, for: .normal)
        view.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        view.contentVerticalAlignment = .bottom
        return view
    }()
    
    let startAgainButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "primary")
        view.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "secondary")
        
        setupUI()
        
        viewModel.statusUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshUI()
            }
        }
        viewModel.start()
    }
    
    func setupUI() {
        setupResultLabel()
        setupResultImageView()
        setupWebsiteButton()
        setupStartAgainButton()
        
        refreshUI()
    }
    
    func setupResultLabel() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                             constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -20)
        ])
    }
    
    func setupResultImageView() {
        resultImageView.layer.cornerRadius = 20
        resultImageView.layer.masksToBounds = true
        
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resultImageView)
        NSLayoutConstraint.activate([
            resultImageView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor,
                                                 constant: 20),
            resultImageView.leadingAnchor.constraint(equalTo: resultLabel.leadingAnchor),
            resultImageView.trailingAnchor.constraint(equalTo: resultLabel.trailingAnchor),
            resultImageView.heightAnchor.constraint(equalTo: resultImageView.widthAnchor,
                                                    multiplier: 450/600)
        ])
    }
    
    func setupWebsiteButton() {
        websiteLinkButton.setTitle(viewModel.websiteText, for: .normal)
        websiteLinkButton.addTarget(self, action: #selector(websiteLinkButtonPressed), for: .touchUpInside)
        
        websiteLinkButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(websiteLinkButton)
        NSLayoutConstraint.activate([
            websiteLinkButton.topAnchor.constraint(equalTo: resultImageView.bottomAnchor),
            websiteLinkButton.leadingAnchor.constraint(equalTo: resultImageView.leadingAnchor),
            websiteLinkButton.trailingAnchor.constraint(equalTo: resultImageView.trailingAnchor)
        ])
        resultImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func setupStartAgainButton() {
        startAgainButton.setTitle(viewModel.startAgainText, for: .normal)
        startAgainButton.addTarget(self, action: #selector(startAgainButtonPressed), for: .touchUpInside)
        
        startAgainButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(startAgainButton)
        NSLayoutConstraint.activate([
            startAgainButton.topAnchor.constraint(equalTo: websiteLinkButton.bottomAnchor),
            startAgainButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            startAgainButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            startAgainButton.heightAnchor.constraint(equalToConstant: 96),
            startAgainButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        resultImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func refreshUI() {
        resultLabel.text = viewModel.resultText
        
        resultImageView.alpha = 0
        if let imageName = viewModel.imageName {
            resultImageView.image = UIImage(named: imageName)
            
            UIView.animate(withDuration: 2) {
                self.resultImageView.alpha = 1
            }
        }
    }
    
    @objc
    func startAgainButtonPressed(_ sender: UIButton) {
        coordinator?.restart()
    }
    
    @objc
    func websiteLinkButtonPressed(_ sender: UIButton) {
        let url = URL(string: viewModel.websiteText)
        coordinator?.showWebsite(url: url)
    }
}
