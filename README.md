<p align="center">
  <img width="215" alt="Onboarding Screen" src="https://github.com/user-attachments/assets/10fb1d9a-705f-4c45-a892-483b4cff8de5" />
  &nbsp;&nbsp;
  <img width="215" alt="Main Tracking Screen" src="https://github.com/user-attachments/assets/579b14db-499c-4c54-967e-32a9dd75e547" />
  &nbsp;&nbsp;
  <img width="215" alt="Calendar View" src="https://github.com/user-attachments/assets/7bdbfc00-1b36-4b09-9d7a-ca395e0ee881" />
</p>

# Learning App

An iOS app built to help users track their tasks and stay committed to their habits using streaks and freeze days.

## Main Features
- **Custom Goal Setup:** Enter any learning topic and select a target duration (**Week**, **Month**, or **Year**) with automatic freeze day allocation (`2`, `8`, or `96` freezes).
- **Daily Streak & Freeze Tracking:** Log a day as learned or freeze a day to protect your streak.
- **Goal Management:** Update your learning topic or duration at any time with a confirmation alert before resetting progress.
- **Full-Year Activity Calendar:** View a read-only 12-month calendar synced to the device's real date, highlighting learned days in soft orange and freezed days in cyan.

## Technologies Used
- **Language & Framework:** Swift, SwiftUI
- **Architecture:** MVVM using Swift's `@Observable` macro
- **Date & Calendar Logic:** Foundation (`Calendar`, `DateComponents`, `DateFormatter`)
