//
//  ActivityViewModel.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 03/06/1448 AH.
//

import Foundation
import Observation
enum GoalStatus {
    case active      // الهدف ما زال مستمراً
    case completed   // اكتمل الهدف بنجاح
    case notMet      // انتهت المدة ولم يكتمل الهدف
}
@Observable
class ActivityViewModel {
    // 1. بيانات شريط الأيام
    var days: [DayElement] = []
        
        var currentDateFormatted: String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "EEEE, d MMMM"
            return formatter.string(from: Date())
        }
        
        init() {
            self.days = generateWeekDays()
        }
        
        func generateWeekDays(from startDate: Date = Date()) -> [DayElement] {
            let calendar = Calendar.current
            let letters = ["S", "M", "T", "W", "T", "F", "S"]
            
            var result: [DayElement] = []
            for offset in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: offset, to: startDate) {
                    let weekdayIndex = calendar.component(.weekday, from: date) - 1
                    let dayNumber = "\(calendar.component(.day, from: date))"
                    let state: DayState = (offset == 0) ? .current : .normal
                    result.append(DayElement(letter: letters[weekdayIndex], number: dayNumber, state: state))
                }
            }
            return result
        }

        // 2. عدادات البطاقات (النار والثلج)
        var learnedDaysCount: Int = 0
        var freezedDaysCount: Int = 0
    
    // 3. بيانات رصيد التجميد
    var usedFreezes: Int = 0
    var maxFreezes: Int = 2
    
    // 4. حالات الأزرار لليوم الحالي
    var isLoggedToday: Bool = false
    var isFreezedToday: Bool = false
    var isTodayCompleted: Bool {
            isLoggedToday || isFreezedToday
        }
        
        var isFreezeDisabled: Bool {
            isTodayCompleted || usedFreezes >= maxFreezes
        }
    // 7. بيانات الهدف وحالة الانتقال من شاشة البداية
        var learningTopic: String = "Swift"
        var selectedDuration: String = "Week"
        var hasStarted: Bool = false
    var goalStatus: GoalStatus = .active // هذا السطر اللي يمديني اجرب عليه الواجهات بتاسك ٣
        
    var learnedDates: Set<Date> = []
        var freezedDates: Set<Date> = []

        func calendarStatus(for date: Date) -> DayState {
            let normalized = Calendar.current.startOfDay(for: date)
            if learnedDates.contains(normalized) {
                return .loggedPast
            } else if freezedDates.contains(normalized) {
                return .freezed
            } else {
                return .normal
            }
        }
    
        private var targetDays: Int {
            switch selectedDuration {
            case "Week": return 7
            case "Month": return 30
            case "Year": return 365
            default: return 7
            }
        }
        
        func checkGoalCompletion() {
            let totalDays = learnedDaysCount + freezedDaysCount
            if totalDays >= targetDays {
                goalStatus = learnedDaysCount > 0 ? .completed : .notMet
            }
        }
        
        func startLearning(topic: String, duration: String) {
            let trimmed = topic.trimmingCharacters(in: .whitespaces)
            learningTopic = trimmed.isEmpty ? "Swift" : trimmed
            selectedDuration = duration
            
            // تحديد رصيد التجميد تلقائياً حسب المدة
            switch duration {
            case "Week": maxFreezes = 2
            case "Month": maxFreezes = 8
            case "Year": maxFreezes = 96
            default: maxFreezes = 2
            }
            goalStatus = .active
            hasStarted = true
        }
    func updateGoal(topic: String, duration: String) {
            let trimmed = topic.trimmingCharacters(in: .whitespaces)
            learningTopic = trimmed.isEmpty ? "Swift" : trimmed
            selectedDuration = duration
            
            switch duration {
            case "Week": maxFreezes = 2
            case "Month": maxFreezes = 8
            case "Year": maxFreezes = 96
            default: maxFreezes = 2
            }
            
            // تصفير العدادات والأيام السابقة لبدء السلسلة من جديد
            learnedDaysCount = 0
            freezedDaysCount = 0
            usedFreezes = 0
            isLoggedToday = false
            isFreezedToday = false
        learnedDates.removeAll()
                freezedDates.removeAll()
            goalStatus = .active
            
        days = generateWeekDays()
        }
    
    // 5. دالة تسجيل التعلم لليوم
        func logAsLearned() {
            guard !isTodayCompleted else { return }
            
            isLoggedToday = true
            learnedDates.insert(Calendar.current.startOfDay(for: Date()))
            learnedDaysCount += 1
            
            if let index = days.firstIndex(where: { $0.state == .current }) {
                days[index].state = .loggedPast
            }
            checkGoalCompletion()
        }
        
        // 6. دالة تجميد اليوم
        func freezeDay() {
            guard !isFreezeDisabled else { return }
            
            isFreezedToday = true
            freezedDates.insert(Calendar.current.startOfDay(for: Date()))
            usedFreezes += 1
            freezedDaysCount += 1
            
            if let index = days.firstIndex(where: { $0.state == .current }) {
                days[index].state = .freezed
            }
            checkGoalCompletion()
        }
}
