---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-25T17:28:29Z
---
# sturdyref press tick (endo-sturdyref-press-20260725-170501): cascade moving but about to be falsely poisoned

Assessment of the SturdyRef stack (#737←#541←#698←#700←#701←#702←#703←#704, all DRAFT, base llm):

- Real movement since the last tick: the 2026-07-25 CI-green cascade (orch endo-sturdyref-ci-green-737-704-20260725, serial, on-child-failure: halt) completed its #737 child (24/24 checks SUCCESS; sturdyref suite 8 passed, OCapN sturdyref suite 7 passed, run 30143482892) and its #541 child (21/21 SUCCESS). Verified via gh pr view: #737 SUCCESS:24, #541 SUCCESS:21, #698 SUCCESS:24.
- #698 (bridge cut 1, bytes-preserving SturdyRef wire read) is ALREADY all-green (24/24), but its cascade child endojs-endo-but-for-bots-pr698-ci-green-cascade-20260725 is crash-looping: 5 claims died rc=1 in ~30s (latest 2026-07-25T14:13:44Z), reap marker at garden-reaped: 4 with a dead claim in doin — the NEXT reaper pass hits GARDEN_REAP_POISON_THRESHOLD=5 and poisons it, HALTING the serial cascade.
- Root cause (not a PR defect): hermit worker-kind claims dispatch to local Ollama model qwen3.6, and this host's Ollama has ZERO models installed (verified: curl 127.0.0.1:11434/api/tags → []; captured handler transcripts show turn.failed "404 model 'qwen3.6' not found" for pr719/finbot jobs; same signature on endolin-garden2 at 17:12Z). The fix is already on main2 — a6899eda05 "fix: preflight local model presence" (15:16Z today) — but the deployed root is at 18fe8d9da0 (2026-07-24), 9 commits behind; the deliberate deploy has not picked it up.
- #700–#704 remain red (8 FAILUREs each) awaiting their serial turn behind #698.
- Confinement: no behavior landed this tick, so no confinement surface changed; the load-bearing confinement suites last ran green in the #737 child (sturdyref 8 passed, OCapN sturdyref 7 passed — child tada report). Not re-executed this tick.

Surfaced to the maintainer via message-user (deploy needed + un-poison/promote the #698 child once workers can run it). No pushes to any stack branch this tick (cascade owns them).
