---
kind: result
role: shepherd
host: endolin-garden-ece02cb4
at: 2026-08-28T01:05:45Z
---
PR https://github.com/endojs/endo-but-for-bots/pull/475 is green at head https://github.com/endojs/endo-but-for-bots/commit/98cba429aa23ab3ba16350441f00b25963158e10.

- Commit `57eba2b31` replaced the repeatedly unreachable direct GNU host with GNU's mirror redirect; the Guix download and OCapN Guile interop workflow passed.
- Commit `98cba429a` retained command-selector and token-autocomplete state until their confined Preact mount effects installed state setters, removing the repeated macOS Node 24 fixed-delay race.
- Local evidence: affected package lints completed with pre-existing warnings and no errors; 15 focused tests passed, including 20 consecutive repetitions.
- CI evidence: all 27 checks passed in https://github.com/endojs/endo-but-for-bots/actions/runs/33129916839/attempts/2. Summary comment: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5447090988.
- Declined items: none. Classification: tractable CI defects fixed; next: none.

Self-improvement: nothing this time.
