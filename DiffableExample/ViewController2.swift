import UIKit

struct Post {
    let uuid = UUID()
    let title: String
}

class ViewController2: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UUID>
    typealias DataSource = UITableViewDiffableDataSource<Section, UUID>

    @IBOutlet weak var tableView: UITableView!
    var dataSource: DataSource!
    var posts: [Post] = [
        Post(title: "포스팅 1"),
        Post(title: "포스팅 2"),
        Post(title: "포스팅 3")
    ]
    
    enum Section: Int, CaseIterable {
        case top
        case post
        case bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        applyInitialSnapshot()
    }
    
    private func setupTableView() {
        let cellProvider = {
            [weak self] (tableView: UITableView, indexPath: IndexPath, uuid: UUID) -> UITableViewCell? in
            guard let self = self else { return nil }
            switch Section(rawValue: indexPath.section)! {
            case .top:
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = "탑 메세지"
                return cell
            case .post:
                let post = self.posts[indexPath.row]
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = post.title
                return cell
            case .bottom:
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = "바텀 메세지"
                return cell
            }
        }
        
        let dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([UUID()], toSection: .top)
        snapshot.appendItems(self.posts.map { $0.uuid }, toSection: .post)
        snapshot.appendItems([UUID()], toSection: .bottom)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
