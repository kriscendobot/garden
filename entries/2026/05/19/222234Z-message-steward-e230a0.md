---
ts: 2026-05-19T22:22:34Z
kind: message
role: steward
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/19/220153Z-dispatch-steward-dc9c4d.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 231
    role: source
---

# 12 follow-up dispatches needed from #231 review (8 builder + 1 gardener + 1 designer + 2 issue-file)

kriskowal's #231 CHANGES_REQUESTED carried 20 inline comments; the
fixer (`ca1c56`) addressed all in-scope doc edits in 3 topical
commits (`c9c648c`/`ed838bc`/`3aba6ab`). The Axis-2 follow-ups
are out-of-scope for the fixer and need separate dispatches.

## Builder dispatches (8)

1. **L153** (G1: CI build pipeline) — "Please dispatch a builder."
   Wire build pipeline into CI workflow emitting per-platform
   artifacts.
2. **L205** (G4: Flatpak pipeline) — "Please dispatch a builder to
   propose a pipeline for Flatpack. We can defer the other packaging
   systems."
3. **L227** (G5: Node LTS pin) — "Please dispatch a builder to move
   this to a working LTS release. I believe that's currently 22 or
   24."
4. **L257** (G7: icon automation) — "Please dispatch a builder to
   improve the automation for projecting out these file formats from
   the source icon. If platform-specific, let's consider checking
   in the built artifact and creating automation that can be run in
   a CI environment."
5. **L275** (G8: consolidated stop/purge via CapTP, deferred but
   wanted reviewable) — "This can be deferred, but please dispatch a
   builder to implement the consolidated solution so we have
   reviewable material."
6. **L375** (G14: third-party LICENSE aggregation in
   `make-distributables.mjs`) — "Please dispatch a builder."
7. **L387** (G15: macOS arm64+x64 matrix or universal binary) —
   "Please dispatch a builder."
8. **L405** (G16: Primer-into-CAS packaged-build smoke test) —
   "Dispatch a builder to add tests for this flow."

## Gardener dispatch (1)

9. **L227** (LTS-motion sensing) — "Please dispatch a gardener to
   propose a mechanism for sensing motion on the Node.js LTS
   supported versions window and automatically updating this
   version as well as the CI versions, maintaining an upgrade PR
   as that window shifts and shepherding it through CI or
   discovering compatibility impasses early."

## Designer dispatch (1)

10. **L359** (G13: telemetry/crash-reporting shape) — "Please
    dispatch a designer to flesh this out."

## Issue-file asks (2)

11. **L191** (Windows certificate-acquisition process) — "Please
    file an issue with instructions for beginning the process of
    obtaining a certificate. This is otherwise out of scope for MVR,
    wherein it is sufficient to target MacOS."
12. **L539** (signing-identity setup, standalone of G2 deferral) —
    "Please file an issue with instructions to set this up."

The liaison may want to bundle adjacent items (the G5+LTS-motion
pair; the G14+G15 LICENSE-and-arch grouping; etc.) for shared
dispatch context — your call.

Self-improvement: nothing new this turn.
