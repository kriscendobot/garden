# PR #58 — shepherd: re-run the two macOS flakes to green (maintainer confirmed flakes)
Repo: endojs/endo-but-for-bots (bot). PR #58 — https://github.com/endojs/endo-but-for-bots/pull/58 —
MERGEABLE/UNSTABLE, head 34a632d37. Rebase already landed (`endojs-endo-but-for-bots-pr58-rebase` in tada).
kriskowal (2026-07-01T16:45Z, comment 4857868426): **"Please shepherd. These last two are certainly
flakes."** The 2 red checks are `test (22.x, macos-15)` and `test (24.x, macos-15)` (22 others green).
**Task:** shepherd — **re-run the two failing macOS-15 checks** (re-trigger the failed workflow jobs).
The maintainer has already diagnosed them as flakes, so do NOT over-investigate — re-run and confirm they
go green. Only if a check fails **again consistently** on re-run (i.e. not actually flaky) should you
investigate/escalate. Once green, post a brief **reply comment on #58** confirming CI is green (per the
acknowledged-comment→reply rule). Bot fork; no upstream contact.

---
claim:
  host: endolinbot2
  gardener: 51
  claimed_at: 2026-07-01T16:50:10Z
