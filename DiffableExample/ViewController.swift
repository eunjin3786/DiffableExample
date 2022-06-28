import UIKit

// Section이 하나인 TableView.

class ViewController: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: DataSource!
    
    enum Section {
        case main
    }
    
    enum Row: CaseIterable {
        case dog
        case cat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        applyInitialSnapshot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.applyNewSnapshot()
        }
    }
    
    private func setupTableView() {
        let cellProvider = {
            (tableView: UITableView, indexPath: IndexPath, row: Row) -> UITableViewCell in
            let cell = UITableViewCell()
            switch row {
            case .dog:
                cell.textLabel?.text = "강아지 셀"
            case .cat:
                cell.textLabel?.text = "고양이 셀"
            }
            return cell
        }
        
        let dataSource = UITableViewDiffableDataSource<Section, Row>(tableView: tableView, cellProvider: cellProvider)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(Row.allCases, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false) {
            print(#function + " completion called")
        }
    }
    
    func applyNewSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(Row.allCases.reversed(), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true) {
            print(#function + " completion called")
        }
    }
}

