//
//  OnboardingView.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 30/05/1448 AH.
//


import SwiftUI

struct OnboardingView: View {

    var viewModel: ActivityViewModel
        @State private var learningTopic: String = ""
        @State private var selectedDuration: String = "Week"

    var body: some View {

        ZStack {

            // لون الخلفية التلقائي للنظام
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(alignment: .leading) {

                // 1. Flame Icon
                HStack {
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                }

                // 2. Welcome Text
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Text("Hello")
                            .font(.largeTitle)
                            .foregroundColor(.white)

                        Text("Learner")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Text("This app will help you learn everyday!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 110)

                // 3. Learning Topic
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn")
                    TextField("Swift", text: $learningTopic)
                                            .foregroundColor(.white)

                   

                    Divider()
                        .background(Color.gray.opacity(0.5))
                }
                .padding(.top, 20)

                // 4. Duration Buttons
                VStack(alignment: .leading, spacing: 12) {

                    Text("I want to learn it in a")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 16) {

                        // Week
                        Button(action: {
                            selectedDuration = "Week"
                        }) {
                            Text("Week")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedDuration == "Week" ? .white : .gray)
                                .frame(width: 90, height: 44)
                                .background {
                                    if selectedDuration == "Week" {
                                        Color.orange
                                    } else {
                                        Capsule()
                                            .fill(.ultraThinMaterial)
                                            .glassEffect(.regular, in: Capsule())
                                    }
                                }
                                .cornerRadius(22)
                        }

                        // Month
                        Button(action: {
                            selectedDuration = "Month"
                        }) {
                            Text("Month")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedDuration == "Month" ? .white : .gray)
                                .frame(width: 90, height: 44)
                                .background {
                                    if selectedDuration == "Month" {
                                        Color.orange
                                    } else {
                                        Capsule()
                                            .fill(.ultraThinMaterial)
                                            .glassEffect(.regular, in: Capsule())
                                    }
                                }
                                .cornerRadius(22)
                        }

                        // Year
                        Button(action: {
                            selectedDuration = "Year"
                        }) {
                            Text("Year")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedDuration == "Year" ? .white : .gray)
                                .frame(width: 90, height: 44)
                                .background {
                                    if selectedDuration == "Year" {
                                        Color.orange
                                    } else {
                                        Capsule()
                                            .fill(.ultraThinMaterial)
                                            .glassEffect(.regular, in: Capsule())
                                    }
                                }
                                .cornerRadius(22)
                        }
                    }
                }
                .padding(.top, 20)

                Spacer()

                // 5. Start Learning Button
                HStack {
                    Spacer()

                    VStack(spacing: 8) {

                        Button(action: {
                            viewModel.startLearning(topic: learningTopic, duration: selectedDuration)
                            // أكشن الزر
                        }) {
                            Text("Start Learning")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 160, height: 50)
                                .background(Color.orangeui)
                                .cornerRadius(25)
                                .glassEffect(
                                    .clear,
                                    in: RoundedRectangle(cornerRadius: 25)
                                )
                        }

                        Text("You can edit your desire later")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    OnboardingView(viewModel: ActivityViewModel())
   
}
