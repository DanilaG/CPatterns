import SwiftUI
import YandexMobileMetrica

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setUpCustomNavBarAppearance()
        setUpCustomSearchBarAppearance()
        setUpYandexMetrica()
        return true
    }
}

// MARK: - UI setUp

private extension AppDelegate {
    func setUpCustomNavBarAppearance() {
        let backgroundColor = UIColor(Color.blueMain)
        let titleColor = UIColor.white

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func setUpCustomSearchBarAppearance() {
        UISearchBar.appearance().overrideUserInterfaceStyle = .dark
        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(.backgroundSearch)
    }
}

private extension AppDelegate {
    func setUpYandexMetrica() {
        guard let filePath = Bundle.main.path(forResource: "YMetricaInfo", ofType: "plist") else {
            print("❌ Couldn't find file YMetricaInfo.plist.")
            return
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            print("❌ Couldn't find key 'API_KEY' in YMetricaInfo.plist.")
            return
        }

        guard let configuration = YMMYandexMetricaConfiguration(apiKey: value) else {
            print("❌ No Yandex metrica configuration")
            return
        }

        configuration.logs = true
        configuration.crashReporting = true
        configuration.locationTracking = false

        YMMYandexMetrica.activate(with: configuration)
    }
}
