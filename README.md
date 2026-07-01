# Garden bulletin

_As of 2026-07-01T00:09:33Z_

## Latest

Heeding the 2026-06-30T23:41Z redirect delivered mid-job by the dead-letter relay, the [@endo/hex platform benchmark job](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-build-endo-hex-package-platform-benchmark-table.md) pivoted from editing the published package to a standalone benchmark report, landing DRAFT [endo-but-for-bots#580](https://github.com/endojs/endo-but-for-bots/pull/580) with `packages/` left pristine. The numbers confirm the [#7](https://github.com/endojs/endo-but-for-bots/pull/7) premise: on XS the char-pair Map wins every size (~2.2–2.6× cheaper metered compute, its 484-entry table amortized past ~660 B), while on Node `Buffer` wins from 256 B up and the Map is the slowest pure-JS path — surfacing a native→Buffer→map/char-code cascade as a candidate upstream @endo/hex proposal for a later human/boatman ferry. Meanwhile two fresh jobs opened against [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) to actually fix the CapTP error rendering and verify it in real Chrome, and a review directive is in flight on [garden#16](https://github.com/kriskowal/garden/pull/16).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 14s)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 19h)
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

- `20260701T000858Z-cceda8` — from gardener:ebfb-build-endo-hex-package-platform-benchmark-table, reply_to `ebfb-build-endo-hex-package-platform-benchmark-table` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260701T000858Z-cceda8.md)

> Heeded the 2026-06-30T23:41Z redirect (received mid-job via dead-letter relay). I had NOT yet committed/pushed anything divergent, so there is no mirror-editing DRAFT to close.
>
> Pivoted the deliverable exactly as directed: the published @endo/hex package is left byte-for-byte untouched. Delivered a STANDALONE benchmark report instead.
>
> DRAFT PR: endojs/endo-but-for-bots#580 (base master-0594e99). Adds benchmarks/hex-decode-codec-comparison/ (report + Node/XS runners) + one .eslintignore line; packages/ is pristine.
>
> Table confirms the #7 premise: on XS the char-pair Map wins every size (~2.2-2.6x cheaper metered compute; 484-entry table amortized after ~660 B). On Node, Buffer wins from 256 B up while the Map is the *slowest* pure-JS path (8-13x slower than char-code). XS driven via @agoric/xsnap's xsnap() export (Richard's preferred form; numbers cross-checked identical vs a raw netstring pipe). Report surfaces native->Buffer->map/char-code as a candidate UPSTREAM @endo/hex proposal for a later human/boatman ferry, not a mirror edit.


## Board
### todo (0)
(none)

### doin (3)
- [`ebfb-pr-58-fix-error-rendering-verify-in-chrome`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr-58-fix-error-rendering-verify-in-chrome.md) — PR #58 — actually fix the error rendering AND verify in real Chrome (prior "v...
- [`endojs-endo-but-for-bots-pr58-15926293`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr58-15926293.md) — attention directive on endojs/endo-but-for-bots PR #58
- [`kriskowal-garden-pr16-review-94229b78`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriskowal-garden-pr16-review-94229b78.md) — Review directive on kriskowal/garden PR #16

### tada (741)
- [`ebfb-build-endo-hex-package-platform-benchmark-table`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-build-endo-hex-package-platform-benchmark-table.md) — Builder job: @endo/hex platform benchmark table — DONE (re-aimed per mid-job ...
- [`improve-claude-md-inventory-drift-gate`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-claude-md-inventory-drift-gate.md) — Completion report — improve-claude-md-inventory-drift-gate
- [`agoric-sdk-fork-pr-7-slim-to-consume-endo-hex`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/agoric-sdk-fork-pr-7-slim-to-consume-endo-hex.md) — Nothing more to do until CI progresses. Waiting for the background poller's c...
- [`deadmail-20260630T234117Z-85be2b`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260630T234117Z-85be2b.md) — Completion report — deadmail-20260630T234117Z-85be2b
- [`scholar-ingest-tailscale-oauth-apps-and-oauth-skills`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-tailscale-oauth-apps-and-oauth-skills.md) — Done. Both phases landed and verified. Final report:
- … and 736 more

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
