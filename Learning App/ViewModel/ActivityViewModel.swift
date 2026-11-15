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
    var days: [DayElement] = [
        DayElement(letter: "S", number: "20", state: .loggedPast),
        DayElement(letter: "M", number: "21", state: .loggedPast),
        DayElement(letter: "T", number: "22", state: .loggedPast),
        DayElement(letter: "W", number: "23", state: .loggedPast),
        DayElement(letter: "T", number: "24", state: .current),
        DayElement(letter: "F", number: "25", state: .normal),
        DayElement(letter: "S", number: "26", state: .normal)
    ]
    
    // 2. عدادات البطاقات (النار والثلج)
    var learnedDaysCount: Int = 4
    var freezedDaysCount: Int = 0
    
    // 3. بيانات رصيد التجميد
    var usedFreezes: Int = 0
    var maxFreezes: Int = 2
    
    // 4. حالات الأزرار لليوم الحالي
    var isLoggedToday: Bool = false
    var isFreezedToday: Bool = false
    // 7. بيانات الهدف وحالة الانتقال من شاشة البداية
        var learningTopic: String = "Swift"
        var selectedDuration: String = "Week"
        var hasStarted: Bool = false
    var goalStatus: GoalStatus = .active // هذا السطر اللي يمديني اجرب عليه الواجهات بتاسك ٣
        
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
            goalStatus = .active
            
            days = [
                DayElement(letter: "S", number: "20", state: .normal),
                DayElement(letter: "M", number: "21", state: .normal),
                DayElement(letter: "T", number: "22", state: .normal),
                DayElement(letter: "W", number: "23", state: .normal),
                DayElement(letter: "T", number: "24", state: .current),
                DayElement(letter: "F", number: "25", state: .normal),
                DayElement(letter: "S", number: "26", state: .normal)
            ]
        }
    
    // 5. دالة تسجيل التعلم لليوم
        func logAsLearned() {
            guard !isLoggedToday else { return }
            
            isLoggedToday = true
            learnedDaysCount += 1
            
            if let index = days.firstIndex(where: { $0.state == .current || $0.state == .freezed }) {
                days[index].state = .loggedPast
            }
            checkGoalCompletion()
        }
        
        // 6. دالة تجميد اليوم
        func freezeDay() {
            guard !isFreezedToday && usedFreezes < maxFreezes else { return }
            
            isFreezedToday = true
            usedFreezes += 1
            freezedDaysCount += 1
            
            if let index = days.firstIndex(where: { $0.state == .current }) {
                days[index].state = .freezed
            }
            checkGoalCompletion()
        }
}
