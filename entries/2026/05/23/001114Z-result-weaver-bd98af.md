---
ts: 2026-05-23T00:11:14Z
kind: result
role: weaver
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/23/000900Z-dispatch-general-contractor-beefe7.md
---

PR #360 rebased onto the new frozen base `llm-b1c3f4d` (snapshot of
`origin/llm` at `b1c3f4dca97666b5dd975cc8640fe858a02be3a9`, which is also
the current upstream tip).
PR base moved from `llm` (raw) to `llm-b1c3f4d` (frozen-base convention,
per `skills/frozen-base-branch/SKILL.md`).
Force-push-with-lease succeeded: `070438cb8 → da5fc6606` on
`design/familiar-multi-platform-pre-release`.
Post-rebase state: `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`,
still draft.

Conflicts resolved in `designs/README.md` (three regions):

1. Top header / "Recently added or revised" prose.
   Base had the 2026-05-20 "daemon mount and git capability plans added"
   header and a structured list with daemon-mount-capabilities,
   daemon-git-capability, daemon-git-remotes, patterns-diagnostic-feedback,
   endopi, hardened-text-codecs-shim, hardened-url-shim.
   Our PR had a flat "See also" with the two new familiar-* designs.
   Resolution: kept base's full structured list (preserves all the recent
   design context); updated the header date to 2026-05-22 with a note
   on the per-platform packaging + pre-release CI lanes; prepended the
   two new familiar-* designs as the most-recent entries in the
   "Recently added or revised" list.
2. Totals line.
   Base: 125 designs (39 Complete, 18 In Progress, 36 Not Started,
   20 Proposed, 2 Active, 7 Reference, 2 Deprecated, 1 Superseded).
   Our PR: stale 106-design totals.
   Resolution: kept base's prose (refreshed-2026-05-19 sweep
   explanation and 16-designs-added breakdown) and bumped to 127
   designs / 22 Proposed (+2 each for the two new Proposed familiar
   designs); appended the two new designs to the "Totals reflect the
   16 design files added on `llm`" breakdown so the running count
   ties out.
3. Milestone-1 detail table.
   Base had the recent struck-through rows reflecting completed work
   (`~~ci-no-npm-lifecycle~~`, `~~base64-native-fallthrough~~`,
   `~~hex-package~~`, `~~unhandled-rejection-display~~`) in
   milestone `½`/`—`; our PR had the older non-struck versions in
   milestone `1` PLUS the two new familiar rows.
   Resolution: kept base's rows (they reflect reality on `llm`); kept
   the `~~unhandled-rejection-display~~` row at the table tail
   (milestone `—`); inserted the two new familiar-* rows (M1, M / M-L
   sized) immediately before the unhandled-rejection-display row, in
   line with the surrounding milestone-1 ordering.

The summary table (lines 178-179), the Mermaid dependency graph
(lines 272-288), and the milestone-detail familiar rows landed already
during the auto-merge prior to the three conflict regions; the
resolution above only addresses the three explicit `<<<<<<<` regions.

Tests: not run.
The change touches only `designs/README.md` and the two new design
documents; no source code, no package tests in scope.
Per the weaver role's *Operating norms*, runtime tests are only
required for source-touching rebases.

Branch state for follow-up: PR #360 is on `llm-b1c3f4d`,
head `design/familiar-multi-platform-pre-release` at `da5fc6606`,
draft.
The next stage owed is whatever the PR-creation-flow chain prescribes
for a design-only DRAFT post-rebase; the general-contractor that
dispatched this weaver is the immediate consumer.

Self-improvement: nothing this time.
The frozen-base convention worked exactly as documented; the three
conflicts were all of the "stale snapshot vs. updated state +
new additions" shape and were honest weaves of both intentions.
