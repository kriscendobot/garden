## Completion report

**Dead-letter intent picked up.** The maintainer commented on kriscendobot/garden#58: *"Separate hints for the TCP host and port is an aberration. There should only be one hint per transport protocol."* The addressee (`issue-kriscendobot-garden-58`) had completed, so I folded the comment into the work and replied on the issue thread — without closing it.

**Root cause found.** The `@endo/ocapn-noise` TCP transport advertised two hints (`tcp:host` + `tcp:port`) while the WebSocket transport advertised a single `ws:url`, producing the mixed location `{ "tcp:host":"0.0.0.0", "tcp:port":"3469", "ws:url":"ws://127.0.0.1:8930" }` the maintainer saw.

**Fix implemented** (isolated worktree off `endojs/endo-but-for-bots` `llm`):
- `packages/ocapn-noise/src/transports/tcp.js` — `listen()` now returns one hint `{ url: "tcp://<host>:<port>" }`; `connect()` reads it. Mirrors the ws transport including wildcard-host substitution (`0.0.0.0`/`::` → `127.0.0.1`) and IPv6 bracketing so the URL round-trips through `new URL()`.
- `packages/daemon/src/networks/ocapn.js` — parses bound host/port back out of the single `tcp:url` hint when composing its advertised address.
- Updated the transport test, README, the network design doc, and added a changeset (`@endo/ocapn-noise` minor, `@endo/daemon` patch).

**Verification:** standalone round-trip against the real transport module (single `url` hint of the form `tcp://127.0.0.1:<port>`, byte dials through, all error paths fire) and clean `tsc` (lint:types) for both packages. Full ava suite could not run — the warm-cache node_modules lacks `ava`.

**Outputs:**
- PR opened (draft, job-marked): [endojs/endo-but-for-bots#1072](https://github.com/endojs/endo-but-for-bots/pull/1072).
- Issue reply: https://github.com/kriscendobot/garden/issues/58#issuecomment-5447894399

**Follow-ups (flagged in the issue reply, not silently dropped):**
1. PR #1072 is draft — needs the code panel / gauntlet before un-drafting (`run the gauntlet #1072`).
2. The live minion.town daemon advertises the single `tcp:url` only after a `@endo/ocapn-noise` package bump + redeploy (deferred to next daemon deploy).
3. The legacy `@endo/ocapn` `tcp-test-only` netlayer still emits split `host`/`port` hints, but it is testing-only on a different code path (change ripples into the syrup wire tests) — deferred, not folded into this PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5447781817.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (7091540 cached reads)
- Output: 43986 tokens
- Cost: $5.813389000000001
- Wall-clock: 685s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
