# Garden bulletin

_As of 2026-07-24T16:04:49Z_

## Latest

On the board, minion.town's MCP work advanced: [B1 socket-adapter](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-mcp-b1-socket-adapter.md) completed (it was already implemented and merged in an earlier commit) and B2 (first real per-session guest tools) was claimed; the PR #701 SturdyRef restack onto the PR #737 line and a fresh red-CI shepherd on [endo-but-for-bots#831](https://github.com/endojs/endo-but-for-bots/pull/831) also went in-flight.

Two things want a maintainer decision. [endo-but-for-bots#824](https://github.com/endojs/endo-but-for-bots/pull/824) is non-draft with green CI and a clean merge state but is stuck on a **stale approval** — kriskowal's APPROVED review is pinned to the old head `9b40eef`, while the current head is `a0cd0d0`, so the conductor gate needs a re-approval on the current head before it can merge. Separately, the [endo-but-for-bots#804](https://github.com/endojs/endo-but-for-bots/pull/804) review is **holding for an intent confirm** before churning design docs: the landed facts (`@endo/syrup-frame` shipped, no CBOR framing pkg landed) contradict `cbors.md`/`syrups.md`, and the gardener wants a Y/N on renaming both docs to the `-frame` convention.

Reliability pressure on the leader host: the hourly [xs2rust-endor #600](https://github.com/endojs/endo-but-for-bots/pull/600) press-driver, `endojs-pr160-ci-fix-finalize`, and `daemon-store-phase4-sorted` all **deterministically overran the 2400s handler budget and were poisoned/parked** — the daemon-store-family-build orchestration halted at 3/6 children as a result. These jobs exceed a single claim-scoped handler and need to be split into stages or run detached before they can make progress.

The finbot [PR #4](https://github.com/kriscendobot/finbot/pull/4) SES-compartment role-program feature reached green CI and is mergeable, but is blocked purely on governance — the 28-seat panel can't run until the panel model's weekly limit resets (Jul 25 03:00 UTC), so no Fable sign-off yet. Research also landed a clear verdict on **Kimi K3**: locally infeasible (>10× the box's memory, weights not public until Jul 27), but cheap to wire as a hosted OpenAI-compatible arm for the bid-auction if a funded Moonshot key and codex tool-call compatibility check out.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/pull/621) — design: refine endoclaw-oauth as the connector credential foundation (settle first-mint flow) (waiting 12h)
- [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/pull/705) — feat(agent-tools): git remote push tier — makeGitRemoteTool (fetch/pull/push) (waiting 1d)
- [endojs/endo-but-for-bots#806](https://github.com/endojs/endo-but-for-bots/pull/806) — fix(ocapn-noise): refuse late crossed-hello SYN instead of minting a doomed session (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 5d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 6d)
- [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671) — feat(daemon): EndoRegistry capability and required @registry host name (waiting 6d)
- [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) — feat(pass-style): narrow byteArray to plain frozen Uint8Array (waiting 7d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 7d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 10d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260722T060407Z-8a88fc` — from orchestrator:daemon-store-family-build-halted, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260722T060407Z-8a88fc.md)

> Orchestration daemon-store-family-build HALTED: child daemon-store-phase4-sorted failed (serial, on-child-failure=halt). 3/6 done before halt; swept: daemon-store-phase5-parity daemon-store-phase6-cli-wui

- `20260722T223418Z-6d697e` — from gardener:endojs-endo-but-for-bots-pr826-build, reply_to `endojs-endo-but-for-bots-pr826-build` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260722T223418Z-6d697e.md)

> Build is blocked: design PR [https://github.com/endojs/endo-but-for-bots/pull/826](https://github.com/endojs/endo-but-for-bots/pull/826) remains OPEN and unmerged into llm (confirmed 2026-07-22T22:34:11Z). Per the job prerequisite, I have not started an implementation branch or PR. Please merge it or direct an exception; the job can then resume on llm.

- `20260723T004606Z-d721bb` — from orchestrator:minion-town-mcp-daemon-guest-tools-orchestration-halted, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T004606Z-d721bb.md)

> Orchestration minion-town-mcp-daemon-guest-tools-orchestration HALTED: child minion-town-mcp-b5-retire-toy-tools failed (serial, on-child-failure=halt). 5/7 done before halt; swept: minion-town-mcp-b6-extract-endo-mcp

- `20260723T112821Z-c23414` — from issue-inbox-watcher, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T112821Z-c23414.md)

> kind: access-request
>
> @PatrickMockridge interacted with the garden's issue inbox on kriskowal/garden #38 but is NOT on
> the maintainer allowlist, so the interaction was DROPPED (dispatched
> nothing). If this is a collaborator you want to let drive the garden by
> issue, add them:
>
>     scripts/jobs/add-maintainer.sh PatrickMockridge
>
> After that, FUTURE issues/comments from @PatrickMockridge will dispatch — but THIS one
> was already dropped, so ask them to re-post it (or re-post it yourself)
> if it still matters.
>
> Interaction: [https://github.com/kriskowal/garden/issues/38](https://github.com/kriskowal/garden/issues/38)#issuecomment-5057850972
>
> You are shown this ONCE per individual. Reply or archive to dismiss it.

- `20260723T193026Z-d2e1f9` — from triager:kriscendobot-proposal-compartments, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T193026Z-d2e1f9.md)

> kind: error
>
> # triage circuit-breaker OPENED for `kriscendobot-proposal-compartments`
>
> The triage handler (`/home/kris/garden/scripts/jobs/handlers/triager-claude.sh`) FAILED 5 consecutive times on the SAME change
> and hit the threshold (`GARDEN_TRIAGE_FAIL_THRESHOLD=5`).
>
> - Repo slug: `kriscendobot-proposal-compartments`  (watched ref `main`)
> - Failing range: `7e60fdbce66ef2d97370007afeb807192c653333` → `d23d7ded5531d901e258e1d2df15129ea04c10b9`
>
> Because the transition is deterministic (same old→new SHAs, same diff), retrying
> cannot help — it only crash-loops the `garden-triager@kriscendobot-proposal-compartments` unit and fills the
> journal. The breaker is now OPEN: this sha will NOT be re-triaged until a NEW
> change appears on `kriscendobot-proposal-compartments:main`, which clears the breaker automatically.
>
> Investigate the handler failure (reproduce by hand:
> `/home/kris/garden/scripts/jobs/handlers/triager-claude.sh kriscendobot-proposal-compartments 7e60fdbce66ef2d97370007afeb807192c653333 d23d7ded5531d901e258e1d2df15129ea04c10b9 <bare>`), or, if this repo should not be watched
> at all, remove it from the watch set. Note: under CLAUDE.md § Monitoring safety
> constraint only `endojs/endo-but-for-bots` is currently authorized for watching —
> worth confirming `kriscendobot-proposal-compartments` belongs in the set.

- `20260723T205604Z-9cb169` — from gardener:drive-mystic-rollout-20260723, reply_to `drive-mystic-rollout-20260723` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T205604Z-9cb169.md)

> Rollout operational preconditions checked: the user systemd manager has MOONSHOT_API_KEY present (value not inspected or printed), and the official Kimi Code installer completed with kimi 0.29.0 at ~/.kimi-code/bin/kimi. A cleric has claimed the linked mystic recovery implementation. Please keep deployment deliberate: do not deploy or enable Mystic until its independent validation finishes; then use the bounded one-worker canary and scale back to zero.

- `20260723T210657Z-8a2ea9` — from gardener:kimi-k3-harness-implement-20260723, reply_to `kimi-k3-harness-implement-20260723` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T210657Z-8a2ea9.md)

> Kimi Code harness is deployment-ready on main2 at a1dd8984510f83c38f438f9aac5c5429ac5d3bbd. It adds the explicit-only mystic worker kind with the official Kimi Code CLI, isolated per-job KIMI_CODE_HOME/session resume, marker-gated completion, credential-safe KIMI_MODEL_* injection, and zero-default scaling. Offline verification passed: kimi-provider-test (18), worker-spine-kinds-test (101), model-routing-test (29), scaler-desired-count-test (12), completion-signal-test, handler-orphan-reap-test (15), and foreman-provider-order-test (8). No funded live Kimi canary was run; keep mystics at zero until the documented canary.

- `20260723T211816Z-877dbc` — from gardener:drive-mystic-rollout-20260723, reply_to `drive-mystic-rollout-20260723` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T211816Z-877dbc.md)

> Mystic rollout has a deployment and credential blocker. I independently verified the landed harness and corrected the official Kimi Code wire-model mapping on main2 at bf1f9e4032 (garden selector `kimi-k3` maps to Kimi Code model `k3`; dedicated Mystic remains moonshot and explicit-only). Focused offline harness, model-routing, worker-spine, and foreman routing tests pass. Please deliberately deploy main2 through the liaison procedure, recreate the container with MOONSHOT_API_KEY injected without printing it, then run the documented one-worker reversible tool canary and scale Mystic back to zero. This host currently has no `kimi` executable, no `MOONSHOT_API_KEY` in user systemd, and no Mystic unit, so a live canary cannot truthfully be run here. The original implementation child remains in doin after its recorded Claude failure; I did not alter its claim and left it for the reaper's normal ownership/requeue path. Monk remains at zero.

- `20260723T212425Z-60b4e4` — from gardener:drive-mystic-rollout-20260723, reply_to `drive-mystic-rollout-20260723` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T212425Z-60b4e4.md)

> Mystic implementation and independent validation are complete on main2 at bf1f9e4032. I independently reran mystic-kimi-harness-test (14), worker-spine-kinds (103), model-routing (29), and foreman-provider-order (10), all passing. Please perform the deliberate drained deploy from the leader liaison after this orchestration job is no longer busy, then notify me so I can run the one-worker reversible canary and return capacity to zero.

- `20260723T213341Z-77bddd` — from gardener:drive-mystic-rollout-20260723, reply_to `drive-mystic-rollout-20260723` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T213341Z-77bddd.md)

> Real blocker: despite completed implementation/validation, the deliberate deployment is still pending (root remains 1239f16ff; main2 bf1f9e4032). I have re-alerted the leader liaison; the live one-worker canary cannot run safely until deployed.

- `20260723T214650Z-cb691c` — from identity-drift-guard:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T214650Z-cb691c.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolin-garden-ece02cb4`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-yeWDHL/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolin-garden-ece02cb4' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** an inherited-env `GARDEN` pinned for the fleet (commonly
> `~/.config/environment.d/*.conf`, which the systemd --user manager inherits;
> common.sh precedence step 1). Identity is otherwise DERIVED from `hostname -s`;
> there is no `.garden` file consulted anymore. This is the endolinbot2 regression
> class.
>
> **Fix:** remove the pinned `GARDEN` (delete the environment.d entry, then
> `systemctl --user unset-environment GARDEN` and restart the pool) so identity
> falls back to the derived `endolin-garden-ece02cb4`; if this is a deliberate parallel pool,
> record the override in `/tmp/idg-yeWDHL/state/identity-override` (or export
> GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.

- `20260723T214655Z-e04fac` — from identity-drift-guard:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T214655Z-e04fac.md)

> kind: error
>
> # Host-identity DRIFT detected (deterministic guard)
>
> **GARDEN=`driftname`** diverges from **hostname -s=`endolin-garden-ece02cb4`** on this host,
> with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
> `/tmp/idg-yeWDHL/state/identity-override`).
>
> GARDEN is the single key every per-host structure hangs off — claim metadata, the
> `hosts/<host>` worker count, the journal index, and the leader/follower
> predicate. An unrecorded divergence silently mislabels all of it (here: up to this
> host's full gardener pool) and disables the leader gate.
>
> **Leader impact:** is-main-host reports FOLLOWER: the leader marker names 'endolin-garden-ece02cb4' (this host's real hostname -s), but the drifted GARDEN=driftname does not match it — every leader-only singleton is being SKIPPED on the true leader host
>
> **Likely source:** an inherited-env `GARDEN` pinned for the fleet (commonly
> `~/.config/environment.d/*.conf`, which the systemd --user manager inherits;
> common.sh precedence step 1). Identity is otherwise DERIVED from `hostname -s`;
> there is no `.garden` file consulted anymore. This is the endolinbot2 regression
> class.
>
> **Fix:** remove the pinned `GARDEN` (delete the environment.d entry, then
> `systemctl --user unset-environment GARDEN` and restart the pool) so identity
> falls back to the derived `endolin-garden-ece02cb4`; if this is a deliberate parallel pool,
> record the override in `/tmp/idg-yeWDHL/state/identity-override` (or export
> GARDEN_IDENTITY_OVERRIDE=`driftname`) so this guard stays quiet.
>
> Posted once per distinct drift state by `scripts/jobs/identity-drift-guard.sh`
> (gardener-scaler preflight). It will not repeat until the drift changes or clears.

- `20260723T215345Z-771502` — from gardener:drive-mystic-rollout-20260723, reply_to `drive-mystic-rollout-20260723` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T215345Z-771502.md)

> Evidence update: independent validation is now complete and passing (`mystic-harness-validate-20260723`), including official Kimi CLI use, explicit Mystic/Moonshot/kimi-k3 routing, KIMI_CODE_HOME isolation, sentinel/resume/cleanup, no default capacity, and provider-scoped reputation. main2 remains bf1f9e4032 while the deployed root is still pre-deploy, so requirements 5-7 are pending the leader's deliberate deployment and secret-safe container recreation. No Mystic capacity was enabled; Monk remains zero. After deployment, the only remaining sequence is one explicit reversible tool canary, inspect its Moonshot-scoped reputation event and interruption/resume evidence, then set Mystic back to zero.

- `20260723T221404Z-bd5cb3` — from gardener:drive-mystic-rollout-20260723, reply_to `drive-mystic-rollout-20260723` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260723T221404Z-bd5cb3.md)

> Real deployment blocker: deliberate deploy correctly aborted because the deployed root is dirty (D journal/jobs/tada/mirror-endo-2780-cache-globals-gauntlet/report.md; M roles/liaison/AGENT.md). I will not modify or discard deployed-root state. Leader must resolve it then rerun deploy; Mystic remains zero and the canary has not run.

- `20260724T072629Z-9e4c4f` — from gardener:garden-fix-mystic-canary-runtime-20260724, reply_to `garden-fix-mystic-canary-runtime-20260724` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T072629Z-9e4c4f.md)

> The repair is landed and local regressions are green. I attempted the required deliberate deploy, but its drain correctly waits on this still-active gardener claim, which would deadlock the job. Please have the liaison deploy `scripts/jobs/deploy-garden.sh` immediately after this claim completes; then the remaining canary step must run on the deployed worker spine.

- `20260724T075343Z-549535` — from gardener:garden-fix-mystic-canary-runtime-20260724, reply_to `garden-fix-mystic-canary-runtime-20260724` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T075343Z-549535.md)

> Deliberate deployment is blocked by tracked changes in the deployed root: roles/liaison/AGENT.md and journal/jobs/tada/mirror-endo-2780-cache-globals-gauntlet/report.md. The deploy guard correctly refused to overwrite them and lifted the drain. Please resolve or deploy those root changes, then this job can run exactly one Kimi canary. No credential values were read or logged.

- `20260724T110405Z-e89417` — from watchdog:triager/kriscendobot-agoric-3-proposals, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T110405Z-e89417.md)

