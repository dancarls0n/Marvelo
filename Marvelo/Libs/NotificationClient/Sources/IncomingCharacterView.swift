//
//  Created by Dan Carlson on 2022-12-17.
//  

import SwiftUI
import Models

public struct IncomingCharacterView: View {
    
    public init(name: String, imageURL: URL? = nil, description: String? = nil, onDismiss: @escaping () -> Void = { }) {
        self.name = name
        self.imageURL = imageURL
        self.description = description
        self.onDismiss = onDismiss
    }
    
    var name: String
    var imageURL: URL?
    var description: String?
    var onDismiss: () -> Void = { }
    
    public var body: some View {
        ZStack {
            Color.red.opacity(0.5)
            VStack {
                HStack {
                    ZStack {
                        HStack {
                            Spacer()
                            Text("🚨INCOMING🚨")
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button(action: { onDismiss() },
                                   label: { Image(systemName: "xmark").foregroundColor(.black) })
                        }
                    }
                }.frame(height: 50)
                HStack {
                    Spacer(minLength: 80)
                    AsyncImage(url: imageURL,
                               content: { $0.resizable() },
                               placeholder: { Image(systemName: "person.fill").resizable() })
                    .frame(width: 70, height: 70)
                    .cornerRadius(35.0)
                    Text(name).padding(.leading, 10)
                    Spacer(minLength: 80)
                }
                if let description = description {
                    Text(description)
                }
            }.padding()
                .background(Color.white)
                .cornerRadius(30.0)
                .shadow(color: .gray, radius: 5.0)
                .padding(30.0)
                
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingCharacterView(name: "Bob",
                              imageURL: URL(string: "https://picsum.photos/200"),
                              description: "Invisible Plane, Lasso, The works")
    }
}
