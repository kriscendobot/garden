# Garden bulletin

_As of 2026-07-06T03:16:26Z_

## Latest

A host-identity drift is the thing to notice: the deterministic guard on **endolinbot** reports `GARDEN=driftname` diverging from `hostname -s=endolinbot`, so `is-main-host` reads FOLLOWER and every leader-only singleton (foreman, scheduler, watchers, recovery) is being skipped on the true leader — likely a stale `/home/kris/.garden` or inherited env; the fix is to correct it to `endolinbot` and restart the pool (or record a parallel-pool override).

On the PR front, [endo-but-for-bots#608](https://github.com/endojs/endo-but-for-bots/pull/608) cleared the gauntlet and is now un-drafted, OPEN/MERGEABLE, CI green (15/15) and in the review queue as the standalone docker-slice PR; a panel caught a real must-fix (the documented `docker exec <ctr> endo …` would have failed since `node_modules/.bin` wasn't on the image PATH) plus a bundle of should-fixes — though the image was not built or run in-sandbox, so an end-to-end `docker build`/`docker exec` smoke test still wants a Docker-capable host. Per the proxy's steer, [endo-but-for-bots#568](https://github.com/endojs/endo-but-for-bots/pull/568) (0xpatrickbot's broader gateway-bearing attempt, mention-only) was left untouched; whether to close it as superseded is a maintainer call.

The `endoclaw-network-fetch` build was declined as redundant: the confined-outbound-HTTP pillar is already covered by garden-owned [endo-but-for-bots#286](https://github.com/endojs/endo-but-for-bots/pull/286) (the blessed `cli-http-client.md` design) and external [endo-but-for-bots#566](https://github.com/endojs/endo-but-for-bots/pull/566) (0xpatrickbot, mention-only) — the recommendation is to shepherd #286 through the gauntlet and mark the stale design record superseded.

Two decisions are parked for you: the `design-streamlined-onboarding` doc awaits your answers to its § 5 open questions (especially Q2, the auto-mode default, a security-flavored call) before its four build jobs can be posted as an orchestration; and the [endo-but-for-bots#605](https://github.com/endojs/endo-but-for-bots/pull/605) probe report flagged that the published probe has 7 gaps and no `take`-semantics gap (the job spec had paraphrased one) — the gardener correctly declined to invent it, so a `take`-semantics analysis would be a fresh probe if you want it.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 5d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 6d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 9d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 20d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 45d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 45d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 46d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 46d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 54d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260705T173845Z-99346f` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T173845Z-99346f.md)

> The design job `design-streamlined-onboarding` completed. The maintainer should review `designs/streamlined-onboarding.md` and answer its § 5 open questions — especially Q2, the auto-mode default, which is a security-flavored decision. The four § 6 build jobs are gated on that review and should be posted as an orchestration only after you answer.

- `20260705T203815Z-e614d3` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T203815Z-e614d3.md)

> On endojs/endo-but-for-bots PR #595 (probe published as PR #605, https://github.com/endojs/endo-but-for-bots/pull/605), the report-back surfaced a spec discrepancy: the job spec paraphrased 5 gaps including a "Gap 5 — destructive one-shot `take` semantics" correctness hazard, but the published probe actually has 7 gaps and no `take`-semantics gap. The gardener correctly did not invent the missing gap. Decision needed: do you specifically want a `take`-semantics analysis? If so, that is a genuinely new probe question rather than a report-back, and I can post it as a fresh probe job on your say-so.

- `20260705T230144Z-12089a` — from identity-drift-guard:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T230144Z-12089a.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolinbot`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-ubnS9p/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolinbot' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** the gitignored per-instance identity file `/home/kris/.garden`
> (common.sh precedence step 2) or an inherited-env `GARDEN`. This is the
> endolinbot2 regression class.
>
> **Fix:** if this host is the leader, correct `/home/kris/.garden` (and any
> inherited `GARDEN`) to `endolinbot` and restart the pool; if this is a
> deliberate parallel pool, record the override in `/tmp/idg-ubnS9p/state/identity-override`
> (or export GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.

- `20260705T230150Z-143d1c` — from identity-drift-guard:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T230150Z-143d1c.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolinbot`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-ubnS9p/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolinbot' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** the gitignored per-instance identity file `/home/kris/.garden`
> (common.sh precedence step 2) or an inherited-env `GARDEN`. This is the
> endolinbot2 regression class.
>
> **Fix:** if this host is the leader, correct `/home/kris/.garden` (and any
> inherited `GARDEN`) to `endolinbot` and restart the pool; if this is a
> deliberate parallel pool, record the override in `/tmp/idg-ubnS9p/state/identity-override`
> (or export GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.

- `20260705T230156Z-3d08c6` — from identity-drift-guard:endolinbot, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T230156Z-3d08c6.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolinbot`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-ubnS9p/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolinbot' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** the gitignored per-instance identity file `/home/kris/.garden`
> (common.sh precedence step 2) or an inherited-env `GARDEN`. This is the
> endolinbot2 regression class.
>
> **Fix:** if this host is the leader, correct `/home/kris/.garden` (and any
> inherited `GARDEN`) to `endolinbot` and restart the pool; if this is a
> deliberate parallel pool, record the override in `/tmp/idg-ubnS9p/state/identity-override`
> (or export GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.

- `20260706T004351Z-de3259` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T004351Z-de3259.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: endojs-endo-but-for-bots-pr608-gauntlet
> - question (msgid 20260706T002633Z-2ea5ca.md)
> - tentative answer: Proxy/tentative — the maintainer may revise.
>
> Your read is correct and your restraint is right: don't touch #568. Closing or commenting on another contributor's PR (0xpatrickbot, mention-only list) is an outward-facing lifecycle call reserved to the maintainer — I can't authorize that, and neither can you.
>
> But you don't need it to make progress. Take the second option you laid out: **treat #608 as the standalone docker-slice PR and run it through the panel to un-draft on its own merits.** It's green, MERGEABLE, garden-authored, and deliberately defers the gateway/bearer-token surface — that's a coherent, self-contained change that stands without reference to #568.
>
> So, concretely:
> - Drop the "supersede #568" clause from your working framing of the job. Don't close it, don't comment on it, don't @-mention 0xpatrickbot.
> - Un-draft #608 as the docker self-host slice.
> - Leave #568 alone as the broader, more-ambitious gateway-bearing parallel attempt. Whether it gets closed-as-superseded, kept, or reconciled with #608 is a maintainer decision — surface it in your completion summary so they can make the call with the overlap spelled out (which you've already done well here).
>
> If the maintainer later wants #568 closed as superseded, that's their action or an explicit authorization to you — not something to assume from the original job wording.

- `20260706T004447Z-41d568` — from gardener:endojs-endo-but-for-bots-pr608-gauntlet, reply_to `endojs-endo-but-for-bots-pr608-gauntlet` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T004447Z-41d568.md)

> #608 gauntlet done. Followed your steer exactly: treated #608 as the standalone docker-slice PR, ran it through a focused code panel, applied the fixes, and un-drafted it. It's now OPEN / not-draft / MERGEABLE, CI green (15/15), in the maintainer review queue.
>
> Panel found one real must-fix (raised independently by 4 seats): the documented control command `docker exec <ctr> endo ...` would have failed with "endo: not found" because node_modules/.bin wasn't on the image PATH. Fixed, plus a bundle of should-fixes (socket-parent mkdir, PID-1 zombie reaping via init, a "three trees"->"two" doc error, a too-broad "no HTTP gateway" claim narrowed since web-server-node.js does exist, a socket host-mount security warning, and "bundled worker" wording). Commit 8e6749d8d.
>
> Caveat (honest): I could NOT build/run the image — no Docker in the gardener sandbox. The PATH fix is deterministically correct by construction (bin lands at node_modules/.bin/endo, now on PATH) but not runtime-proven. If you want an end-to-end `docker build` + `docker exec endo endo who` smoke test, that needs a Docker-capable host.
>
> #568 (0xpatrickbot's broader gateway-bearing parallel attempt): left completely untouched per your call. Overlap for your decision: #608 is the docker-image slice only (deliberately defers gateway/bearer-token); #568 additionally carries the ws-gateway impl + test, chat main.js, package.json, and the design doc, based on `llm` and currently CONFLICTING. Closed-as-superseded / kept / reconciled is your call.

- `20260706T025117Z-fc0dcd` — from gardener:build-endoclaw-network-fetch-http-client-capability, reply_to `build-endoclaw-network-fetch-http-client-capability` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T025117Z-fc0dcd.md)

> Build job `endoclaw-network-fetch` (HttpClient/HttpClientControl confined-outbound-HTTP pillar, M3): NOT building — the design is already delivered by two open PRs, so a third implementation would be waste. Surfacing for disposition.
>
> 1. PR #566 `feat(exo-http-client): add confined HttpClient` (base llm, DRAFT, ALL CI GREEN) by 0xpatrickbot — a complete, faithful `@endo/exo-http-client` package: `makeHttpClientAndControl` -> {client, control}, exact-origin allowlist via makeExo/M.interface, per-minute rate limit, response byte cap, redirect:'manual', revoke(). 1060-line impl + 514-line tests. It even EXCEEDS the design with trust-on-first-bind (which cli-http-client.md defers to a separate design). Matches endoclaw-network-fetch's capability shape exactly. Caveat: 0xpatrickbot is on mention-only-pr-authors/allowlist, so the garden must not drive/review #566 unless @-mentioned.
>
> 2. PR #286 `endo http mk Phase 1 (controller + client cap pair, cli-http-client.md)` (base llm, OPEN) by kriscendobot — the garden's OWN implementation of the maintainer-blessed SUPERSEDING design (cli-http-client.md; design revision PR #163 is MERGED). Daemon+CLI-integrated controller/client pair with ReadableBlob bodies and cancellation.
>
> History: PR #144 (single formula) was CLOSED with "take this back to design" -> produced cli-http-client.md (#163 merged) -> #286 builds it.
>
> Recommendation: The garden's delivery vehicle for this pillar is PR #286 (blessed design, garden-owned) — shepherd it through the gauntlet. #566 is the external contributor's parallel take on the original design; leave it be (mention-only). Mark the endoclaw-network-fetch design record Superseded-by cli-http-client (it currently reads "Not Started", which is stale). If you instead want a garden-owned standalone exo package on master base, say so and I'll build it.


## Board
### todo (0)
(none)

### doin (2)
- [`gauntlet-endo-but-for-bots-pr609-endoclaw-timer`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/gauntlet-endo-but-for-bots-pr609-endoclaw-timer.md) — ---
- [`xs2rust-endor-strings-utf16-test`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-strings-utf16-test.md) — Test/corpus: prove result parity + recalibrated meter for the UTF-16 string s...

### tada (1244)
- [`fix-ensure-project-worktree-silent-stale-fetch`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/fix-ensure-project-worktree-silent-stale-fetch.md) — Inbox is empty. Job complete.
- [`design-daemon-agent-tools-reconcile-mount-git-capabilities`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-daemon-agent-tools-reconcile-mount-git-capabilities.md) — **Completion report: design-daemon-agent-tools-reconcile-mount-git-capabiliti...
- [`deadmail-20260706T030053Z-a1f859`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260706T030053Z-a1f859.md) — Completion report
- [`xs2rust-endor-strings-utf16-build`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-strings-utf16-build.md) — Completion report
- [`design-gateway-bearer-token-auth-reconcile-endo-gateway`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-gateway-bearer-token-auth-reconcile-endo-gateway.md) — Completion report:
- … and 1239 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s8.md) — awaiting `xs2rust-endor-strings-utf16` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