> triager: fetch for kriscendobot-agoric-3-proposals at /home/kris/garden2/worktrees/kriscendobot-agoric-3-proposals.git failed (rc=128). Retrying next tick; if this persists, the upstream is unreachable and kriscendobot-agoric-3-proposals cannot be triaged until it is restored.

- `20260724T110411Z-b356af` — from watchdog:triager/kriscendobot-endo, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T110411Z-b356af.md)

> triager: fetch for kriscendobot-endo at /home/kris/garden2/worktrees/kriscendobot-endo.git failed (rc=1). Retrying next tick; if this persists, the upstream is unreachable and kriscendobot-endo cannot be triaged until it is restored.

- `20260724T111218Z-b77592` — from watchdog:triager/kriscendobot-minion.town, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T111218Z-b77592.md)

> triager: fetch for kriscendobot-minion.town at /home/kris/garden2/worktrees/kriscendobot-minion.town.git failed (rc=1). Retrying next tick; if this persists, the upstream is unreachable and kriscendobot-minion.town cannot be triaged until it is restored.

- `20260724T145608Z-699a80` — from gardener:finbot-progress-20260724-105003, reply_to `finbot-progress-20260724-105003` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T145608Z-699a80.md)

> Advanced the panel gate attempt for [https://github.com/kriscendobot/finbot/pull/4](https://github.com/kriscendobot/finbot/pull/4). CI remains green on 895ae4822d3c0f36c4026c9bcbddcbcc59f81c62, but the code panel is still blocked at assessor by the Claude weekly-limit response. The scheduled retry at 2026-07-25T03:05:00Z remains the next unblocked step; if it passes, it will dispatch the required Fable orchestrator sign-off. No merge or source change occurred.

- `20260724T155925Z-606f6d` — from watchdog:triager/kriscendobot-garden, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T155925Z-606f6d.md)

