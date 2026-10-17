---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1476
panel_kind: code
provider: anthropic
base_ref: origin/llm-61cd656
pr_body_hash: ea243f5bba6247af773d651476fe080b45215dce2f0061bff5fe4008b163887b
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 88b95820a7efb75d3c020f0b401598ca1a3e0433
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: eb8110ba4ebc
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1476 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `88b95820`

seat verdicts (34): archivist=must-fix assessor=comment benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=comment migrator=pass orthographer=comment packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=must-fix
must-fix items (20):
- archivist: **must-fix**: `packages/ocapn/src/client/ocapn.js:1073-1074` says "Liveness belongs to the network, which absorbs hea...
- archivist: **should-fix**: `packages/ocapn-noise/README.md` (Session heartbeats section) says "The session reader skips heartbea...
- archivist: **comment-only**: `packages/ocapn-noise/src/types.d.ts`: the new `getLiveness()` on `OcapnNoiseSession` has no JSDoc,...
- archivist: The README's default and bound claims (six intervals, at least three, 5 s default interval) match `normalizeHeartbeat...
- archivist: The `getLiveness` fields match `SessionLiveness` in `types.d.ts`.
- archivist: The older-peer abort claim is consistent with the unknown-type throw at `ocapn.js:1085`.
- archivist: `designs/ocapn-noise-session-reconnect.md` § 5 exists and gives 5 s / 30 s. Its T1 open question still covers those ...
- archivist: The `peekTypeHint`, `enterRecord`, and `readRecordLabel` calls in `isHeartbeatFrame` exist in both the CBOR and Syrup...
- decomplector: **Should-fix: `readPeerFrame` braids the liveness timer, close, failure delivery and abandon.** [proposed-rule: one m...
- decomplector: `readPeerFrame` (`network.js`) per read creates a Promise, a timer and an `abandon` closure, and puts the closure in ...
- decomplector: The timer's only action is to set the shared `heartbeatFailure` variable and call `close()`.
- decomplector: `close()` calls `fireOnClose`, then `stopHeartbeat`, then every `abandon`, then `endOfReads()`, which finally reads a...
- decomplector: So one failure travels through four places: a mutable place, a Set of closures, `closed`, and `endOfReads`.
- decomplector: Failure is also delivered as a one-shot rejection that is consumed on first read. Later reads see a plain `done`, so ...
- decomplector: A smaller shape would be a single `lastFrameAt` stamp that the interval tick compares with `sessionTimeoutMs`. Expiry...
- decomplector: The trade-off is that the timeout then runs even when the consumer is not reading. The code comment says it must not,...
- decomplector: **Should-fix: the mechanism has now drawn must-fix findings in three rounds, and the PR does not say why it is needed.**
- decomplector: Existing path: the transport's own end or error already reaches `stream.reader.next`, so the new code adds nothing fo...
- decomplector: The new mechanism is only needed to detect a silently dead peer. The PR should say that explicitly.
- decomplector: Without the justification, further hardening of `absorbHeartbeat`, `isHeartbeatFrame` and the nonce counters is churn.
