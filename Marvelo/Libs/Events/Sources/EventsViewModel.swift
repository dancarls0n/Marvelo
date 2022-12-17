  //
 //  Created by Dan Carlson on 2022-12-14.
//

import Foundation

import DataStore
import Models
import UIKit

@MainActor
public class EventsViewModel: NSObject {
		
	// TODO: Bind to data layer to get updates upon event or favorites changes
	
	private var dataStore: DataStore
    private var eventsStreamTask: Task<Void, Never>?
	 
	init(dataStore: DataStore) {
		self.dataStore = dataStore
	}

    func startMonitoringDataStore() {
        // Subscribe for updates.
        eventsStreamTask = Task {
            for await updatedEvents in dataStore.eventsStream() {
                modelizeEvents(events: updatedEvents)
            }
        }

        // Get the persisted events
        let events = dataStore.getEvents(refetch: false)
        modelizeEvents(events: events)
    }

    func stopMonitoringDataStore() {
        eventsStreamTask?.cancel()
        eventsStreamTask = nil
    }

	var reloadTableView: (() -> Void)?
	
	// Fetched from DataStore
	var events: [Event] = []
	var favoritesList: FavoriteList = FavoriteList()
	
	var eventCellViewModels = [EventCellViewModel]() {
		didSet {
			reloadTableView?()
		}
	}

	func modelizeEvents(events: [Event]) {
		self.events = events
		var vms = [EventCellViewModel]()
		for event in events {
			vms.append(createCellModel(event: event, favorites: favoritesList))
		}
		eventCellViewModels = vms
	}
	
    func createCellModel(event: Event, favorites: FavoriteList) -> EventCellViewModel {
		let avatarUrl = event.thumbnail?.path
		let title = event.title ?? ""
		let description = event.description ?? ""
		let comicsCount: Int = event.comics?.items?.count ?? 0
        
        return EventCellViewModel(avatarImageUrl: avatarUrl,
                                  title: title,
                                  description: description,
                                  comicsCount: comicsCount,
                                  characters: event.characters?.items ?? [],
                                  favoriteList: favorites)
	}
	
	func getCellViewModel(at indexPath: IndexPath) -> EventCellViewModel {
		return eventCellViewModels[indexPath.row]
	}
}
