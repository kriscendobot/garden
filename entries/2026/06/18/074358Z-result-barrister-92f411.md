---
ts: 2026-06-18T07:43:00Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - pr: 462
---

Code panel on PR #462 (`feat(exo-stream): migrate daemon and consumers to @endo/exo-stream wire protocol`) by kumavis. External-author PR, authorized review per dispatch.

## Panel composition

Panel kind: code-panel
Panel execution: in-band fallback (Agent tool not available in this dispatch)
Panel-hints output: 22 of 26 seats recommended.

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (6): breaker, curator, fast-checker, gateway, migrator, surfacer
Content-triggered (5): locksmith, purist, spec-keeper, warden, wire-watcher
Cross-panel (0): none
Suppressed (4): benchmarker, changeset-auditor, pruner, engine-realist (no content signals; pedant/copyeditor suppressed, no substantial markdown outside designs/)
Barrister-side overrides: none.

@copilot add-reviewer fired alongside panel dispatch.

## Verdict counts

| Disposition | Count |
|---|---|
| must-fix-loop | 4 |
| summary-fix | 3 |
| follow-up | 5 |
| acknowledge | 18+ |
| drop | 0 |

Formal verdict: `--request-changes` submitted at 2026-06-18T07:42:47Z.
Review URL: https://github.com/endojs/endo-but-for-bots/pull/462#pullrequestreview-2987476549

## Must-fix items (for justice re-run after fixer)

1. `packages/daemon/src/pubsub.js:85-93` — subscriber `return()` and `throw()` overrides do not propagate termination to the underlying subscription, leaking the spring chain and creating a concurrent next()+return() race.
2. `packages/platform/src/fs/snapshot-blob.js:20` — `streamBase64` assigned a pre-built one-shot pump; second call silently delivers empty stream. All other callsites create a fresh pump per call.
3. `packages/daemon/src/pubsub.js` — no unit test for `makeChangeTopic().subscribe().return()` prompt settlement; the PR's tests cover the downstream symptom (disable-then-post) but not the subscriber lifecycle directly.
4. `packages/daemon/test/channel.test.js:2582,2622` — deadlock regression tests lack `t.timeout`; CLAUDE.md requires it for hang/stall guards.

## Summary-fix items (post via job-board after review)

- Remove dead `IterRef` typedef and stale comment from `packages/daemon/src/channel.js:19-29`.
- `packages/daemon/src/tar-checkin.js:38`: fix JSDoc comment from "CapTP base64 ref decoding" to "consumer-side traversal".
- `packages/daemon/test/channel.test.js:2582,2622`: add `t.timeout(10_000)`.

## Proposed-rule messages queued to gardener

Seven proposed rules emerged from the panel. The most load-bearing:
- streamBase64 implementations must create a fresh reader per call (not assign a pre-built pump).
- Passthrough reader overrides of return()/throw() must propagate to the wrapped stream.
- Async-iteration lifecycle fixes must carry direct unit tests, not only integration tests.
- Deadlock regression tests must carry `t.timeout`.

## Next stage

next: liaison (external PR by kumavis; maintainer decides whether to request fixer dispatch or relay findings to kumavis for author-side fix; no bot-side fixer dispatch without maintainer authorization)

Self-improvement: in-band panel on a large migration PR (110 files, 803 insertions, 1474 deletions) worked well; the most productive approach was reading key implementation files (pubsub.js, snapshot-blob.js, reader-pump.js) end-to-end rather than relying solely on diff context lines. The snapshot-blob one-shot pump finding required tracing through mapReader and asyncIterate to confirm the generator-is-this behavior — a reminder that must-fix items on subtle lifecycle bugs require source-level verification, not just diff reading.
