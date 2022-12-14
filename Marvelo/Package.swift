// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
	name: "Marvelo",
	defaultLocalization: "en",
	platforms: [.iOS(.v15)]
)

enum Module: String, CaseIterable {
	case APIClient
	case Characters
	case Events
	case Favorites
	case Models
	case Notifications
	case Secrets
	case Storage
}

extension Module {
	var targetName: String { rawValue }
	var sourcesPath: String { "Libs/\(targetName)/Sources" }
	var testsPath: String { "Libs/\(targetName)/Tests" }
	var testTargetName: String { "\(targetName)Tests"}
	
	private static let target: (Module) -> Target = {
		.target(
			name: $0.rawValue,
			dependencies: [],
			path: $0.sourcesPath
		)
	}
	
	private static let testTarget: (Module) -> Target = {
		.testTarget(
			name: $0.testTargetName,
			dependencies: [],
			path: $0.testsPath
		)
	}
	
	func target(transform: (inout Target) -> Void = { _ in }) -> Target {
		var target = Module.target(self)
		transform(&target)
		return target
	}
	
	func testTarget(hasSnapshotTests: Bool = false, transform: (inout Target) -> Void = { _ in }) -> Target {
		var testTarget = Module.testTarget(self)
		transform(&testTarget)
		if hasSnapshotTests {
			testTarget.dependencies += [.product(name: "SnapshotTesting", package: "swift-snapshot-testing")]
			testTarget.resources = (testTarget.resources ?? []) + [.copy("__Snapshots__")]
		}
		testTarget.dependencies += [.byName(name: targetName)]
		return testTarget
	}
	
	static func targets(@TargetBuilder _ content: () -> [Target]) -> [Target] {
		content()
	}
}

extension Target.Dependency {
	
	static func module(_ module: Module, condition: TargetDependencyCondition? = nil) -> Target.Dependency {
		.byName(name: module.rawValue, condition: condition)
	}
	
	static func commonModule(_ module: CommonModule, condition: TargetDependencyCondition? = nil) -> Target.Dependency {
		.product(name: module.rawValue, package: "LocalModules", condition: condition)
	}
}

@resultBuilder
struct TargetBuilder {
	static func buildBlock() -> [Target] { [] }
	static func buildBlock(_ components: Target...) -> [Target] { components }
}

//MARK: - Module Products
package.products += Module.allCases.map {
	Product.library(
		name: $0.rawValue,
		targets: [$0.rawValue]
	)
}

// MARK: - Module Targets
package.targets += Module.targets {
	
	Module.APIClient.target {
		$0.dependencies += [
			.module(.Models)
		]
	}
	//
	//    Module.APIClientLive.target {
	//        $0.dependencies = [
	//            .module(.APIClient)
	//        ]
	//    }
	Module.Models.target {
		$0.dependencies = []
	}
	
	Module.Characters.target {
		$0.dependencies = []
	}
	
	Module.Events.target {
		$0.dependencies = []
	}
	
	Module.Favorites.target {
		$0.dependencies = []
	}
	
	Module.Notifications.target {
		$0.dependencies = [
			.product(name: "Ably", package: "ably-cocoa")
		]
	}
	
	Module.Secrets.target {
		$0.dependencies = []
	}
	
	Module.Storage.target {
		$0.dependencies = []
	}
	
	// MARK: - Module Test Targets
	Module.APIClient.testTarget() {
		$0.dependencies += [
			//            .commonModule(.CommonModuleName)
		]
	}
	Module.Models.testTarget()
}


package.dependencies += [
	
	//MARK: - Local Package Dependencies
	//    .package(name: "LocalModules", path: "../Modules"),
	
	//MARK: - External Package Dependencies
	.package(url: "https://github.com/ably/ably-cocoa",
					 from: "1.2.19"),
	.package(
		url: "https://github.com/onevcat/Kingfisher.git",
		exact: "7.4.1"
	)
]

enum CommonModule: String {
	case CommonModuleName
	case CommonModuleNameLive
}
