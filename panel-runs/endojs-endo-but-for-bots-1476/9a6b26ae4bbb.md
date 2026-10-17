---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1476
panel_kind: code
provider: anthropic
base_ref: 61cd656cb8d9c3c1c50334eb78bfa0dc8eb1657c
pr_body_hash: ae70a9224336e3818bf77f67270299e9ec30e845baf7219326b443c730fe497f
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 6ef59e4f32f97832caf12b95cf0e821ef391b0fb
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 9a6b26ae4bbb
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1476 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `6ef59e4f`

seat verdicts (34): archivist=must-fix assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=comment coverage-auditor=must-fix curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=comment orthographer=comment packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=must-fix
must-fix items (20):
- archivist: **comment-only:** `packages/ocapn-noise/src/network.js:187` says the default is "`HEARTBEAT_INTERVAL`, per designs/oc...
- archivist: **comment-only:** `packages/ocapn-noise/src/types.d.ts:196-200` now declares `handshakeTimeoutMs` and `maxInProgressP...
- archivist: **comment-only, unverified in full:** `packages/ocapn-noise/README.md:217-219` says "an older peer aborts the session...
- breaker: **should-fix: the heartbeat interval can outlive a failed transport.**
- breaker: **Invariant attacked:** the diff's own claim that "a close leaves neither a blocked consumer nor a running timer" (`n...
- breaker: **Attack:** `stopHeartbeat` runs only from `fireOnClose`. The `stream.reader.next()` inside `readPeerFrame` can rejec...
- breaker: That rejection propagates out of `reader.next` and never sets `closed`.
- breaker: The `setInterval` keeps firing `sendHeartbeat`. Every `stream.writer.next` rejection is swallowed by `.catch(() => {})`.
- breaker: The `active` entry is never forgotten, and the pings never stop.
- breaker: **Consequences:**
- breaker: The timer isn't `unref`'d, so a Node process can be held open by a dead session.
- breaker: The liveness timeout cannot catch this. It runs only while a read is pending, and the consumer has stopped reading af...
- breaker: **Proposed fix:**
- breaker: Treat a rejection from `stream.reader.next` as a session end: close, which also stops the timer.
- breaker: Close when a heartbeat's own `writer.next` rejects, not just when encoding or encryption throws in `tick`.
- breaker: [proposed-rule: a timer a session owns must be cleared on every terminal path, including transport rejection, not onl...
- breaker: **should-fix: the liveness timeout does not watch a consumer that stops reading.**
- breaker: **Invariant attacked:** "a peer that goes silent is detected as a lost session".
- breaker: **Attack:** the timer is armed only while a `reader.next()` is pending. A consumer that stops reading while the peer ...
- breaker: **Why it matters:** this is acknowledged by design, but item 1 means nothing else ends it. The README should state th...