> triager: fetch for kriscendobot-garden at /home/kris/garden2/worktrees/kriscendobot-garden.git failed (rc=128). Retrying next tick; if this persists, the upstream is unreachable and kriscendobot-garden cannot be triaged until it is restored.

- `20260724T160112Z-d43ec3` — from watchdog:triager/kriscendobot-endo, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T160112Z-d43ec3.md)

> triager: fetch for kriscendobot-endo at /home/kris/garden2/worktrees/kriscendobot-endo.git failed (rc=1). Retrying next tick; if this persists, the upstream is unreachable and kriscendobot-endo cannot be triaged until it is restored.

- `20260724T160432Z-73d845` — from watchdog:triager/kriscendobot-agoric-sdk, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260724T160432Z-73d845.md)

> triager: fetch for kriscendobot-agoric-sdk at /home/kris/garden2/worktrees/kriscendobot-agoric-sdk.git failed (rc=1). Retrying next tick; if this persists, the upstream is unreachable and kriscendobot-agoric-sdk cannot be triaged until it is restored.

- `poison-build-readableblob-range-attenuation-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-build-readableblob-range-attenuation-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/build-readableblob-range-attenuation; it stays HELD until a human promotes it
> (promote-plan.sh build-readableblob-range-attenuation) or removes it, so nothing is lost.
> Original job base: build-readableblob-range-attenuation
>
> --- original job body ---

- `poison-drive-mystic-rollout-20260723-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-drive-mystic-rollout-20260723-requeue-exhausted.md)

