import UIKit

class ViewController: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: DataSource!
    
    enum Section: Int {
        case main
    }
    
    enum Row: Int, CaseIterable {
        case dog
        case cat
    }
    
    var dogText = "강아지"
    var catText = "고양이"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        applyInitialSnapshot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // self.applyNewSnapshot()
            // self.updateTexts()
            self.deleteItems()
        }
    }
    
    private func setupTableView() {
        let cellProvider = {
            [weak self] (tableView: UITableView, indexPath: IndexPath, row: Row) -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
            switch row {
            case .dog:
                cell.textLabel?.text = "\(self.dogText) 셀"
            case .cat:
                cell.textLabel?.text = "\(self.catText) 셀"
            }
            return cell
        }
        
        let dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.dog, .cat], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func applyNewSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([.cat], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateTexts() {
        dogText = "갱얼쥐"
        catText = "고냥이"
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([.dog])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func insertItems() {
        var snapshot = dataSource.snapshot()
        snapshot.insertItems([.cat], afterItem: .dog)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func deleteItems() {
        let snapshot = Snapshot()
        dataSource.defaultRowAnimation = .top
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// by using datasource
extension ViewController {

    // for single section
    func dogCell() -> UITableViewCell? {
        guard let indexPath = dataSource.indexPath(for: .dog) else { return nil }
        return tableView.cellForRow(at: indexPath)
    }

    func findRow(of index: Int) -> Row? {
        return dataSource.itemIdentifier(for: IndexPath(row: index, section: Section.main.rawValue))
    }
}

// by using snapshot
//extension ViewController {
//
//    // for single section
//    func dogCell() -> UITableViewCell? {
//        let snapshot = dataSource.snapshot()
//        guard let index = snapshot.indexOfItem(.dog) else { return nil }
//        guard let section = snapshot.indexOfSection(.main) else { return nil }
//        return tableView.cellForRow(at: IndexPath(row: index, section: section))
//    }
//
//    func findRow(of index: Int) -> Row? {
//        let snapshot = dataSource.snapshot()
//        return snapshot.itemIdentifiers(inSection: .main)
//            .first(where: { snapshot.indexOfItem($0) == index })
//    }
//
//    // for multipleSections
//    func rowsInSection(of section: Section) -> [Row] {
//        let snapshot = dataSource.snapshot()
//        let items = snapshot.itemIdentifiers(inSection: section)
//        return items
//    }
//
//    func findSection(containing row: Row) -> Section? {
//        let snapshot = dataSource.snapshot()
//        return snapshot.sectionIdentifier(containingItem: row)
//    }
//}
