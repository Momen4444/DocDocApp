# Docdoc — Flutter login/onboarding UI

Covers the 4 screens from the Figma file: Splash → Onboarding → Sign In → Sign Up.

## What's real vs. placeholder

- **Layout, spacing, colors, buttons, fields, navigation** — fully built, matches the Figma structure.
- **Doctor photo on Onboarding** — placeholder icon. Export the real image from Figma
  (select the layer → right panel → Export → PNG, 2x or 3x) into `assets/images/`,
  then swap the `Container` placeholder in `onboarding_screen.dart` for
  `Image.asset('assets/images/onboarding_doctor.png', fit: BoxFit.cover)`, and
  uncomment the `assets:` section in `pubspec.yaml`.
- **Font** — set to `Inter` as a placeholder. Check Figma's Inspect panel for the
  real family, drop the `.ttf` files in `assets/fonts/`, and uncomment the `fonts:`
  section in `pubspec.yaml`. If you don't care about pixel-matching the font, just
  delete the `fontFamily: 'Inter'` line in `theme/app_theme.dart` to use the OS default.
- **Phone country-code picker on Sign Up** — hardcoded 🇬🇧 emoji + arrow, not a real
  picker. Swap in the `intl_phone_field` package for a working one.
- **Google/Facebook/Apple buttons** — wired to `onTap` callbacks that currently do
  nothing. Hook up `google_sign_in`, `flutter_facebook_auth`, `sign_in_with_apple`
  when you're ready to wire real auth.

## Two things worth checking in the Figma file itself

1. The colored circles with letters ("S", "A", "O") and small profile photos
   floating over the frames in the screenshot are Figma's own multiplayer
   cursors/collaborator avatars, not part of the app design — they aren't built
   here, and you shouldn't build them.
2. Both the Sign In and Sign Up screens say "Already have an account yet? Sign Up"
   in the screenshot, which only makes sense on one of them. This build uses
   "Don't have an account? Sign Up" on Sign In and "Already have an account? Sign In"
   on Sign Up — worth confirming against the actual intended copy.

## Setup

```bash
flutter create docdoc_app
```

Then copy this `lib/` folder and `pubspec.yaml` into the new project, replacing
the generated defaults. From the project root:

```bash
flutter pub get
flutter run
```
