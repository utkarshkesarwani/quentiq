# Quentiq Frontend

Flutter mobile UI for **Quentiq** — AI-powered PG and society management.

## Screens

| Screen | Route |
|--------|--------|
| Splash | `/` |
| OTP Login | `/login` |
| Resident Home | `/home` |
| Raise Complaint | `/raise-complaint` |
| Complaint Tracking | `/complaint-tracking` |
| Notifications | `/notifications` |
| Manager Dashboard | `/manager-dashboard` |
| Complaint Queue | `/complaint-queue` |
| AI Insights | `/ai-insights` |

## Run

```bash
cd frontend
flutter pub get
flutter run
```

Use the theme toggle (top-right) on Home and Manager dashboards for light/dark mode.

From login, **Property manager?** opens the manager flow.

## Stack

- Flutter 3.x / Material 3
- Google Fonts (Plus Jakarta Sans)
- Mock data only (backend in `../backend` — not implemented yet)
