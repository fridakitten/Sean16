//
//  ContentView.swift
//  Sean16CPU
//
//  Created by Frida Boleslawska on 26.09.24.
//

import SwiftUI
import Cocoa
import AppKit

struct ScreenEmulatorViewWrapper: NSViewRepresentable {
    func makeNSView(context: Context) -> MyScreenEmulatorView {
        let screenView = getEmulator() ?? MyScreenEmulatorView()
        screenView.translatesAutoresizingMaskIntoConstraints = false  // Ensure it can resize
        return screenView
    }
    
    func updateNSView(_ nsView: MyScreenEmulatorView, context: Context) {
        nsView.needsDisplay = true  // Redraw the view when the window resizes
    }
}

struct ContentView: View {
    @State var hello: String = ""
    var body: some View {
        GeometryReader { geometry in
            let aspectRatio = CGSize(width: 254, height: 159) //155
            let scale = min(geometry.size.width / aspectRatio.width, geometry.size.height / aspectRatio.height)
            
            VStack {
                ScreenEmulatorViewWrapper()
                    .frame(width: aspectRatio.width, height: aspectRatio.height) // Fixed size of 255x100
                    .scaleEffect(scale)  // Scale to fill the window while maintaining aspect ratio
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // Center in the available space
                    .clipped()  // Ensure any overflow is clipped to fit within the window bounds
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            let mainBundle = Bundle.main
                            if let resourcePath = mainBundle.resourcePath {
                                kickstart("\(resourcePath)/output.bin")  // Start the emulator on appear
                            }
                        }
                    }
            }
            .edgesIgnoringSafeArea(.all)  // Fill the entire window
        }
    }
}
