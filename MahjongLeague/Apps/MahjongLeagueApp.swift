import SwiftUI
import ComposableArchitecture
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
        
        return true
    }
}

@main
struct MahjongLeagueApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                GameView(
                    store: Store(
                        initialState: GameState(),
                        reducer: gameReducer,
                        environment: GameEnvironment(
                            apiClient: FirebaseAPIClient.live,
                            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                        )
                    )
                )
                .tabItem {
                    Text("記録")
                    Image(systemName: "pencil")
                }
                Text("hoge")
                    .tabItem {
                        Text("分析")
                        Image(systemName: "doc.text")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
