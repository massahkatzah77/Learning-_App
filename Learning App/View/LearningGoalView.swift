//
//  LearningGoalView.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 04/06/1448 AH.
//


import SwiftUI

struct LearningGoalView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: ActivityViewModel
    
    @State private var topic: String = ""
    @State private var selectedDuration: String = "Week"
    @State private var showUpdateAlert: Bool = false
    @FocusState private var isTopicFocused: Bool
    
    private let durations = ["Week", "Month", "Year"]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                // 1. الشريط العلوي (رجوع + العنوان + زر الصح البرتقالي)
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .glassEffect(.regular, in: Circle())
                            }
                    }
                    
                    Spacer()
                    
                    Text("Learning Goal")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        isTopicFocused = false
                        showUpdateAlert = true
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.orange)
                            .clipShape(Circle())
                            .glassEffect(.clear, in: Circle())
                    }
                }
                .padding(.top, 8)
                
                // 2. حقل اسم المهارة
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Swift", text: $topic)
                        .foregroundColor(.white)
                        .focused($isTopicFocused)
                    
                    Divider()
                        .background(Color.gray.opacity(0.5))
                }
                .padding(.top, 12)
                
                // 3. أزرار اختيار المدة
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn it in a")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        ForEach(durations, id: \.self) { duration in
                            Button(action: {
                                selectedDuration = duration
                            }) {
                                Text(duration)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedDuration == duration ? .white : .gray)
                                    .frame(width: 90, height: 44)
                                    .background {
                                        if selectedDuration == duration {
                                            Color.orange
                                        } else {
                                            Capsule()
                                                .fill(.ultraThinMaterial)
                                                .glassEffect(.regular, in: Capsule())
                                        }
                                    }
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // 4. نافذة التنبيه المخصصة (Update goal)
            if showUpdateAlert {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showUpdateAlert = false
                    }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Update goal")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("If you update now, your streak will start over.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            showUpdateAlert = false
                        }) {
                            Text("Dismiss")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            viewModel.updateGoal(topic: topic, duration: selectedDuration)
                            showUpdateAlert = false
                            dismiss()
                        }) {
                            Text("Update")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.orange)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
                }
                .padding(.horizontal, 36)
            }
        }
        .onAppear {
            topic = viewModel.learningTopic
            selectedDuration = viewModel.selectedDuration
        }
    }
}



#Preview {
    LearningGoalView(viewModel: ActivityViewModel())
}
