//
//  CalendarView.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 05/06/1448 AH.
//

import SwiftUI

struct CalendarView: View {
        var viewModel: ActivityViewModel
        @Environment(\.dismiss) private var dismiss
        
        private let calendar = Calendar.current
        private let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
        
        private var currentYear: Int {
            calendar.component(.year, from: Date())
        }
        
        private var currentMonth: Int {
            calendar.component(.month, from: Date())
        }
        
        var body: some View {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // 1. الهيدر العلوي (زر الرجوع + عنوان Activities)
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        Spacer()
                        
                        Text("Activities")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // موازنة بصرية لتوسيط العنوان
                        Color.clear
                            .frame(width: 40, height: 40)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // 2. قائمة أشهر السنة الحالية (للعرض فقط بدون تفاعل)
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 24) {
                                ForEach(1...12, id: \.self) { month in
                                    MonthCalendarSection(
                                        year: currentYear,
                                        month: month,
                                        weekdays: weekdays,
                                        columns: columns,
                                        viewModel: viewModel
                                    )
                                    .id(month)
                                    
                                    if month < 12 {
                                        Divider()
                                            .background(Color.white.opacity(0.15))
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                        .onAppear {
                            proxy.scrollTo(currentMonth, anchor: .top)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - قسم كل شهر داخل التقويم
    private struct MonthCalendarSection: View {
        let year: Int
        let month: Int
        let weekdays: [String]
        let columns: [GridItem]
        var viewModel: ActivityViewModel
        
        private let calendar = Calendar.current
        
        private var monthTitle: String {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            
            guard let date = calendar.date(from: components) else { return "" }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
        
        private var monthDays: [Date?] {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            
            guard let firstDayOfMonth = calendar.date(from: components),
                  let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
                return []
            }
            
            // حساب الفراغات قبل اليوم الأول من الشهر ليطابق يوم الأسبوع الحقيقي
            let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
            var cells: [Date?] = Array(repeating: nil, count: firstWeekday)
            
            for day in range {
                components.day = day
                cells.append(calendar.date(from: components))
            }
            
            return cells
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 14) {
                Text(monthTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // أسماء أيام الأسبوع
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(weekdays, id: \.self) { dayName in
                        Text(dayName)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // شبكة أيام الشهر (تتلون فقط عند تسجيل تعلم أو تجميد)
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Array(monthDays.enumerated()), id: \.offset) { _, date in
                        if let date = date {
                            let dayNumber = calendar.component(.day, from: date)
                            let status = viewModel.calendarStatus(for: date)
                            let isToday = calendar.isDateInToday(date)
                            
                            Text("\(dayNumber)")
                                .font(.system(size: 16, weight: status == .normal ? .medium : .semibold))
                                .foregroundColor(textColor(for: status, isToday: isToday))
                                .frame(width: 38, height: 38)
                                .background(backgroundColor(for: status, isToday: isToday))
                                .clipShape(Circle())
                        } else {
                            Color.clear
                                .frame(width: 38, height: 38)
                        }
                    }
                }
            }
        }
        
        private func textColor(for status: DayState, isToday: Bool) -> Color {
            switch status {
            case .loggedPast, .current:
                return isToday ? .white : .orangeui
            case .freezed:
                return .cyan
            case .normal:
                return .white
            }
        }
        
        private func backgroundColor(for status: DayState, isToday: Bool) -> Color {
            switch status {
            case .loggedPast, .current:
                return isToday ? .orangeui : .orangeui.opacity(0.25)
            case .freezed:
                return .cyan.opacity(0.25)
            case .normal:
                return .clear
            }
        }
    }

#Preview {
    CalendarView(viewModel: ActivityViewModel())
}
