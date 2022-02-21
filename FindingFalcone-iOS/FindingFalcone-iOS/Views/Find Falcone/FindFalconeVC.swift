import UIKit

class FindFalconeVC: UIViewController {
    private var rowHeight: CGFloat { 128 }
    private var cellIdentifier: String { "JourneyCell" }
    
    weak var coordinator: FindFalconeCoordinator?
    var viewModel: FindFalconeVM!
    
    let tableView = UITableView()
    
    let totalJourneyTimeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .white
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.backgroundColor = UIColor(named: "primary")
        return view
    }()
    
    let readyStatusIndicator = StatusLight()
    
    let findFalconeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(named: "primary")
        view.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.screenTitleText
        self.view.backgroundColor = UIColor(named: "secondary")
        
        setupUI()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.refresh()
    }
    
    func setupUI() {
        setupNavigationBar()
        setupTableView()
        setupFindFalconeButton()
        setupTimeLabel()
        setupReadyStatusIndicator()
    }
    
    func setupNavigationBar() {
        let info = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(showHelp))
        info.tintColor = UIColor(named: "primary")
        self.navigationItem.setRightBarButton(info, animated: false)
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "JourneyCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func setupFindFalconeButton() {
        findFalconeButton.setTitle(viewModel.findFalconeText, for: .normal)
        findFalconeButton.addTarget(self, action: #selector(findFalconeButtonPressed), for: .touchUpInside)
        
        findFalconeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(findFalconeButton)
        NSLayoutConstraint.activate([
            findFalconeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            findFalconeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            findFalconeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            findFalconeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            findFalconeButton.heightAnchor.constraint(equalToConstant: 96)
        ])
    }
    
    func setupTimeLabel() {
        totalJourneyTimeLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        totalJourneyTimeLabel.layer.cornerRadius = 8
        totalJourneyTimeLabel.layer.masksToBounds = true
        totalJourneyTimeLabel.layer.borderWidth = 1
        totalJourneyTimeLabel.layer.borderColor = UIColor(named: "secondary")?.cgColor
        
        totalJourneyTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(totalJourneyTimeLabel)
        NSLayoutConstraint.activate([
            totalJourneyTimeLabel.centerXAnchor.constraint(equalTo: findFalconeButton.centerXAnchor),
            totalJourneyTimeLabel.heightAnchor.constraint(equalToConstant: 32),
            totalJourneyTimeLabel.bottomAnchor.constraint(equalTo: findFalconeButton.topAnchor,
                                                          constant: 1),
            totalJourneyTimeLabel.widthAnchor.constraint(equalTo: findFalconeButton.widthAnchor,
                                                         multiplier: 0.4),
        ])
        self.view.bringSubviewToFront(findFalconeButton)
    }
    
    func setupReadyStatusIndicator() {
        readyStatusIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(readyStatusIndicator)
        NSLayoutConstraint.activate([
            readyStatusIndicator.heightAnchor.constraint(equalToConstant: 6),
            readyStatusIndicator.widthAnchor.constraint(equalToConstant: 6),
            readyStatusIndicator.topAnchor.constraint(equalTo: findFalconeButton.topAnchor,
                                                      constant: 8),
            readyStatusIndicator.trailingAnchor.constraint(equalTo: findFalconeButton.trailingAnchor, constant: -10)
        ])
    }
    
    func setupObservers() {
        viewModel.journeyUpdated = { [weak self] (eta, readyStatus) in
            self?.totalJourneyTimeLabel.text = eta
            self?.readyStatusIndicator.update(readyStatus)
        }
        
        viewModel.updateRow = { [weak self] row in
            guard let self = self else { return }
            
            if let row = row {
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        
        viewModel.showAlert = { [weak self] alert in
            guard let alert = alert else { return }
            self?.coordinator?.showAlert(title: alert.title, message: alert.message)
        }
        
        viewModel.showFalconeResult = { [weak self] in
            self?.coordinator?.showFindFalconeResult()
        }
    }
}

extension FindFalconeVC {
    @objc
    func showHelp() {
        viewModel.showHelp()
    }
    
    @objc
    func findFalconeButtonPressed(_ sender: UIButton) {
        viewModel.findFalcone()
    }
}

extension FindFalconeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.journeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! JourneyCell
        
        let journeyID = viewModel.journeys[indexPath.row]
        let cellVM = viewModel.getJourney(for: journeyID)
        cell.setup(with: cellVM)
        
        cell.selectPlanet = { [weak self] in
            guard let _weakSelf = self else { return }
            
            let planets = _weakSelf.viewModel.getAvailablePlanets()
            _weakSelf.coordinator?.selectPlanet(from: planets) { (planet) in
                _weakSelf.viewModel.assignPlanet(planet.name, for: journeyID)
            }
        }
        
        cell.selectVehicle = { [weak self] in
            guard let _weakSelf = self else { return }
            
            let vehicles = _weakSelf.viewModel.getAvailableVehicles(for: journeyID)
            _weakSelf.coordinator?.selectVehicle(from: vehicles) { (vehicle) in
                _weakSelf.viewModel.assignVehicle(vehicle.name, for: journeyID)
            }
        }
        
        return cell
    }
}
