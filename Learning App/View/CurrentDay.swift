//
//  CurrentDay.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 02/06/1448 AH.
//

import SwiftUI

struct CurrentDay: View {
    var viewModel: ActivityViewModel
    @State private var showEditGoal: Bool = false
    @State private var showCalendar: Bool = false
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                // 1. قسم النصوص (العنوان والتاريخ)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Activity")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    Text(viewModel.currentDateFormatted)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                HStack(spacing: 14) {
                    HeaderButton(iconName: "calendar") {
                                            showCalendar = true
                                        }
                    HeaderButton(iconName: "pencil.and.outline") {
                        showEditGoal = true
                    }
                }
                .padding(.horizontal)
                
            }
            
            WeekCalendarView(days: viewModel.days)
            
            HStack(spacing: 16) {
                StatCardView(
                    icon: "flame.fill",
                    iconColor: .orange,
                    value: "\(viewModel.learnedDaysCount) \(viewModel.learnedDaysCount == 1 ? "day" : "days")",
                    title: "Learned"
                )
                
                StatCardView(
                    icon: "snowflake",
                    iconColor: .cyan,
                    value: "\(viewModel.freezedDaysCount) \(viewModel.freezedDaysCount == 1 ? "day" : "days")",
                    title: "Freezed"
                )
            }
            .padding(.horizontal)
            Spacer()
            
            if viewModel.goalStatus == .active {
                            LogLearnedButton(isLogged: viewModel.isLoggedToday) {
                                viewModel.logAsLearned()
                            }
                            .disabled(viewModel.isLoggedToday || viewModel.isFreezedToday)
                                            .opacity(viewModel.isFreezedToday ? 0.45 : 1.0)
                            
                            Spacer()
                            
                FreezeButtonView(
                                    isLoggedToday: viewModel.isLoggedToday,
                                    isFreezedToday: viewModel.isFreezedToday,
                                    usedFreezes: viewModel.usedFreezes,
                                    maxFreezes: viewModel.maxFreezes
                                ) {
                                    viewModel.freezeDay()
                                }
                            .padding(.bottom, 12)
                        } else {
                            GoalStatusView(isCompleted: viewModel.goalStatus == .completed) {
                                showEditGoal = true
                                // سنربطه بفتح شاشة تعديل الهدف في الخطوة الجاية
                            }
                            
                            Spacer()
                        
 
                            
                        }
        }
        .navigationDestination(isPresented: $showEditGoal) {
            LearningGoalView(viewModel: viewModel)
                .toolbar(.hidden, for: .navigationBar)
        }
        .navigationDestination(isPresented: $showCalendar) {
                    CalendarView(viewModel: viewModel)
                        .toolbar(.hidden, for: .navigationBar)
                }
        
    }
    
    
    
    
    
    struct HeaderButton: View {
        let iconName: String
        var action: () -> Void = {}
        
        var body: some View {
            Button(action: action) {
                Image(systemName: iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .glassEffect(.regular, in: Circle())
                    }
            }
        }
    }
    
    struct WeekCalendarView: View {
        // بيانات وهمية (Mock Data) لرؤية التصميم، لاحقاً الـ ViewModel هو من سيغذي هذه المصفوفة بالبيانات الحقيقية
        let days: [DayElement]
        var body: some View {
            HStack {
                ForEach(days) { day in
                    VStack(spacing: 12) {
                        Text(day.letter)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text(day.number)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(textColor(for: day.state))
                            .frame(width: 36, height: 36)
                            .background {
                                Circle()
                                    .fill(backgroundColor(for: day.state).opacity(0.85))
                                
                            }                        }
                    .frame(maxWidth: .infinity) // لتوزيع الأيام بالتساوي أفقياً مهما كان حجم الشاشة
                }
            }
            .padding(.horizontal)
        }
        private func textColor(for state: DayState) -> Color {
            switch state {
            case .loggedPast: return .orange
            case .current: return .white
            case .freezed: return .cyan// بناءً على تصميمك، النص داخل الدائرة الممتلئة يكون أسود ليقرأ بوضوح
            case .normal: return .white
            }
        }
        
        private func backgroundColor(for state: DayState) -> Color {
            switch state {
            case .loggedPast: return Color.orange.opacity(0.15) // برتقالي شفاف ليعطي تأثير الخلفية الداكنة
            case .current: return .orange
            case .freezed: return Color.cyan.opacity(0.15)
            case .normal: return .clear
                
                
            }
        }
    }
    struct StatCardView: View {
        let icon: String
        let iconColor: Color
        let value: String
        let title: String
        
        var body: some View {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                
                VStack(spacing: 2) {
                    Text(value)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0))
                    .glassEffect(in: RoundedRectangle(cornerRadius: 33))
            }
        }
    }
    
    struct LogLearnedButton: View {
        let isLogged: Bool
        let onTap: () -> Void
        
        var body: some View {
            Button(action: {
                onTap()
                // سيتم ربط الضغط بالـ ViewModel لاحقاً
            }) {
                Text(isLogged ? "Logged as Learned" : "Log as Learned")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isLogged ? .gray : .white)
                    .multilineTextAlignment(.center)
                    .frame(width: 300, height: 300)
                    .background {
                        Circle()
                            .fill(isLogged ? Color.white.opacity(0.08) : Color.orange)
                    }
                    .overlay {
                        Circle()
                            .stroke(
                                isLogged ? Color.white.opacity(0.15) : Color.white.opacity(0.25),
                                lineWidth: 1
                            )
                    }
            }
            .disabled(isLogged)
        }
    }
    struct FreezeButtonView: View {
        let isLoggedToday: Bool
            let isFreezedToday: Bool
            let usedFreezes: Int
            let maxFreezes: Int
            let onTap: () -> Void
            
            // يتعطل الزر ويتحول للرمادي في ثلاث حالات: تسجيل التعلم اليوم، تجميد اليوم، أو نفاذ الرصيد
            private var isDisabled: Bool {
                isLoggedToday || isFreezedToday || usedFreezes >= maxFreezes
            }
        
        var body: some View {
            VStack(spacing: 12) {
                Button(action: {
                    onTap()
                    // سيتم ربط الإجراء بالـ ViewModel لاحقاً
                }) {
                    Text(isFreezedToday ? "Freezed for a day" : "Freeze for a day")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isDisabled ? .gray : .white)
                        .frame(width: 250, height: 52)
                        .background {
                            Capsule()
                                .fill(isDisabled ? Color.white.opacity(0.08) : Color.cyan)
                        }
                        .overlay {
                            Capsule()
                                .stroke(
                                    isDisabled ? Color.white.opacity(0.15) : Color.white.opacity(0.3),
                                    lineWidth: 1
                                )
                        }
                }
                .disabled(isDisabled)
                
                Text("\(usedFreezes) out of \(maxFreezes) Freezes used")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    
}
struct GoalStatusView: View {
    let isCompleted: Bool
    let onSetGoal: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isCompleted ? "hands.clap.fill" : "xmark.seal.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
                .padding(.bottom, 4)
            
            Text(isCompleted ? "Well done!" : "You didn't reach your goal this time.")
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(isCompleted ? "Ready for your next goal?" : "Want to set another goal?")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: onSetGoal) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil.and.outline")
                    Text("Set a goal")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.orange)
                .clipShape(Capsule())
                .glassEffect(.clear, in: Capsule())
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 24)
    }
}
#Preview {
    NavigationStack {
        CurrentDay(viewModel: ActivityViewModel())
    }
}
    

