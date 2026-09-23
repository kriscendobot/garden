---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-25T23:42:48Z
---
# sturdyref press tick (endo-sturdyref-press-20260725-230503): #700 GREEN, #701 restacked + pushed

Assessment and action on the SturdyRef stack (#774←#737←#541←#698←#700←#701←#702←#703←#704, all DRAFT, base llm):

- The 17:28Z tick's blocker is CLEARED: local Ollama now has qwen3.6:latest (installed 17:35Z; curl 127.0.0.1:11434/api/tags shows it), so the hermit crash-loop cause is gone. Deployed root is still 18fe8d9da0 (pre "preflight local model presence" fix) — deploy still pending, but moot for this failure signature while the model is present.
- The halted cascade (endo-sturdyref-ci-green-737-704-20260725, halted at the poisoned pr698 child) is MOOT for #698: this job's earlier claim (reaped once; garden-reaped: 1) had already restacked #700 and pushed fixes at 23:09–23:15Z. #698 was already 24/24 green.
- **#700 (bridge cut 2) is now fully GREEN**: run 30179098189 conclusion SUCCESS, gh pr checks tally 24/24 pass (the previously-failing cover 22.x/24.x and test 22.x/24.x ubuntu+macos all pass). Verified via gh run view / gh pr checks.
- **#701 (bridge cut 3) restacked and pushed**: rebased its 4 own commits `--onto e0122dfd7 0a2d989961` (conflict-free) and pushed with --force-with-lease; head ff9f25c73 → a99012a62, sitting directly on #700's green head. CI running on the new head; evidence comment: https://github.com/endojs/endo-but-for-bots/pull/701#issuecomment-5081068741
- Local real-execution evidence on the pushed tree: ocapn ses-ava sturdyref.test.js + sturdyref-uri.test.js → 17 tests passed; daemon ava --serial sturdyref-store.test.js + sturdyref-resolution.test.js → 16 tests passed.
- **Confinement properties preserved** (tests observed passing): no-location (a token cannot reveal its shim locator or a swiss number), no-identification (resolution keyed on minted identity; distinct tokens for one id unlinkable), opaque-and-unforgeable (resolution binding unforgeable; off-band id binding not a readable property).

Next unblocked artifact for the following tick: once #701's CI on a99012a62 is green, restack #702 (`--onto <new-701-head> ff9f25c73a`), then #703, #704 in order. The poisoned pr698 cascade child in jobs/plan/ is moot (its mission — #698 rebased+green — is satisfied); the maintainer poison notice can be closed accordingly. #695 (agent provide/accept design) green and quiet — the "agents throughout" bar still waits on the bridge cuts.
