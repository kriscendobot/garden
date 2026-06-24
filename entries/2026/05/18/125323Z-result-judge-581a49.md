---
ts: 2026-05-18T12:53:23Z
kind: result
role: judge
host: endolinbot
posture: liaison
short_id: 581a49
dispatch_root: dispatches/judge--581a49
repo: endojs/endo-but-for-bots
branch: feat/daemon-message-streaming-phase-1
base: llm
pr_number: 287
project: endo-but-for-bots
refs:
  - entries/2026/05/18/124045Z-dispatch-judge-581a49.md
  - entries/2026/05/18/115753Z-dispatch-cleaner-b026a1.md
  - entries/2026/05/18/115403Z-result-builder-060dd6.md
---

# Judge result: PR #287 daemon-message-streaming Phase 1 (un-drafted, 0 must-fix)

## Panel kind and execution
- Panel kind: code-panel (PR's file list spans `packages/daemon/src/`, `packages/daemon/test/`, `designs/`, and `.changeset/`; not design-only).
- Panel execution: in-band-fallback (no `Agent`/`Task` tool surfaced in this judge dispatch; `ToolSearch select:Agent` returned no match).
- All sixteen seats authored as separate per-seat blocks against the per-seat role files, one at a time, before aggregation.

## Round 1 (only round)
- Seats dispatched: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist (16 of 16).
- `@copilot` added as additional reviewer via `gh pr edit 287 --add-reviewer @copilot`.
- Verdict counts:
  - request-changes: 0
  - comment-only: 16 (every seat returned no must-fix; two seats raised should-fix items independently)
  - approve: 0 (no seat returned a clean approve; the dispatch brief asked the panel to particularly scrutinise stream lifecycle, least-authority completeness, persistence semantics, and Phase 2+ deferrals, so every seat returned a block with at least an out-of-scope note)
- Must-fix: 0.
- Should-fix (raised by 2+ seats):
  1. `StreamWriter` (and `StreamFinalization`) constructed with `Far(...)` rather than `makeExo(..., M.interface(...), ...)`. Project `CLAUDE.md` prefers `makeExo` for runtime input validation and `__getMethodNames__()`; existing mail-surface exos all follow that idiom. Raised by **purist** and **curator**.
  2. The four new optional `Package` fields (`stream`, `phase`, `aborted`, `abortReason`) implicitly model two shapes (streaming-in-flight vs finalised-aborted) without a discriminator. A union or a comment naming the valid combinations would help. Raised by **typist** and **purist**.
- Out-of-scope items recorded for follow-up:
  - Rename `finalised` parameter in `mail.js` `receive()` streaming branch (it shadows `StreamFinalization` vocabulary). (stylist)
  - Tighten `mail-stream.js` line 21 prose to surface late-subscriber replay. (archivist)
  - Integration test asserting persisted recipient inbox carries `aborted: true` and `abortReason` after `writer.abort()`. (breaker)
  - Cross-peer streams (Phase 2+): patch `stream` / `streamFinalization` Far refs in `receive()`'s remote-sender branch; consider trust model for replayed events. (wire-watcher)
  - Back-pressure (Phase 2+): unbounded in-memory buffer needs a high-watermark / drain-promise shape. (engine-realist)

## Particular-attention items from the dispatch brief
- **Stream lifecycle correctness**: confirmed. Late-subscriber replay pinned by `late subscribers replay buffered events`; writer.append-after-end no-op pinned by `append/setPhase reject after end()`; idempotent end pinned by `end() after end() is a no-op`; idempotent abort path pinned by `abort() after end() is a no-op` and cleaner's `end() after abort() is a no-op (abort wins)`.
- **`least-authority` stub completeness**: audited. Three call sites of `makeExo('EndoGuest'|'EndoHost', GuestInterface|HostInterface, ...)` exist (daemon.js:2959 least-authority, guest.js:368, host.js:1437). Only the daemon.js least-authority site required the `streamReply: disallowedFn` addition; the host/guest exos forward the real `streamReply` from `makeMailbox`. Builder's fix is correct; cleaner's audit is correct.
- **Persistence semantics**: confirmed match to design. `buildFinalisedEnvelope` writes `strings: [final.text]`, drops `stream` / `streamFinalization`, sets `phase` when defined, and on `aborted` adds `aborted: true` + `abortReason`. `attachStreamPersistOnSenderSide` and the inline dispatch in `receive` both call `transient.persist(finalEnvelope)` on the resolved finalisation regardless of status. The cleaner-brief vs design discrepancy (cleaner brief said abort should NOT persist; design says abort SHOULD persist) is resolved in favour of the design; implementation matches design.
- **Phase 2+ deferrals**: confirmed no accidental implementation of back-pressure (writer is fire-and-forget; `append` returns immediately), CLI integration (no Genie-side changes), persistent in-flight state (no on-disk stream records), cross-peer streams (only same-daemon test coverage; cross-peer Far ref patching not present and not asserted), or `streamSend` (only `streamReply` added to interfaces). All deferrals respected.

## CI status
- At panel-start (post-builder, post-cleaner, pre-judge): 19/25 SUCCESS, 6 in-progress, 0 fail.
- At un-draft time: 25/25 SUCCESS, 0 fail. `gh pr checks 287 --watch --fail-fast` ran to completion within ~8 minutes; no flake.

## Fixer round count
- 0 fixer dispatches required (must-fix was empty after round 1).

## Final PR state
- `gh pr ready 287 --repo endojs/endo-but-for-bots` ran successfully (`Pull request #287 is marked as "ready for review"`).
- `gh pr view 287 --json isDraft,mergeable,mergeStateStatus,reviewDecision`: `isDraft=false`, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`, `reviewDecision=""` (the panel's review was `--comment` because the authenticated identity (kriscendobot) is also the PR's author; the dispatch matrix keys on the "Must-fix before merge: none." line in the body).
- PR is now in the maintainer's review queue. The two should-fix items above are the orchestrator's call to fold in or carry forward.

## Self-PR limitation
- The authenticated `gh` identity in this dispatch is `kriscendobot`, which is also the PR's author. GitHub blocks `--request-changes` in that case, so the panel review was submitted with `--comment` and an explicit `Must-fix before merge: none.` final line in the body so the orchestrator's dispatch matrix can key on the absence of the must-fix shape.

## Self-improvement
The in-band-fallback procedure in `roles/judge/AGENT.md` § In-band fallback says the top-of-dispatch probe is "one `ToolSearch` for 'Agent' / 'task spawn' / 'subagent dispatch', or one trial `Agent` invocation against a no-op task" and that ambiguity defaults to in-band. The `ToolSearch select:Agent` form returned "No matching deferred tools found" cleanly; the path is solid. One refinement worth recording for the next judge: the brief named "anti-bail pattern" explicitly and pointed at PR #284's successful retry. That framing (run the panel FIRST, snapshot CI, one `--watch` if still pending, write the result entry before terminating) is exactly what this dispatch did, and it worked. The pattern is worth promoting from "dispatch brief reminder" to a row in `roles/judge/AGENT.md` § Notes from the field so subsequent judges find it by reading their role file rather than relying on the orchestrator to include it in every dispatch. Message to liaison.
