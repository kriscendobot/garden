---
role: weaver
---

Weave endojs/endo-but-for-bots PRs #617 (endoclaw-timer Phase 2, tick delivery as mail + `TickResponse` exo) and #619 (Phase 3, startup recovery / coalesced catch-up tick) — the stacked scheduled-execution PRs — restacking each onto the now-grown head of PR #609 (`build/endoclaw-timer-daemon-formula-integration`, which absorbed Phase 4 host-integration commit `c84fb80ed` today). #619 is currently CONFLICTING and #617 mergeable-UNKNOWN because both were last rebased 2026-07-08 before #609 moved; rebase #617 onto #609's head then #619 onto #617's head, reconcile the facet-pair split, and restore each to MERGEABLE so the endoclaw-timer stack lands M3's scheduled-execution pillar. Base per stack, bot identity.