> POISON notice — occurrence #2 (first seen 2026-07-23T22:23:07Z, latest 2026-07-24T02:23:06Z).
> This job has been poison-parked 2 times for the same condition (requeue-exhausted);
> this is an AMENDED notice, not a new one. Latest detail:
>
> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/drive-mystic-rollout-20260723; it stays HELD until a human promotes it
> (promote-plan.sh drive-mystic-rollout-20260723) or removes it, so nothing is lost.
> Original job base: drive-mystic-rollout-20260723
>
> --- original job body ---
> ---
> role: orchestrator
> model: gpt-5.6-terra
> handler-timeout: 10800
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-24T00:44:51Z -->
>
> model: gpt-5.6-terra
> role: orchestrator
> handler-timeout: 10800
> Drive the Mystic (Moonshot Kimi K3 via official Kimi Code CLI) rollout to verified completion.
>
> Own and recover the existing serial orchestration kimi-k3-harness-rollout-20260723 and its children kimi-k3-harness-implement-20260723 and kimi-k3-harness-validate-20260723. The implementation child is stranded in doin after a Claude quota failure; all Claude monk workers are intentionally disabled and must remain unable to claim jobs. Use the normal board/reaper/requeue mechanisms or create a clearly linked replacement child if recovery cannot safely reassign it. Ensure implementation work is performed by a non-Anthropic backend, preferably the Codex cleric path.
>
> Completion means all of the following: (1) land a dedicated worker kind named mystic, provider moonshot, model kimi-k3, using the official Kimi Code CLI rather than Codex Responses; (2) preserve explicit-model-only routing, isolated per-job worktree and KIMI_CODE_HOME, secret hygiene, bounded process cleanup, output/report capture, completion sentinel, resume/requeue behavior, and reputation metadata; (3) add and pass focused offline and worker-spine regression tests; (4) independently validate the landed implementation; (5) coordinate with the leader liaison for deliberate deployment of main2 rather than editing the deployed root; (6) ensure MOONSHOT_API_KEY reaches user systemd without printing it and install the supported Kimi Code CLI; (7) enable exactly one Mystic only for a reversible tool-using canary, prove correct worker/provider/model reputation scope plus interruption/resume behavior, then return Mystic capacity to zero unless the maintainer explicitly authorizes otherwise; and (8) leave monk capacity at zero.
>
> Do not make Kimi a default, do not enable high-stakes design/build routing, do not delete failed diagnostic evidence, and do not bypass the journal claim/completion contracts. Monitor every stage instead of merely posting follow-ups. Send concise progress only for a real blocker and send the final evidence-backed result to the maintainer inbox.

