Everything is confirmed. My panel must-fix changes are all present in the final branch head (14 marker matches), preserved through a rebase onto the newer `llm` base as commit `3fb6ef48c`. A peer instance (Kriscendo Bot) added a compatible follow-up (`733f3f5ab`) refining my `/ocapn-cbor-np` example to the actually-deployed `/.well-known/ocapn-cbor-np` path from minion.town's Caddy route — deepening the same maintainer-directed alignment. CI is terminal GREEN (all 5 checks SUCCESS, rc 0) on the current head.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1071 gauntlet FIX round 1 — design doc `designs/ocapn-network-transport-separation.md` ("one hint per transport protocol").

**What I did:** Read the panel-1 verdict (7-seat request-changes) plus the maintainer's fresh inline review comment, then applied the aggregated must-fix items in one commit:

- **WebSocket path restored (maintainer comment 3 + skeptic/decomplector/ergonomist/novice):** WS/WSS hint value changed from bare authority to a required `host:port/path`, with a worked `/ocapn-cbor-np` example aligned to minion.town.
- **Encoding/parse rule stated:** on-wire `encodeURIComponent` per daemon-locator-reference, decode-then-split parsing, `@`-in-path escaped as `%40`.
- **Codec axis fixed (critic/skeptic/decomplector/ergonomist):** wire-codec name now carried on the transport (derived from its codec) instead of a parallel free-form `codecName`, so `tcp+cbor` and `tcp+syrup` can coexist and the multi-codec claim matches the API.
- **Terminology reconciled (copyeditor):** one word per axis; dropped the duplicate "Carrier" column; reconciled the "transport protocol" directive quote; renamed `advertisedHost`→`advertisedAuthority`, dual-sense "authority"→"listener handle".
- **Figure + Test Plan:** added `wss+cbor` to the mermaid; fixed stale "duplicate-scheme"→"duplicate-transport-and-codec"; added hint round-trip/IPv6/`@`-in-path/non-interchangeability cases.
- **Style (pedant/copyeditor):** removed the introduced em-dashes and `e.g.`; prettier passes.

**What changed:** committed `dd9f872d0` and pushed to the PR head. The branch was subsequently rebased onto the latest `llm` (my commit → `3fb6ef48c`) and a peer added `733f3f5ab` refining the example path to the deployed `/.well-known/ocapn-cbor-np`. Current head `733f3f5ab` contains my fix; CI is GREEN (build, lint, zizmor, test, browser-tests all SUCCESS).

**Follow-ups:** none for this stage. The gauntlet driver re-posts panel-2 next. I did not re-push after the peer's alignment commit, since my work is already incorporated and CI is green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1071-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 90 tokens (3782754 cached reads)
- Output: 34866 tokens
- Cost: $4.82855
- Wall-clock: 673s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
