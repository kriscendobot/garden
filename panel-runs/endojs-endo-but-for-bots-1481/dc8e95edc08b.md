---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1481
panel_kind: code
provider: anthropic
base_ref: 2a16357eaacc75d44ffac6c66307d7b8837de399
pr_body_hash: d287324777fe6f5a87acaede5967fe25f95f65698010a4a08dee2fed952b0e08
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 413c992de9fe7b2e58d279c498ae627d96b99598
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: dc8e95edc08b
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1481 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `413c992d`

seat verdicts (34): archivist=must-fix assessor=comment benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=pass wire-watcher=comment
must-fix items (20):
- archivist: **must-fix**: `designs/ocapn-noise-session-reconnect.md:414`, the `SESSION_HARD_TIMEOUT` row gives its range as "up t...
- archivist: **should-fix**: `packages/ocapn-noise/README.md` says nothing about the new `reconnect` option, the `reconnecting`/`u...
- archivist: **comment-only**: `packages/ocapn-noise/src/types.d.ts:157` says `lastAckedRecvNonce` is `undefined` "while reconnect...
- archivist: **comment-only**: `packages/ocapn-noise/src/types.d.ts:139` says the default `backoffMaxMs` is "capped by `hardTimeou...
- archivist: **comment-only**: Design `Dependencies` row (`designs/ocapn-noise-session-reconnect.md:644`) lists the cryptographic ...
- breaker: **should-fix: the pre-abort queue has no size bound.**
- breaker: Invariant: the design says a frame is either accepted into the session or rejected with it, and the fail-fast comment...
- breaker: Attack: during a partition, `writer.next` (around line 1690) only throws in the last `backoffMaxMs` of the 10-minute ...
- breaker: Suggested fix: add a byte or frame cap on `outbound` plus `unacked` that fails fast like the hard-timeout path does.
- breaker: [proposed-rule: a replay queue that survives a transport loss needs an explicit size cap, not only a time cap]
- breaker: **should-fix: application frames that parse as control records break the frame count.**
- breaker: Invariant: the replay position is the count of session frames. `receivedFrames` is incremented only for frames `absor...
- breaker: Attack: if the session layer above ever writes a frame whose first record label is `op:ping`, `op:pong`, `op:session-...
- breaker: Result: after the next reconnect, `peerHello.received` is lower than the sender's true delivered count. `attach` then...
- breaker: Today OCapN ops do not use those labels, so I rate this should-fix rather than must-fix.
- breaker: Suggested fix: reserve those labels in the codec, or reject such outbound frames in `writer.next`.
- breaker: **comment-only: a peer can claim a lower `received` count on a later reconnect.**
- breaker: `attach` (line 1368) checks only `peerReceived > nextFrameIndex`. It never checks that the claim is not below one alr...
- breaker: Attack: after `outbound.filter(index >= peerReceived)` has dropped frames, a lower claim on the next resume replays f...
- breaker: Only an authenticated peer can do this, and it can already drop its own inbound frames.