- `poison-garden-fix-mystic-canary-runtime-20260724-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-garden-fix-mystic-canary-runtime-20260724-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/garden-fix-mystic-canary-runtime-20260724; it stays HELD until a human promotes it
> (promote-plan.sh garden-fix-mystic-canary-runtime-20260724) or removes it, so nothing is lost.
> Original job base: garden-fix-mystic-canary-runtime-20260724
>
> --- original job body ---
> model: gpt-5.6-terra
> role: fixer
> Fix and revalidate the Kimi K3 Mystic canary runtime in kriskowal/garden.
>
> Observed live failure on both kimi-k3-canary-20260723-c and -d: scripts/jobs/gardener.sh line 481 calls reap_process_group, but the function is absent at runtime, so mystic/1 exits rc=1 immediately after the handler. Restore the helper in the shared worker spine/common library with its documented safety guards and add a regression that runs the real deployed call path, not only a sourced fixture. Re-run handler-orphan-reap, mystic-kimi-harness, worker-spine, completion, and routing tests.
>
> Also audit and harden secret-safe Moonshot propagation against the established Anthropic path: garden passes ANTHROPIC_API_KEY via Docker -e at container creation; PID 1 -> systemd --user -> worker unit inheritance supplies it without embedding secrets in unit files. MOONSHOT_API_KEY should follow the same path, with deterministic presence-only diagnostics and documentation that existing containers require secret-safe recreation. Do not print, inspect, persist, or commit credential values.
>
> After landing and deliberate deployment coordination, requeue exactly one reversible kimi-k3 canary, validate completion plus mystic/moonshot/kimi-k3 reputation scope, and return mystics to 0. Keep monks at 0 throughout. Preserve the failed canary evidence and use normal board/reaper contracts.

- `poison-minion-town-mcp-b5-retire-toy-tools-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-minion-town-mcp-b5-retire-toy-tools-requeue-exhausted.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/minion-town-mcp-b5-retire-toy-tools; it stays HELD until a human promotes it
> (promote-plan.sh minion-town-mcp-b5-retire-toy-tools) or removes it, so nothing is lost.
> Original job base: minion-town-mcp-b5-retire-toy-tools
>
> --- original job body ---
> ---
> role: builder
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T22:31:03Z -->
>
> # B5: retire toy tools
>
> Repository: kriscendobot/minion.town.
>
> After B4, implement B5 from designs/mcp-daemon-guest-tools.md §7. Delete minion_status, list_minions, summon_minion, their in-memory Map, and their scope rows. Stop advertising mcp/minions:*; rewrite the server.ts toy header for facet-backed guest tools; update README and DEPLOYMENT.md phase rows; clean Cognito scope configuration. Guest tools now mount unconditionally, returning clean daemon-unavailable errors when the socket is absent.
>
> Validation required at deployed edge: a fresh tools/list has only guest_* tools, then rerun full E1-E4 sweep green. Report concrete command/run evidence.


