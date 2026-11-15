//
//  ContentView.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 30/05/1448 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
            OnboardingView(viewModel: viewModel)
                .navigationDestination(isPresented: $viewModel.hasStarted) {
                    CurrentDay(viewModel: viewModel)
                        .toolbar(.hidden, for: .navigationBar)
                }
        }
    }
}

#Preview {
    ContentView()
}
