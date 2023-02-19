//
//  ContentView.swift
//  Memorize
//
//  Created by Omar Ahmed on 2/13/23.
//

import SwiftUI

// Define the ContentView struct that conforms to the View protocol
struct ContentView: View {
    // An array of Theme structs
    let themes = [        
        Theme(name: "Vehicles", emojis: ["🚖", "🚗", "🚘", "🚙", "🚚", "🚛", "🚜","🏎","🚓","🚕"], icon: "car", color: .red),
        Theme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻","🐐","🐢","🐼"], icon: "hare", color: .green),
        Theme(name: "Fruits", emojis: ["🍎", "🍓", "🍊", "🍇", "🍌", "🍉", "🫐", "🍒","🥝","🍈"], icon: "leaf.fill", color: .yellow)
    ]
    
    // State property to store the current theme index
    @State private var currentThemeIndex = 0
    
    // State property to store the emoji count
    @State private var emojiCount = 16
    
    // Body of the ContentView struct
    var body: some View {
        VStack {
            // Display the "Memorize!" text
            Text("Memorize!")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // ScrollView to display the emojis
            ScrollView {
                // Use LazyVGrid to arrange the emojis in a grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                   ForEach(getEmojis(), id: \.self) { emoji in
                        // Display each emoji in a CardView
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .padding()
            }
            .foregroundColor(themes[currentThemeIndex].color)
            
            // Add a spacer to push the bottom buttons to the bottom of the screen
            Spacer()
            
            // HStack to arrange the theme buttons horizontally
            HStack{
                ForEach(themes.indices) { index in
                    let theme = themes[index]
                    // Button to change the theme
                    Button {
                        currentThemeIndex = index
                        refreshCards()
                        let count = emojiCount
                        emojiCount = 0 // clear the existing emojis
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            emojiCount = count // set the new emojis
                        }
                    } label: {
                        VStack {
                            // Display the icon of the theme
                            Image(systemName: theme.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)

                            
                            // Display the name of the theme
                            Text(theme.name)
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                    
                    // Add a spacer between buttons, except for the last button
                    if index < themes.count - 1{
                        Spacer()
                    }
                }
            }
            

            // Set the font for the theme buttons
            .font(.largeTitle)
            // Add padding to the theme buttons
            .padding(.horizontal,40)
        }
    }
    
    
    // For Extra Code
    // Method to refresh the cards
    private func refreshCards() {
        // Get the current theme
        let theme = themes[currentThemeIndex]
        // Determine the number of emojis to be displayed
        let count = theme.emojis.count > 8 ? Int.random(in: 8...theme.emojis.count) : theme.emojis.count
        emojiCount = count
    }
    
    // Method to get the emojis for the current theme
    private func getEmojis() -> [String] {
        // Get the current theme
        let theme = themes[currentThemeIndex]
        // Shuffle the emojis and get the specified number of them
        let emojis = theme.emojis.shuffled().prefix(emojiCount)
        return Array(emojis)
    }
}

// Struct to represent a theme
struct Theme {
    let name: String
    let emojis: [String]
    let icon: String
    let color: Color
}

// Struct to represent a card view
struct CardView: View {
    var content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack(alignment: .center) {
            // Define the shape of the card
            let shape = RoundedRectangle(cornerRadius: 25.0)
            if isFaceUp {
                // Fill the card with white color and add a border if the card is face up
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3.0)
                // Display the emoji on the card
                Text(content)
                    .font(.largeTitle)
            } else {
                // Fill the card with the background color if the card is not face up
                shape.fill()
            }
        }
        // Add a tap gesture to the card to toggle the face up/down state
        .onTapGesture {
            withAnimation {
                isFaceUp = !isFaceUp
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        ContentView()
            .preferredColorScheme(.light)
    }
}
