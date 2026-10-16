---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1481
panel_kind: code
provider: anthropic
base_ref: origin/build/ocapn-noise-session-queue-2a16357
pr_body_hash: 80d0a0ccb8ce520ca2a1118319a02d3594013eb051b25a5f6efef5d064d5a8c3
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: da167ac385f59e48ffe64747aab02898d7a3e2c3
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 4fe3dfdbf4d1
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — endojs/endo-but-for-bots #1481 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `da167ac3`

seat verdicts (33): archivist=must-fix assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=must-fix coverage-auditor=comment curator=must-fix duality-auditor=pass engine-realist=must-fix fast-checker=comment gateway=pass integrator=comment locksmith=comment migrator=comment orthographer=pass packager=must-fix procurer=pass prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=comment saboteur=must-fix scribe=pass spec-keeper=must-fix stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=must-fix
must-fix items (20):
- archivist: **should-fix**: `packages/ocapn-noise/README.md:179` (the `provideSession` usage section). The new public `reconnect`...
- archivist: **comment-only**: `packages/ocapn-noise/src/types.d.ts`, `SessionLiveness.lastAckedRecvNonce` doc says "the highest N...
- archivist: **comment-only**: `designs/ocapn-noise-session-reconnect.md:8` still reads `Status | Proposed`, and the phased-implem...
- archivist: Default constants match design § 5: heartbeat 5 s, backoff 250 ms / 30 s, hard timeout 10 min (`network.js:186-237`,...
- archivist: Design § 3 and § 5 references in `network.js` resolve to real sections.
- archivist: `unackedFrames` "Always 0 without reconnect" matches `network.js:1422`, which pushes only when `reconnectSettings` is...
- archivist: The changeset's export names (`readOcapnSessionControlMessage`, `writeOcapnSessionControlMessage`) match `packages/oc...
- archivist: The diff adds no banner-style comments.
- assessor: **must-fix: duplicate delivery when the responder resumes while its old instance is still attached.**
- assessor: `packages/ocapn-noise/src/network.js`, responder `resumable` branch (diff around lines 1347–1352).
- assessor: The `received: resumable.getReceivedFrames()` argument is evaluated before `await writeSessionHello(...)`. `resumable...
- assessor: While the hello write is pending, the old instance is still `current`. Its `pump` keeps accepting frames and incremen...
- assessor: The dialer replays every frame from the stale `received` value onward, so those frames arrive twice. This breaks the ...
- assessor: It is realistic: the dialer notices loss first (a write stall) while the old socket still half-works.
- assessor: Fix: detach `current` before computing and sending the hello (or freeze `receivedFrames` first). Add a test that inte...
- assessor: [rule: roles/jurors/assessor/AGENT.md § Primary surface]
- assessor: **should-fix: a lost resume reply makes the dialer abort a session the responder still holds.**
- assessor: Same branch, `peerHello.epoch === resumable.getEpoch() + 1n`.
- assessor: If the responder attaches at epoch N+1 but the hello reply never reaches the dialer (handshake timeout or a drop), th...
- assessor: The responder now expects N+2, so it answers with the epoch-0 refusal. The dialer's `redial` then calls `fail` ("peer...
