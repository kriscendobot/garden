# Garden bulletin

_As of 2026-07-08T12:59:22Z_

## Latest

The endoclaw network-fetch builder [stopped rather than duplicate work](https://github.com/endojs/endo-but-for-bots/pull/566): a gardener found that DRAFT [endo-but-for-bots#566](https://github.com/endojs/endo-but-for-bots/pull/566) (0xpatrickbot) already implements the confined `HttpClient`/`HttpClientControl` design end to end, and flags that it bases on `llm` rather than `master` — worth a reviewer's eye against the base-branch norm; the maintainer is asked to retire the job and, if wanted, post a shepherd/panel to drive #566 to green. The CloudFlare storage design for the Endo daemon landed on branch `design/endo-daemon-cloudflare-storage` in endo-but-for-bots (design doc plus scaffold and 6 passing tests), but note the parked go-ahead `build-endo-daemon-cloudflare-storage` still names the pre-redirect target (`kriscendobot/endo`) and must be corrected to endo-but-for-bots before promotion. The AWS storage design also completed, seeding several parked build/deploy follow-ups. On the branch-ops side, [endo-but-for-bots#617](https://github.com/endojs/endo-but-for-bots/pull/617) was woven back to MERGEABLE, and the Docker self-host daemon build and the Stripe-credits minion.town deploy both finished.

## Parked for maintainer feedback

- [endojs/endo#3319](https://github.com/endojs/endo/pull/3319) — feat(eslint-plugin)!: support ESLint 10+ (waiting 13h)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 5d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 8d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 9d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 12d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 22d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 47d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 47d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 49d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 48d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260708T053541Z-30f34a` — from gardener:endojs-endo-but-for-bots-endoclaw-network-fetch-build, reply_to `endojs-endo-but-for-bots-endoclaw-network-fetch-build` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T053541Z-30f34a.md)

> Builder job `endoclaw-network-fetch` (build the HttpClient/HttpClientControl cap in endojs/endo-but-for-bots): STOPPED — the job body said "no in-flight PR", but there IS a comprehensive one.
>
> **PR #566** (`feat(exo-http-client): add confined HttpClient`, DRAFT, MERGEABLE, base `llm`, author 0xpatrickbot, updated 2026-07-08 — today) already implements this exact design:
> - `packages/exo-http-client` — the `HttpClient` / `HttpClientControl` exo facet pair (`src/http-client.js`, `src/types.ts`, tests)
> - `packages/http-confine` — shared pure confinement core: origin-parse allowlist, method/header validation, injected-clock per-minute rate limit, max-response-byte cap, redirect checks, timeout/cancel, `revoke()`
> - updates `designs/endoclaw-network-fetch.md` (the doc this job cites) + adds trust-on-first-bind policy, changesets, docs
>
> Every acceptance criterion in the design is covered. Building a second implementation would be a duplicate and would collide on the same branch/design. I did NOT open a competing PR.
>
> Recommendation: retire this job as already-satisfied by #566, and instead post a **shepherd/panel** job to drive #566 to green + out of draft if you want it landed. Say the word and I'll (as a fresh job) do that instead. Note #566 bases on `llm` not `master` — worth a reviewer eye given the base-branch norm.

- `20260708T062911Z-80c4e5` — from gardener:design-endo-daemon-cloudflare-storage, reply_to `design-endo-daemon-cloudflare-storage` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T062911Z-80c4e5.md)

> CloudFlare storage design job: done, with one board correction to apply at promote time.
>
> **Delivered** (per the mid-job redirect to endojs/endo-but-for-bots): branch `design/endo-daemon-cloudflare-storage` on endojs/endo-but-for-bots — design doc `packages/daemon/CLOUDFLARE-STORAGE.md` + scaffold (`src/better-sqlite3-do.js` DO-SQLite backend for daemon-database.js, `src/daemon-cloudflare-powers.js` R2 FilePowers + crypto + assembly) + 6 passing AVA tests over mock bindings. daemon-database.js / pet-store.js / daemon-persistence-powers.js run UNCHANGED.
>
> **Correction needed:** the parked go-ahead job `plan/build-endo-daemon-cloudflare-storage.md` was posted BEFORE the redirect and still names `kriscendobot/endo` + branch `design-endo-daemon-cloudflare-storage`. There is no plan-edit primitive, so when you consider promoting it, please fix (or drop+repost with) the target: repo **endojs/endo-but-for-bots**, branch **design/endo-daemon-cloudflare-storage**, design doc `packages/daemon/CLOUDFLARE-STORAGE.md`, phases per its § 7 (phase 1: miniflare/workerd rig + @noble crypto injection + limit guards; phase 2: R2 multipart large-blob path). The rest of the parked body stands.
>
> **Also:** the pre-redirect deliverable (upstream-endo-shaped variant, generic SqlPowers/D1 design without daemon-database) remains on kriscendobot/endo branch `design-endo-daemon-cloudflare-storage` — relevant if this ever ferries to upstream endojs/endo, which lacks the fork's database layer. Say the word if you'd rather it be deleted.

- `20260708T074534Z-1dcec3` — from gardener:design-endo-daemon-cloudflare-storage, reply_to `design-endo-daemon-cloudflare-storage` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T074534Z-1dcec3.md)

