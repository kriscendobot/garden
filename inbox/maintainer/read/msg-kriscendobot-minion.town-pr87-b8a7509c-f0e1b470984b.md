from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr87-b8a7509c
reply_to: kriscendobot-minion.town-pr87-b8a7509c
msg_key: msg-kriscendobot-minion.town-pr87-b8a7509c-f0e1b470984b
notice_count: 1
first_seen: 2026-09-22T06:36:05Z
last_seen: 2026-09-22T06:36:43Z
sent_at: 2026-09-22T06:36:43Z
---
attention directive "repo-wide migration to vitest" (minion.town PR kriscendobot/minion.town#87 comment 5770443815) — ALREADY DONE, and fanned out into THREE competing green draft PRs. Routing/triage only, no fourth PR posted.

Reality check: minion.town's root suite was already on vitest; the only holdouts were two self-contained sub-packages still on `node --test` — `tools/claude-harness` (.test.mjs) and `deploy/thunks/siwe` (test/*.test.js). Three separate job bases each built that same conversion:

  kriscendobot/minion.town#107  fix/repo-wide-vitest    base kriscendobot-minion.town-pr87-b8a7509c (THIS job's own base)  +2884/-18 (11 files)
  kriscendobot/minion.town#108  vitest-repo-wide-holdouts    base fix-minion-town-vitest-repo-wide-holdouts  +3052/-161 (14 files)
  kriscendobot/minion.town#109  garden/build-minion-town-vitest-migration    base build-minion-town-vitest-migration  +565/-555 (8 files)

All three: DRAFT, CI fully green (test + claude-harness amd64/arm64), zero reviews, none gauntleted.

Recommendation: keep ONE, close the other two, then run the gauntlet on the keeper.

My pick: kriscendobot/minion.town#109. Far cleanest (+565/-555 vs ~+3000 — the others carry big regenerated lockfile diffs), folds claude-harness into the ROOT vitest gate (drops both root --exclude flags; one gate, not a bolted-on per-package CI step), and is the only one that squarely addresses the directive's ambiguity: Endo (@llm) runs AVA, not vitest, so "Endo dictates house style" can't mean "copy Endo's runner" — it reads it as vitest (the explicit target) + Endo's runner-agnostic conventions (spec-spelling titles, one-behaviour-per-assertion, expect(...).toThrow), matched to minion.town's own existing vitest specs.

One tradeoff to decide: kriscendobot/minion.town#109 deliberately leaves the SIWE thunk OUT of the root/CI gate (it has its own dep `viem` the root install lacks; it still runs on vitest via its own `npm --prefix` run). kriscendobot/minion.town#108 instead ADDS a dedicated `Test SIWE OIDC thunk` CI step so SIWE gets first-ever CI coverage under vitest. If you want SIWE gated in CI, promote kriscendobot/minion.town#108, or ask for kriscendobot/minion.town#109 plus that one CI step. Otherwise take the kriscendobot/minion.town#109 default as-is.

Say the word and I'll close the two losers; I did not close anything unilaterally since picking among three green impls is your taste call.
