import UIKit

/// A generic `UICollectionViewDelegateFlowLayout` object
///
/// You need to initialize with an `ItemSelectableProviding` & `UIConfigurableCollectionViewCell` object.
class ItemPickerDelegate<Item: ItemSelectableProviding, Cell: UIConfigurableCollectionViewCell>: NSObject, UICollectionViewDelegateFlowLayout where Item == Cell.Item {
    typealias DidSelectHandler = (Item) -> Void
    
    private weak var datasource: ItemPickerDatasource<Item, Cell>?
    private let didSelect: DidSelectHandler?
    
    let gridSize: GridSize
    
    init(gridSize: GridSize, datasource: ItemPickerDatasource<Item, Cell>?, didSelect: DidSelectHandler?) {
        self.gridSize = gridSize
        self.datasource = datasource
        self.didSelect = didSelect
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let rows = CGFloat(gridSize.rows)
        let columns = CGFloat(gridSize.columns)
        
        let width: CGFloat = collectionView.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right - (layout.minimumInteritemSpacing * (columns - 1))
        let height: CGFloat = collectionView.bounds.size.height - layout.sectionInset.top - layout.sectionInset.bottom - (layout.minimumLineSpacing * (rows - 1))
        
        return CGSize(width: width/columns, height: height/rows)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = datasource?.items[indexPath.row],
           item.isSelectable {
            didSelect?(item)
        }
    }
}
