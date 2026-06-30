# Garden bulletin

_As of 2026-06-30T23:38:42Z_

## Latest

A gardener working `endo-hex-tiered-codec-port` surfaced that the premise is already satisfied: `@endo/hex` (published `@endo/hex@1.1.1`) exists upstream and is mirrored in endo-but-for-bots, already tiered (native `Uint8Array.fromHex`/`toHex` with a bounded-loop pure-JS floor) and XS-safe — no `flatMap`, no large-array spread, no module-scope decode map — with a witness round-trip and the existing test suite covering every correctness pin. The gardener declined to diverge the mirror by adding a Buffer tier or map-table floor and is asking the maintainer whether to close the job as already-satisfied or re-scope it to the genuinely-remaining work: slimming [kriscendobot/agoric-sdk#7](https://github.com/kriscendobot/agoric-sdk/pull/7) to depend on `@endo/hex` and drop its in-tree `hex.js` (note `@endo/hex`'s error text differs, so #7's exact-string assertions would need a tweak). Related hex work is still in flight — a Richard Gibson feedback pass on the same agoric-sdk fork PR and a platform-benchmark-table builder job for `@endo/hex` on endo-but-for-bots master. Separately, an attention directive landed on [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP cross-worker error tracing), now the freshest item parked for review.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 3m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 18h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 40d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260630T233833Z-01a1d0` — from gardener:endo-hex-tiered-codec-port, reply_to `endo-hex-tiered-codec-port` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260630T233833Z-01a1d0.md)

> Job endo-hex-tiered-codec-port — premise is already satisfied; surfacing before doing speculative work.
>
> `@endo/hex` ALREADY EXISTS upstream and is mirrored in endo-but-for-bots:
> - packages/hex, published @endo/hex@1.1.1, authored upstream (commit ad7a177e8 "feat(hex): Add hex transcoder").
> - It is already TIERED: Tier 1 native `Uint8Array.fromHex`/`toHex` preferred (captured pre-lockdown, dispatched via Reflect.apply); Tier "floor" is a pure-JS polyfill.
> - It is XS-SAFE by the job's own criterion: the polyfill uses BOUNDED for-loops with char-code arithmetic — NO flatMap, NO large-array spread, and in fact NO module-scope decode Map at all. I ran a standalone witness: full 0..255 round-trip, mixed/upper/lower case, odd-length + non-hex rejection (incl. the `@`/backtick 0x20-fold guards, no silent truncation), and a 1 MiB encode/decode round-trip — all pass.
> - Its test suite (test/main.test.js) already covers every #7 correctness pin and more (cross-tier agreement, offset diagnostics, native-path diagnostic preservation, non-ASCII/high-bit rejection).
>
> Deltas vs the literal job text:
> 1. NO `Buffer` tier (tier 2). Upstream deliberately goes native -> pure-JS; the polyfill is the only non-native path.
> 2. The floor is char-code arithmetic, NOT the "map [char-pair] table" #7 found fastest on XS. Upstream's bench comment claims char-code is ~2.5-3x faster than the table on V8 and notes XS is slow regardless until Moddable ships native fromHex.
>
> Adding a Buffer tier or swapping to a map-table in the bot fork would DIVERGE the mirror from a published upstream package — counter to the mirror's purpose and the spirit of the hard scope line. So I did NOT modify endo-but-for-bots.
>
> Recommendation: close this job as already-satisfied. The real remaining work is the explicitly-separate agoric-sdk #7 slim-down — make packages/internal depend on `@endo/hex` and drop the in-tree hex.js body. The existing `@endo/hex` is a drop-in for #7's encodeHex/decodeHex (note: #7 currently throws `Invalid hex string: ${hex}`; `@endo/hex` throws a hex/odd-length message with offset+name — equivalent semantics, different text, so #7's tests that assert the exact string would need a tweak). If you DO still want a Buffer perf-tier or the map-table floor, that's an upstream `@endo/hex` design change to take to endojs/endo proper — not the bot fork.
>
> Should I (a) close as already-satisfied, or (b) re-scope this job to the agoric-sdk #7 slim-down against the existing `@endo/hex`?


## Board
### todo (0)
(none)

### doin (5)
- [`agoric-sdk-fork-pr-7-apply-richard-gibson-feedback`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/agoric-sdk-fork-pr-7-apply-richard-gibson-feedback.md) — Apply Richard Gibson's feedback to the mirror kriscendobot/agoric-sdk#7
- [`ebfb-build-endo-hex-package-platform-benchmark-table`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-build-endo-hex-package-platform-benchmark-table.md) — Builder: create @endo/hex on endo-but-for-bots master — best-on-all-platforms...
- [`endo-hex-tiered-codec-port`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-hex-tiered-codec-port.md) — Design + build a tiered @endo/hex codec in endo-but-for-bots
- [`endojs-endo-but-for-bots-pr58-1446f9e1`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr58-1446f9e1.md) — attention directive on endojs/endo-but-for-bots PR #58
- [`scholar-ingest-tailscale-oauth-apps-and-oauth-skills`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-tailscale-oauth-apps-and-oauth-skills.md) — Scholar: ingest Tailscale OAuth-apps doc + produce garden OAuth use-case skil...

### tada (733)
- [`kriskowal-garden-pr16-review-39c42194`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr16-review-39c42194.md) — Completion report
- [`kriskowal-garden-pr16-3c8d784d`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr16-3c8d784d.md) — Completion report — job kriskowal-garden-pr16-3c8d784d
- [`kriskowal-garden-pr16-eabd1e1d`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr16-eabd1e1d.md) — Completion report — job kriskowal-garden-pr16-eabd1e1d
- [`ebfb-retention-paths-chat-panel`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-retention-paths-chat-panel.md) — Completion report
- [`deadmail-issue-comment-4848697844`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4848697844.md) — Completion report — dead-lettered deadmail-issue-comment-4848697844
- … and 728 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table-v2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/284` · PLAN (follow-on, re-parked): add a retention-paths table to the formula inspe...
- [`garden-encode-directives-reliably-become-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-encode-directives-reliably-become-jobs.md) — awaiting `garden-encode-acknowledged-comment-needs-reply` · Widen the comment-watcher: actionable maintainer directives reliably become J...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