> Final coordinates for the CloudFlare storage design (supersedes the paths in my earlier message):
>
> - Draft PR: https://github.com/endojs/endo-but-for-bots/pull/638 (design/endo-daemon-cloudflare-storage → llm; draft, per the fork's convention — the AWS sibling is #637).
> - Design doc moved to the fork's norm: `designs/endo-daemon-cloudflare-storage.md` (metadata table, Status, Prompt; README summary + M5 rows synced — expect a trivial totals conflict with #637, both add one design).
> - Scaffold unchanged: `packages/daemon/src/better-sqlite3-do.js`, `src/daemon-cloudflare-powers.js`, `test/cloudflare-{mock-bindings,powers.test}.js` — 6 tests green, tsc clean.
>
> The parked `plan/build-endo-daemon-cloudflare-storage.md` correction from my earlier message still applies; when promoting, point it at PR #638 / the designs/ doc.

- `20260708T125913Z-17cb01` — from watchdog:foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T125913Z-17cb01.md)

> garden-foreman's pump handler (/home/kris/garden2/scripts/jobs/handlers/foreman-claude.sh) failed rc=1 on endolin-garden2-5bcdff64; the board pump is starving. stderr tail: /home/kris/garden2/scripts/jobs/handlers/foreman-claude.sh: line 92: designer: command not found
> /home/kris/garden2/scripts/jobs/handlers/foreman-claude.sh: line 92: builder: command not found
> <6>12:59:13 [foreman-claude] usage-meter: claude exited rc=1; usage not recorded


## Board
### todo (0)
(none)

### doin (0)
(none)

### tada (1518)
- [`endojs-endo-but-for-bots-pr637-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr637-shepherd.md) — Completion report
- [`endojs-endo-but-for-bots-pr638-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr638-shepherd.md) — Completion report
- [`daily-progress-summary-20260708-070528`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/daily-progress-summary-20260708-070528.md) — Completion report
- [`deadmail-20260708T074539Z-84584c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260708T074539Z-84584c.md) — Completion report
- [`design-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-endo-daemon-cloudflare-storage.md) — Completion report: design-endo-daemon-cloudflare-storage
- … and 1513 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-account-store-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-account-store-minion-town.md) — _normal_ · Build: account store + auto-provisioning for minion.town (Phase A — ships dar...
- [`build-endo-daemon-aws-storage-wiring`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-aws-storage-wiring.md) — _normal_ · Build: wire the AWS storage platform into a daemon flavour (phases 2-3 of des...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`styled-privilege-surfaces-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/styled-privilege-surfaces-minion-town.md) — _normal_ · Build: styled privilege surfaces for minion.town (Phase C — role-aware landin...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s18`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s18.md) — awaiting `xs2rust-endor-build-stage5-fix6` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
