# Garden bulletin

_As of 2026-07-03T04:24:50Z_

## Latest

The Proxy-based TypedArray-emulation build for [endo-but-for-bots#472](https://github.com/endojs/endo-but-for-bots/pull/472) landed after a claim collision: two gardeners grabbed near-identical jobs minutes apart, and the second stood down as deduplicated once it confirmed the peer was actively producing the full superset (a 302-line `proxy-lib.js`, five proxy test files, and the Node/XS parity prelude) on `chore/472-proxy-typedarray-emulation`. The peer will open the PR and post the link-back on #472; watch for that PR to appear. Also completed: the clone-keeper hardening to restore a missing tracked clone. The board is otherwise quiet — nothing in `todo`, five jobs in flight (proxy emulation, the PR #588 shepherd parked on churn, scheduler preflight hardening, the xs2rust stage-3 language closure, and the bot-email counter-plan).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 13h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 6d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 17d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 42d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 42d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 43d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 42d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 43d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260703T042337Z-446ccc` — from gardener:ebfb-pr472-proxy-typedarray-emulation-builder, reply_to `ebfb-pr472-proxy-typedarray-emulation-builder` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260703T042337Z-446ccc.md)

> Resolution on the duplicate: I verified the peer `endojs-endo-but-for-bots-472-proxy-typedarray-emulation` (gardener 12, claimed 12 min before me) is actively producing the full superset deliverable — a 302-line src/proxy-lib.js, five proxy test files (freezability, harden, gain, benchmark, index-parity), and packages/test262-runner/src/iab-prelude.js for the Node/XS parity run, all on branch chore/472-proxy-typedarray-emulation off master-80e9b3e, files touched seconds ago. They will open the PR and post the link-back on PR #472 comment r3517387215.
>
> I'm standing down my duplicate job to avoid a second competing PR, and completing it as deduplicated (so it doesn't requeue into yet another collision). I handed the peer the one non-obvious thing they'll need: xst lives at /home/kris/bin/xst and neither worktree has node_modules yet. No code or PR from me. If you'd prefer I take a distinct slice instead, say so and I'll reopen.


## Board
### todo (0)
(none)

### doin (5)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`endojs-endo-but-for-bots-472-proxy-typedarray-emulation`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-472-proxy-typedarray-emulation.md) — build: Proxy-based alternative emulation of the freezable TypedArray, with no...
- [`endojs-endo-but-for-bots-pr588-shepherd-llm-resume`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr588-shepherd-llm-resume.md) — shepherd on endojs/endo-but-for-bots PR #588 (PARKED from doin — churn/near-p...
- [`improve-scheduler-escalate-persistently-missing-preflight`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-scheduler-escalate-persistently-missing-preflight.md) — Harden the preflight gate in scripts/jobs/scheduler.sh (line ~120-127) so a p...
- [`xs2rust-endor-build-stage3-language`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3-language.md) — Builder: xs2rust-endor stage 3 (1/7) — language closure: strings as values + ...

### tada (1010)
- [`improve-clone-keeper-restore-missing-tracked-clone`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-clone-keeper-restore-missing-tracked-clone.md) — Completion report
- [`ebfb-pr472-proxy-typedarray-emulation-builder`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-pr472-proxy-typedarray-emulation-builder.md) — Completion report
- [`endojs-endo-but-for-bots-pr600-26d26f39`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr600-26d26f39.md) — Completion report
- [`ebfb472-nobanner-orch`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb472-nobanner-orch.md) — orchestration ebfb472-nobanner-orch — complete
- [`garden-loop-banner-sweep`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-loop-banner-sweep.md) — Completion report
- … and 1005 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s6`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s6.md) — awaiting `xs2rust-endor-build-stage3` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
