# Garden bulletin

_As of 2026-09-04T00:24:41Z_

## Latest

Cloudflare OS library ingestion completed after 10 consecutive scholar passes covering the entire repository — overview, design, packages, and source-code comment fragments — with 90+ sections across topics like MCP server connectors, Gatekeeper architecture, and collaborative-workspace sharing now indexed. Separately, Node 24 local-verify parity infrastructure shipped — local-verify now enforces runtime version matching CI (Node 24 for lts/* projects), and the fleet is provisioned with Node 24 alongside Node 22; early hosts will hard-fail Node-24 projects until the next deploy. Containment drift recurrence on minion.town detected and logged (a third `@agent` powers record missed by the prior whitespace-tolerant scan). A heavy backlog of parked work awaits maintainer decisions: SIWE tier + allowlist configuration for minion.town, OpenRouter zero-data-retention + stealth-model routing policy, test262 fixture consolidation scope (merge vs. dual-tree), deployer stalled for 3 days across two hosts, and five gauntlets halted mid-stage on panel/fix failures. Several triager fetch failures recovered; provider quota constraint cleared.

## Parked for maintainer feedback

- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 2h)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 7h)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 2d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 2d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 2d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 2d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 3d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 5d)
- [endojs/endo-but-for-bots#858](https://github.com/endojs/endo-but-for-bots/pull/858) — feat(stream): add auto buffer (waiting 5d)
- [endojs/endo-but-for-bots#216](https://github.com/endojs/endo-but-for-bots/pull/216) — feat(endor,tui): interactive TUI mode + stub packages (per kriskowal #32 reconstruct) (waiting 7d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `watchdog-budget-level-uncalibrated-anthropic-endolin-garden2-5bcdff64` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-uncalibrated-anthropic-endolin-garden2-5bcdff64.md)

> budget-level: pool anthropic:endolin-garden2-5bcdff64 cap=385000000 is UNCALIBRATED (provenance='none'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date).

- `20260903T195940Z-0ba282` — from gauntlet:sweep-ci-starved-conflicting-prs-20260901-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260903T195940Z-0ba282.md)

> Gauntlet sweep-ci-starved-conflicting-prs-20260901-gauntlet HALTED: stage 'sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean' (clean) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.

- `20260904T002145Z-5578a6` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T002145Z-5578a6.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: endojs-endo-but-for-bots-pr891-gauntlet-fix-1
> - question (msgid 20260903T171950Z-91c065.md)
> - tentative answer: proxy/tentative: Yes — go with the weave. This is a mechanical rebase-conflict situation, not a review or authority question. Post a `weave` job for [https://github.com/endojs/endo-but-for-bots/pull/891](https://github.com/endojs/endo-but-for-bots/pull/891) to rebase the head (kriscendobot:design/endo-zone) onto current `llm` (1d91f0d9d) and resolve the `designs/README.md` conflict (the "Totals:"/"Last updated:" grooming lines — take the live-`llm` grooming values, not the stale pinned ones, then re-apply/keep your 701eaca1d fix-round-1 content on top). Plain `weave`/rebase is the right tool here, not pin-the-merge-base — you're not repointing the PR's base to a frozen `llm-<sha>` branch, just catching the existing base up; save pin-the-merge-base for cases that need a stable snapshot base. After the weave pushes, CI should attach to the new head and the fix-round-1 gauntlet stage can resume/re-check normally — no need to re-post the fix stage in the meantime, that would keep spinning as you found. Maintainer may revise if there's a reason to prefer pin-the-merge-base instead.

- `20260819T003825Z-b548b6` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003825Z-b548b6.md)

> From report `issue-kriskowal-garden-67`: next steps are (1) turning "phase 0" (structural shapes + explicit membership checks, no registry/new authority) into an actual PR on the fork, and (2) drilling into the two-phase attestation mechanism against the resolver's existing invitation-based reporting path. This touches the `kriscendobot/agoric-sdk` fork, which per standing scope needs your call rather than an autonomous job.

- `doomed-fu-guard-worker-self-disqualify-missing-agent-bin-1-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fu-guard-worker-self-disqualify-missing-agent-bin-1-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/fu-guard-worker-self-disqualify-missing-agent-bin-1; it stays HELD until a human promotes it
> (promote-plan.sh fu-guard-worker-self-disqualify-missing-agent-bin-1) or removes it, so nothing is lost.
> Original job base: fu-guard-worker-self-disqualify-missing-agent-bin-1
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> Garden repo (main2): `run-test.sh` currently has ~30 pre-existing failures (environmental — sandbox lacks network for `github.com:kriskowal/garden.git`, a shellcheck-wrapper subtest, a foreman fill-batch block), leaving the suite red by default so it can't gate anything. Fix or properly skip the environmental failures.

- `watchdog-budget-zone-endolin-garden-ece02cb4-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-ok.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-08-27T01:30:12Z, latest 2026-09-03T21:07:53Z).
> The SAME condition (`budget-zone-endolin-garden-ece02cb4-ok`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget pool anthropic:endolin-garden-ece02cb4 changed zone backoff -> ok at spend=170763114 of cap=595000000 (high-water 0.85; Friday 21:00 Pacific window).

- `20260819T003940Z-06bfa7` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003940Z-06bfa7.md)

> From report `self-heal-fix-garden-comment-watcher-kriscendobot-garden-repo-404-crashloop`: need a decision on `worktrees/kriskowal-garden.git` — remove it or re-point its origin.

- `watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet` — from watchdog:cleric/2, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet.md)

> gardener job 'endojs-endo-but-for-bots-pr881-gauntlet' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7207s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `watchdog-budget-level-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-endolin-garden-ece02cb4-3.md)

> budget-level changed endolin-garden-ece02cb4 gardener workers 1 -> 3: budget pool anthropic:endolin-garden-ece02cb4 spend=170897074 cap=595000000 high-water=0.85 target=3

- `doomed-endojs-endo-but-for-bots-pr946-conduct-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr946-conduct-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr946-conduct; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr946-conduct) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr946-conduct
>
> --- original job body ---
> ---
> role: conductor
> tier: minion
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:58:28Z cleared=none -->
>
> ---
> role: conductor
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Finalize (curate → merge) endojs/endo-but-for-bots PR #946
>
> A trusted maintainer APPROVED this PR and the watcher confirmed it is
> OPEN, mergeable, and checks green. This is the CURATION step: dispatch the
> **conductor** to un-draft (if the PR is still draft) and merge. Do NOT name
> a merge method — the conductor owns that choice (roles/conductor/AGENT.md).
>
> Guards (the watcher already enforced these; re-verify before merging):
>   - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the endojs/endo
>     upstream — those are the maintainers / boatmans call.
>   - The PR must still be OPEN, mergeable, and checks green. If it has
>     regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
>     forcing the merge.
>   - Idempotent: if the PR is already merging/merged/closed, do nothing.
>
> Source: pr-review-body by kriskowal
> Approval: [https://github.com/endojs/endo-but-for-bots/pull/946](https://github.com/endojs/endo-but-for-bots/pull/946)#pullrequestreview-4941598685

- `watchdog-handler-budget-overrun-fix-usage-meter-unbound-var-and-widen-shellcheck-ci` — from watchdog:monk/4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-fix-usage-meter-unbound-var-and-widen-shellcheck-ci.md)

> gardener job 'fix-usage-meter-unbound-var-and-widen-shellcheck-ci' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2407s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `watchdog-budget-level-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-endolin-garden-ece02cb4-1.md)

> budget-level changed endolin-garden-ece02cb4 gardener workers 3 -> 1: budget pool anthropic:endolin-garden-ece02cb4 spend=121189197 cap=149000000 high-water=0.85 target=1

- `20260728T173844Z-cfda47` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T173844Z-cfda47.md)

> Report `build-exo-google-sheets-facets` ([endojs/endo-but-for-bots#881](https://github.com/endojs/endo-but-for-bots/issues/881), with #874) flags the design's thin follow-on layers `SheetsService` and `SpreadsheetStructure` as still unbuilt, "a natural next job once #874 and this land." Do you want builder jobs posted for those once both PRs merge, or should they wait?

- `watchdog-budget-zone-endolin-garden-ece02cb4-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-backoff.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-08-23T02:43:12Z, latest 2026-09-03T19:51:57Z).
> The SAME condition (`budget-zone-endolin-garden-ece02cb4-backoff`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget pool anthropic:endolin-garden-ece02cb4 changed zone ok -> backoff at spend=169261898 of cap=149000000 (high-water 0.85; Friday 21:00 Pacific window).

- `20260803T024348Z-ebba81` — from gardener:garden-budget-omega, reply_to `garden-budget-omega` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260803T024348Z-ebba81.md)

> Budget 5/5 (omega) — one grounding question before this design can be acted on.
>
> You asked me to "look at what Josh Corbin's Unum is doing to classify tasks by
> their omega notation ... the task's rank in a tree of plans." I read all 15
> `library/sections/unum--*` sections, grepped the whole library, and fetched the
> live unum repo overview + a web search. **No omega notation, task-rank scheme, or
> "tree of plans" ranking exists in anything I can reach.** The ingested unum
> material is pinned to early-July commits (per-persona-model-tiers, vigil-charge,
> claim-lifecycle, the cost ledger) and predates whatever you saw. The only `omega`
> hits in the garden are econometrics (Diebold-Mariano, HAR-RV).
>
> So I have written the design with a *reconstructed* interpretation, clearly
> labelled as MINE and provisional — omega as a lower-bound rank = depth in a plan
> tree; lowest rank (leaves) worked first; a task too big for its time window
> creates a plan and promotes its own rank (which the garden's orchestration jobs
> already half-implement). I did NOT invent priorities or reorder anything.
>
> Two asks for @jcorbin (on the maintainers allowlist), whenever convenient — an
> unanswered question is fine, I have flagged the gap in the design rather than
> guessing:
>
> 1. Point me at unum's actual omega/rank definition (a PLAN/ or LORE/ doc, or a
>    commit) so I can ground the scheme instead of reconstructing it.
> 2. Confirm or correct the reconstruction: is "lowest omega" the leaf (do-first)
>    or the root, and is "promote itself in the tree" the same move as the garden
>    posting an orchestration job with parked children?
>
> Design landed at `designs/omega-task-rank-and-foreman-retirement.md` (Status:
> Proposed, changes no dispatch behavior). No rush.

- `20260903T170508Z-e9b44e` — from gardener:minion-town-remote-guest-endo-cli-endo-invite-primitive, reply_to `minion-town-remote-guest-endo-cli-endo-invite-primitive` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260903T170508Z-e9b44e.md)

> Step 1 of designs/remote-guest-endo-cli.md (the upstream go/no-go checkpoint) is
> implemented and opened as a DRAFT PR: [endojs/endo-but-for-bots#1125](https://github.com/endojs/endo-but-for-bots/issues/1125) (base llm,
> head kriscendobot:bot/build/endo-guest-invite-primitive). Not yet merged — the
> minion.town chain (design §§4–8) stays gated until it lands. I did NOT start any
> minion.town follow-ups.
>
> ACTUAL ENDO SHAPE (matches the design §3 sketch; a few notes the §§4–8 chain must
> re-verify against once the PR merges):
>
> - E(guest).invite(localPetName) → invitation object; E(invitation).locate() →
>   endo:// locator; E(invitation).cancel() → revoke. Matches §3 exactly.
> - The locator `from` names the inviting GUEST's handle (not the top host), so the
>   acceptor binds the guest. Both pet stores receive the opposite handle; neither
>   bound handle carries host-only methods. Verified two-daemon over tcp AND
>   OCapN/Noise.
> - Guest-safety holds: the guest gains no getPeerInfo/addPeerInfo/host facet/peer
>   enumeration/outbound dialing. Network mediation is an internal daemon broker
>   (resolved from the root endo bootstrap's network host), never handed to the
>   guest — this is the design's "internal daemon network broker".
> - Single-use is deterministic + restart-durable (accept rejects before side
>   effects when the invitation's slot no longer names it); a replay fails cleanly.
>
> DELTAS the minion.town §4 RemoteInviteFacet must account for (Endo layer differs
> from the §4 app sketch, as the design anticipated):
> 1. cancel() is on the INVITATION OBJECT, not by id. §4's cancel(inviteId) must
>    keep its own inviteId → invitation-object map; there is no Endo-level inviteId.
> 2. NO Endo-level expiresAt/TTL. Expiry is entirely a minion.town §4 concern (as
>    the design already states); the Endo invitation does not auto-expire.
> 3. NEW REQUIREMENT: guests now carry their own guest-scoped @pins directory (a
>    new optional guest-formula field). A guest formulated on a daemon WITHOUT this
>    change cannot invite (no @pins to durably retain the local handle). So
>    minion.town's canonical g-<hash> guests must run on a daemon that includes the
>    PR; pre-existing guests may need re-formulation or a migration.
> 4. The invitation exo also exposes accept() (the wire-protocol method the
>    acceptor's daemon calls); it is not guest-facing authority but is on the object.
>
> No materially-different broker-mediation contract vs. the design — the §3 API
> sketch holds. Recommend: hold §§4–8 until the PR merges on llm, then re-verify the
> RemoteInviteFacet mapping against the four deltas above. If review changes the
> contract, I'll re-report.

- `20260903T073707Z-bff9ad` — from orchestrator:minion-town-clipometer-esbuild-orchestration-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260903T073707Z-bff9ad.md)

> Orchestration minion-town-clipometer-esbuild-orchestration HALTED: child minion-town-clipometer-esbuild-pipeline stalled in flight for 2501s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/4 done before halt; parked remainder: minion-town-clipometer-esbuild-validate minion-town-clipometer-primer-esbuild-update minion-town-clipometer-esbuild-issue-report

- `20260901T205650Z-59a6f5` — from gardener:retire-gardener-worker-kind-alias, reply_to `retire-gardener-worker-kind-alias` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T205650Z-59a6f5.md)

> Retirement gate 1 failed on endolin-garden2-5bcdff64, so I stopped before changing code, journal state, or units as directed. Direct host evidence: /home/kris/garden2/.garden-state/gardeners contains 101 legacy *.garden identity markers plus gardeners/backend/{state,status}; newest legacy file is backend/status from 2026-08-25T22:56:02Z. Legacy garden-gardener@1..4 units are disabled/inactive, but the host declares monks: 4 while only garden-monk@1..3 are enabled and active (monk@4 disabled/inactive). Please reconcile/authorize disposition of the legacy state markers and the monk count mismatch, then requeue the alias-retirement cleanup.

- `doomed-fix-usage-meter-unbound-var-and-widen-shellcheck-ci-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fix-usage-meter-unbound-var-and-widen-shellcheck-ci-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/fix-usage-meter-unbound-var-and-widen-shellcheck-ci; it stays HELD until a human promotes it
> (promote-plan.sh fix-usage-meter-unbound-var-and-widen-shellcheck-ci) or removes it.
> Original job base: fix-usage-meter-unbound-var-and-widen-shellcheck-ci
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> ## Grounding incident
> While filing a fix job on 2026-08-23, `scripts/jobs/post-job.sh` printed:
>
>     scripts/jobs/usage-meter.sh: line 302: cutoff: unbound variable
>
> a live `set -u` failure in the fleet budget-state read path (the WARN text
> confirms it fell back fail-open: "fleet budget state unreadable; posting ...
> to todo/"). This is exactly the class of bug `shellcheck` catches
> (`SC2154`/unset-variable-under-`set -u` patterns) — but `usage-meter.sh` is
> not in `.github/workflows/checks.yml`'s shellcheck file list, which is a
> curated allowlist (daemons, watcher stub, checks gates, per-test scripts),
> not the full `scripts/jobs/` tree. The workflow's own comment already
> concedes the gap: "Pre-existing scripts outside this scope have known
> issues; widening the lint surface is a separate effort."
>
> Separately (already fixed directly, not part of this job): `checks.yml`'s
> `on: push/pull_request: branches: [main]` pointed at the abandoned `main`
> branch (last touched 2026-07-05, since diverged from `main2`) instead of
> `main2`, the actual development branch — so shellcheck/bash-n/gate-tests
> have not run on a real commit in weeks; only `pages-build-deployment` was
> firing. That trigger fix landed separately; this job is the file-scope
> widening plus the specific bug.
>
> ## Ask
>
> 1. **Fix the specific bug**: `scripts/jobs/usage-meter.sh:302` references
>    `$cutoff` unset under some code path. Trace the call graph, fix the
>    unbound reference (declare/default it, or guard the read), and add or
>    extend a regression test if the file has one (check
>    `scripts/jobs/test/` for a usage-meter test harness first).
>
> 2. **Widen `checks.yml`'s shellcheck step to mandatory, broad coverage.**
>    The maintainer wants shellcheck genuinely in the mandatory pre-commit/CI
>    testing, not a narrow allowlist that happens to exclude the very file
>    that broke. Concretely:
>    - Add `scripts/jobs/*.sh` (at minimum) to the shellcheck file list,
>      ideally the same broad `find scripts skills -name '*.sh'` sweep the
>      `bash -n` step already uses, so newly added scripts are covered by
>      construction rather than requiring a per-file allowlist edit forever.
>    - `shellcheck -S warning` across the full `scripts/jobs/` tree will
>      likely surface real pre-existing warnings beyond the one bug above
>      (the workflow comment already anticipates this) — triage and fix each
>      one rather than silently loosening the severity or excluding files
>      wholesale. Where a finding is a deliberate/false-positive pattern
>      (e.g. an intentionally-unbound variable a caller is expected to set),
>      use a scoped `# shellcheck disable=SCxxxx` with a one-line reason,
>      not a file-level exclusion.
>    - If the full sweep is too large for one pass, land it in the widest
>      scope you can clear in this job and note remaining excluded paths
>      explicitly in the workflow comment (mirroring the existing "known
>      issues" note) rather than leaving the gap implicit.
>    - Keep the check genuinely mandatory: it should fail the workflow (not
>      just warn) on any finding at `-S warning` or above, matching the
>      existing step's behavior.
>
> 3. Confirm the retargeted workflow (now triggering on `main2`) actually
>    runs green on your PR-equivalent push and report the run URL.

- `watchdog-preflight-gather-fail-kriscendobot-minion.town` — from watchdog:pr-feedback-preflight, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-preflight-gather-fail-kriscendobot-minion.town.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-08-10T23:05:19Z, latest 2026-09-01T04:59:18Z).
> The SAME condition (`preflight-gather-fail-kriscendobot-minion.town`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> pr-feedback-preflight could not gather evidence for [kriscendobot/minion.town#73](https://github.com/kriscendobot/minion.town/issues/73) (cid=5489113009) and failed open.
> This is a tool/transport failure, not a no-evidence finding — real feedback may
> have been processed WITHOUT the peer-resolution recheck. Reason:
> evidence gathering failed: could not fetch pull [kriscendobot/minion.town#73](https://github.com/kriscendobot/minion.town/issues/73)
> --- captured stderr ---
> gh: Not Found (HTTP 404)

- `20260819T003849Z-3a1d32` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003849Z-3a1d32.md)

> From report `qwen-model-watch-20260728-180502` (echoed by `fu-qwen-model-watch-20260728-180502-1-20260728-223502`): decide the local qwen lane's fate — promote the local default to the 35B-A3B MoE, or accept `hermits: 0` and drop it (`qwen3:0.6b` is small enough it isn't obviously useful).

- `20260819T003451Z-370a6d` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003451Z-370a6d.md)

> From report `deadmail-20260728T074423Z-6bee53`: the new dead-letter anti-pattern documents that a botanist rendering MERGE-NOW and exiting while the approval gate blocks leaves no living addressee for a later correction, but doesn't fix the delivery gap itself. Worth deciding whether/how to close it (e.g. a standing re-addressee) — flagging for your call rather than guessing at the mechanism.

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-08-08T15:52:01Z, latest 2026-09-03T02:22:02Z).
> The SAME condition (`root-repo-deploy-stalled-endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> root repo /home/kris/garden deploy has been STALLED for ~3d: deployed sha 2bf8803996bd70d17c81abff3c16d127bbc89bb5 is 64 commit(s) behind origin/main2 (3cfbeb5ac433f64679608b13575d04962401a697) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden-ece02cb4)

- `doomed-endojs-endo-but-for-bots-pr1023-gauntlet-panel-2-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr1023-gauntlet-panel-2-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1023-gauntlet-panel-2; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr1023-gauntlet-panel-2) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr1023-gauntlet-panel-2
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: panel
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:56:16Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: panel
> handler-timeout: 7200
> gauntlet: endojs-endo-but-for-bots-pr1023-gauntlet
> gauntlet_stage: panel
> gauntlet_iteration: 2
> pr: [https://github.com/endojs/endo-but-for-bots/pull/1023](https://github.com/endojs/endo-but-for-bots/pull/1023)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1023
>
> You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr1023-gauntlet). Run EXACTLY ONE panel round, post the
> verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1023-gauntlet-panel-2 <pr-head-owner>/<repo-name> <pr-head-branch>`.
>    Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1023 --json headRepositoryOwner,headRefName`;
>    do not pass the base repo when the PR head belongs to a fork.
> 2. Run the panel in SINGLE-ROUND mode against that worktree:
>    `GARDEN_PANEL_SINGLE_ROUND=1 \
>      scripts/jobs/gardening/panel.sh <worktree> 1023 <base-ref>`
>    It fans the seats, aggregates, and prints its disposition as the terminal line's
>    last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
> 3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on [https://github.com/endojs/endo-but-for-bots/pull/1023](https://github.com/endojs/endo-but-for-bots/pull/1023) — the
>    panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
>    review on must-fix, a comment/approve on pass).
> 4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
>    report with `orchestration-failed: true` and do NOT emit a panel marker.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: panel=pass -->
>   <!-- gauntlet-stage-result: panel=must-fix -->

- `watchdog-budget-level-uncalibrated-anthropic-endolin-garden-ece02cb4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-uncalibrated-anthropic-endolin-garden-ece02cb4.md)

> budget-level: pool anthropic:endolin-garden-ece02cb4 cap=595000000 is UNCALIBRATED (provenance='none'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date).

- `20260804T052828Z-2bba29` — from gardener:review-retrospective-consolidated-20260804, reply_to `review-retrospective-consolidated-20260804` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260804T052828Z-2bba29.md)

> Consolidated review-retrospective pass (85 events) — done. Two escalations that
> need your eyes, both about improvements that already shipped yet recurred:
>
> 1. RECURRENCE — cluster `inline-import-jsdoc` (was closed). The no-inline-import-jsdoc
>    gate + typist backstop landed on main2 2026-07-16 (0c569a64e4 / d0da42892a). Yet on
>    [endojs/endo-but-for-bots#792](https://github.com/endojs/endo-but-for-bots/issues/792) (review 2026-07-22) you wrote "Prefer @import. Should
>    have been caught in review." The writer flagged recurrence=1 and reopened the cluster.
>    CAVEAT: 07-22 is only days after the 07-16 commit, so the fleet may not have DEPLOYED
>    the fix when that PR's code was authored (a deploy-lag artifact, not a true failure of
>    the gate). I did NOT auto-start a second improvement round. If it predates the deploy,
>    no action; if not, the gate/probe is under-covering @import in some tag position.
>
> 2. GATE UNDER-COVERAGE — cluster `avoid-name-abbreviations`. The deterministic
>    spell-out-identifiers pre-push gate landed 2026-07-11 (aa2da527e5), but two later
>    PRs still drew abbreviation asks: [endojs/endo-but-for-bots#806](https://github.com/endojs/endo-but-for-bots/issues/806) (07-22, network.js) and
>    [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) (07-29, "Addr is Address" in a test file). The cluster was
>    never marked `closed`, so no auto-recurrence fired. Likely gaps: the probe skips test
>    files, or its dictionary misses `Addr`. Recommend widening the spell-out-identifiers
>    probe scope+dictionary (a builder job).
>
> Landed this pass (main2 37b04ec909): prefer-@endo-primitives and
> capability-hardening-attenuation review checks (builder directives + purist/locksmith
> seats). Dispatched: review-improve-merge-base-pinning (deferred builder). Full report in
> the job completion.

- `20260819T003813Z-b83dfb` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003813Z-b83dfb.md)

> From report `ironhorse-js-26-map-methods`: four cross-cutting engine-wide gaps (each would close residuals across the whole js-26 Map/Set-methods proposal) each warrant their own feature increment. Worth your prioritization call on sequencing before I queue them.

- `doomed-local-verify-endo-test-xs-cargo-parity-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-local-verify-endo-test-xs-cargo-parity-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/local-verify-endo-test-xs-cargo-parity; it stays HELD until a human promotes it
> (promote-plan.sh local-verify-endo-test-xs-cargo-parity) or removes it.
> Original job base: local-verify-endo-test-xs-cargo-parity
>
> --- original job body ---
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> role: builder
>
> Close the remaining local-verify environment parity exposed after `test:xs` coverage landed in commit 4c1c39ee15. A real run against endojs/endo-but-for-bots@llm used the CI-pinned Moddable 5.0.0 xst successfully, then `@endo/hardened262` failed before exercising Ironhorse because the garden image has no `cargo`; the isolated worktree also has the CI-required `c/moddable` submodule uninitialized. Mirror the `test-xs` workflow prerequisites generically, preserve silent-on-success, and add regression coverage. Evidence blob in project worktree at the originating job was deeb55ea4c940dbbd69335b23b48ed8cac441563.

- `doomed-fu-requeue-ps23-stranded-claims-4-elapsed-constancy` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fu-requeue-ps23-stranded-claims-4-elapsed-constancy.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
> The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
> The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
> Read the handler log for the fast failure cause. Raising the handler budget will not help.
> The work is preserved at jobs/plan/fu-requeue-ps23-stranded-claims-4; it stays HELD until a human promotes it
> (promote-plan.sh fu-requeue-ps23-stranded-claims-4) or removes it.
> Original job base: fu-requeue-ps23-stranded-claims-4
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> Garden repo (main2): SUBTEST 7 of `elapsed-constancy-classifier-test.sh` fails on main2 (explicit-cap exemption not firing — sub-floor reclassification wins instead). Fix it.

- `doomed-mtown-git-remote-followup-notice-recheck-20260818-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-mtown-git-remote-followup-notice-recheck-20260818-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/mtown-git-remote-followup-notice-recheck-20260818; it stays HELD until a human promotes it
> (promote-plan.sh mtown-git-remote-followup-notice-recheck-20260818) or removes it, so nothing is lost.
> Original job base: mtown-git-remote-followup-notice-recheck-20260818
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> token-budget: 100000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-21T22:18:56Z cleared=none -->
>
> ---
> role: gardener
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> # Notice: recheck the minion.town git-remote follow-up on the daemon commit-formula design
>
> This is the notice (sentinel) job of the D->N->F chained follow-up in skills/chained-followup/SKILL.md, re-armed on a short once: schedule because the design had not yet advanced to a build at the last check.
>
> D is ebfb-daemon-commit-formula-design. Its design PR is [https://github.com/endojs/endo-but-for-bots/pull/988](https://github.com/endojs/endo-but-for-bots/pull/988).
>
> Use gh read-only metadata, not comment prose, to determine whether PR #988 has advanced to a build: a build PR referencing or implementing the design has opened, or the design merged and a build is underway. Cross-reference timeline metadata is the preferred mechanical link check (gh api repos/endojs/endo-but-for-bots/issues/988/timeline).
>
> If advanced to build, post F with post-job.sh using base mtown-git-remote-commit-formula-act and this exact body:
> Act on the daemon-native commit formula in minion.town's capability-addressed git remote (design/git-remote-capability). Name the endo-but-for-bots build PR/commit that landed. Update designs/git-remote-capability.md §4 (Strategy B) to reflect git commit/tree/tag identity through the new daemon commit formula — synthetic refs tree rooted at a formula identifier, name-hub lookup paths ending in a readable-tree, synthetic orphan commits enveloping the readable-tree — and carry the design to the implementation increment. Origin review: [https://github.com/kriscendobot/minion.town/pull/41](https://github.com/kriscendobot/minion.town/pull/41)#pullrequestreview-4939454650
>
> If not yet built, re-arm this notice again on a short once: schedule (scripts/jobs/set-schedule-once.sh). If the design was declined (PR #988 closed unmerged), end the chain, message the maintainer through message-user.sh, and do not post F.

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

- `watchdog-provider-quota` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-provider-quota.md)

> WATCHDOG notice — occurrence #20 (first seen 2026-09-01T22:33:11Z, latest 2026-09-03T23:33:10Z).
> The SAME condition (`provider-quota`) has now been observed 20 times; this is ONE
> coalesced notice that updates in place, not 20 messages. Latest detail:
>
> provider weekly limit reached: the API is refusing calls fleet-wide (resets Sep 5, 3am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 5973c8b843864ea1aede70b64c43587b13e13f2f (git -C /home/kris/garden2/).
> limit_type: weekly
> This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
> resumes on its own once the window resets (see skills/restore/SKILL.md for the
> post-outage restore). Every unit that trips the limit folds into THIS one notice
> rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
> provider quota exceeded while running garden-mirror-closer. Observed: You've hit your weekly limit · resets Sep 5, 3am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 5973c8b843864ea1aede70b64c43587b13e13f2f (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 5973c8b843864ea1aede70b64c43587b13e13f2f).

- `doomed-openrouter-zdr-policy-and-stealth-lane-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-openrouter-zdr-policy-and-stealth-lane-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/openrouter-zdr-policy-and-stealth-lane; it stays HELD until a human promotes it
> (promote-plan.sh openrouter-zdr-policy-and-stealth-lane) or removes it.
> Original job base: openrouter-zdr-policy-and-stealth-lane
>
> --- original job body ---
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> Follow-up to `design-openrouter-provider` (`designs/openrouter-provider.md`,
> commit `9790c4f4db`), which left two maintainer decisions as open questions.
> The maintainer (kriskowal) has now answered both — this job builds what they
> authorized, not a re-ask.
>
> ## Decision 1 — reject logging/training-use by default (answers Open question 1)
>
> The garden's default OpenRouter posture is: **no prompt/response logging, no
> training on inputs.** Enforce this as a real, code-auditable constraint, not
> an account-page setting someone could forget or reset:
>
> - Investigate OpenRouter's actual current mechanism for this — most likely a
>   per-request `provider: { data_collection: "deny" }` field (routes only to
>   zero-data-retention-capable providers, whatever they don't serve is simply
>   excluded from routing) alongside/instead of the account-level privacy
>   toggle at openrouter.ai/settings/privacy. Confirm current behavior against
>   OpenRouter's own docs rather than assuming; this is a request I have not
>   verified against a live account.
> - Wire the `openrouter`/`cleric-codex.sh` `$custom_openai_compat` request
>   path to send that deny-collection constraint on **every** OpenRouter
>   request, unconditionally — not opt-in per job, not toggleable by a job
>   body. This is a fleet posture, not a per-request choice.
> - **Re-review the two seed inventory rows against this constraint.** The
>   design doc already noted free `:free` variants commonly *require*
>   logging/training to be enabled as the price of the free tier — if that's
>   still true, a deny-collection request to those ids may simply return no
>   eligible provider (empty routing) rather than an error, or may 404/402.
>   Determine empirically (status-only probe, no key exists yet so this may
>   need to wait for §3 below, or can be reasoned from OpenRouter's docs) and
>   either (a) drop the two named-free rows and replace with providers that
>   demonstrably support zero retention even on `:free`, if any exist, or (b)
>   document plainly that under this policy the free lane is currently empty
>   and the garden's OpenRouter reach starts at zero usable named models until
>   a compliant one is found or a paid ZDR-capable route is reviewed and
>   authorized separately. Do not silently keep a non-compliant row enabled.
> - Update `designs/openrouter-provider.md` § Open questions (mark question 1
>   Resolved: with the decision and what it costs) and
>   `context/operations/openrouter.md` to state the enforced policy plainly
>   and reflect the reviewed row set.
>
> ## Decision 2 — admit stealth/cloaked models via a second kind (answers Open question 2)
>
> The maintainer wants to use OpenRouter's rotating cloaked "stealth" models
> (e.g. `openrouter/stealth/ox-alpha`-shaped ids) *while cloaked*, accepting
> the design's stated risk (undisclosed provenance, no reviewed stable id).
> Build the design's already-sketched policy (b):
>
> - A second kind, `openrouter-promo` (or a better name if one occurs to
>   you — say why if you rename it), same handler/provider, same
>   explicit-model-only fencing as `openrouter`, but with its OWN registry
>   namespace so its arms never pool with the stable named lane's
>   (`opencode-alternate-harness.md`'s option-C reasoning applies again here:
>   a distinct kind keeps distinct risk profiles distinctly scored).
> - A **short mandatory re-review cadence** for whatever cloaked ids are
>   enabled (the design flagged this as required but undesigned) — pick a
>   concrete cadence (daily is a reasonable default for something that can
>   vanish or silently become a different model at any time) and a mechanism
>   to enforce it: a scheduled check (skill: [schedule]) that re-probes each
>   enabled stealth id's `/models` listing and a live tool-using canary, and
>   **automatically disables** (not just warns about) an id that 404s or that
>   the maintainer has not re-attested within the cadence window.
> - A documented **rip-cord**: how to immediately zero the pool and drop a
>   specific stealth id's row (`set-openrouter-promos.sh 0` plus removing its
>   inventory row) — mirror the shape of `set-openrouters.sh`.
> - This lane inherits the deny-logging/deny-training constraint from Decision
>   1 unconditionally, same as the stable lane — "we accept not knowing which
>   model this is" is a different risk than "we accept our prompts being
>   logged", and the maintainer has only authorized the former.
>
> ## Decision 2b — reputation continuity on unmask (net-new, not in the prior design)
>
> When a stealth id's identity is later revealed (OpenRouter publishes what it
> was, or the maintainer otherwise learns it), the garden should be able to
> **carry the accumulated reputation forward** onto the now-named model's
> arm(s) rather than discarding it and starting that model at zero history.
> This is genuinely new — the prior design didn't address it. Design and build
> a maintainer-triggered (never automatic — an unmask is an external fact only
> a human confirms) reputation-arm migration:
>
> - Read `reputation.sh` / the reducer (`reputation-reduce.sh`, described
>   elsewhere as the sole writer of arm projections) before proposing a
>   mechanism — the migration must go through whatever the reducer considers
>   its single source of truth, not hand-edit a projection file.
> - Shape: an operator script, `rerecord-reputation-arm.sh <old-arm-key>
>   <new-arm-key> --authorized-by <maintainer>` (or fold into an existing
>   attested-op pattern if one already fits better — the sysop's
>   `authorized_by:` attestation gate on destructive ops is the precedent to
>   follow for who may trigger this and how it's recorded) that relabels the
>   stealth arm's history onto the real model's arm, idempotently, with a
>   journal record of the migration (what was renamed, when, by whom) so it's
>   auditable and never silently double-applied.
> - If a full merge (combining history if the target arm already has some) is
>   materially harder than a clean rename (target arm didn't exist before),
>   it's fine to build the rename case now and leave merge-on-collision as an
>   explicit open question rather than guessing at reducer semantics you
>   haven't verified.
>
> ## Out of scope for this job
>
> Actually supplying `OPENROUTER_API_KEY` or enabling any worker. The pool
> (both `openrouter` and the new `openrouter-promo`) stays at zero. Container
> recreation with the key is a separate, host-side, maintainer-run step
> (cannot be done from inside a garden container — no docker socket there) —
> the liaison is handling that directly with the maintainer, not asking this
> job to do it.
>
> ## Precedents to read first
>
> - `designs/openrouter-provider.md` (this job's predecessor) and
>   `context/operations/openrouter.md`.
> - `skills/schedule/SKILL.md` for the re-review cadence mechanism.
> - `roles/sysop`/`designs/sysop.md` § attestation, as the precedent for a
>   maintainer-attested, auditable, idempotent operator action.

- `20260819T003456Z-bdaa62` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003456Z-bdaa62.md)

> From report `deadmail-20260812T232828Z-4f1d09`: need a decision on disclosure timing before any public fork PR goes up for the pushed branch (no PR exists yet). Separately, the same report flags a real gap worth tracking — authenticated peer identity in host `gateway()` is missing across all transports, which is what lets the cross-peer retained-formula-number following gap stay open. Given the security-sensitive framing, routing both to you rather than autonomously spawning work.

- `watchdog-handler-budget-overrun-minion-town-endo-b3-daemon-deploy-verify` — from watchdog:cleric/1, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-minion-town-endo-b3-daemon-deploy-verify.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-08-09T18:34:06Z, latest 2026-09-02T04:45:00Z).
> The SAME condition (`handler-budget-overrun-minion-town-endo-b3-daemon-deploy-verify`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> gardener job 'minion-town-endo-b3-daemon-deploy-verify' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2419s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `doomed-retire-gardener-worker-kind-alias-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-retire-gardener-worker-kind-alias-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden2-5bcdff64.
> The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/retire-gardener-worker-kind-alias; it stays HELD until a human promotes it
> (promote-plan.sh retire-gardener-worker-kind-alias) or removes it.
> Original job base: retire-gardener-worker-kind-alias
>
> --- original job body ---
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> Maintainer directive (2026-09-01, liaison session): retire the legacy `gardener`
> worker-kind alias now that the Anthropic worker has been renamed to `monk`
> fleet-wide.
>
> Context: `designs/anthropic-worker-kind-monk.md` landed stage 0 (compatibility
> release) and stage 1 (per-host cutover) via job `monk-finish-gardener-rename`.
> Both fleet hosts (`endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`) have
> since cut over: `journal/hosts/<host>` declares `monks: N` on each, and on
> `endolin-garden-ece02cb4` the legacy `garden-gardener@1.service` unit is
> enabled but **inactive/dead** while `garden-monk@1..4` run live. Stage 2
> (writer-default flip) and the alias retirement itself were explicitly deferred
> in that job's report as "a still-later, separately-reviewed cleanup." This job
> is that cleanup, now authorized.
>
> The design gates retirement on five recorded facts (§ Staged, reversible
> rollout, stage 2 "Canonical writes and cleanup"). Re-verify all five before
> touching anything irreversible, since the liaison could only check the local
> host directly:
>
> 1. All fleet inventory reports zero legacy units and state markers — confirmed
>    on `endolin-garden-ece02cb4` (`garden-gardener@1` inactive, no
>    `state/gardeners/` markers). **Re-check `endolin-garden2-5bcdff64` directly**
>    (its `hosts/` file still carries a `gardeners: 1` mirror line, same shadowed
>    shape presumed but not yet confirmed live).
> 2. No live `doin`, `work`, inbox, active worktree, or recent bid has a legacy
>    (`gardener`-kind) owner — confirmed: the last ~15 `claim()` log entries
>    fleet-wide are all `monk-N`/`cleric-N`. Note `complete-job.sh` always writes
>    the commit-message label `gardener-$id` regardless of actual kind (that is
>    the generic role label, not the worker-kind field — don't mistake it for a
>    live legacy claim; verify by reading each `worker_kind:` field, not the
>    commit subject).
> 3. All hosts have deployed the canonical release — the monk registry row is
>    present in both hosts' currently-deployed checkouts (root repo tested
>    directly on `endolin-garden-ece02cb4`; the leader's live `garden-monk@`
>    pool being active is itself proof for that host).
> 4. No supported external script calls the alias — the internal compat shims
>    (`GARDEN_GARDENER_CLONE` fallback, `set-gardeners.sh`, the
>    `handlers/gardener-claude.sh` forwarder) are the alias implementation
>    itself and are exactly what this job removes; they don't count against
>    this gate. Do check `context/operations/starting.md`,
>    `context/operations/scaling.md`, and `context/first-run/auth.md` (all
>    currently mention `gardeners:`) and update them.
> 5. A rollback drill is no longer promised — this is the maintainer's call,
>    given in this directive.
>
> Do the removal by reversing each row of the design's inventory table (§
> Boundary and inventory):
>
> - `scripts/jobs/common.sh`: delete the `gardener` row from `worker_kind_field`
>   and `worker_kinds()`; simplify `canonical_worker_kind` to a pure v2 decoder
>   (reject a v1 `worker_kind: gardener` record as unknown/legacy rather than
>   silently mapping it — decide and document whether historical read paths
>   still need the v1 mapping for old journal artifacts, since journal history
>   is append-only and must remain readable); remove `anthropic_active_kind`'s
>   monk-vs-gardener selection now that only one Anthropic kind exists.
> - Delete `scripts/jobs/handlers/gardener-claude.sh` (the forwarding wrapper);
>   update `gardener.sh`/`claim-job.sh`/`complete-job.sh` to drop the
>   `GARDEN_GARDENER_CLONE` legacy-env fallback (keep `GARDEN_WORKER_CLONE`
>   only), checking every call site the grep in this job's originating session
>   found across `common.sh`, `usage-meter.sh`, `usage-append.sh`,
>   `regenerate-topics-counts.sh`, `regenerate-sections-index.sh`,
>   `library-slug-prefix-check.sh`, `library-link-check.sh`, `auction.sh`.
> - `scripts/jobs/set-gardeners.sh`: retire it (or turn it into a clear
>   "renamed to set-monks.sh" error) — check callers first.
> - `scripts/jobs/reputation-reduce.sh`: drop the dual projection; write only
>   `reputation/arms/monk/...` going forward. Decide whether the historical
>   `reputation/arms/gardener/...` tree is deleted, left as an inert archive, or
>   migrated — do not silently lose auction history.
> - `scripts/systemd/`/`install-units.sh`: stop rendering `garden-gardener@`
>   units; disable and remove any enabled-but-inactive `garden-gardener@N` unit
>   files on both hosts as part of this job's own host-side cleanup (not a
>   separate deploy step, since disabling an already-inactive unit changes no
>   running behavior).
> - Journal state: clear the stale `gardeners: N` mirror line from
>   `journal/hosts/endolin-garden-ece02cb4` and
>   `journal/hosts/endolin-garden2-5bcdff64` (a plain journal edit, no deploy
>   needed).
> - Tests: remove/retarget `monk-worker-kind-compat-test.sh` and
>   `monk-host-cutover-test.sh` assertions that specifically exercise the
>   gardener alias/dual-pool exclusivity/rollback path (or convert them into
>   regression coverage that a legacy `worker_kind: gardener` claim/env is now
>   correctly rejected, per whatever decision you make on historical-read
>   compatibility above); keep `worker-spine-kinds-test.sh` green for monk.
> - Docs: update `CLAUDE.md`, `context/operations/starting.md`,
>   `context/operations/scaling.md`, `context/first-run/auth.md`, and this
>   design doc's own "Implementation status" section to record retirement as
>   complete (stage 2/3), per house convention of updating the design doc's
>   status alongside the landing commit.
>
> Land directly on `main2` (no PR for the garden's own repo, per `CLAUDE.md` §
> Conventions). Run the full regression sweep (scaler/deploy/reaper/handler/
> health/worker-spine/auction-reputation suites) before pushing, and report
> which of it needed updating versus already passed. If any of the five gate
> facts above does NOT hold when you check it, stop and report back rather than
> proceeding — this change forecloses rollback to the legacy pool.

- `watchdog-preflight-gather-fail-endojs-endo-but-for-bots` — from watchdog:pr-feedback-preflight, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-preflight-gather-fail-endojs-endo-but-for-bots.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-07-30T00:14:18Z, latest 2026-09-03T21:14:00Z).
> The SAME condition (`preflight-gather-fail-endojs-endo-but-for-bots`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> pr-feedback-preflight could not gather evidence for [endojs/endo-but-for-bots#982](https://github.com/endojs/endo-but-for-bots/issues/982) (cid=5532176099) and failed open.
> This is a tool/transport failure, not a no-evidence finding — real feedback may
> have been processed WITHOUT the peer-resolution recheck. Reason:
> evidence gathering failed: could not fetch pull [endojs/endo-but-for-bots#982](https://github.com/endojs/endo-but-for-bots/issues/982)
> --- captured stderr ---
> gh: Not Found (HTTP 404)

- `doomed-endojs-endo-but-for-bots-pr807-gauntlet-fix-1-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr807-gauntlet-fix-1-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr807-gauntlet-fix-1; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr807-gauntlet-fix-1) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr807-gauntlet-fix-1
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: shepherd
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:57:49Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: shepherd
> handler-timeout: 7200
> gauntlet: endojs-endo-but-for-bots-pr807-gauntlet
> gauntlet_stage: fix
> gauntlet_iteration: 1
> pr: [https://github.com/endojs/endo-but-for-bots/pull/807](https://github.com/endojs/endo-but-for-bots/pull/807)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #807
>
> You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr807-gauntlet). Apply the panel's must-fix items ONCE,
> push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr807-gauntlet-fix-1 <pr-head-owner>/<repo-name> <pr-head-branch>`.
>    Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/807 --json headRepositoryOwner,headRefName`;
>    do not pass the base repo when the PR head belongs to a fork.
> 2. Read the LATEST panel verdict on [https://github.com/endojs/endo-but-for-bots/pull/807](https://github.com/endojs/endo-but-for-bots/pull/807) (the request-changes `gh pr review` the
>    panel-1 stage just posted) for its must-fix items. Apply them.
> 3. Push the fix as review-feedback follow-up commits to the PR head with
>    `scripts/jobs/gardening/safe-push-pr-head.sh`.
> 4. Watch CI to terminal, BOUNDED (same as the clean stage):
>    `GARDEN_CI_DEADLINE_SECS=3600 \
>      scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 807 --no-merge`
>    - rc 0 (GREEN): success.
>    - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
>    - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
>   <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `doomed-kriscendobot-minion.town-pr37-gauntlet-panel-6-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-kriscendobot-minion.town-pr37-gauntlet-panel-6-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/kriscendobot-minion.town-pr37-gauntlet-panel-6; it stays HELD until a human promotes it
> (promote-plan.sh kriscendobot-minion.town-pr37-gauntlet-panel-6) or removes it, so nothing is lost.
> Original job base: kriscendobot-minion.town-pr37-gauntlet-panel-6
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: panel
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:58:49Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: panel
> handler-timeout: 7200
> gauntlet: kriscendobot-minion.town-pr37-gauntlet
> gauntlet_stage: panel
> gauntlet_iteration: 6
> pr: [https://github.com/kriscendobot/minion.town/pull/37](https://github.com/kriscendobot/minion.town/pull/37)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #37
>
> You are ONE stage of a staged gauntlet (kriscendobot-minion.town-pr37-gauntlet). Run EXACTLY ONE panel round, post the
> verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh kriscendobot-minion.town-pr37-gauntlet-panel-6 <pr-head-owner>/<repo-name> <pr-head-branch>`.
>    Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/minion.town/pull/37 --json headRepositoryOwner,headRefName`;
>    do not pass the base repo when the PR head belongs to a fork.
> 2. Run the panel in SINGLE-ROUND mode against that worktree:
>    `GARDEN_PANEL_SINGLE_ROUND=1 \
>      scripts/jobs/gardening/panel.sh <worktree> 37 <base-ref>`
>    It fans the seats, aggregates, and prints its disposition as the terminal line's
>    last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
> 3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on [https://github.com/kriscendobot/minion.town/pull/37](https://github.com/kriscendobot/minion.town/pull/37) — the
>    panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
>    review on must-fix, a comment/approve on pass).
> 4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
>    report with `orchestration-failed: true` and do NOT emit a panel marker.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: panel=pass -->
>   <!-- gauntlet-stage-result: panel=must-fix -->

- `20260901T175244Z-931faa` — from gardener:minion-town-remove-mcp-tool-prefixes, reply_to `minion-town-remove-mcp-tool-prefixes` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T175244Z-931faa.md)

> [kriscendobot/minion.town#75](https://github.com/kriscendobot/minion.town/issues/75) is merged and deployment run 33539977066 succeeded. The remaining required blind live discovery evaluation needs an authenticated minion.town MCP session. This worker container has no AWS CLI/credentials or minion.town OAuth connection, so it cannot read the sanctioned minion/test-cc-client secret or attach the live MCP to a context-free agent. Please either run a connected blind agent with only the directive "evaluate 2 + 2" and send the transcript/result, or make a short-lived sanctioned Bearer token available through this job inbox (do not paste a long-lived client secret).

- `20260903T223114Z-7b9785` — from gardener:self-heal-fix-garden-state-clone-keeper-head-deployed-sha-drift, reply_to `self-heal-fix-garden-state-clone-keeper-head-deployed-sha-drift` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260903T223114Z-7b9785.md)

> root-repo-guard fix landed on main2 (c2ea79b117): guard_head() now treats a detached HEAD that is a main2 ancestor but != deployed_sha as drift and re-detaches to the deploy point. This is the bug that let garden-state-clone-keeper.service fail rc=127.
>
> IMMEDIATE REMEDIATION still needed on host endolin-garden-ece02cb4: its root checkout HEAD is at 252205765d (an old ancestor) while deployed-sha and the rendered units expect 3cfbeb5ac4. I did NOT touch $GARDEN_ROOT (git-in-root is forbidden — corrupts journal sync). Please run a deliberate, drained `deploy-garden.sh` on that host: it re-advances the root to the current deployed sha AND deploys this guard fix, after which the guard self-heals this drift class on every future tick. (Once deployed, the newly-deployed guard would also re-detach the stale HEAD to deployed_sha on its next tick even without a full deploy — but a deploy is the clean fix since the running code is itself stale.)

- `doomed-endojs-endo-but-for-bots-pr909-gauntlet-fix-1-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr909-gauntlet-fix-1-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr909-gauntlet-fix-1; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr909-gauntlet-fix-1) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr909-gauntlet-fix-1
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: shepherd
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:58:22Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: shepherd
> handler-timeout: 7200
> gauntlet: endojs-endo-but-for-bots-pr909-gauntlet
> gauntlet_stage: fix
> gauntlet_iteration: 1
> pr: [https://github.com/endojs/endo-but-for-bots/pull/909](https://github.com/endojs/endo-but-for-bots/pull/909)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #909
>
> You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr909-gauntlet). Apply the panel's must-fix items ONCE,
> push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr909-gauntlet-fix-1 endojs/endo-but-for-bots <pr-head-branch>`.
> 2. Read the LATEST panel verdict on [https://github.com/endojs/endo-but-for-bots/pull/909](https://github.com/endojs/endo-but-for-bots/pull/909) (the request-changes `gh pr review` the
>    panel-1 stage just posted) for its must-fix items. Apply them.
> 3. Push the fix as review-feedback follow-up commits to the PR head with
>    `scripts/jobs/gardening/safe-push-pr-head.sh`.
> 4. Watch CI to terminal, BOUNDED (same as the clean stage):
>    `GARDEN_CI_DEADLINE_SECS=3600 \
>      scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 909 --no-merge`
>    - rc 0 (GREEN): success.
>    - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
>    - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
>   <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)


## Spend & quota
_Since Friday 20:00 Pacific reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 60.9M | $635.14 _(notional, rate-card)_ | 10% of 595.0M (ok) |
| Codex | 9.7M _(+389.0M cached)_ | n/a _(ChatGPT plan — no per-token $; plan-metered)_ | no quota set |

## Board
### todo (0)
(none)

### doin (111)
- [`design-pass-style-symbol-condition-variant`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-pass-style-symbol-condition-variant.md) — Motivation, as given
- [`cybernetics-rec8-scheduler-admission`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/cybernetics-rec8-scheduler-admission.md) — ---
- [`kriscendobot-garden-pr73-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-garden-pr73-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/garden PR #73
- [`endojs-endo-but-for-bots-pr431-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr431-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #431
- [`xs2rust-endor-press-20260903-005005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260903-005005.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`design-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-claude-usage-dashboard-scraper.md) — Starting brief (from the liaison's inline proposal; revise freely, this is a ...
- [`minion-town-validate-clip-site-separation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-validate-clip-site-separation.md) — Why this matters
- [`kriscendobot-agoric-sdk-pr10-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-agoric-sdk-pr10-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/agoric-sdk PR #10
- [`ironhorse-fuzz-91afec2d990bc402-repair-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-91afec2d990bc402-repair-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1088
- [`ironhorse-test262-fable-supervisor-20260829-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-test262-fable-supervisor-20260829-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1113
- [`endojs-endo-but-for-bots-pr356-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr356-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #356
- [`build-npm-registry-as-directory-tree-review5064787686-r2-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-npm-registry-as-directory-tree-review5064787686-r2-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1117
- [`dependabotany-recheck-endo-but-for-bots-20260903-035007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/dependabotany-recheck-endo-but-for-bots-20260903-035007.md) — Daily dependabotany backstop for endo-but-for-bots
- [`endojs-endo-but-for-bots-pr335-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr335-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #335
- [`endojs-endo-but-for-bots-pr241-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr241-gauntlet-fix-6.md) — Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #241
- [`minion-town-pr41-link-build-pr`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-pr41-link-build-pr.md) — Drop the git-remote build PR link on kriscendobot/minion.town#41
- [`minion-town-clip-formula-id-origin-gc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-clip-formula-id-origin-gc.md) — The reported concern
- [`kriscendobot-agoric-sdk-pr18-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-agoric-sdk-pr18-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — kriscendobot/agoric-sdk PR #18
- [`endojs-endo-but-for-bots-pr1115-8bddd4d7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1115-8bddd4d7.md) — attention directive on endojs/endo-but-for-bots PR #1115
- [`ironhorse-fuzz-2276f4edebdcb3bb-repair-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-2276f4edebdcb3bb-repair-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1088
- [`endojs-endo-but-for-bots-pr1072-review-e10c72d0`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1072-review-e10c72d0.md) — Review directive on endojs/endo-but-for-bots PR #1072
- [`ironhorse-fuzz-ab889c8f6184c60d-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-ab889c8f6184c60d-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1088
- [`cybernetics-rec9-inbox-coalescing`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/cybernetics-rec9-inbox-coalescing.md) — ---
- [`endojs-endo-but-for-bots-pr539-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr539-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #539
- [`endojs-endo-but-for-bots-pr1089-32c7e8f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1089-32c7e8f1.md) — attention directive on endojs/endo-but-for-bots PR #1089
- [`cybernetics-rec4-fuzz-triage-backpressure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/cybernetics-rec4-fuzz-triage-backpressure.md) — ---
- [`endojs-endo-but-for-bots-pr1102-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1102-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1102
- [`ironhorse-fuzz-6f0b586a80019097-repair-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-6f0b586a80019097-repair-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1088
- [`endojs-endo-but-for-bots-pr897-a478f53a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr897-a478f53a.md) — attention directive on endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr322-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr322-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #322
- [`minion-town-guest-reminders-capability-experiment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-guest-reminders-capability-experiment.md) — Experimentally inject an @reminders capability into new minion.town guests, v...
- [`build-minion-town-clip-shell-framework`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-minion-town-clip-shell-framework.md) — Borrow extensively from @endo/chat
- [`endojs-endo-but-for-bots-pr266-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr266-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #266
- [`endojs-endo-but-for-bots-pr1080-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1080-conduct.md) — Finalize (curate -> merge) endojs/endo-but-for-bots PR #1080
- [`ironhorse-fuzz-66facfd52ae8c673-repair-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-66facfd52ae8c673-repair-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1088
- [`xs2rust-endor-press-20260902-215005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260902-215005.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr1018-fddf3f5a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1018-fddf3f5a.md) — attention directive on endojs/endo-but-for-bots PR #1018
- [`kriscendobot-minion.town-pr41-dadbe275`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-minion.town-pr41-dadbe275.md) — attention directive on kriscendobot/minion.town PR #41
- [`cybernetics-rec7-frontmatter-validation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/cybernetics-rec7-frontmatter-validation.md) — ---
- [`build-minion-town-invitation-onboarding`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-minion-town-invitation-onboarding.md) — Build invitation-only guest onboarding for minion.town
- [`xs2rust-endor-press-20260902-225005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260902-225005.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr1098-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1098-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1098
- [`issue-kriscendobot-garden-79`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/issue-kriscendobot-garden-79.md) — Issue from kriskowal on kriscendobot/garden #79
- [`minion-town-formula-graph-content-gc-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-formula-graph-content-gc-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/minion.town PR #83
- [`endojs-endo-but-for-bots-pr1125-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1125-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #1125
- [`ebfb-exo-stream-drop-base64-stream-methods-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1100
- [`diagnose-panel-fix-loop-oscillation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/diagnose-panel-fix-loop-oscillation.md) — Why do panel must-fix counts oscillate instead of descending?
- [`endojs-endo-but-for-bots-pr891-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr891-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #891
- [`minion-town-pr17-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-pr17-conduct.md) — ---
- [`build-ocapn-nonce-locator-endo-mechanism-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-ocapn-nonce-locator-endo-mechanism-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1124
- [`xs2rust-endor-press-20260903-093506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260903-093506.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr996-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr996-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #996
- [`endojs-endo-but-for-bots-pr666-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr666-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #666
- [`design-manual-quota-calibration`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-manual-quota-calibration.md) — What already exists (read first)
- [`endojs-endo-but-for-bots-pr717-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr717-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #717
- [`minion-town-clipometer-esbuild-pipeline-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-clipometer-esbuild-pipeline-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — kriscendobot/minion.town PR #84
- [`xs2rust-endor-press-20260901-033503`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260901-033503.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr735-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr735-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #735
- [`xs2rust-endor-press-20260903-140507`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260903-140507.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr1018-fix-20260901-122004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1018-fix-20260901-122004.md) — Address current Ironhorse panic-design review on endojs/endo-but-for-bots#1018
- [`xs2rust-endor-press-20260903-025006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260903-025006.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`design-reset-time-detection`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-reset-time-detection.md) — What already exists
- [`endojs-endo-but-for-bots-pr1103-ff1e7149`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1103-ff1e7149.md) — attention directive on endojs/endo-but-for-bots PR #1103
- [`endojs-endo-but-for-bots-pr264-review-1da7ebe7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr264-review-1da7ebe7.md) — Review directive on endojs/endo-but-for-bots PR #264
- [`endojs-endo-but-for-bots-pr814-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr814-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #814
- [`kriscendobot-garden-pr75-review-c4c627a3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-garden-pr75-review-c4c627a3.md) — Review directive on kriscendobot/garden PR #75
- [`endojs-endo-but-for-bots-pr1116-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1116-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1116
- [`endojs-endo-but-for-bots-pr254-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr254-conduct.md) — Finalize (curate -> merge) endojs/endo-but-for-bots PR #254
- [`fu-minion-town-containment-gateway-endo-sock-1-20260903-035007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/fu-minion-town-containment-gateway-endo-sock-1-20260903-035007.md) — Containment drift check for kriscendobot/minion.town gateway records
- [`endojs-endo-but-for-bots-pr938-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr938-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #938
- [`endojs-endo-but-for-bots-pr1099-review-6694e2d7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1099-review-6694e2d7.md) — Review directive on endojs/endo-but-for-bots PR #1099
- [`endojs-endo-but-for-bots-pr673-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr673-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #673
- [`endojs-endo-but-for-bots-pr1013-gauntlet-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1013-gauntlet-panel-5.md) — Gauntlet stage: PANEL round 5 — endojs/endo-but-for-bots PR #1013
- [`kriscendobot-garden-pr77-review-13d229b9`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-garden-pr77-review-13d229b9.md) — Review directive on kriscendobot/garden PR #77
- [`deadmail-issue-comment-5518048659`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/deadmail-issue-comment-5518048659.md) — Issue follow-up — fold a late comment into the issue work
- [`endojs-endo-but-for-bots-pr887-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr887-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #887
- [`endojs-endo-but-for-bots-pr1097-fix-review`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1097-fix-review.md) — Fix PR #1097 per @kriskowal review (CHANGES_REQUESTED)
- [`kriscendobot-minion-town-pr68-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-minion-town-pr68-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr511-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr511-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #511
- [`build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet-panel-6.md) — Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #79
- [`endojs-endo-but-for-bots-pr935-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr935-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #935
- [`diagnose-panel-seat-error-rate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/diagnose-panel-seat-error-rate.md) — Diagnose why all seven panel seats error together (~20% of panel runs)
- [`endojs-endo-but-for-bots-pr1125-aea62c0d`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1125-aea62c0d.md) — attention directive on endojs/endo-but-for-bots PR #1125
- [`ironhorse-fuzz-1898f584e9bf841a-repair-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-1898f584e9bf841a-repair-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1088
- [`kriscendobot-garden-pr73-review-6e23fb68`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-garden-pr73-review-6e23fb68.md) — Review directive on kriscendobot/garden PR #73
- [`endojs-endo-but-for-bots-pr450-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr450-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #450
- [`endojs-endo-but-for-bots-pr665-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr665-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #665
- [`endojs-endo-but-for-bots-pr715-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr715-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #715
- [`ironhorse-fuzz-314f811064b8febb-repair-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-314f811064b8febb-repair-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`garden-pty-lane-context-introspection`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/garden-pty-lane-context-introspection.md) — Experimental PTY lane with context-usage introspection
- [`kriscendobot-minion.town-pr17-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-minion.town-pr17-conduct.md) — Finalize (curate -> merge) kriscendobot/minion.town PR #17
- [`xs2rust-endor-press-20260903-233506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260903-233506.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr249-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr249-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #249
- [`endojs-endo-but-for-bots-pr569-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr569-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #569
- [`endojs-endo-but-for-bots-pr741-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr741-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #741
- [`endojs-endo-but-for-bots-pr892-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr892-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #892
- [`endojs-endo-but-for-bots-pr797-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr797-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #797
- [`endojs-endo-but-for-bots-pr1106-88910e00`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1106-88910e00.md) — attention directive on endojs/endo-but-for-bots PR #1106
- [`endojs-endo-but-for-bots-pr249-pinbase`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr249-pinbase.md) — pinbase directive on endojs/endo-but-for-bots PR #249
- [`build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — kriscendobot/minion.town PR #81
- [`xs2rust-endor-press-20260903-163507`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260903-163507.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`design-groom-role`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-groom-role.md) — Why
- [`endojs-endo-but-for-bots-pr508-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr508-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #508
- [`xs2rust-endor-press-20260903-015006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260903-015006.md) — Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr695-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr695-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #695
- [`endojs-endo-but-for-bots-pr1097-ea5076f8`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1097-ea5076f8.md) — attention directive on endojs/endo-but-for-bots PR #1097
- [`self-heal-fix-garden-mirror-closer-gh-primary-quota-already-exceeded-misclassified`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/self-heal-fix-garden-mirror-closer-gh-primary-quota-already-exceeded-misclassified.md) — ---
- [`endojs-endo-but-for-bots-pr1099-51e0345a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1099-51e0345a.md) — attention directive on endojs/endo-but-for-bots PR #1099
- [`endojs-endo-but-for-bots-pr1127-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1127-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1127
- [`endojs-endo-but-for-bots-pr1102-narrow-special-names`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1102-narrow-special-names.md) — Narrow design PR #1102 to the special-names-on-options-bag mechanism
- [`endojs-endo-but-for-bots-pr933-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr933-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #933

### tada (6829)
- [`endojs-endo-but-for-bots-pr1127-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1127-conduct.md) — Cost
- [`endojs-endo-but-for-bots-pr1127-dd008d4e`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1127-dd008d4e.md) — Report
- [`xs2rust-endor-press-20260903-222019`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260903-222019.md) — Ironhorse press — completion report (dispatch xs2rust-endor-press-20260903-22...
- [`xs2rust-endor-press-20260903-210515`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260903-210515.md) — Ironhorse press — completion report (dispatch xs2rust-endor-press-20260903-21...
- [`xs2rust-endor-press-20260903-200506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260903-200506.md) — Ironhorse press — assessment (dispatch xs2rust-endor-press-20260903-200506)
- … and 6824 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`ironhorse-fuzz-bd4559ecbc0432c1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bd4559ecbc0432c1-repair.md) — _normal_ · Repair Ironhorse engine defect bd4559ecbc0432c1 (target differential_source) ...
- [`ironhorse-fuzz-baad1f22ef053213-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-baad1f22ef053213-repair.md) — _normal_ · Repair Ironhorse engine defect baad1f22ef053213 (target differential_regexp_s...
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`ironhorse-fuzz-fcbb16f5721e8fd2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fcbb16f5721e8fd2-repair.md) — _normal_ · Fix Ironhorse fuzz finding fcbb16f5721e8fd2 (target differential_source) and ...
- [`ironhorse-fuzz-89e303d17e33b117-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-89e303d17e33b117-repair.md) — _normal_ · Repair Ironhorse engine defect 89e303d17e33b117 (target differential_regexp_s...
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`ironhorse-fuzz-8b8afc47fcfb223d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8b8afc47fcfb223d-repair.md) — _normal_ · Repair Ironhorse engine defect 8b8afc47fcfb223d (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr663-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr663-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #663
- [`minion-town-weblet-ocap-synthesis-units-4-5-land-weekly-reset`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-weblet-ocap-synthesis-units-4-5-land-weekly-reset.md) — _high_ · Finish and land minion.town OCap synthesis units 4-5 after the weekly panel r...
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`ironhorse-fuzz-50834e82d3af453d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-50834e82d3af453d-repair.md) — _normal_ · Repair Ironhorse engine defect 50834e82d3af453d (target differential_regexp_s...
- [`ironhorse-fuzz-27824c75429b8581-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-27824c75429b8581-repair.md) — _normal_ · Repair Ironhorse engine defect 27824c75429b8581 (target differential_source) ...
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`endojs-endo-but-for-bots-pr550-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr550-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #550
- [`endojs-endo-but-for-bots-pr945-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr945-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #945
- [`ironhorse-fuzz-12aca768c2e73c73-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-12aca768c2e73c73-repair.md) — _normal_ · Fix Ironhorse fuzz finding 12aca768c2e73c73 (target differential_regexp) and ...
- [`ironhorse-fuzz-c781c9b9de456ab2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c781c9b9de456ab2-repair.md) — _normal_ · Repair Ironhorse engine defect c781c9b9de456ab2 (target differential_regexp_s...
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`ironhorse-fuzz-bc9529ac5818aa24-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc9529ac5818aa24-repair.md) — _normal_ · Repair Ironhorse engine defect bc9529ac5818aa24 (target differential_regexp_s...
- [`ironhorse-fuzz-9001b34fa6dd2d80-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9001b34fa6dd2d80-repair.md) — _normal_ · Repair Ironhorse engine defect 9001b34fa6dd2d80 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr551-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr551-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #551
- [`build-e-untag-handled-promise-pipelining`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-e-untag-handled-promise-pipelining.md) — _normal_ · What already exists (do not re-derive; verify against current master
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`xs2rust-endor-press-20260902-090504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-090504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr359-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr359-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #359
- [`sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1013
- [`ironhorse-fuzz-3a6aab9d9d140c2c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3a6aab9d9d140c2c-repair.md) — _normal_ · Repair Ironhorse engine defect 3a6aab9d9d140c2c (target differential_regexp_s...
- [`ironhorse-fuzz-c6c71d428a37088c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c6c71d428a37088c-repair.md) — _normal_ · Repair Ironhorse engine defect c6c71d428a37088c (target differential_regexp_s...
- [`ironhorse-fuzz-51c6a212946102f6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-51c6a212946102f6-repair.md) — _normal_ · Repair Ironhorse engine defect 51c6a212946102f6 (target differential_regexp) ...
- [`ironhorse-fuzz-13b68e2edb67861a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-13b68e2edb67861a-repair.md) — _normal_ · Repair Ironhorse engine defect 13b68e2edb67861a (target differential_regexp) ...
- [`ironhorse-fuzz-e2a75557f762cd9c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e2a75557f762cd9c-repair.md) — _normal_ · Repair Ironhorse engine defect e2a75557f762cd9c (target differential_regexp) ...
- [`endo-claude-agent-sdk-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-probe.md) — _normal_ · Probe: measure the Agent SDK's confinement claims against a live run
- [`ironhorse-fuzz-f83dc8932cd3b41a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f83dc8932cd3b41a-repair.md) — _normal_ · Repair Ironhorse engine defect f83dc8932cd3b41a (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr264-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #264
- [`endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1085
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr879-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr879-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #879
- [`endojs-endo-but-for-bots-pr897-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave-20260901.md) — _normal_ · Weave (rebase onto live llm) endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr664-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr664-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #664
- [`xs2rust-endor-press-20260902-110504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-110504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-1cd4ddc72d5801c4-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cd4ddc72d5801c4-repair.md) — _normal_ · Repair Ironhorse engine defect 1cd4ddc72d5801c4 (target differential_regexp_s...
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`ironhorse-fuzz-f2f53bb078bc8a4e-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f2f53bb078bc8a4e-repair.md) — _normal_ · Fix Ironhorse fuzz finding f2f53bb078bc8a4e (target differential_regexp) and ...
- [`ironhorse-fuzz-cfdc1a28296f23a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-cfdc1a28296f23a1-repair.md) — _normal_ · Repair Ironhorse engine defect cfdc1a28296f23a1 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr360-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr360-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #360
- [`endojs-endo-but-for-bots-pr990-refresh`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr990-refresh.md) — _normal_ · refresh directive on endojs/endo-but-for-bots PR #990
- [`xs2rust-endor-press-20260902-130505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-130505.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`retire-gardener-worker-kind-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-worker-kind-alias.md) — _normal_ · ---
- [`xs2rust-endor-press-20260902-162005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-162005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-1a2012ae1ec44d21-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1a2012ae1ec44d21-repair.md) — _normal_ · Fix Ironhorse fuzz finding 1a2012ae1ec44d21 (target differential_regexp_surfa...
- [`ironhorse-fuzz-6ba52f2bdc534545-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ba52f2bdc534545-repair.md) — _normal_ · Repair Ironhorse engine defect 6ba52f2bdc534545 (target differential_regexp_s...
- [`xs2rust-endor-press-20260902-120504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-120504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`kriscendobot-minion.town-pr79-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr79-conduct.md) — _normal_ · Finalize (curate -> merge) kriscendobot/minion.town PR #79
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-base-update-and-pin-alias.md) — _normal_ · ---
- [`ironhorse-fuzz-ccb76a40851925f9-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ccb76a40851925f9-repair.md) — _normal_ · Repair Ironhorse engine defect ccb76a40851925f9 (target differential_regexp) ...
- [`ironhorse-fuzz-d5413146a257bc30-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d5413146a257bc30-repair.md) — _normal_ · Repair Ironhorse engine defect d5413146a257bc30 (target differential_regexp_s...
- [`kriscendobot-minion.town-pr68-retcon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-retcon.md) — _normal_ · retcon directive on kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr675-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr675-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #675
- [`ironhorse-fuzz-ad5b483fc5e0973f-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ad5b483fc5e0973f-repair.md) — _normal_ · Repair Ironhorse engine defect ad5b483fc5e0973f (target differential_regexp_s...
- [`ironhorse-fuzz-79f0475dd0440b2d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-79f0475dd0440b2d-repair.md) — _normal_ · Repair Ironhorse engine defect 79f0475dd0440b2d (target differential_regexp) ...
- [`ironhorse-fuzz-b95320dfb5dd9d3d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-b95320dfb5dd9d3d-repair.md) — _normal_ · Repair Ironhorse engine defect b95320dfb5dd9d3d (target differential_regexp_s...
- [`ironhorse-fuzz-7072dc2d72d9e2fd-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7072dc2d72d9e2fd-repair.md) — _normal_ · Repair Ironhorse engine defect 7072dc2d72d9e2fd (target differential_regexp) ...
- [`ironhorse-fuzz-ecae051e6e8f5a27-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ecae051e6e8f5a27-repair.md) — _normal_ · Repair Ironhorse engine defect ecae051e6e8f5a27 (target differential_source) ...
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`xs2rust-endor-press-20260902-183505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-183505.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-67ca18e4febe7a34-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-67ca18e4febe7a34-repair.md) — _normal_ · Repair Ironhorse engine defect 67ca18e4febe7a34 (target differential_source) ...
- [`ironhorse-fuzz-2cc2ac67ba7e9b9f-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2cc2ac67ba7e9b9f-repair.md) — _normal_ · Repair Ironhorse engine defect 2cc2ac67ba7e9b9f (target differential_regexp_s...
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr762-gauntlet-20260902`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr762-gauntlet-20260902.md) — _normal_ · Complete the gauntlet for endojs/endo-but-for-bots#762
- [`ironhorse-fuzz-d87697d49a5f8f67-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d87697d49a5f8f67-repair.md) — _normal_ · Repair Ironhorse engine defect d87697d49a5f8f67 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr463-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr463-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #463
- [`ironhorse-fuzz-e0fe14e41d5074a6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e0fe14e41d5074a6-repair.md) — _normal_ · Repair Ironhorse engine defect e0fe14e41d5074a6 (target differential_source) ...
- [`ironhorse-fuzz-ab41c5d203ace017-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ab41c5d203ace017-repair.md) — _normal_ · Repair Ironhorse engine defect ab41c5d203ace017 (target differential_regexp) ...
- [`xs2rust-endor-press-20260902-173504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-173504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr432-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr432-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #432
- [`kriscendobot-minion.town-pr56-review-7d4dc95d`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-7d4dc95d.md) — _normal_ · Review directive on kriscendobot/minion.town PR #56
- [`endojs-endo-but-for-bots-pr736-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr736-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #736
- [`endojs-endo-but-for-bots-pr871-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr871-weave-20260901.md) — _normal_ · Weave endojs/endo-but-for-bots#871 — the sturdyref agent-surface build
- [`amend-invitation-oauth-mcp-prerequisite`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/amend-invitation-oauth-mcp-prerequisite.md) — _normal_ · What's actually true today versus what's designed for later — verify,
- [`ironhorse-fuzz-bc3d0df623811a38-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc3d0df623811a38-repair.md) — _normal_ · Fix Ironhorse fuzz finding bc3d0df623811a38 (target differential_regexp_surfa...
- [`ironhorse-fuzz-fad9672dc7a6e6be-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fad9672dc7a6e6be-repair.md) — _normal_ · Repair Ironhorse engine defect fad9672dc7a6e6be (target differential_source) ...
- [`ironhorse-fuzz-197b32cc30bdd4fe-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-197b32cc30bdd4fe-repair.md) — _normal_ · Repair Ironhorse engine defect 197b32cc30bdd4fe (target differential_regexp_s...
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
- [`xs2rust-endor-press-20260902-100504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-100504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endo-pr3360-mirror`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-pr3360-mirror.md) — _normal_ · What "mirror" means here
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`ironhorse-fuzz-c99f800f6a36e8a6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c99f800f6a36e8a6-repair.md) — _normal_ · Repair Ironhorse engine defect c99f800f6a36e8a6 (target differential_regexp) ...
- [`ironhorse-fuzz-9894aac5ad23c6eb-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9894aac5ad23c6eb-repair.md) — _normal_ · Repair Ironhorse engine defect 9894aac5ad23c6eb (target differential_regexp) ...
- [`ironhorse-fuzz-af5b4a677483eac3-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-af5b4a677483eac3-repair.md) — _normal_ · Fix Ironhorse fuzz finding af5b4a677483eac3 (target differential_regexp_surfa...
- [`ironhorse-fuzz-5eeb0aadb2004075-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5eeb0aadb2004075-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5eeb0aadb2004075 (target differential_regexp) and ...
- [`ironhorse-fuzz-ac8a8e3d9d3d7f96-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ac8a8e3d9d3d7f96-repair.md) — _normal_ · Repair Ironhorse engine defect ac8a8e3d9d3d7f96 (target differential_regexp) ...
- [`ironhorse-fuzz-378372c8706a48a8-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-378372c8706a48a8-repair.md) — _normal_ · Fix Ironhorse fuzz finding 378372c8706a48a8 (target differential_regexp_surfa...
- [`minion-town-endo-b3-daemon-deploy-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-endo-b3-daemon-deploy-verify.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-issue982-build-special-names`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-issue982-build-special-names.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr68-review-45cc89f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-review-45cc89f1.md) — _normal_ · Review directive on kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr1018-review-eccc706c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-eccc706c.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1018
- [`xs2rust-endor-press-20260902-152005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-152005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-05264cccae42245a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-05264cccae42245a-repair.md) — _normal_ · Repair Ironhorse engine defect 05264cccae42245a (target differential_source) ...
- [`ironhorse-fuzz-5c9d2506e6048f4a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5c9d2506e6048f4a-repair.md) — _normal_ · Repair Ironhorse engine defect 5c9d2506e6048f4a (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr897-shepherd-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-shepherd-20260901.md) — _normal_ · ---
- [`ironhorse-fuzz-daf6694aec7856aa-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-daf6694aec7856aa-repair.md) — _normal_ · Repair Ironhorse engine defect daf6694aec7856aa (target differential_source) ...
- [`ironhorse-fuzz-a172d6aba922c9ad-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-a172d6aba922c9ad-repair.md) — _normal_ · Repair Ironhorse engine defect a172d6aba922c9ad (target differential_regexp) ...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`xs2rust-endor-press-20260902-065004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-065004.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-7637ac162a0b916a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7637ac162a0b916a-repair.md) — _normal_ · Repair Ironhorse engine defect 7637ac162a0b916a (target differential_regexp) ...
- [`ironhorse-fuzz-931a687135cabb0c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-931a687135cabb0c-repair.md) — _normal_ · Repair Ironhorse engine defect 931a687135cabb0c (target differential_source) ...
- [`ironhorse-fuzz-9edaa2277fb90f03-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9edaa2277fb90f03-repair.md) — _normal_ · Repair Ironhorse engine defect 9edaa2277fb90f03 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr709-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr709-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #709
- [`ironhorse-fuzz-1dc231089278c110-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1dc231089278c110-repair.md) — _normal_ · Repair Ironhorse engine defect 1dc231089278c110 (target differential_regexp) ...
- [`ironhorse-fuzz-822848c732a1b805-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-822848c732a1b805-repair.md) — _normal_ · Repair Ironhorse engine defect 822848c732a1b805 (target differential_regexp) ...
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`ironhorse-fuzz-e4a8e011666d0362-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e4a8e011666d0362-repair.md) — _normal_ · Repair Ironhorse engine defect e4a8e011666d0362 (target differential_regexp_s...
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`endojs-endo-but-for-bots-pr697-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr697-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #697
- [`endojs-endo-but-for-bots-pr631-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr631-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #631
- [`endojs-endo-but-for-bots-pr711-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr711-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #711
- [`ironhorse-fuzz-fd8517d5f3071227-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fd8517d5f3071227-repair.md) — _normal_ · Repair Ironhorse engine defect fd8517d5f3071227 (target differential_regexp) ...
- [`ironhorse-fuzz-557805e944888b5a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-557805e944888b5a-repair.md) — _normal_ · Repair Ironhorse engine defect 557805e944888b5a (target differential_regexp_s...
- [`ironhorse-fuzz-284de587e16bce32-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-284de587e16bce32-repair.md) — _normal_ · Repair Ironhorse engine defect 284de587e16bce32 (target differential_source) ...
- [`ironhorse-fuzz-repromote-quarantined`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-repromote-quarantined.md) — _normal_ · Re-promote the quarantined ironhorse fuzz-repair jobs
- [`endojs-endo-but-for-bots-pr529-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr529-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #529
- [`ironhorse-ocap-workload-optimization`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-workload-optimization.md) — _normal_ · The thesis
- [`ironhorse-fuzz-5e7a173f899ae7a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5e7a173f899ae7a1-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5e7a173f899ae7a1 (target differential_regexp) and ...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`endojs-endo-but-for-bots-pr648-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr648-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #648
- [`ironhorse-fuzz-e773681b6d831dc1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e773681b6d831dc1-repair.md) — _normal_ · Repair Ironhorse engine defect e773681b6d831dc1 (target differential_regexp_s...
- [`build-kebab-case-lint-wildcard-test262-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #762
- [`build-minion-town-claude-agents-capability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-claude-agents-capability.md) — _normal_ · ---
- [`ironhorse-fuzz-bf6cfbd74a7487fc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bf6cfbd74a7487fc-repair.md) — _normal_ · Repair Ironhorse engine defect bf6cfbd74a7487fc (target differential_regexp) ...
- [`daily-progress-summary-20260902-070506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20260902-070506.md) — _normal_ · Daily midnight Pacific progress summary
- [`ironhorse-fuzz-4658b8adc7bdd428-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-4658b8adc7bdd428-repair.md) — _normal_ · Repair Ironhorse engine defect 4658b8adc7bdd428 (target differential_source) ...
- [`ironhorse-fuzz-45f4af87eaf627c7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-45f4af87eaf627c7-repair.md) — _normal_ · Fix Ironhorse fuzz finding 45f4af87eaf627c7 (target differential_regexp) and ...
- [`ironhorse-fuzz-37e026fd30cbae19-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-37e026fd30cbae19-repair.md) — _normal_ · Repair Ironhorse engine defect 37e026fd30cbae19 (target differential_source) ...
- [`ironhorse-fuzz-c9eaa7b5ae02437a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c9eaa7b5ae02437a-repair.md) — _normal_ · Repair Ironhorse engine defect c9eaa7b5ae02437a (target differential_regexp_s...
- [`xs2rust-endor-press-20260902-142005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-142005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-d38f12f4884e186c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d38f12f4884e186c-repair.md) — _normal_ · Repair Ironhorse engine defect d38f12f4884e186c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr610-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr610-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #610
- [`xs2rust-endor-press-20260902-205005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-205005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-29a24c1b1052ec91-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-29a24c1b1052ec91-repair.md) — _normal_ · Repair Ironhorse engine defect 29a24c1b1052ec91 (target differential_regexp) ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ironhorse-fuzz-6ca7a76e0bfe3435-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ca7a76e0bfe3435-repair.md) — _normal_ · Repair Ironhorse engine defect 6ca7a76e0bfe3435 (target differential_regexp_s...
- [`ironhorse-fuzz-aaa423e9c5d56067-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-aaa423e9c5d56067-repair.md) — _normal_ · Repair Ironhorse engine defect aaa423e9c5d56067 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr674-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr674-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #674
- [`proposal-compartments-xs-parser-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/proposal-compartments-xs-parser-design.md) — _normal_ · ---
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`ironhorse-fuzz-8ea950859db8a5f7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8ea950859db8a5f7-repair.md) — _normal_ · Repair Ironhorse engine defect 8ea950859db8a5f7 (target differential_regexp) ...
- [`kriscendobot-vattr97-pr1-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-vattr97-pr1-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/vattr97 PR #1
- [`xs2rust-endor-press-20260902-193509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-193509.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`kriscendobot-minion.town-pr78-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr78-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #78
- [`ironhorse-fuzz-6be90176ff07c648-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6be90176ff07c648-repair.md) — _normal_ · Repair Ironhorse engine defect 6be90176ff07c648 (target differential_regexp) ...
- [`kriscendobot-minion.town-pr80-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr80-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #80
- [`endojs-endo-but-for-bots-pr690-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr690-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #690
- [`gauntlet-endo-pr1113-20260902`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/gauntlet-endo-pr1113-20260902.md) — _normal_ · ---
- [`ironhorse-fuzz-1cb63ec6f8e6fc22-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cb63ec6f8e6fc22-repair.md) — _normal_ · Repair Ironhorse engine defect 1cb63ec6f8e6fc22 (target differential_regexp_s...
- [`ironhorse-fuzz-3310b49d21f64878-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3310b49d21f64878-repair.md) — _normal_ · Fix Ironhorse fuzz finding 3310b49d21f64878 (target differential_source) and ...
- [`xs2rust-endor-press-20260902-075006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-075006.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-8adaa3bbc9cda1ce-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8adaa3bbc9cda1ce-repair.md) — _normal_ · Repair Ironhorse engine defect 8adaa3bbc9cda1ce (target differential_source) ...
- [`ironhorse-fuzz-ed616f6ec22095dc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ed616f6ec22095dc-repair.md) — _normal_ · Repair Ironhorse engine defect ed616f6ec22095dc (target differential_regexp) ...
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`endo-claude-agent-sdk-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-design.md) — _normal_ · Design: the Claude Agent SDK as an alternative confinement substrate for @end...
- [`ironhorse-fuzz-3fc02d8b57faa79a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3fc02d8b57faa79a-repair.md) — _normal_ · Repair Ironhorse engine defect 3fc02d8b57faa79a (target differential_source) ...
- [`endo-claude-agent-sdk-backend`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-backend.md) — _normal_ · Build: a paid-tier Agent SDK backend behind @endo/claude's existing seams
- [`ironhorse-fuzz-2a2de75b75de4894-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2a2de75b75de4894-repair.md) — _normal_ · Repair Ironhorse engine defect 2a2de75b75de4894 (target differential_source) ...
- [`ironhorse-fuzz-a7755caa51aa9320-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-a7755caa51aa9320-repair.md) — _normal_ · Repair Ironhorse engine defect a7755caa51aa9320 (target differential_source) ...

### deferred (top by priority; foreman auto-promotes when idle)
- [`implement-worktree-teardown-on-job-completion`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/implement-worktree-teardown-on-job-completion.md) — _high_ · ---
- [`design-endor-git-windows-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-endor-git-windows-followup.md) — _normal_ · Follow-up: Windows (MSVC) support for endor-git bindings
- [`design-slots-ocapn-op-lanes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-slots-ocapn-op-lanes.md) — _normal_ · ---
- [`ebfb-sturdyref-stack-modernize`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-stack-modernize.md) — _2_ · The situation
- [`ebfb-thixotrope-drop-inert-bundle-filter`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-thixotrope-drop-inert-bundle-filter.md) — _normal_ · ---
- [`endo-bejar-hofman-box-investigation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-bejar-hofman-box-investigation.md) — _normal_ · Investigate the Bejar-Hofman Box: reachable-only-from-roots monitoring
- [`endo-daemon-sqlite-wal-limit-measurement`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-sqlite-wal-limit-measurement.md) — _normal_ · Measure the daemon SQLite WAL size policy
- [`endo-sha256-async-arm-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sha256-async-arm-followup.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-248-build-ses-import-attributes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-248-build-ses-import-attributes.md) — _normal_ · Build: SES import attributes (design #248)
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — _normal_ · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`review-improve-merge-base-pinning`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-improve-merge-base-pinning.md) — _normal_ · review-improve: merge-base-pinning (prevention + durable sensing)
- [`scholar-ingest-cap-talk`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/scholar-ingest-cap-talk.md) — _normal_ · Ingest the cap-talk mailing list into the library
- [`endojs-endo-but-for-bots-pass-style-src-naming`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pass-style-src-naming.md) — _normal_ · regularize pass-style src file naming convention — endojs/endo-but-for-bots
- [`garden-gauntlet-reexport-policy-check`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-gauntlet-reexport-policy-check.md) — _normal_ · propose a gauntlet check that prevents plain re-export policy violations
- [`wire-siwe-onchain-authz-minion-town-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town-followup.md) — _normal_ · Finish wiring SIWE on-chain authz into minion.town's policy layer (maintainer...
- [`endo-immutable-arraybuffer-hardened262-coverage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-immutable-arraybuffer-hardened262-coverage.md) — _normal_ · Extend hardened test262 coverage to every immutable-arraybuffer method
- [`endo-marshal-passables-equal-ava-operator`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-marshal-passables-equal-ava-operator.md) — _normal_ · ava context patch: byteArray-aware passablesEqual operator
- [`endojs-endo-but-for-bots-migrate-agents-to-agentry-scuttle-lal`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-migrate-agents-to-agentry-scuttle-lal.md) — _normal_ · Design/plan: migrate remaining agents to agentry; scuttle the lal providers
- [`minion-town-guest-peer-fetch-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-guest-peer-fetch-verify.md) — _normal_ · Verify peer enlivenSturdyRef fetch of a minion.town guest by formula id
- [`ironhorse-iterator-intrinsic-metadata`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-intrinsic-metadata.md) — _normal_ · fix Ironhorse %IteratorPrototype% / %AsyncIteratorPrototype% intrinsic metadata
- [`local-verify-zizmor-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-zizmor-parity.md) — _low_ · local-verify: cover the zizmor workflow audit (CI parity gap)
- [`explore-ironhorse-promise-chain-shortening`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-promise-chain-shortening.md) — _low_ · Explore: promise resolution chain shortening in Ironhorse
- [`explore-ironhorse-ptc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-ptc.md) — _low_ · Explore: Proper Tail Calls (PTC) in Ironhorse
- [`endojs-endo-but-for-bots-pr388-review-3f255add-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-3f255add-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr888-review-8b40fdbe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr888-review-8b40fdbe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #888 (primary: endojs-endo-but-f...
- [`kriscendobot-minion.town-pr52-review-86b4c679-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr52-review-86b4c679-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #52 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr388-review-37754f3b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-37754f3b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`kriscendobot-minion.town-pr53-review-90b51c86-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr53-review-90b51c86-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #53 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1072-review-73226ec0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-73226ec0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-bb54af10-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-bb54af10-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-a5d1fff6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-a5d1fff6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr819-review-f8bab00f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr819-review-f8bab00f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #819 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr832-review-7bada805-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-review-7bada805-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr858-review-e6eaf772-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-e6eaf772-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1018-review-cf8012a8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-cf8012a8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1015-2b55429b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-2b55429b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1015-review-348a2017-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-review-348a2017-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr832-review-f3554a0a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-review-f3554a0a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1085-b27f483f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-b27f483f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr832-e39ce097-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-e39ce097-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr858-review-8add9193-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-8add9193-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1072-review-c8a0f42b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-c8a0f42b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr66-review-21dce903-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr66-review-21dce903-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #66 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1015-review-6a83ee90-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-review-6a83ee90-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1018-review-eccc706c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-eccc706c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-1e30a92e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-1e30a92e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-43d08bdd-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-43d08bdd-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-6cbbd9d4-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-6cbbd9d4-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-ac4e65b2-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-ac4e65b2-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-b9fa19b7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-b9fa19b7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-beaff99f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-beaff99f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-c4d75838-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-c4d75838-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-fd3c3617-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-fd3c3617-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-070ee47a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-070ee47a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-e10c72d0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-e10c72d0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1080-review-09542d7d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1080-review-09542d7d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1080 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1097-review-8f8bb13f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1097-review-8f8bb13f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1097 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1099-e2aa4377-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1099-e2aa4377-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1099 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1099-review-6694e2d7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1099-review-6694e2d7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1099 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1102-review-61dcfee0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1102-review-61dcfee0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1102 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1105-68436fbc-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1105-68436fbc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1105 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1107-ca3f4ec6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1107-ca3f4ec6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1107 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1115-8bddd4d7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1115-8bddd4d7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1115 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr264-review-1da7ebe7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-review-1da7ebe7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #264 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr897-review-8efe291e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-review-8efe291e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #897 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr935-review-a285ce89-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr935-review-a285ce89-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #935 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr982-0b4f9f5d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr982-0b4f9f5d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #982 (primary: endojs-endo-but-f...
- [`kriscendobot-garden-pr72-review-9328ebe3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr72-review-9328ebe3-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #72 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr72-review-e5ce867a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr72-review-e5ce867a-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #72 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr73-review-6e23fb68-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr73-review-6e23fb68-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #73 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr75-review-c4c627a3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-review-c4c627a3-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr77-review-13d229b9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr77-review-13d229b9-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #77 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr17-review-72d9bc6d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr17-review-72d9bc6d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #17 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr17-review-a27f619f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr17-review-a27f619f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #17 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr41-dadbe275-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr41-dadbe275-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #41 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-ebea2826-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-ebea2826-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-5867a29b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-5867a29b-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-6f509bbb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-6f509bbb-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-7d4dc95d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-7d4dc95d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-7fde9428-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-7fde9428-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr62-review-353e723b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr62-review-353e723b-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #62 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr63-376756ac-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr63-376756ac-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #63 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr63-c48b67b6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr63-c48b67b6-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #63 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr64-review-54703139-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr64-review-54703139-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #64 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr67-review-19714c10-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr67-review-19714c10-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #67 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr68-review-45cc89f1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-review-45cc89f1-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #68 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr73-34dcca36-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr73-34dcca36-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #73 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr76-review-1635fe3d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr76-review-1635fe3d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #76 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr77-review-6b8f8a0e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr77-review-6b8f8a0e-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #77 (primary: kriscendobot-minio...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`endo-sturdyref-agent-surface-gauntlet-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-gauntlet-20260901.md) — awaiting `endojs-endo-but-for-bots-pr871-weave-20260901` · Run the gauntlet for endojs/endo-but-for-bots#871 (sturdyref agent surface)
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`kriscendobot-minion.town-pr54-refresh-after-pr69`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr54-refresh-after-pr69.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/69` · Refresh kriscendobot/minion.town PR #54 after §9 cleanup lands
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`cybernetics-rec6-panel-error-retry`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/cybernetics-rec6-panel-error-retry.md) — awaiting `diagnose-panel-seat-error-rate` · ---

## Watch set
kriscendobot-minion.town kriscendobot-agoric-3-proposals kriscendobot-cosgov kriscendobot-ocapn kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-agoric-sdk kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 3 gardeners
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 gardeners
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): 8 gardeners
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): 1 gardeners
