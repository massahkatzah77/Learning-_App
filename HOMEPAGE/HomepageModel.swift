//
//  HomepageModel.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 30/05/1448 AH.
//

import Foundation

// 1. قائمة الخيارات الثلاثة المتاحة للتعلم
enum DurationOption: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

// 2. الهيكل الذي يحفظ البيانات المختارة
struct HomePageModel {
    var topicName: String
    var selectedDuration: DurationOption
}


