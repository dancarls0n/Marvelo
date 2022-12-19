//
//  Created by Dan Carlson on 2022-12-17.
   
import SwiftUI

public struct SoloCharacterView: View {
       
    var name: String
    var imageURL: URL?
    var isFavorited: Bool = false
    var description: String?
    var lastUpdate: String?
    var eventNames: [String] = []
        
    var onFavoriteToggle: () -> Void = { }
    var onCalculateRank: () -> Void = { }
    var onDismiss: () -> Void = { }
    
    private var eventListString: String {
        var eventsString = eventNames.reduce(into: "", { resultString, eventName in  resultString = " \(eventName)," })
        return eventsString.trimmingCharacters(in: [","])
    }
    
    public init(name: String, imageURL: URL? = nil, isFavorited: Bool = false, description: String? = nil, lastUpdate: String? = nil, eventNames: [String] = [], onFavoriteToggle: @escaping () -> Void = { }, onCalculateRank: @escaping () -> Void = { }, onDismiss: @escaping () -> Void = { }) {
        self.name = name
        self.imageURL = imageURL
        self.isFavorited = isFavorited
        self.description = description
        self.lastUpdate = lastUpdate
        self.eventNames = eventNames
        self.onFavoriteToggle = onFavoriteToggle
        self.onCalculateRank = onCalculateRank
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: { onDismiss() },
                           label: { Image(systemName: "xmark").foregroundColor(.black) })
                }
                Spacer()
            }
            VStack {
                HStack {
                    AsyncImage(url: imageURL,
                               content: { $0.resizable() },
                               placeholder: { Image(systemName: "person.fill").resizable() })
                    .frame(width: 70, height: 70)
                    .cornerRadius(35.0)
                    .padding(.leading, 10)
                    VStack {
                        Text(name).font(.largeTitle)
                        lastUpdate.flatMap { Text($0).font(.footnote).italic() }
                    }.padding(.leading, 10)
                }.padding(.top, 20)
                
                if let description = description {
                    Text(description).padding([.top, .bottom], 20.0)
                }
                
                HStack {
                    
                    Button("Favorite Rank") { onCalculateRank() }
                    Spacer()
                    Button(action: { onFavoriteToggle() }, label: {
                        if isFavorited {
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                        } else {
                            Image(systemName: "star")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                        }
                    })
                    Spacer()
                }
                
                Text("Events \(eventNames.count)").padding(.top, 40)
                Text(eventListString).font(.body).italic()
                
            }.padding().background(Color.white)
        }
    }

}
