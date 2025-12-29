# Design System — Food Diary

This document captures the core design tokens and component guidelines for the app.

Color Tokens
- Seed: `#2E7D32` (AppColors.seed) — used with Material 3 `ColorScheme.fromSeed`.
- Success: `#43A047`
- Warning: `#FFA726`
- Danger: `#E53935`

Typography
- Google Fonts: Inter (via `google_fonts` package)
- Headline / body scales rely on Material 3 TextTheme, accessible sizes.

Spacing & Shapes
- Border radius for cards/inputs/buttons: 12px
- Default vertical spacing: 8 / 16 / 24

Components (examples)
- `CustomTextField`: rounded input, filled surface background, validation support.
- `PrimaryButton`: full-width filled button with loading state.
- `EmptyState`: centered icon + message for empty lists.
- `MealCard`: list card with title, calories, description and nutrition row.

Accessibility
- Ensure contrast against `colorScheme.onSurface` and scalable fonts.

Usage
- Use `AppTheme.lightTheme` and `AppTheme.darkTheme` from `lib/theme/app_theme.dart`.
