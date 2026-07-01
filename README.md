# Garden bulletin

_As of 2026-07-01T02:32:58Z_

## Latest

The `.js`-extension lint ask from kriskowal's #442 review resolved itself without a maintainer call: two builder jobs raced the same design, so [endo-but-for-bots#582](https://github.com/endojs/endo-but-for-bots/pull/582) closed as a duplicate in favor of [endo-but-for-bots#581](https://github.com/endojs/endo-but-for-bots/pull/581) — both independently landed a new `@endo/jsdoc-import-extensions` rule (covering the JSDoc `@import` blind spot that `import/extensions` and `import/no-unresolved` miss) scoped to relative imports only, correctly leaving `@endo/*` subpaths to their exports maps since `platform`/`agentry`/`preact-container` use extensionless export keys. #581 is the review target, with one optional `checkTypeImports: true` suggestion pending. On the byteArray front, [endo-but-for-bots#571](https://github.com/endojs/endo-but-for-bots/pull/571) completed, and two jobs are in flight against [endo-but-for-bots#572](https://github.com/endojs/endo-but-for-bots/pull/572): resolving a README merge conflict and opening fresh view-based byteArray implementation PRs per erights' directive.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 21h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 40d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 40d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 40d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260701T012823Z-f8fc72` — from gardener:enforce-js-extension-lint-endo-but-for-bots, reply_to `enforce-js-extension-lint-endo-but-for-bots` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260701T012823Z-f8fc72.md)

> DRAFT PR endojs/endo-but-for-bots#582 opened for the "enforce .js extension by lint" ask (kriskowal's #442 review on content-store.js:6).
>
> Done: new `@endo/jsdoc-import-extensions` rule (the JSDoc `@import` blind spot that both import/extensions and import/no-unresolved miss) + `checkTypeImports: true` on import/extensions. Tests 158 passing; `eslint .` green (0 errors).
>
> Holding as DRAFT for one scope call, laid out in the PR body: requiring `.js` on `@endo/*` SUBPATHS is not uniformly correct. `@endo/platform`, `@endo/agentry`, `@endo/preact-container` use extensionless export KEYS, so their extensionless specifiers are the only form that resolves — the reported `@endo/platform/fs/lite/types` is actually a correct explicit-key export. Enforcing `.js` there needs a separate exports-map migration of those 3 packages to `.js`-suffixed keys (the convention @endo/daemon, @endo/exo, @endo/marshal already follow). Fold that migration into this PR, or land the JSDoc/relative enforcement now and track the migration as a follow-up?

- `20260701T013055Z-3babe0` — from gardener:enforce-js-extension-lint-endo-but-for-bots, reply_to `enforce-js-extension-lint-endo-but-for-bots` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260701T013055Z-3babe0.md)

> CORRECTION to my prior note: I closed my PR #582 as a duplicate. A sibling builder job opened #581 two minutes earlier for the same #442 ask, and it independently reached the same design (the `@endo/jsdoc-import-extensions` rule, relative-only scope) with a proper frozen `llm` base and a changeset. No maintainer decision is needed on the `@endo/*` subpath question I raised — both PRs independently concluded that requiring `.js` on `@endo/*` subpaths is not uniformly correct (platform/agentry/preact-container use extensionless export keys), so both correctly leave subpaths to their exports maps and `import/no-unresolved`. Review target is #581. I left one optional suggestion there (add `checkTypeImports: true` to also cover TS `import type`). My job dedups in favor of #581.


## Board
### todo (0)
(none)

### doin (2)
- [`endojs-ebfb-fresh-bytearray-view-impl-prs`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-ebfb-fresh-bytearray-view-impl-prs.md) — open fresh view-based byteArray implementation PRs (erights directive on #572)
- [`endojs-ebfb-pr572-weave-readme-conflict`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-ebfb-pr572-weave-readme-conflict.md) — resolve merge conflict on endo-but-for-bots #572 (design-only, base llm)

### tada (765)
- [`endojs-endo-but-for-bots-pr571-c05feda5`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr571-c05feda5.md) — Completion report
- [`endojs-endo-but-for-bots-pr572-02dd3364`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr572-02dd3364.md) — Completion report
- [`endojs-endo-but-for-bots-pr572-review-ee8280af`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr572-review-ee8280af.md) — Completion report: endojs-endo-but-for-bots-pr572-review-ee8280af
- [`endojs-endo-but-for-bots-pr475-2f49bb71`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-2f49bb71.md) — Completion report
- [`endojs-endo-but-for-bots-pr570-16d6cc1e`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr570-16d6cc1e.md) — Completion report — endojs-endo-but-for-bots-pr570-16d6cc1e
- … and 760 more

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
