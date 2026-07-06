# Garden bulletin

_As of 2026-07-06T03:55:13Z_

## Latest

[endo-but-for-bots#608](https://github.com/endojs/endo-but-for-bots/pull/608) landed out of draft as the standalone docker-self-host slice — OPEN, MERGEABLE, CI green (15/15), now in the review queue. A focused panel caught one real must-fix (the documented `docker exec … endo` control command would have hit "endo: not found" because `node_modules/.bin` wasn't on the image PATH) plus a bundle of should-fixes; the fix is correct by construction but not runtime-proven, since the gardener sandbox has no Docker. The [endoclaw-timer gauntlet on #609](https://github.com/endojs/endo-but-for-bots/pull/609) also completed.

Most of this cycle's substance is **gardeners declining to build duplicates and surfacing disposition calls** rather than opening new PRs. Three overlapping docker-self-host attempts now coexist — [#608](https://github.com/endojs/endo-but-for-bots/pull/608) (docker files only), the comprehensive-but-stale [#134](https://github.com/endojs/endo-but-for-bots/pull/134) (CHANGES_REQUESTED), and 0xpatrickbot's conflicting [#568](https://github.com/endojs/endo-but-for-bots/pull/568) — and the builder is asking a real architecture question: does remote-auth wire into `ws-gateway.js` (the current design record) or wait for `@endo/gateway` per kriskowal's 2026-05 steer? Verified ws-gateway wiring + tests are parked on branch `wip/daemon-docker-selfhost-gateway-remote-auth` for whichever PR wins. Similarly, the confined-HTTP-client pillar is already served by garden-owned [#286](https://github.com/endojs/endo-but-for-bots/pull/286) (blessed `cli-http-client.md` design) and 0xpatrickbot's [#566](https://github.com/endojs/endo-but-for-bots/pull/566), so no third build was started. Both need a maintainer decision on which PR is canonical and how to dispose of the losers.

Finally, an infrastructure alarm worth acting on: the deterministic identity-drift guard fired three times reporting **`GARDEN=driftname` diverging from `hostname -s=endolinbot`** with no recorded override — which flips this true leader host to FOLLOWER and silently **skips every leader-only singleton** (foreman, scheduler, watchers). If endolinbot is the leader, `/home/kris/.garden` needs correcting to `endolinbot` and the pool restarted.

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

- `20260706T035229Z-97d0d7` — from gardener:build-endo-but-for-bots-daemon-docker-selfhost, reply_to `build-endo-but-for-bots-daemon-docker-selfhost` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T035229Z-97d0d7.md)

> Builder job `build-endo-but-for-bots-daemon-docker-selfhost` (design: `daemon-docker-selfhost.md`, "M3 keystone"): I did NOT open a 4th PR — three overlapping open PRs already implement this, and the maintainer previously deferred the exact approach the design record describes. Surfacing for adjudication.
>
> ## Existing open PRs (endojs/endo-but-for-bots)
> - **#134** (kriscendobot, DRAFT, base `llm`, CHANGES_REQUESTED, last touched 2026-06-28) — the COMPREHENSIVE one: docker/ + `ws-gateway.js` CIDR gate + `daemon-node.js` wiring + tests + static-file serving + a `docker.yml` CI workflow. Stale.
> - **#608** (kriscendobot, NON-draft, base `master-eecc683`, MERGEABLE, created 2026-07-05) — docker/ files ONLY (Dockerfile, entrypoint, compose, README, .dockerignore). Missing clause 4 (remote authentication) entirely.
> - **#568** (0xpatrickbot, DRAFT, base `llm`, CONFLICTING, 2026-06-29) — a third-party attempt, 12 files.
>
> ## The architecture question (why I'm asking, not building)
> kriskowal's own review on **#134** (2026-05-13) requested changes and said: *"We need to make progress on the Endo Gateway concept before we can sensibly run under Docker. The Gateway subsumes the ws-gateway.js here with the Weblet virtual host and will require its own entrypoint. The gateway itself is presumably also a daemon, but instantiated at the system level."* Issue #173 (Endo Gateway requirements) is now CLOSED and the `@endo/gateway` package skeleton has landed (`packages/gateway/src/{config,vhost}.js`, `ENDO_HTTP_ADDR`, `0.0.0.0:8920` default) — but the daemon still runs its runtime gateway on `ws-gateway.js`; `@endo/gateway` is not yet wired into the daemon's path.
>
> So the design record (`daemon-docker-selfhost.md`, still "Not Started") describes the **ws-gateway.js** approach the maintainer said was being subsumed. Building clause 4 (remote auth) into `ws-gateway.js` now — which #134 already did and which I independently re-verified works — may be building on the foundation the maintainer wants replaced by `@endo/gateway`.
>
> ## What I verified (useful either way)
> I implemented + tested the gateway remote-auth wiring on base `llm`: wired the already-built-but-unwired `cidr.js makeAddressChecker` into `ws-gateway.js` (localhost-only by default, `ENDO_GATEWAY=remote` / `ENDO_GATEWAY_ALLOWED_CIDRS` opt-in, closes disallowed clients with the README's documented "Only local connections allowed", TLS warning), plus `daemon-node.js` env reads and 5 new ava tests in `ws-gateway.test.js` (all green; the reject test is regression-proven — it fails when the gate is removed). This confirms the ws-gateway approach is a ~40-line, testable change. It also confirms **the gateway-bearer-token-auth design (marked Complete) shipped its README + checker + unit tests but its wiring into ws-gateway.js was never landed** — that gap is real regardless of which PR wins.
>
> ## Recommendation
> Consolidate to ONE PR and settle the base architecture first:
> 1. Decide whether Docker remote-auth wires into **ws-gateway.js** (current design record; #134's approach) or should wait for/build on **`@endo/gateway`** (the maintainer's 2026-05 steer). If ws-gateway is fine for now, the fastest path is to refresh **#134** (rebase, add the CI test kriskowal asked for, address the CHANGES_REQUESTED) rather than start fresh — it already has everything.
> 2. Close the losers (#568 conflicting third-party; #608 or #134 depending on the choice).
> 3. Update `daemon-docker-selfhost.md` if the gateway pivot changes the design.
>
> I have the verified gateway wiring + tests ready to hand to whichever PR becomes canonical. Tell me which way to go (refresh #134 / extend #608 / rebuild on @endo/gateway) and I'll execute.

- `20260706T035346Z-7823c6` — from gardener:build-endo-but-for-bots-daemon-docker-selfhost, reply_to `build-endo-but-for-bots-daemon-docker-selfhost` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T035346Z-7823c6.md)

> Follow-up to the daemon-docker-selfhost surface: my verified work is pushed (no PR) to branch `wip/daemon-docker-selfhost-gateway-remote-auth` on endojs/endo-but-for-bots, off origin/llm tip (1132289). Contains the ws-gateway.js CIDR wiring + daemon-node.js env reads + 5 green ws-gateway.test.js tests + the docker/ image. Cherry-pick or rebase onto the canonical PR once you decide the direction.


## Board
### todo (0)
(none)

### doin (1)
- [`xs2rust-endor-stage4-accessors-attributes`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage4-accessors-attributes.md) — Stage-4 child: accessor properties, full property descriptors, freeze/seal (h...

### tada (1252)
- [`build-endo-but-for-bots-daemon-docker-selfhost`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-endo-but-for-bots-daemon-docker-selfhost.md) — Completion report: build-endo-but-for-bots-daemon-docker-selfhost
- [`mention-kriskowal-garden-26-fd0eac1c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-kriskowal-garden-26-fd0eac1c.md) — Comment is live and rendered; inbox is empty. This was a design-memo reply ta...
- [`gauntlet-endo-but-for-bots-pr609-endoclaw-timer`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/gauntlet-endo-but-for-bots-pr609-endoclaw-timer.md) — Completion report
- [`deadmail-issue-comment-4888913059`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4888913059.md) — Completion report
- [`port-xs-to-rust-memory-safe-engine-s8`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/port-xs-to-rust-memory-safe-engine-s8.md) — Completion report — port-xs-to-rust-memory-safe-engine-s8
- … and 1247 more

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
- [`port-xs-to-rust-memory-safe-engine-s9`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s9.md) — awaiting `xs2rust-endor-build-stage4` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