## Spend & quota
_Trailing 7d window; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 58.2M | $673.66 _(notional, rate-card)_ | no quota set |
| Codex | 592.7M _(+358.5M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 64% _(plan; codex-reported)_ |

## Board
### todo (2)
- [`kimi-k3-canary-20260723-c`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/kimi-k3-canary-20260723-c.md) — model: kimi-k3
- [`kimi-k3-canary-20260723-d`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/kimi-k3-canary-20260723-d.md) — model: kimi-k3

### doin (26)
- [`arc-status-daily-20260723-030512`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/arc-status-daily-20260723-030512.md) — Daily status + change summary for the standing review arcs
- [`arc-status-daily-20260724-032002`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/arc-status-daily-20260724-032002.md) — Daily status + change summary for the standing review arcs
- [`endo-byte-array-press-20260723-162019`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-byte-array-press-20260723-162019.md) — Press passable/immutable byte arrays forward (endojs/endo-but-for-bots, base ...
- [`endo-byte-array-press-20260723-223502`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-byte-array-press-20260723-223502.md) — Press passable/immutable byte arrays forward (endojs/endo-but-for-bots, base ...
- [`endo-byte-array-press-20260724-043515`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-byte-array-press-20260724-043515.md) — Press passable/immutable byte arrays forward (endojs/endo-but-for-bots, base ...
- [`endo-byte-array-press-20260724-105003`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-byte-array-press-20260724-105003.md) — Press passable/immutable byte arrays forward (endojs/endo-but-for-bots, base ...
- [`endo-git-integration-press-20260723-162019`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-git-integration-press-20260723-162019.md) — Press git-integration / the M3 version-controlled-filesystem loop (endojs/end...
- [`endo-git-integration-press-20260723-223502`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-git-integration-press-20260723-223502.md) — Press git-integration / the M3 version-controlled-filesystem loop (endojs/end...
- [`endo-git-integration-press-20260724-043515`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-git-integration-press-20260724-043515.md) — Press git-integration / the M3 version-controlled-filesystem loop (endojs/end...
- [`endo-git-integration-press-20260724-105003`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-git-integration-press-20260724-105003.md) — Press git-integration / the M3 version-controlled-filesystem loop (endojs/end...
- [`endo-npm-cas-registry-press-20260723-162019`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-npm-cas-registry-press-20260723-162019.md) — Press npm-via-CAS registry-proxy forward (endojs/endo-but-for-bots, base llm)
- [`endo-npm-cas-registry-press-20260723-223502`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-npm-cas-registry-press-20260723-223502.md) — Press npm-via-CAS registry-proxy forward (endojs/endo-but-for-bots, base llm)
- [`endo-npm-cas-registry-press-20260724-043515`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-npm-cas-registry-press-20260724-043515.md) — Press npm-via-CAS registry-proxy forward (endojs/endo-but-for-bots, base llm)
- [`endo-npm-cas-registry-press-20260724-105003`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-npm-cas-registry-press-20260724-105003.md) — Press npm-via-CAS registry-proxy forward (endojs/endo-but-for-bots, base llm)
- [`endo-sturdyref-press-20260723-162019`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-sturdyref-press-20260723-162019.md) — Press the SturdyRef effort forward — OCapN sturdyrefs + provide/accept throug...
- [`endo-sturdyref-press-20260723-223502`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-sturdyref-press-20260723-223502.md) — Press the SturdyRef effort forward — OCapN sturdyrefs + provide/accept throug...
- [`endo-sturdyref-press-20260724-043515`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-sturdyref-press-20260724-043515.md) — Press the SturdyRef effort forward — OCapN sturdyrefs + provide/accept throug...
- [`endo-sturdyref-press-20260724-105003`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-sturdyref-press-20260724-105003.md) — Press the SturdyRef effort forward — OCapN sturdyrefs + provide/accept throug...
- [`endo-vfs-parity-press-20260723-162019`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-vfs-parity-press-20260723-162019.md) — Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endo-vfs-parity-press-20260723-223502`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-vfs-parity-press-20260723-223502.md) — Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endo-vfs-parity-press-20260724-043515`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-vfs-parity-press-20260724-043515.md) — Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endo-vfs-parity-press-20260724-105003`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endo-vfs-parity-press-20260724-105003.md) — Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260723-162019`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ocapn-noise-press-20260723-162019.md) — Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260723-223502`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ocapn-noise-press-20260723-223502.md) — Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260724-043515`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ocapn-noise-press-20260724-043515.md) — Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260724-105003`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ocapn-noise-press-20260724-105003.md) — Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)

### tada (3381)
- [`finbot-progress-20260724-105003`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/finbot-progress-20260724-105003.md) — Advanced PR #4’s panel gate attempt. CI remains green; the code panel again s...
- [`daily-progress-summary-20260724-070501`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/daily-progress-summary-20260724-070501.md) — Wrote and pushed journal/periodicals/2026/07/23.md to journal2 (commit f54937...
- [`finbot-progress-20260724-043515`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/finbot-progress-20260724-043515.md) — Advanced https://github.com/kriscendobot/finbot/pull/4: CI and local verifica...
- [`endojs-endo-but-for-bots-pr621-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr621-shepherd.md) — CI is green on head ee359efb57f259bdb99b88f756e1024a138a6b97. The initially c...
- [`weave-endo-but-for-bots-pr621-endoclaw-oauth-20260724`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/weave-endo-but-for-bots-pr621-endoclaw-oauth-20260724.md) — Rebased PR #621 onto llm 28dffa9, resolved both design-index conflicts preser...
- … and 3376 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`build-readableblob-range-attenuation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · ---
- [`daemon-store-phase4-sorted`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/daemon-store-phase4-sorted.md) — _normal_ · Build Phase 4: sorted variants and range queries (design Phase 4)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`drive-mystic-rollout-20260723`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _normal_ · ---
- [`ebfb-124-resume-rebase-review-fixups`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-resume-rebase-review-fixups.md) — _normal_ · ---
- [`ebfb-124-sqlite-iterate-streaming`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-iterate-streaming.md) — _normal_ · ---
- [`ebfb-124-sqlite-pragma-simple`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-pragma-simple.md) — _normal_ · ---
- [`ebfb-124-sqlite-shutdown-checkpoint`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-shutdown-checkpoint.md) — _normal_ · ---
- [`endo-git-integration-press-20260722-095006`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-git-integration-press-20260722-095006.md) — _normal_ · Press git-integration / the M3 version-controlled-filesystem loop (endojs/end...
- [`endo-master-fb9cef4-ci-build-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-master-fb9cef4-ci-build-gauntlet.md) — _normal_ · ---
- [`endo-vfs-parity-press-20260717-182002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-vfs-parity-press-20260717-182002.md) — _normal_ · Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endojs-endo-but-for-bots-pr124-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr124-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr160-fixer`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr160-fixer.md) — _normal_ · fixer (shepherd→fixer auto-chain) on endojs/endo-but-for-bots PR #160
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`endojs-endo-but-for-bots-pr704-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr704-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704
- [`endojs-endo-but-for-bots-pr763-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr763-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
- [`endojs-endo-but-for-bots-pr806-conduct`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr806-conduct.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr809-review-2f33af27`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-2f33af27.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #809
- [`endojs-endo-but-for-bots-pr824-build`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr824-build.md) — _normal_ · Build @endo/sha256 from the approved platform-neutral hash design
- [`endojs-endo-but-for-bots-pr826-build`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr826-build.md) — _normal_ · Build the approved ReadableBlob range-attenuation design from PR #826
- [`endojs-pr160-ci-fix-finalize`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-pr160-ci-fix-finalize.md) — _normal_ · ---
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _normal_ · ---
- [`garden-style-url-not-path`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-url-not-path.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr661-agent-tools-http-client`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop.md) — _normal_ · ---
- [`kriscendobot-agoric-sdk-pr15-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd.md) — _normal_ · shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/merge-upstream-master-into-llm-20260717.md) — _normal_ · Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`minion-town-mcp-b2-first-guest-tools-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/minion-town-mcp-b2-first-guest-tools-gauntlet.md) — _normal_ · ---
- [`minion-town-mcp-b5-retire-toy-tools`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/minion-town-mcp-b5-retire-toy-tools.md) — _normal_ · B5: retire toy tools
- [`ocapn-noise-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260717-000503.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260717-182002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260717-182002.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260719-003513`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260719-003513.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`weave-endo-but-for-bots-pr626-stack-surgery-eval`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval.md) — _normal_ · Weave endojs/endo-but-for-bots PR #626 (Phase-5 stack-surgery eval) onto llm
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer
- [`xs2rust-endor-press-20260720-022510`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-022510.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-123515`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-123515.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-145005`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-145005.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-172003`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-172003.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-192031`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-192031.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-203502`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-203502.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-215002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-215002.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-230516`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-230516.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-002001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-002001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-022003`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-022003.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-043501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-043501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-053503`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-053503.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-063505`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-063505.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-100501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-100501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-122001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-122001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-143501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-143501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-165010`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-165010.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-180501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-180501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-202001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-202001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260722-012002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260722-012002.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260722-033502`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260722-033502.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260722-045001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260722-045001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260722-055018`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260722-055018.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-stage10p-fresh-env-sweep`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-stage10p-fresh-env-sweep.md) — _normal_ · Stage-10p child 3 (re-posted by s47 after the serial-halt sweep — spec unchan...

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr809-review-722e1113-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-722e1113-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr809-review-39ff950a-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-39ff950a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`kriscendobot-minion.town-pr12-a3def291-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr12-a3def291-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #12 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr719-review-9fcf7da1-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr719-review-9fcf7da1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #719 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr705-review-207112c7-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr705-review-207112c7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #705 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr160-review-85ea7a37-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr160-review-85ea7a37-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #160 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr792-review-91808a86-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr792-review-91808a86-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #792 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr160-review-b7e466e9-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr160-review-b7e466e9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #160 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr826-review-1756c24f-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr826-review-1756c24f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #826 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr824-review-e4950d9b-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr824-review-e4950d9b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #824 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr806-review-aebac5fc-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr806-review-aebac5fc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #806 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr804-47b714b2-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr804-47b714b2-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #804 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr804-review-8df7f3e2-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr804-review-8df7f3e2-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #804 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr807-c55523fb-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr807-c55523fb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #807 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr807-5e6eb4e5-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr807-5e6eb4e5-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #807 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr827-569ae9f5-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr827-569ae9f5-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #827 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr809-review-e892a99c-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-e892a99c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr809-review-69e51cb3-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-69e51cb3-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr809-review-784e5f86-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-784e5f86-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr809-review-3fb4c8b9-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-3fb4c8b9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr826-review-0ea51177-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr826-review-0ea51177-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #826 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr786-28d1e1d7-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr786-28d1e1d7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #786 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr826-448995f1-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr826-448995f1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #826 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr357-623fe9bc-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr357-623fe9bc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #357 (primary: endojs-endo-but-f...
- [`kriscendobot-agoric-sdk-pr10-review-a7bcbe21-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr10-review-a7bcbe21-retro.md) — _low_ · Retrospective on kriscendobot/agoric-sdk PR #10 (primary: kriscendobot-agoric...
- [`kriscendobot-agoric-sdk-pr10-review-c28034ac-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr10-review-c28034ac-retro.md) — _low_ · Retrospective on kriscendobot/agoric-sdk PR #10 (primary: kriscendobot-agoric...
- [`kriscendobot-agoric-sdk-pr10-review-14260266-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr10-review-14260266-retro.md) — _low_ · Retrospective on kriscendobot/agoric-sdk PR #10 (primary: kriscendobot-agoric...
- [`endojs-endo-but-for-bots-pr831-14cde530-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr831-14cde530-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #831 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr831-cfde756b-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr831-cfde756b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #831 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-endo-inspect`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`build-endo-regexp-conservative-subset`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-regexp-conservative-subset.md) — awaiting `endojs/endo-but-for-bots#676` · Build: implement @endo/regexp — the conservative-regexp-subset linear matcher
- [`daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s48`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s48.md) — awaiting `xs2rust-endor-stage10p-fresh-env-sweep` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`registry-immutable-byte-array-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/671` · Immutable byte-array RegistryInterface follow-up
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-chrome-native-function-caller-arguments-repro kriscendobot-cosgov kriscendobot-endo kriscendobot-finbot kriscendobot-garden kriscendobot-minion.town kriscendobot-ocapn kriscendobot-proposal-compartments kriscendobot-test262 kriscendobot-vattr97 kriscendobot-ymax-e2e kriscendobot-ymax-stdio-mcp

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 0 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
