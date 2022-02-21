import UIKit
import FindingFalconeCore

/// An object that displays an item picker to the user.
///
/// Use this class to configure the popup with the items that you want to display. Provide an appropriate `datasource` & `delegate` to show the content.
class ItemPickerVC: UIViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    
    var cellNib: UINib!
    var cellIdentifier: String!
    
    var datasource: UICollectionViewDataSource?
    var delegate: UICollectionViewDelegateFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = title
        setupLayers()
        setupCollectionView()
    }
    
    func setupLayers() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    func setupCollectionView() {
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = datasource
        collectionView.delegate = delegate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.dismiss(animated: false)
    }
}
