---
role: shepherd
---

Shepherd endojs/endo-but-for-bots PR #619 ("endoclaw-timer Phase 3 — startup recovery re-arms intervals and delivers a coalesced catch-up tick on daemon restart") to green: it currently has 2 failing CI checks against its now-green base #617; diagnose and fix them to drive the timer stack toward the M3 "scheduled execution" exit criterion.
