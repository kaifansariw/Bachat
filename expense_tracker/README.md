# Ledger — a minimal expense tracker (Flutter)

A clean, distraction-free expense tracker. Three screens, one state
provider, no visual clutter.

## Design

- **Palette** — warm paper background (`#FAF9F6`), near-black ink text,
  and a single accent: muted forest green for income/primary actions,
  muted clay for expenses. Category colors are desaturated, never neon.
- **Type** — Sora for headings, Inter for body copy, and **JetBrains
  Mono** for every money figure, so amounts always line up like a real
  ledger — that's the app's one signature typographic move.
- **Signature element** — the *ledger ring* on the home screen: an
  analog-dial-style gauge (tick marks, not a generic percent ring) that
  shows how much of the monthly budget is left.

## Screens

- **Home** — total balance, this month's income/spend, the ledger ring,
  and a swipe-to-delete transaction list.
- **Add transaction** — expense/income toggle, amount, title, category
  picker, date, optional note.
- **Spending** — a bar chart of expenses by category plus a ranked
  breakdown with progress bars.

## Getting started

```bash
flutter pub get
flutter run
```

Requires an internet connection the first time you run the app so
`google_fonts` can fetch Sora, Inter, and JetBrains Mono. To ship fully
offline, bundle the fonts locally and switch the `google_fonts` calls in
`lib/theme/app_theme.dart` to a local `fontFamily` instead.

## Project structure

```
lib/
  main.dart                     # app entry, theme + provider wiring
  theme/app_theme.dart          # design tokens: colors, type, ThemeData
  models/
    category.dart               # category definitions (icon + color)
    transaction.dart            # MoneyTransaction model
  providers/expense_provider.dart # in-memory state + derived stats
  screens/
    main_shell.dart              # bottom nav + FAB shell
    home_screen.dart
    add_transaction_screen.dart
    stats_screen.dart
  widgets/
    ledger_ring.dart             # signature dial gauge (CustomPainter)
    transaction_tile.dart
    category_picker.dart
    section_header.dart
  utils/formatters.dart          # currency + date formatting
```

## Notes on state

All data is in-memory via a single `ExpenseProvider` (`ChangeNotifier`),
seeded with a few example transactions so the app looks alive on first
run. There's no persistence layer yet — swap in `sqflite`, `hive`, or a
backend of your choice by replacing the body of `ExpenseProvider`
without touching any screen.
