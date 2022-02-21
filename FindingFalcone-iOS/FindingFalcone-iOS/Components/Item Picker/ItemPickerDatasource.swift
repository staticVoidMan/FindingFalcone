import UIKit

/// A generic `UICollectionViewDataSource` object
///
/// You need to initialize with an `ItemProviding` & `UIConfigurableCollectionViewCell` object.
class ItemPickerDatasource<Item: ItemProviding, Cell: UIConfigurableCollectionViewCell>: NSObject, UICollectionViewDataSource where Item == Cell.Item {
    let items: [Item]
    let cellIdentifier: String
    
    init(items: [Item], cellIdentifier: String) {
        self.items = items
        self.cellIdentifier = cellIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! Cell
        
        let viewModel = items[indexPath.item]
        cell.setup(with: viewModel)
        
        return cell
    }
}
