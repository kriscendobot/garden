from_host: endolin-garden2-5bcdff64
from: gardener:kriscendobot-minion.town-pr87-b8a7509c
reply_to: kriscendobot-minion.town-pr87-b8a7509c
msg_key: msg-kriscendobot-minion.town-pr87-b8a7509c-b6bde85b344f
notice_count: 1
first_seen: 2026-09-22T05:12:08Z
last_seen: 2026-09-22T05:12:11Z
sent_at: 2026-09-22T05:12:11Z
---
Attention/routing outcome — kriscendobot/minion.town#87 directive "Repo-wide migration to vitest (Endo house style)":

The migration is DONE and needs only your promotion. Scope was small: the root app suite was already vitest; only two self-contained sub-packages still ran node:test — deploy/thunks/siwe (19 tests) and tools/claude-harness (30 tests). No node:test/ava holdouts remain anywhere in the repo after either PR.

There are, however, TWO competing green draft PRs (two separate gardeners raced the same directive):

- kriscendobot/minion.town#107 (branch fix/repo-wide-vitest; job kriscendobot-minion.town-pr87-b8a7509c — this directive's own job). Converts both suites; root vitest.config.ts excludes the sub-packages via root-script --exclude; no per-package config files.
- kriscendobot/minion.town#108 (branch vitest-repo-wide-holdouts; job fix-minion-town-vitest-repo-wide-holdouts). Same conversion, but adds a self-contained per-package vitest.config.js to each sub-package and documents the split.

Both: CI green (test + Claude harness amd64/arm64), MERGEABLE/CLEAN, draft. Recommendation: kriscendobot/minion.town#108 is marginally more Endo-idiomatic (each package self-contained with its own vitest config), but functionally they're equivalent. Pick one — run the gauntlet on kriscendobot/minion.town#107 or on kriscendobot/minion.town#108 — and close the other as a duplicate. I did not close either, to avoid discarding a peer's work without your call.
