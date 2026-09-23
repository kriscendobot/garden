---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-11T22:10:21Z
---
# SturdyRef press tick (2026-07-11T22:05 dispatch, job endo-sturdyref-press-20260711-220507)

**Branch HEADs (verified via `gh api .../commits/<branch>`):**
`build/sturdyrefs-pass-style-ocapn` @ `d3c68897b9` (#521, DRAFT),
`build/sturdyrefs-endor-syscall-retention` @ `fab626e84a` (#541, DRAFT, CI green
as of the 21:05 tick; unchanged since),
`design/sturdy-refs-endor-syscall-followup` @ `22923949b2` (#539, DRAFT),
`design/sturdy-refs-agent-surface` @ `619493db4d` (#695, DRAFT). #510 MERGED.

**Maintainer gate status:** the 21:10 message asking for the #695 go/no-go on
cuts A–F and the formula-backed-token answer
(`inbox/maintainer/unread/20260711T211001Z-4a530e.md`) is still UNREAD — no
reply this tick. Not re-pinged (one standing question is enough; it stays in
the unread inbox).

**Pressed this tick:** posted the non-gated designer sub-job
`ebfb-design-sturdyref-wire-bridge` (identity
`endojs/endo-but-for-bots#539:wire-bridge-design`) for the bar-1 cross-peer
gap: wire codec both directions (Syrup + `ocapn://`, export/mint side),
foreign-locator internalization at the daemon facet boundary (the
`internalizeLocator` non-local path the enlivenment design leaves at one
sentence), three-party handoff, confinement binding, and a builder cut table.
Duplicate-checked first: no existing PR or design covers it (`gh pr list
--search "internalizeLocator" / "wire codec sturdyref"`); it has been carried
as follow-up debt in three consecutive reports.

**Next tick guidance:** (1) check for the maintainer's #695 reply — on GO, post
cuts A–F as parked children under one serial orchestration (A–B stacked on
`build/sturdyrefs-endor-syscall-retention`); (2) check whether
`ebfb-design-sturdyref-wire-bridge` was claimed / progressed — if its design PR
opens, review its cut table for the subsequent build sequencing; do NOT
double-post it (identity-deduped). Stack hygiene (#521→#541 weave onto live
`llm`, #539/#511 base refresh) stays deferred to landing time.

**Confinement statement:** nothing landed this tick (assessment + one job post
+ this entry), so no invariant widened. The posted design job binds all three
invariants (no-location, no-identification, opaque-and-unforgeable) as
acceptance criteria and requires per-cut confinement tests.
