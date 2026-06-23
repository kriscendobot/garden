---
ts: 2026-06-23T01:01:17Z
kind: result
role: librarian
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Librarian cycle 452 complete. **100-CYCLE MILESTONE** — one hundredth conformant cycle since the cycle-353 pivot. Chat-lane after cycle 451 designs-lane ocapn-tcp-syrups-framing.md. Ingested `packages/whylip/src/hooks/useConversation.js` (444 lines, Kris Kowal + Dan Finlay + kumavis, commit `1f7015e3`).

**Files written:**

- `library/sections/endo-but-for-bots--packages-whylip-src-hooks-useConversation-js--three-tier-parse-cascade-with-format-retry-loop-and-mailbox-streaming-sync.md` (section body)
- `library/sources/endo-but-for-bots--packages-whylip-src-hooks-useConversation-js.md` (source index)
- `library/sections/README.md` (updated: section count 966 → 967; file count 5558 → 5559; 100-cycle milestone banner; cycle 452 entry added)
- `library/topics/chat-ui.md` (new section row added)
- `library/topics/captp.md` (new section row added)

**Single most structurally interesting move:** §the-named-format-retry-as-client-side-llm-correction-protocol as tier-3 meta-pattern. When `parseResponse` returns a `parseError` (the response looked like JSON but failed to parse) and `MAX_FORMAT_RETRIES` (= 1) is not exhausted, the hook sends the error back to Fae as an ordinary CapTP message: `FORMAT_ERROR: ${parsed.parseError}\n\nHere is your previous response...\n${text}`. Fae receives it as an ordinary user message and retries with a corrected format. No Fae-side awareness of the error protocol is required; the CapTP message channel doubles as the correction channel. §the-named-single-retry-cap-for-correction-loop: `MAX_FORMAT_RETRIES = 1` is the load-bearing correctness constraint — without it, a consistently-malformed LLM could loop the hook forever.

**Citation arc count delta:** 944 + 9 = **NINE-HUNDRED-AND-FIFTY-THREE** (nine arcs closed: cycle 451 adjacent forward + cycle 443 MAJOR CLOSURE (README dual-backend framing confirmed in source: MemoryBackend hard-coded, mailbox reconstruction deterministic, navigateTo pure local) + cycle 442 (SceneCanvas hook-as-scene-consumer arc) + cycle 444 (three-tier-parse-cascade meta-pattern confirmed independent instance) + cycle 413 (mailbox-as-message-passing-substrate confirmed in reconstruction) + cycle 429 (E(powers).send('fae', ...) three-empty-arrays confirmed) + cycle 326 (75) + cycle 322 (75) + cycle 364 (4)).

**State delta for cluster:** 142 consecutive non-garden sources (310-452); **100 conformant cycles** (post-cycle-353 pivot; milestone reached); sections 967 (966 + 1); file count 5,564 (5,563 + 1). Additional §the-named-* facts established: §the-named-memory-backend-hardcoded-not-configured, §the-named-three-tier-parse-cascade-for-llm-output, §the-named-lenient-unescape-for-llm-generated-json, §the-named-mailbox-ordering-as-tree-reconstruction-invariant, §the-named-two-phase-init-then-stream-with-deduplication, §the-named-optimistic-local-add-before-remote-send, §the-named-navigate-to-as-pure-local-state-switch.

Self-improvement: nothing this time.
