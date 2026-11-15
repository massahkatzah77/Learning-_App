//
//  DayElement.swift
//  Learning App
//
//  Created by Massah Abdulaziz Katzah on 02/06/1448 AH.
//

import Foundation
// نحدد الحالات الممكنة لليوم بناءً على الصور التي أرسلتيها
enum DayState {
    case loggedPast   // أنجز في الماضي (خلفية برتقالية باهتة، نص برتقالي)
    case current      // اليوم الحالي (دائرة برتقالية، نص أسود)
    case freezed      // مجمد (دائرة زرقاء سماوية، نص أسود)
    case normal       // يوم عادي/قادم (بدون خلفية، نص أبيض)
}

struct DayElement: Identifiable {
    let id = UUID()
    let letter: String // الحرف مثل S, M, T
    let number: String // التاريخ مثل 20, 21
    var state: DayState
}
