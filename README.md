# Garden bulletin

_As of 2026-09-19T16:32:06Z_

## Latest

The foreman promoted ~60 ironhorse fuzz repairs to the queue with ~15 in progress. Two quarantined repairs need provider-policy re-scoping. Gauntlet triage cleared five September halts; [endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/pull/1100) confirmed base-drift requiring a weave/pin-merge-base. Garden infrastructure landed: awaiting-maintainer gate, sysop exec-op design (surfacing boatman isolation gaps), and thesaurus jury seat for Botese (cliché-phrase detection). The maintainer inbox holds multiple unresolved blockers on guest peer-fetch, SIWE tier selection, DNSSEC, clip publishing, and others.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 1d)
- [endojs/endo#3367](https://github.com/endojs/endo/pull/3367) — fix(immutable-arraybuffer): Avoid introducing unrelated properties (waiting 2d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 7d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 15d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 17d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 17d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 17d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 17d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 18d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 21d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `ev7-host-introduction-request` — from gardener:minion-town-eval-mail-pair, reply_to `minion-town-eval-mail-pair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ev7-host-introduction-request.md)

> Identity A's authenticated tools/list succeeded. The send schema says recipients are only @self, @host, or a pet name already held for another party; it has no discovery or attachment field. Please arrange a host-side introduction that gives identity A a pet name for identity B and identity B a reciprocal pet name for identity A, then complete the requested GitHub-federation login checkpoint for B. I will not send to @host because the evaluation cannot clean up a host-inbox message.

- `20260919T002912Z-6e4a7c` — from deploy-garden, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260919T002912Z-6e4a7c.md)

> kind: error
>
> # Deploy candidate test gate rejected main2
>
> candidate: `024f3a012a53f761565e6d81718e7a18291800a8`
> failing suites: scripts/jobs/test/terminal-handler-failure-reap-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/03-scripts_jobs_test_terminal-handler-failure-reap-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/policy-refusal-quarantine-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/07-scripts_jobs_test_policy-refusal-quarantine-test.sh.log), scripts/jobs/test/codex-policy-refusal-resume-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/08-scripts_jobs_test_codex-policy-refusal-resume-test.sh.log), total-wall-clock
>
> Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
> are host-local on `endolin-garden2-5bcdff64` and retain at most
> `16384` bytes of output per suite.
>
> The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
> for a deliberate emergency deploy after assessing this failure.

- `doomed-daily-progress-summary-20260918-070547-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-daily-progress-summary-20260918-070547-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/daily-progress-summary-20260918-070547; it stays HELD until a human promotes it
> (promote-plan.sh daily-progress-summary-20260918-070547) or removes it, so nothing is lost.
> Original job base: daily-progress-summary-20260918-070547
>
> --- original job body ---
> Scheduled dispatch context (computed by the scheduler at fire time):
>
> - window_start: 2026-09-17T07:00:00Z (UTC, inclusive)
> - window_end: 2026-09-18T07:00:00Z (UTC, exclusive)
> - pacific_date: 2026-09-17 (the Pacific day this periodical covers)
> - output: journal/periodicals/2026/09/17.md
>
> ---
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Daily midnight Pacific progress summary
>
> Act as the [journalist](../../roles/journalist/AGENT.md) with purpose
> `daily-progress-summary` (see that role's § Daily progress summaries). Write one
> daily progress-summary periodical covering the prior 24 hours across every project,
> then commit it to `journal2`.
>
> 1. **Window.** If the scheduler prepended a "Scheduled dispatch context" block
>    above (it does under the anchored `daily-at-00:00-America/Los_Angeles`
>    cadence), use its `window_start`, `window_end`, `pacific_date`, and `output`
>    verbatim. Otherwise fall back to the Pacific day that most recently closed:
>    window `[<pacific_date> 00:00, next-day 00:00)` in America/Los_Angeles, and
>    `output = journal/periodicals/<YYYY>/<MM>/<DD>.md` keyed by that `pacific_date`.
> 2. **Read.** Every entry under `journal/entries/<YYYY>/<MM>/<DD>/` whose `ts:` is
>    in `[window_start, window_end)` (a UTC window can straddle two day-directories;
>    scan both and filter by `ts:`), plus the board transitions in the window
>    (`jobs/{todo,doin,tada}` moves from `git -C journal log --since=... --until=...`).
>    Scope is intentionally everything: dispatches, results, ticks, messages, and
>    worktree-lifecycle entries alike.
> 3. **Write.** One abstract-first periodical at `output`, partitioned by project
>    (the `project:` slug; one section per project with any entry, plus a garden-meta
>    section for untagged entries) and, within each, by activity kind. Do not skip a
>    project for having only a couple of entries. Cite sources by relative path;
>    paraphrase, do not copy. House style applies (no em-dashes in prose, no Latin
>    shorthand, relative paths). Commit and push the one file with the usual CAS; if
>    the file already exists for that Pacific date, overwrite it (the periodical is a
>    function of the window, so a re-run is idempotent).
>
> Deliverable: the periodical file committed to `journal2`, or (empty window) a
> one-line periodical saying nothing moved. No board writes, no upstream actions.
>
> ---
> Translated from v1 `schedule/garden/20260513T070000Z--5a93f9.md`
> (recurrence `daily-at-00:00-America/Los_Angeles`, dispatch `journalist` /
> `daily-progress-summary`, window "prior 24 hours", scope all projects).
> The v1 trigger/short-id/fired machinery is dropped: v2 schedules are recurring
> specs keyed by cadence, not pre-computed per-fire event files. The v1 periodicals
> output tree is archived under `legacy/v1/periodicals/`. The v1 original is
> retained on `journal-v1` and `origin/journal`.
>
> The cadence is the anchored, DST-aware `daily-at-00:00-America/Los_Angeles` (which
> the scheduler learned on main2 commit 85a1cd8e6): due-ness is decided against the
> most recent Pacific-midnight anchor at-or-before now and `last_dispatched` is
> stamped to that anchor, so the fire never drifts off local midnight and a 23h/25h
> DST day is spanned correctly. It was flipped from the earlier fixed-interval
> `daily` (which drifted, firing at each actual dispatch time rather than at local
> midnight) once the anchored scheduler landed on the leader host; do not revert it
> to `daily` while any leader host still runs a pre-anchor scheduler, or that
> scheduler would treat the token as its weekly default.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #5 (first seen 2026-09-09T20:50:15Z, latest 2026-09-19T07:20:23Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-2`) has now been observed 5 times; this is ONE
> coalesced notice that updates in place, not 5 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 1 -> 2 (target 2): shared cleric demand active=2 queue=1 fleet-envelope=5 target=2

- `doomed-upgrade-fleet-to-main2-uniform-20260918-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-upgrade-fleet-to-main2-uniform-20260918-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/upgrade-fleet-to-main2-uniform-20260918; it stays HELD until a human promotes it
> (promote-plan.sh upgrade-fleet-to-main2-uniform-20260918) or removes it, so nothing is lost.
> Original job base: upgrade-fleet-to-main2-uniform-20260918
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> role: orchestrator
> handler-timeout: 10800
> ---
> Drive every garden host onto the latest `main2`, verifying after each one that its
> drain closed and work actually resumed — looping on the deploy until the fleet is
> uniformly current. MAINTAINER DIRECTIVE (kriskowal, in-session 2026-09-18).
>
> ## Why this is ONE looping orchestrator job, not a parked child set
>
> The standing multi-part pattern is parked children plus `post-orchestration.sh`.
> That is the wrong tool here: the set of lagging hosts and the number of passes are
> BOTH unknown in advance, and `main2` keeps moving while you work. A fixed child
> list cannot express "repeat until uniform." So drive the loop yourself, and use
> `post-job.sh` for any remediation you need to delegate.
>
> ## State at posting time (2026-09-18, re-derive it — do not trust this)
>
>     main2 tip                        11082b7924 "docs(pause): sync IronHorse pause prose to LIFTED"
>     endolin-garden-ece02cb4 (leader) 425cf9877a  behind 1  deployed  0 failures
>     endolin-garden2-5bcdff64         11082b7924  behind 0  deployed  0 failures
>     oros-studio-garden-ce242c49      425cf9877a  behind 1  deployed  0 failures
>
> Read each host's lag from `fleet/health/<host>` on `journal2` against
> `origin/main2`; that is the authoritative view from any host.
>
> ## The loop
>
> Each pass:
> 1. PIN A TARGET. Resolve `origin/main2` HEAD once and treat THAT sha as the pass's
>    target. `main2` advances continuously (the fleet lands commits all day), so
>    "latest" is a moving goalpost — chasing it live never terminates. Converge to the
>    pinned target, then re-evaluate.
> 2. ENUMERATE laggards against the pinned target.
> 3. DEPLOY each laggard (ordering below).
> 4. VERIFY each one positively (below).
> 5. Re-derive lag. If the fleet is uniform at the pinned target, or every remaining
>    gap is only commits that landed DURING this pass, you are done — say so and stop.
>    Do not spin chasing new commits.
>
> STOP CONDITIONS — do not grind:
> - Uniform at the pinned target → done.
> - The same host fails the same way twice → stop looping on it, and report.
> - 5 passes without convergence → stop and escalate to the maintainer inbox with
>   exactly what is stuck and why.
>
> ## Ordering — respect the rolling deploy, do not race it
>
> An autonomous leader-orchestrated rolling deploy already exists
> (`designs/follower-self-deploy.md`): followers roll FIRST as canaries, the leader
> validates each, and the leader advances ITSELF LAST, never on a failed canary.
> Preserve that order — followers first, leader last — and prefer letting the
> autonomous roll do the work where it is already moving. Intervene where it is
> STUCK. If you observe the roll actively progressing a host, watch rather than
> duplicate; two deploy drivers on one host is a way to wedge it.
>
> ## HOW to deploy a host — this is the part that traps people
>
> A host-pinned job (`requires: host=<GARDEN>`) CANNOT deploy a drained or stuck
> host: a drained host CLAIMS NOTHING, so the job sits unclaimed forever. The
> condition you are trying to fix is the one preventing the fix. This was observed
> directly on 2026-09-17 (`calibrate-oros-studio-budget-pool-20260917` sat unclaimed
> 934s and tripped the unclaimable-host watchdog).
>
> So:
> - Host you are ON: run `scripts/jobs/deploy-garden.sh` directly.
> - ANY OTHER host: use the sysop, which ticks even under drain and is the designed
>   tool for an unattended host:
>       scripts/jobs/send-host-op.sh <GARDEN> op=deploy authorized_by=kriskowal
>   `deploy` is a DESTRUCTIVE-tier op and REQUIRES that attestation; kriskowal is on
>   `maintainers/allowlist` and authorized this in-session on 2026-09-18. Do not
>   invent an attestation for anything this job does not cover.
>   You may pass `to_sha=<40-hex>`, but ONLY the current `origin/main2` HEAD — the op
>   REFUSES a stale `to_sha`. Omit it if you are unsure.
> - `deploy` is SELF-RESTARTING: the sysop acks "deploy started" BEFORE invoking
>   `deploy-garden.sh`, because the deploy restarts the fleet including the sysop
>   itself. So an ack means STARTED, NOT FINISHED. Confirm completion from
>   `fleet/health/<host>`'s `deployed_sha`, never from the ack.
>
> ## VERIFY — positively, which is the substance of this job
>
> For each host, after its deploy:
> 1. `deployed_sha` in `fleet/health/<host>` equals the target.
> 2. `unit_failures: 0`.
> 3. THE DRAIN CLOSED. `deploy-garden.sh` lifts its own drain on the success and
>    self-abort paths, but a drain it did NOT engage — an operator `stand down`, or a
>    hard kill before its lift — survives the deploy. A stale draining marker makes
>    every gardener exit cleanly: zero failed units and zero gardeners running. So
>    check `roll_status` is not a drained state.
> 4. WORK ACTUALLY RESUMED. An empty `--state=failed` list is NOT proof, and neither
>    is a clean health record. Confirm the host is CLAIMING: look for fresh
>    `claim(...)` entries by that host in the journal log after its deploy. That is
>    the only positive evidence.
>
> If the drain did not close, read its PROVENANCE before touching it. Since
> `845b1895e2` the marker carries `source:`, and `drain_is_roll_induced` distinguishes
> a roll drain from an operator pause, FAILING SAFE toward operator when the source is
> absent or unknown. Clear a ROLL-INDUCED drain (`send-host-op.sh <GARDEN> op=drain
> state=off`). NEVER clear an operator drain on your own judgment — report it and ask.
> Note a marker written before that commit has no `source:` and therefore reads as an
> operator drain forever; if you find one, say so plainly rather than overriding it.
>
> ## Report
>
> Per host: starting sha, target sha, how it was deployed, final sha, drain state,
> and the positive evidence that it resumed claiming. Then the fleet's final
> uniformity. Name anything you deliberately did not touch and why.

- `cybernetics-economic-resilience-build-terminal-complete` — from orchestrator:cybernetics-economic-resilience-build-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/cybernetics-economic-resilience-build-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: cybernetics-economic-resilience-build
> orchestration-status: complete
> order: serial
> children-total: 6
> children-failed: 0
> failed-children: 
>
> Orchestration cybernetics-economic-resilience-build complete (serial): all 6 children reached tada without a machine-readable failure declaration.

- `watchdog-budget-zone-endolin-garden-ece02cb4-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-ok.md)

> budget pool anthropic:endolin-garden-ece02cb4 changed zone backoff -> ok at spend=0 of cap=143000000 (high-water 0.85; Friday 20:00 Pacific window).

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-17T00:05:35Z, latest 2026-09-17T02:35:16Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-2`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 3 -> 2 (target 1): shared cleric demand active=2 queue=1 fleet-envelope=5 target=1

- `20260919T004115Z-2a258f` — from deploy-garden, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260919T004115Z-2a258f.md)

> kind: error
>
> # Deploy candidate test gate rejected main2
>
> candidate: `024f3a012a53f761565e6d81718e7a18291800a8`
> failing suites: scripts/jobs/test/terminal-handler-failure-reap-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/03-scripts_jobs_test_terminal-handler-failure-reap-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/ranked-promotion-test.sh(rc=1; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/06-scripts_jobs_test_ranked-promotion-test.sh.log), scripts/jobs/test/policy-refusal-quarantine-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/07-scripts_jobs_test_policy-refusal-quarantine-test.sh.log), total-wall-clock
>
> Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
> are host-local on `endolin-garden2-5bcdff64` and retain at most
> `16384` bytes of output per suite.
>
> The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
> for a deliberate emergency deploy after assessing this failure.

- `20260904T121309Z-462d5d` — from gardener:publish-overnight-chronicle-clip, reply_to `publish-overnight-chronicle-clip` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T121309Z-462d5d.md)

> publish-overnight-chronicle-clip: could NOT publish the overnight clip — the minion-town MCP server needs interactive OAuth (GitHub browser login) that a non-interactive gardener session can't perform, so mcp__minion-town__publish is unavailable to me (same failure class you hit). I verified all five facts and BUILT the clip (static index.html + style.css, CSP-clean, light/dark, evidence links). I sent the liaison inbox the ready-to-publish base64 payload (msg 20260904T121238Z-b3f04f) — it can publish in one call once its MCP session re-initializes, then send you the <hash>.ocap.site URL. Nothing is serving yet.

- `20260917T013013Z-4bb88c` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260917T013013Z-4bb88c.md)

> awaiting maintainer — beyond proxy authority: gardener ironhorse-iterator-scenario-parity, msgid msg-ironhorse-iterator-scenario-parity-58aa54c8fbd4.md — Confirming whether the go-ahead promotion counts as the maintainer's explicit exception lifting the IronHorse pause is an authority grant only the maintainer can make; the acceptance-criteria scope question is secondary to that unresolved gate.

- `minion-town-clipometer-esbuild-orchestration-resume-child-minion-town-clipometer-esbuild-validate-failed` — from orchestrator:minion-town-clipometer-esbuild-orchestration-resume-child-minion-town-clipometer-esbuild-validate-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-clipometer-esbuild-orchestration-resume-child-minion-town-clipometer-esbuild-validate-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: minion-town-clipometer-esbuild-orchestration-resume
> orchestration-status: running
> child: minion-town-clipometer-esbuild-validate
> failure-kind: gated-outcome-unsatisfied
> order: serial
> on-child-failure: halt
> detail: completed but declared its gated outcome unsatisfied
>
> Orchestration minion-town-clipometer-esbuild-orchestration-resume observed child minion-town-clipometer-esbuild-validate: completed but declared its gated outcome unsatisfied.

- `msg-add-awaiting-maintainer-gate-20260916-089c812734e1` — from gardener:add-awaiting-maintainer-gate-20260916, reply_to `add-awaiting-maintainer-gate-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-add-awaiting-maintainer-gate-20260916-089c812734e1.md)

> I am implementing the awaiting-maintainer gate. The SIWE successor apply-siwe-onchain-authz-maintainer-decisions was asked only through maintainer inbox message 20260822T055203Z-ae527d, but the new gate must record an issue/PR/comment URL. Which existing GitHub URL should be the answer location? If none exists, please name where you want the two SIWE decisions posted; I will leave its synthetic blocked gate intact until it has a truthful URL.

- `watchdog-budget-zone-endolin-garden-ece02cb4-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-backoff.md)

> budget pool anthropic:endolin-garden-ece02cb4 changed zone ok -> backoff at spend=121946587 of cap=143000000 (high-water 0.85; Friday 20:00 Pacific window).

- `20260904T231419Z-abbbf9` — from gardener:minion-town-clip-content-store-gc-build, reply_to `minion-town-clip-content-store-gc-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T231419Z-abbbf9.md)

> The clip GC implementation is committed and pushed on kriscendobot/minion.town branch feat/clip-content-store-gc at 1e4e0e9, but the required ensure-pr.sh cannot create the draft PR: this host cannot resolve a valid kriscendobot gh token, and the unauthenticated REST limit is also exhausted. Please restore the kriscendobot gh login/token on endolin-garden-ece02cb4; I will then rerun the idempotent PR opener and continue into the gauntlet.

- `msg-scholar-ingest-gefs-orib-20260918-b9e783a4e25f` — from scholar:scholar-ingest-gefs-orib-20260918, reply_to `scholar-ingest-gefs-orib-20260918` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-scholar-ingest-gefs-orib-20260918-b9e783a4e25f.md)

> **GEFS ingested (6 sections), cross-referenced with CASK and Endo VFS as requested.** The paper is Ori Bernstein's Plan 9 copy-on-write file system: a 9p interface over a forest of Bεtrees (write-optimized B+ trees), a single flat qid-keyed key-value store, ZFS-style deadlist snapshot reclamation, and a barrier-phased crash-safe commit. The comparison worth keeping: GEFS is **merkelized but not content-addressed** (block hashes detect corruption; it does no deduplication or content-defined chunking — the notable absence against CASK's Rabin approach), and it names files through an **ambient qid namespace resolved by key construction**, which I named head-on against the garden's **attenuable capability references** (Endo formula graph; the [endojs/endo-but-for-bots#1304](https://github.com/endojs/endo-but-for-bots/issues/1304) read-only-directory and [endojs/endo-but-for-bots#826](https://github.com/endojs/endo-but-for-bots/issues/826) blob-range attenuations) — that ambient-vs-attenuable difference is the least-obvious-later thing this ingest surfaces. New concepts `betree` and `gefs`, new topic `file-systems`, with bidirectional back-links onto rabin-chunking, cask-block-backbones, content-addressed-storage-backend, formula-graph, and crdt-in-formula-persistence. One honesty caveat: the PDF's section headings and the worked key-value example figure were in a glyph-encoded font that didn't extract, so section titles and the venue/year (inferred IWP9 2023) are inferred from the body; the body prose extracted cleanly. Result: `entries/2026/09/18/220705Z-result-scholar-4bc920.md`.

- `20260917T021454Z-d00f80` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260917T021454Z-d00f80.md)

> awaiting maintainer — beyond proxy authority: gardener ironhorse-fuzz-triage-differential_source-efffacee3e2a, msgid msg-ironhorse-fuzz-triage-differential_source-efffacee3e2a-8a97a997e368.md — Whether/why the IronHorse pause ([kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91)) was violated and whether further IronHorse work may proceed is a policy-gate compliance question, not a progress/direction call the proxy can make.

- `20260919T003513Z-01b9a9` — from deploy-garden, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260919T003513Z-01b9a9.md)

> kind: error
>
> # Deploy candidate test gate rejected main2
>
> candidate: `024f3a012a53f761565e6d81718e7a18291800a8`
> failing suites: scripts/jobs/test/terminal-handler-failure-reap-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/03-scripts_jobs_test_terminal-handler-failure-reap-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/policy-refusal-quarantine-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/07-scripts_jobs_test_policy-refusal-quarantine-test.sh.log), total-wall-clock
>
> Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
> are host-local on `endolin-garden2-5bcdff64` and retain at most
> `16384` bytes of output per suite.
>
> The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
> for a deliberate emergency deploy after assessing this failure.

- `minion-town-clipometer-esbuild-pipeline-gauntlet-review-budget-reached` — from gauntlet:minion-town-clipometer-esbuild-pipeline-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-clipometer-esbuild-pipeline-gauntlet-review-budget-reached.md)

> INFO: Gauntlet minion-town-clipometer-esbuild-pipeline-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-worktree-stale-endolin-garden-ece02cb4` — from watchdog:journal-worktree-keeper, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-worktree-stale-endolin-garden-ece02cb4.md)

> journal worktree /home/kris/garden/journal has been STALE for ~2h (7215s since it last reconciled to origin/journal2; threshold 7200s). The keeper cannot self-resolve it: this tick could not reconcile — diverged; self-heal did not reach origin tip this tick (behind=2). Agents landing in journal/ are reading a LAGGED board and must route around it by hand. Investigate: check this host's connectivity to the journal remote, then 'git -C /home/kris/garden/journal status' and the journal-worktree-keeper log. This is one alert per staleness episode — it will NOT re-page, and clears automatically once the worktree reconciles. (host=endolin-garden-ece02cb4)

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-1.md)

> WATCHDOG notice — occurrence #5 (first seen 2026-09-09T21:05:16Z, latest 2026-09-19T07:35:20Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-1`) has now been observed 5 times; this is ONE
> coalesced notice that updates in place, not 5 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 2 -> 1 (target 1): shared cleric demand active=0 queue=1 fleet-envelope=5 target=1

- `build-rbra-cleanbreak-20260916-halted` — from orchestrator:build-rbra-cleanbreak-20260916-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-rbra-cleanbreak-20260916-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: build-rbra-cleanbreak-20260916
> orchestration-status: halted
> child: build-rbra-clean-break-20260916
> failure-kind: handler-timeout
> children-completed: 1
> children-total: 3
> halt-parked-remainder: build-rbra-rename-conformance-20260916
>
> Orchestration build-rbra-cleanbreak-20260916 HALTED: child build-rbra-clean-break-20260916 stalled in flight for 10921s on host endolin-garden-ece02cb4 (handler-timeout=10800s, multiplier=1) (serial, on-child-failure=halt). 1/3 done before halt; parked remainder: build-rbra-rename-conformance-20260916

- `doomed-self-heal-fix-garden-issue-inbox-cursor-read-fail-open-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-self-heal-fix-garden-issue-inbox-cursor-read-fail-open-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-read-fail-open; it stays HELD until a human promotes it
> (promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-read-fail-open) or removes it, so nothing is lost.
> Original job base: self-heal-fix-garden-issue-inbox-cursor-read-fail-open
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> `scripts/jobs/issue-inbox-watcher.sh:386` reads the poll cursor with a bare command substitution under `set -euo pipefail`:
> `last_seen="$("$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"`.
> `cursor-get.sh`'s `sync_clone` can `exit` non-zero on a journal fetch failure (offline `GARDEN_OFFLINE_RC`, or a plain `rc=1` when the failure's stderr misses the offline-signature heuristic — confirmed happening 2026-09-18 per `b320648e47`), and `pipefail` propagates that through the pipe, tripping `set -e` and hard-killing the unit with zero diagnostic output. This matches this incident's captured log exactly: the tick logs `loaded 8 maintainer(s) from journal:maintainers/allowlist` and then dies with exit 1, nothing else — no error line reaches stdout/stderr because the death happens inside the command-substitution pipe itself.
>
> This exact bug class was found and fixed **twice** today in `triager.sh` (`73c2432e89`, then `b320648e47` when the first, narrower fix proved incomplete): capture the rc explicitly (`if out=$(cmd); then rc=0; else rc=$?; fi`) and fail open — WARN + `exit 0` — on ANY nonzero rc, since a cursor read is inherently best-effort (a stale/unreadable cursor just re-polls next tick, never loses data). Apply the same `if …; then rc=0; else rc=$?; fi` / WARN-and-exit-0 pattern to `issue-inbox-watcher.sh:386`.
>
> While in there, apply the identical fix to the two sibling watchers with the same unguarded pattern (same bug, not yet triggered but latent): `scripts/jobs/comment-watcher.sh:423` and `scripts/jobs/mention-watcher.sh:83`.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0.md)

> WATCHDOG notice — occurrence #9 (first seen 2026-09-13T14:20:13Z, latest 2026-09-19T05:50:22Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-0`) has now been observed 9 times; this is ONE
> coalesced notice that updates in place, not 9 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 0 (target 0): shared cleric demand active=1 queue=1 fleet-envelope=5 target=0

- `doomed-oros-ckm-dependabot-audit-0013418-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-oros-ckm-dependabot-audit-0013418-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/oros-ckm-dependabot-audit-0013418; it stays HELD until a human promotes it
> (promote-plan.sh oros-ckm-dependabot-audit-0013418) or removes it, so nothing is lost.
> Original job base: oros-ckm-dependabot-audit-0013418
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> Repo: kriscendobot/oros-ckm-data-readiness (bare clone worktrees/kriscendobot-oros-ckm-data-readiness.git), branch ckm-poc-build @ 0013418.
> The "Close out demo-to-deck alignment arc" commit (0013418, amending CLAUDE.md § Demo-to-deck alignment) records a PROMOTED follow-up: "Dependabot investigate-only pass (2 high on public default branch; pre-existing, zero deps added this arc; complete before funder-room window)." This is a public (Apache 2.0) repo and the alerts predate this arc — investigate-only, no code change implied unless a safe fix is available.
> Note: `gh api repos/kriscendobot/oros-ckm-data-readiness/dependabot/alerts` currently returns "Dependabot alerts are disabled for this repository" (403) — first confirm whether alerts are actually disabled (vs. a token-scope gap) via the repo's GitHub Security tab, then identify the 2 high-severity findings via `yarn audit`/`npm audit` against the default branch's lockfile if the Security tab is unreachable. Produce a short findings summary (package, severity, whether a non-breaking upgrade closes it) for the maintainer; do not merge into `main` — this repo's convention is milestone-merge only, and this is an investigate-only pass.

- `doomed-fix-worktree-sweeper-leader-only-misgating-20260919-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fix-worktree-sweeper-leader-only-misgating-20260919-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/fix-worktree-sweeper-leader-only-misgating-20260919; it stays HELD until a human promotes it
> (promote-plan.sh fix-worktree-sweeper-leader-only-misgating-20260919) or removes it, so nothing is lost.
> Original job base: fix-worktree-sweeper-leader-only-misgating-20260919
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> The terminal-worktree sweeper is MISGATED: it is leader-only, but the garbage it
> collects is LOCAL to every host. On a follower it has never run, and the residue
> accumulates without bound.
>
> MAINTAINER REQUEST (kriskowal, 2026-09-19): "Check whether we already have
> automation for collecting worktree garbage and whether it is working." It exists
> and it is NOT working on followers. This job fixes that.
>
> ## Evidence (endolin-garden2-5bcdff64, a FOLLOWER, 2026-09-18/19)
>
> - `scratch/project-wt-*` directories on disk: **100**, totaling **41 GB**.
> - `garden-worktree-sweeper.timer` is enabled, active, and fires on schedule (last
>   trigger 23:42:00Z, next 00:12:00Z) — so the timer is healthy.
> - Every single run is skipped:
>       garden-worktree-sweeper.service: Skipped due to 'exec-condition'.
> - The gate is in the unit:
>       ExecCondition=/bin/bash .../scripts/jobs/is-main-host.sh
>   This host is a follower, so the condition fails every tick and
>   `worktree-sweeper.sh` never executes here. `Result=exec-condition`,
>   `ActiveState=inactive` — not a crash, a permanent no-op.
>
> ## Why leader-only is wrong for THIS unit
>
> `worktree-sweeper.sh` is explicitly a LOCAL-filesystem safety net. Its own header:
>
>   "The completion and doom paths remove project worktrees promptly. This timer
>    covers interrupted cleanup, removes the trusted spine's garden-root worktrees,
>    and collects legacy directories which are no longer registered in their bare
>    repository. It intentionally has NO fleet-drain guard: inode exhaustion is a
>    reason to run cleanup, not a reason to suspend it."
>
> It has a `has_live_process()` helper that inspects LOCAL processes, and it reclaims
> LOCAL directories. None of that is journal state, so there is nothing for a single
> leader to do on behalf of the fleet — every host generates its own worktrees in its
> own `scratch/`, and only that host can see or reclaim them.
>
> Note the self-contradiction worth preserving in the fix: the script deliberately
> refuses to be suspended by a fleet drain, reasoning that inode exhaustion argues FOR
> running cleanup — while the leader-only gate suspends it entirely on every follower.
> The author clearly intended this to be robust; the gating defeats that intent.
>
> ## Tasks
>
> 1. UNGATE IT from `is-main-host.sh` so it runs on EVERY host, like `garden-sysop`
>    (the existing precedent for a deliberately un-leader-gated per-host daemon; see
>    CLAUDE.md § the sysop). Verify nothing inside `worktree-sweeper.sh` assumes
>    leader identity or singleton execution — if any step IS genuinely fleet-wide,
>    split that step out rather than keeping the whole unit leader-only.
> 2. AUDIT THE PRIMARY PATH. The sweeper is a SAFETY NET; the header says "the
>    completion and doom paths remove project worktrees promptly." 100 surviving
>    worktrees on one host suggests the primary path is ALSO failing, not merely that
>    the net is absent. Determine how many of the 100 correspond to jobs that reached
>    `tada/` or were doomed, and therefore should already have been reclaimed. If the
>    completion path is leaking, fix that too — an ungated safety net that silently
>    compensates for a broken primary path is worse than either problem alone, because
>    it hides the leak.
> 3. CHECK THE CAP. `GARDEN_WORKTREE_SWEEP_MAX` defaults to 100 and this host has
>    exactly 100 worktrees. Confirm whether that is coincidence or whether the cap is
>    interacting with the backlog; a per-tick cap that never drains a backlog larger
>    than itself would be its own defect.
> 4. VERIFY THE OTHER KEEPERS are correctly gated while you are here:
>    `garden-clone-keeper`, `garden-state-clone-keeper`, `garden-journal-worktree-keeper`.
>    There is prior art for this exact failure class — per-id journal clones under
>    `$GARDEN_STATE` were never pruned and wedged a host at zero free inodes TWICE.
>    Report each one's gate and whether it is right; fix any that share this bug.
> 5. Regression test pinning that the sweeper runs on a non-leader host.
>
> ## Context
>
> This surfaced during a CPU-saturation investigation (load 168 on 32 CPUs) where the
> 41 GB of residue was a secondary finding. Disk is not currently at risk (1.4T of
> 3.6T used, 41%), so this is not an emergency — but the inode-exhaustion precedent
> above is why it should not wait for one. A separate design job,
> `design-cpu-back-pressure-job-dispatch-20260918`, owns the load/memory/IO admission
> gate; do not duplicate that work here.

- `ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-halted` — from gauntlet:ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-halted.md)

> Gauntlet ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917 HALTED: stage 'ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-6' (fix) failed 3 times; its stage retry budget is exhausted (max_stage_retries=2). Last failure: reaper doom_signature=requeue-exhausted with failure_classification=transient

- `doomed-improve-self-heal-run-handler-deadline-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-improve-self-heal-run-handler-deadline-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/improve-self-heal-run-handler-deadline; it stays HELD until a human promotes it
> (promote-plan.sh improve-self-heal-run-handler-deadline) or removes it, so nothing is lost.
> Original job base: improve-self-heal-run-handler-deadline
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/self-heal-run.sh
> Wrap the handler invocation at line 104 (`"$@" > >(tee -a "$capture") 2>&1 &`) in a `timeout --signal=TERM --kill-after=<grace> <bound>` the same way the responder already is at line 247-250, so a wedged handler is bounded well inside each unit's `TimeoutStartSec` instead of relying on systemd's blunt job-timeout + SIGKILL backstop. Add a new tunable (e.g. `SELF_HEAL_HANDLER_TIMEOUT`, defaulting comfortably below the tightest caller's `TimeoutStartSec`, e.g. 600s) and classify a resulting rc=124/137 the same way `is_nonattributable_rc`/the offline-signature grep already do, so a timed-out handler exits clean (no responder burn, no Failed unit) rather than looking like a crash. This directly explains today's incident: `garden-comment-watcher@endojs-endo-but-for-bots` and two `garden-receipt-watcher@*` instances each ran past the full 900s `TimeoutStartSec` during a ~30min degraded-connectivity episode and required forceful termination (one needed a cgroup SIGKILL after the 20s `TimeoutStopSec` grace expired), while every other watcher on the same host failed open within seconds via its own internal cursor/fetch bounds. Since self-heal-run.sh is the shared wrapper for the whole fleet, this single change protects every service that rides it, not just these two.

- `doomed-improve-ci-watcher-outage-latch-flap-dedup-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-improve-ci-watcher-outage-latch-flap-dedup-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/improve-ci-watcher-outage-latch-flap-dedup; it stays HELD until a human promotes it
> (promote-plan.sh improve-ci-watcher-outage-latch-flap-dedup) or removes it, so nothing is lost.
> Original job base: improve-ci-watcher-outage-latch-flap-dedup
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/ci-watcher.sh
> The journal-outage latch (`note_journal_outage`/`note_journal_recovered`, ~line 478-520) closes on the first successful fetch after an outage, with no hysteresis. During intermittent (not fully down) journal connectivity, this lets the episode flap open→closed→open repeatedly across the ~15 per-repo watcher instances riding a 90s cadence, each landing on a different side of a brief recovery. Evidence: 2026-09-19 04:53–05:20Z logged 6 separate "host outage episode opened" WARNs across 4 different repo slugs on one host — almost certainly one continuous flaky window, not 6 distinct outages — defeating the latch's stated purpose of collapsing a shared outage into one open+one close. Add debounce: e.g. stamp the close time in the latch dir and require either N consecutive successful `verify_fetch`s or a minimum quiet period (a few minutes) before actually removing the latch/logging "closed"; a failure arriving inside that quiet window should extend the same episode silently rather than opening a fresh loud WARN. Keep the existing sibling-flock serialization; only add the hysteresis state (e.g. `$latch/last_success`) read/written under the same lock.

- `doomed-date-sharded-tada-migrate-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-date-sharded-tada-migrate-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/date-sharded-tada-migrate; it stays HELD until a human promotes it
> (promote-plan.sh date-sharded-tada-migrate) or removes it, so nothing is lost.
> Original job base: date-sharded-tada-migrate
>
> --- original job body ---
> ---
> role: fixer
> tier: mentor
> ---
> <!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-18T05:21:26Z cleared=none -->
>
> ---
> role: fixer
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> # date-sharded-tada stage 3: retroactive migration of jobs/tada/
>
> Blocked on `date-sharded-tada-writer-switch` (stage 2). **Read that job's
> tada report first** and confirm from `fleet/health/*` (leader, garden2,
> oros-studio) that its commit is actually DEPLOYED fleet-wide, not merely
> landed on main2 — the design (`designs/date-sharded-tada.md` § Implementation
> stages) treats each stage as a deploy checkpoint, and this exact "landed but
> not yet deployed" gap is what correctly stopped the first attempt at this
> stage. If any host is still behind, STOP and report — do not proceed on a
> partial deploy.
>
> ## The work (design § 5 "Migration atomicity")
>
> One-shot, idempotent, repeat-until-empty CAS job:
>
> 1. Enumerate every `jobs/tada/<base>.md` at the flat level (not yet sharded).
> 2. For each, recover its completion date from its **add commit** (the first
>    commit that ever added that path — `--diff-filter=A`, `tail -1` on the
>    git log for that exact path, so a base that drained and re-completed keeps
>    its ORIGINAL add date, not a later one):
>    ```sh
>    git log --diff-filter=A --format='%cd' --date=format:'%Y/%m/%d' \
>        -- jobs/tada/<base>.md | tail -1
>    ```
> 3. `git mv` into `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`. If the add commit
>    cannot be found (history rewrite, or genuinely no add commit), the entry
>    goes to `jobs/tada/undated/<base>.md` instead — NEVER skipped, NEVER
>    guessed. This bucket should end up empty or near-empty; if it's not, that
>    is itself worth flagging in your report, not silently accepted.
> 4. Commit the WHOLE set as ONE commit (all ~4,500+ renames in one tree
>    object — git handles this trivially), pushed via the same rebase-CAS retry
>    loop `complete-job.sh` uses. A lost race just re-syncs and re-runs;
>    already-sharded entries are skipped on re-run (idempotent).
> 5. Repeat until zero flat entries remain (excluding `undated/`), then record
>    completion. No fleet drain needed — read the design's own reasoning for
>    why (a completion during migration lands sharded directly, via stage 2's
>    already-deployed writers; migration only ever touches pre-existing flat
>    entries, never something a running job is about to write).
>
> ## The one host-local side effect (design § 5, called out explicitly)
>
> `follow-up.sh`'s seen-marker (`$GARDEN_STATE`, host-local, keyed on tada rel
> path today) will otherwise treat every migrated entry as "new" and could
> storm follow-up notifications for ~4,500 already-old completions. The design
> recommends re-keying the seen-marker on **base** (basename) rather than rel
> path as the durable fix (should already be partly done in stage 1's "Fix
> follow-up.sh base extraction and re-key its seen-marker on base" — verify
> this actually landed and covers this case; if not, fix it as part of this
> job, before running the migration, not after).
>
> ## Report
>
> Total entries migrated, count landed in `undated/` (investigate and explain
> any non-trivial count there, don't just note it), the commit(s) sha, and
> confirmation the follow-up.sh seen-marker re-keying was verified/fixed
> before the migration ran (sequencing matters — check this BEFORE moving
> files, so a migration-triggered follow-up storm can't happen even
> transiently).
>
> Design's stage 4 ("drop the fallback" — remove the now-unneeded flat-read
> arm from the helpers once the backlog is fully sharded) is explicitly OUT OF
> SCOPE for this job — it's cosmetic cleanup the design says can wait "at
> leisure." Flag it as a natural follow-up in your report; do not do it here.

- `msg-triage-halted-gauntlets-20260916-d6b4e6e396b6` — from gardener:triage-halted-gauntlets-20260916, reply_to `triage-halted-gauntlets-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-triage-halted-gauntlets-20260916-d6b4e6e396b6.md)

> # Triage: five halted gauntlets/orchestrations (parked early Sept)
>
> Per-item disposition below. I checked each PR's live state + CI *now* and the actual
> stage records; I did **not** re-post anything. TL;DR: items 1 & 2 were transient
> (capacity-crunch) halts on now-green PRs — cheap re-posts; items 3 & 4 are real
> non-transient failures that must be **re-scoped**, not retried; item 5 has already
> partly landed and needs re-anchoring, not a restart.
>
> Common context: items 1 & 2 both doomed 2026-09-03/04 with
> `doom_signature=requeue-exhausted`, `requeue_cycles=5`, `deadline_overruns=0`,
> `elapsed_constancy_confirmations=1` — i.e. the handler never overran its own
> deadline; it was requeued 5x without progress and exhausted. That window is the
> known capacity/quota outage (temp API key ~1 day around 09-04). `deadline_overruns=0`
> plus that window means these are **transient infra** halts, not work failures — the
> `failure_classification=unknown` only means the reaper couldn't *prove* it at the time.
>
> ---
>
> ## 1. sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean — [endojs/endo-but-for-bots#1013](https://github.com/endojs/endo-but-for-bots/issues/1013)
> - **Premise: LIVE.** [endojs/endo-but-for-bots#1013](https://github.com/endojs/endo-but-for-bots/issues/1013) (`design: relative routing…`, head
>   `design/relative-routing`) is OPEN, not merged, not superseded. **CI is now ALL GREEN**
>   (build/lint/test/browser-tests/zizmor).
> - **Halt: TRANSIENT** (capacity crunch, see common context; no deadline overrun).
> - The `clean` stage is idempotent — step 1 short-circuits to `clean=done` when CI is
>   green at head, and this is a design-doc PR so the coverage pass is a no-op anyway.
> - **→ RE-POST as-is** (no header change). It will idempotently no-op and let the sweep
>   gauntlet advance. Near-zero cost.
>
> ## 2. build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2 — [kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/issues/81)
> - **Premise: LIVE but STALE.** [kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/issues/81) (`Build: capability-first
>   guest onboarding — browser core slice`) OPEN draft, CI `test` green, **not superseded**
>   (its parent design [kriscendobot/minion.town#56](https://github.com/kriscendobot/minion.town/issues/56) merged 09-02; adjacent open work
>   [kriscendobot/minion.town#80](https://github.com/kriscendobot/minion.town/issues/80) / [kriscendobot/minion.town#82](https://github.com/kriscendobot/minion.town/issues/82) / [kriscendobot/minion.town#95](https://github.com/kriscendobot/minion.town/issues/95)
>   doesn't replace it). But it's untouched since 2026-09-02 (~2 weeks) and the browser-core
>   slice was noted as blocked on the Endo guest-native invite/accept dependency.
> - **Halt: TRANSIENT** (same capacity crunch).
> - Caution: this stage carries `handler-timeout=10800` (a full ~3h, 29-seat panel) —
>   exactly the expensive-panel churn the credit investigation flagged.
> - **→ RE-POST panel-2, but confirm the premise first.** Deciding question: *is the
>   [kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/issues/81) browser-core slice still the intended live path, or is it
>   parked pending Endo guest-native invite/accept?* If still live → re-post
>   (transient-safe). If it's waiting on that dependency → keep it parked (DROP the stage)
>   rather than burn a 3h panel on a slice that can't merge yet.
>
> ## 3. ebfb-exo-stream-drop-base64-stream-methods-gauntlet — [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/issues/1100)
> - **Premise: LIVE** (OPEN draft, not merged, not superseded).
> - **Halt: REAL failure, NOT transient.** fix-2 correctly declared `orchestration-failed`.
>   CI is RED (confirmed still red now: lint + test FAILURE on every leg) from **base
>   drift**: this PR migrated `@endo/exo-stream` `stringLengthLimit`→`byteLengthLimit`,
>   but current `llm`'s `packages/9p-server/src/server.js` still calls the removed
>   `stringLengthLimit` API (3 sites). GitHub tests the merge ref, so llm's stale call
>   site + this PR's renamed type = tsc + runtime failures. A plain gauntlet re-post would
>   re-fail identically.
> - **→ RE-SCOPE: weave / pin-the-merge-base of [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/issues/1100) onto current
>   `llm`**, resolving the `9p-server` `stringLengthLimit`→`byteLengthLimit` conflict
>   (semantic port, not just a rename; branch was ~360 commits behind), *then* resume the
>   gauntlet from fix. This is the successor fix-2 already named.
>
> ## 4. build-minion-town-claude-harness-provisioning-gauntlet — [kriscendobot/minion.town#99](https://github.com/kriscendobot/minion.town/issues/99)
> - **Premise: LIVE and healthy.** [kriscendobot/minion.town#99](https://github.com/kriscendobot/minion.town/issues/99) (`feat(deploy): provision
>   pinned Claude harness`) OPEN draft, **mergeable=CLEAN, CI ALL GREEN** (Claude harness
>   amd64/arm64 + test), updated 09-09.
> - **Halt: NOT a work failure** — hit `max_iterations=6`. Every panel round 1–6 returned
>   must-fix; fix-6 achieved green and folded polish (locksmith/saboteur should-fix). The
>   29-seat panel structurally always surfaces fresh nits (and own-PR request-changes
>   downgrades to a comment), so it never emits `pass`. This is precisely the "iteration
>   6/6 churn" cost multiplier the credit investigation named.
> - **→ RE-SCOPE: stop the panel loop.** The code is green + mergeable; another 6-round
>   loop would just grind more nits and cap again. Deciding question: *are the recurring
>   panel must-fixes real merge-blockers, or diminishing polish on already-green,
>   mergeable code?* If diminishing (which the fix-6 folded items suggest), route to a
>   final maintainer review → un-draft/merge rather than re-running the gauntlet.
>
> ## 5. minion-town-clipometer-esbuild-orchestration — HALTED, "0/4 children done"
> - **The halt record is stale.** It recorded child 1 (`…-pipeline`) stalling 2501s vs
>   `handler-timeout=2400s`. But child 1 **subsequently recovered on a reaper requeue and
>   completed** — draft PR [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84) (`CLIPOMETER on real @endo/captp +
>   esbuild pipeline`) is OPEN, CI green. Its own gauntlet reached panel-3 and was then
>   **archived 09-05 by the liaison during a fleet drain** ("archive all scheduled
>   gauntlets during the drain"), which is why [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84) never un-drafted.
>   So the true state is: **child 1 done (PR [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)), children 2–4
>   still parked.** This is drain-parked, not failed.
> - The 2501s>2400s overrun is real but was non-fatal (requeue recovered it). Child 2
>   (`…-validate`) is heavier than child 1 — it does a full build + **live publish to prod
>   + two-window Playwright** validation — so the budget matters more there.
> - **→ RE-SCOPE (do not restart from child 1):**
>   1. Re-anchor the orchestration to **resume at child 2** (`minion-town-clipometer-esbuild-validate`);
>      child 1's deliverable (PR [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)) already exists.
>   2. Give child 2 a raised budget: **`handler-timeout: 3600`** (validate's build+publish+
>      dual-browser run exceeds child 1's 2501s at the 2400 default).
>   3. Note child 2 needs the **real guest MCP identity** (not the disposable
>      `minion-mcp-test-cc`) for the canonical publish — child 1's report flags that if the
>      job env lacks it, that publish step hands to the liaison/maintainer.
>   - Deciding question: *is the live-CLIPOMETER-replacement still wanted (dckc's 09-03
>     directive), and should [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)'s archived gauntlet be un-archived
>     to un-draft it?*
>   - Also unresolved from child 1: the published `@endo/patterns@2.0.0` /
>     `@endo/marshal@1.10.0` npm version inconsistency (worked around by vendoring
>     `iterate-reader.js`) — child 2's live run is the checkpoint that confirms the vendored
>     approach works against the real daemon.
>
> ---
> **Summary:** 1 → RE-POST (no change). 2 → RE-POST panel-2 *iff* premise confirmed live,
> else DROP the stage. 3 → RE-SCOPE to a weave/pin-merge-base then resume. 4 → RE-SCOPE:
> stop the loop, human review → un-draft (green+mergeable). 5 → RE-SCOPE: resume at child 2
> with `handler-timeout: 3600`, un-archive [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)'s gauntlet. I
> promoted/re-posted nothing.

- `doomed-self-heal-fix-garden-issue-inbox-cursor-get-failopen-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-self-heal-fix-garden-issue-inbox-cursor-get-failopen-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-failopen; it stays HELD until a human promotes it
> (promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-get-failopen) or removes it, so nothing is lost.
> Original job base: self-heal-fix-garden-issue-inbox-cursor-get-failopen
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> In scripts/jobs/issue-inbox-watcher.sh, line 386 reads the cursor with a bare command substitution:
>   last_seen="$("$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"
> under `set -euo pipefail` (line 85). cursor-get.sh's sync_clone `exit`s nonzero on a journal-connectivity failure, which trips this script's `set -e` and kills the unit with no error text logged — matching the observed failure signature exactly: the last log line is "loaded N maintainer(s) from journal:maintainers/allowlist" (the statement right before line 386) and then exit 1 with nothing after it.
>
> This is the identical bug class fixed twice in scripts/jobs/triager.sh (commits 73c2432e89 and b320648e47): a cursor read is inherently best-effort — a stale/unreadable cursor just re-polls next tick, never loses data — so treat ANY nonzero rc from cursor-get.sh as fail-open. Apply the same pattern here: capture the rc with `if cursor_out=$("$HERE/cursor-get.sh" "$CURSOR_KEY"); then rc=0; else rc=$?; fi`, and on nonzero rc, `log "WARN: journal unreachable reading cursor $CURSOR_KEY (rc=$rc); skipping this tick"` then `exit 0` instead of falling through to `die`/set -e. Then parse `last_seen` from `$cursor_out` instead of the pipeline.

- `doomed-self-heal-fix-garden-issue-inbox-cursor-get-set-e-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-self-heal-fix-garden-issue-inbox-cursor-get-set-e-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-set-e; it stays HELD until a human promotes it
> (promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-get-set-e) or removes it, so nothing is lost.
> Original job base: self-heal-fix-garden-issue-inbox-cursor-get-set-e
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/issue-inbox-watcher.sh:386 calls cursor-get.sh in a bare, unguarded command-substitution pipeline under `set -euo pipefail`. cursor-get.sh's sync_clone can `die` (or exit GARDEN_OFFLINE_RC) on a journal-fetch failure, and since the call isn't wrapped in an `if cmd; then rc=0; else rc=$?; fi` guard, `set -e` propagates that nonzero rc straight into a fatal exit of the whole watcher — the exact hazard just fixed twice today in scripts/jobs/triager.sh (commits 73c2432e89 and b320648e47) for its own cursor-get.sh call sites, but never ported to issue-inbox-watcher.sh. A cursor read is inherently best-effort (a stale/unreadable cursor just re-polls next tick, never loses data), so this should fail open exactly like triager.sh now does: replace the bare assignment at line 386 with the guarded form used in triager.sh — `if cursor_out="$("$HERE/cursor-get.sh" "$CURSOR_KEY")"; then rc=0; else rc=$?; fi; if [ "$rc" -ne 0 ]; then log "WARN: cursor read failed for $CURSOR_KEY (rc=$rc); skipping this tick"; exit 0; fi; last_seen="$(printf '%s\n' "$cursor_out" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"`. Add/update the unit test covering this watcher's cursor-read path to exercise a failing cursor-get.sh and assert a clean exit 0 rather than a fatal.

- `doomed-ironhorse-ocap-frozen-objects-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-ocap-frozen-objects-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/ironhorse-ocap-frozen-objects; it stays HELD until a human promotes it
> (promote-plan.sh ironhorse-ocap-frozen-objects) or removes it.
> Original job base: ironhorse-ocap-frozen-objects
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> handler-timeout: 7200
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T03:31:11Z cleared=none -->
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> role: builder
> handler-timeout: 7200
> ---
>
> Implement milestone 3 of the design in [endojs/endo-but-for-bots#1300](https://github.com/endojs/endo-but-for-bots/issues/1300),
> `designs/ironhorse-ocap-workload-optimization.md`: exploit proven ordinary-object
> immutability in the Rust Ironhorse engine. This child runs after the closure-site
> milestone has posted an accepted or not-pursuing result.
>
> Use the landed benchmark corpus as the fixed contract. Work in an isolated
> project checkout, use the correct frozen `llm-<sha>` implementation base, and
> open one draft milestone PR through `ensure-pr.sh` if a change earns acceptance.
> Do not un-draft it.
>
> Implement and measure the ordinary, non-proxy fused freeze-and-referent walk,
> the derived sealed/frozen/hardened state cache, and cached fast rejection of
> writes while preserving strict throws, sloppy no-ops, receiver semantics, and
> Proxy/exotic behavior. Measure the frozen property-index and hardened GC-edge
> roster candidates independently; land either only if it clears the design's bar.
> Do not infer deep immutability for mutable internal slots, omit specified write
> behavior, merge object identities, or skip page-level dirty tracking. Derived
> caches are not snapshot payloads and must be rebuilt on restore.
>
> Run the exact path-keyed test262 and hardened262 parent/candidate manifest gate,
> the Rust workspace and snapshot compatibility tests, the general benchmark
> regression gate, and a real same-host before/after object-capability benchmark.
> Post raw reports for every accepted and declined candidate. A correct candidate
> that misses the speed bar is reverted and recorded as not pursuing; that is a
> valid campaign result, not an orchestration failure.
>
> If the core deliverable is finished but its required gated outcome is not met,
> end the report with these exact lines in order:
>
> <<<GARDEN-ORCHESTRATION-FAILED>>>
> <<<GARDEN-JOB-COMPLETE>>>

- `msg-clipometer-reanchor-followthrough-20260917-2c57182e8954` — from gardener:clipometer-reanchor-followthrough-20260917, reply_to `clipometer-reanchor-followthrough-20260917` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-clipometer-reanchor-followthrough-20260917-2c57182e8954.md)

> CLIPOMETER re-anchor follow-through — decisive outcome (campaign BLOCKED on a minion.town server change).
>
> ORCHESTRATION TRACK: TERMINAL / HALTED. Child 2 (minion-town-clipometer-esbuild-validate) ran and returned orchestration-failed. minion-town-clipometer-esbuild-orchestration-resume halted (serial, on-child-failure=halt); children 3 (primer update) & 4 (issue report) correctly stayed parked. You have the structured halt notice in your inbox; here is the WHY it omits:
>
> DECISIVE BLOCKER (child 2, definitive & identity-independent): the esbuild/real-@endo/captp bundle CANNOT be published to the live minion.town daemon. publish.mjs failed HTTP 413. The /mcp endpoint mounts express.json() with no limit (src/http.ts:286 -> default 100 kb). Probed cliff: 99.1 KB -> 200, 101.1 KB -> 413. The publish body carrying the bundle is 206.3 KB (2.06x over); app.js alone (~152 KiB min / 53 KiB gzip) base64s to ~208 KB. Not fixable by tree-shaking (SES + @endo/captp core are the irreducible floor). Same limit hits the real guest identity, so this is NOT a credential problem.
>
> Consequences: live bootstrap/counter/two-window followNameChanges validation was UNREACHABLE (clip never publishes); the vendored iterate-reader.js workaround for the published @endo/patterns@2.0.0 / @endo/marshal@1.10.0 npm inconsistency bundles cleanly locally but is UNVERIFIED against the real daemon (the blocker sits upstream of the vendoring question). No canonical publish performed; old hand-rolled clip 3hpxdb...6qsq is already 404 (nothing to unpublish). Real guest identity WAS reachable — moot given the 413. No production/primer changes made.
>
> MAINTAINER DECISION REQUIRED to unblock the campaign: a minion.town server change, e.g. express.json({ limit: '512kb' }) at src/http.ts:286 (audit any Caddy/ALB body caps too), or a chunked/blob-preupload publish path — carries DoS/security weight. Until one lands, the esbuild pipeline cannot become the live CLIPOMETER.
>
> GAUNTLET TRACK: still ACTIVE. PR [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84) remains open+DRAFT (mergeable_state=dirty — base conflicts). The gauntlet driver is at fix iteration 3 of 6, gh-GraphQL rate-limited ~60 min. OPEN QUESTION: do you want the gauntlet to keep driving [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84) to un-draft as reviewed code (deployment is blocked regardless), or pause it pending your server-limit decision? I will keep monitoring to terminal unless you say otherwise.

- `watchdog-rolling-deploy-canary-failed-endolin-garden2-5bcdff64` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-endolin-garden2-5bcdff64.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-failed-endolin-garden2-5bcdff64` has CLEARED (first seen 2026-09-17T05:26:11Z, cleared 2026-09-17T06:05:07Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> retrying canary endolin-garden2-5bcdff64 (attempt 1/3); clearing prior page.

- `watchdog-self-heal-garden-comment-watcher-endojs-endo-but-for-bots` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-comment-watcher-endojs-endo-but-for-bots.md)

> self-heal: garden-comment-watcher@endojs-endo-but-for-bots exited rc=1 with no scoped fix. Capture: fc95d2521daf8c908c12e8a0db38f55a383c0ac1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p fc95d2521daf8c908c12e8a0db38f55a383c0ac1). Diagnosis: Diagnosis: the captured stdout+stderr tail is only 8 lines total, and every line is a normal, successful operation — the watcher loaded its allowlists, found `#1282` already actioned, then cleanly posted and acked jobs for `#1306` and `#1301` (`posted endojs-endo-but-for-bots-pr1301-review-e2671e4d (review on #1301) + acked` is the very last line). Grepping the whole blob for `error|fail|fatal|trace|exception|exit` turns up nothing — there is no exception, stack trace, or diagnostic message anywhere in the capture.
>
> The script runs under `set -euo pipefail`, so an exit code of 1 with zero corresponding log output means some command *after* that last successful log line (the next loop iteration's `gh api`/`git` call, a journal-push CAS race, etc.) returned nonzero without itself writing

- `msg-garden-gauntlet-reexport-policy-check-c841557cb265` — from gardener:garden-gauntlet-reexport-policy-check, reply_to `garden-gauntlet-reexport-policy-check` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-garden-gauntlet-reexport-policy-check-c841557cb265.md)

> Design proposal ready for review: re-export deprecation policy gate.
>
> @erights asked on [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475) (comment 3450576324) for garden
> machinery to prevent every plain-re-export policy violation and never author a
> new one, reviewed by both @kriskowal and @erights before landing.
>
> Deliverable: [kriscendobot/garden#95](https://github.com/kriscendobot/garden/issues/95) (draft, open-questions design PR) —
> designs/reexport-deprecation-policy-gauntlet.md. Proposes a deterministic
> no-plain-reexport pre-push probe (author-time block), a cost-gated
> reexport-auditor jury seat that reuses it (review-time), and a
> re-export-deprecation-policy skill both consult, plus builder/fixer/web-builder
> norm lines. Nothing is implemented yet — it awaits answers to 5 open questions
> (barrel-file exemption, what counts as a compliant deprecation, whether the LLM
> seat is needed on top of the probe, Endo-only vs garden-wide, and .d.ts
> type-only re-exports).
>
> Please ask @kriskowal and @erights to review [kriscendobot/garden#95](https://github.com/kriscendobot/garden/issues/95). A follow-up
> build implements the probe/seat/skill once the open questions are answered.

- `doomed-self-heal-fix-garden-issue-inbox-cursor-get-pipefail-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-self-heal-fix-garden-issue-inbox-cursor-get-pipefail-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-pipefail; it stays HELD until a human promotes it
> (promote-plan.sh self-heal-fix-garden-issue-inbox-cursor-get-pipefail) or removes it, so nothing is lost.
> Original job base: self-heal-fix-garden-issue-inbox-cursor-get-pipefail
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> issue-inbox-watcher.sh:386 calls `cursor-get.sh` in a bare pipeline (`"$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1`) under `set -euo pipefail`. cursor-get.sh's sync_clone can `die` with rc=1 (unrecognized fetch-failure stderr) or `exit $GARDEN_OFFLINE_RC` (75, recognized offline signature) on a journal fetch hiccup; pipefail propagates either nonzero rc through the sed/head stages, tripping set -e and hard-killing the whole garden-issue-inbox unit instead of skipping the tick. This is the exact bug class fixed today in triager.sh (commits 73c2432e89, b320648e47): capture the rc via `if cursor_out=$("$HERE/cursor-get.sh" "$CURSOR_KEY"); then rc=0; else rc=$?; fi`, and on any nonzero rc, `log "WARN: cursor read failed for $CURSOR_KEY (rc=$rc); skipping this tick"; exit 0` instead of letting set -e kill the process — a cursor read is best-effort (a missed read just re-triages/re-polls next tick, never loses data). Apply the identical fix to the same unguarded pattern in comment-watcher.sh:423 and mention-watcher.sh:83, which share this exact vulnerable shape and will hit the same failure the next time the journal blips.

- `doomed-improve-budget-level-single-host-cap-freeze-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-improve-budget-level-single-host-cap-freeze-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/improve-budget-level-single-host-cap-freeze; it stays HELD until a human promotes it
> (promote-plan.sh improve-budget-level-single-host-cap-freeze) or removes it, so nothing is lost.
> Original job base: improve-budget-level-single-host-cap-freeze
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/budget-level.sh
> A pool with a missing/invalid monk physical cap in config/worker-leveling currently zeroes `mv` globally, which freezes monk apportionment for EVERY host on every tick (see report_freeze call and the `mv=0` fallthrough), not just the misconfigured host's pool. This is firing right now for `anthropic:oros-studio-garden-ce242c49` (added to config/budget-pools at 2026-09-17T02:10Z with no matching `host` row in config/worker-leveling) and is blocking the whole fleet's monk count from rising. `set-budget-pool.sh` already gained a write-time guard for *new* pools (commit dd3e002519, same day) so this exact case can't recur going forward, but it doesn't repair a pool that predates the guard or one written by bypassing the setter (direct journal edit). Harden budget-level.sh to isolate a single pool's missing/invalid-cap fault the same way it already isolates uncalibrated provenance later in the file (`uncalibrated "$prov"&&continue`) — exclude just that pool/host from the apportionment sum and target computation, and freeze/report only that host, rather than blocking every other correctly-configured host's leveling. Separately, the standing config gap itself (oros-studio-garden-ce242c49 has no worker-leveling host row) still needs a human/operator decision on its physical monk cap and a `set-worker-leveling.sh` or `set-budget-pool.sh --monk-cap` call to backfill it — that's outside this script change.

- `msg-build-thesaurus-botese-jury-seat-11aa8295e147` — from gardener:build-thesaurus-botese-jury-seat, reply_to `build-thesaurus-botese-jury-seat` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-build-thesaurus-botese-jury-seat-11aa8295e147.md)

> Job build-thesaurus-botese-jury-seat is landed on main2 (commit e21884be41).
>
> Built the "thesaurus" jury seat for Botese (AI-slop cliche phrases) as a
> structural port of the British-English spelling mechanism: skill
> botese-normalization (SKILL + cliches.tsv), the cost-gated thesaurus seat, the
> deslopper fixer + `deslop #N` verb, the no-LLM cliche-grep pre-pass + seat gate,
> a 19-assertion regression test, and full panel/vocabulary/tiering wiring. Seeded
> with exactly the two maintainer examples (seam, load-bearing), each enumerated as
> its distinctive multi-word collocation ("load-bearing invariant", "seam where")
> rather than the bare word, for precision over recall.
>
> One thing I could NOT do: post the requested closure reply on the origin thread
> [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/issues/1281) (review comment r4028527867). The bot PAT is
> read-only on upstream endojs/endo-but-for-bots (403 on both review-comment and
> issue-comment creation; the fleet works via the kriscendobot fork). If a reply on
> that upstream thread is wanted, it needs the maintainer/ferry identity.

- `doomed-foreman-requiesce-target-0-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-foreman-requiesce-target-0-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/foreman-requiesce-target-0; it stays HELD until a human promotes it
> (promote-plan.sh foreman-requiesce-target-0) or removes it, so nothing is lost.
> Original job base: foreman-requiesce-target-0
>
> --- original job body ---
> ---
> role: fixer
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> # Reduce the foreman's active-job target back to 0
>
> Maintainer directive (kriskowal, 2026-09-17T21:08Z), reversing the partial
> un-quiesce from `foreman-partial-unquiesce-target-2`
> (commit `78772d0c3e`, 0 -> 2) two days ago. Quota pressure has since climbed
> significantly (leader 77%, garden2 66% weekly, both manually verified
> 2026-09-17) — back to a full quiesce.
>
> The liaison has already applied the immediate-effect **foreman brake**
> (`config/foreman-brake` on journal2) for instant relief; this job is the
> standing-baseline correction so the target doesn't silently resume pumping
> at 2 whenever the brake is later lifted.
>
> ## Change
>
> In `scripts/systemd/garden-foreman.service`, change
> `GARDEN_FOREMAN_ACTIVE_TARGET=2` back to `GARDEN_FOREMAN_ACTIVE_TARGET=0`.
> Update the adjacent comment to reflect the new history (July 14 quiesce ->
> September 16 partial lift to 2 -> September 17 back to 0, quota pressure).
> Land on `main2` as usual.
>
> ## Verify
>
> `garden-foreman-test.sh` / `foreman-decision-log-test.sh` still pass. Once
> deployed, `.garden-state/foreman/decisions.log` should show `target=0` /
> `guard=subscribed` again (though the brake already silences the pump
> regardless of target, so this is a standing-baseline fix, not an urgent
> one — no need to force a deploy for it).
>
> Report the before/after target value and confirm the two prior tests pass.

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

- `doomed-improve-elapsed-constancy-escalation-include-capture-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-improve-elapsed-constancy-escalation-include-capture-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/improve-elapsed-constancy-escalation-include-capture; it stays HELD until a human promotes it
> (promote-plan.sh improve-elapsed-constancy-escalation-include-capture) or removes it, so nothing is lost.
> Original job base: improve-elapsed-constancy-escalation-include-capture
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/gardener.sh
> Both elapsed-constancy early-escalation sites (the exit-0-unsatisfying branch ~line 944-977 and the rc!=0 overrun-suspect branch ~line 1465-1495) build a prose-only transcript for `report-error.sh` describing the symptom (near-constant elapsed across N cycles) but never include the actual handler output captured in `$capture` for that cycle — even though the rc!=0 branch's own gate (`[ -s "$capture" ]`) already confirms non-empty output exists at escalation time. `$capture` is an ephemeral `mktemp` file cleaned up each gardener cycle, so once the escalation fires this is the *last* moment the real stderr/stdout is available; a human or mentor triaging the resulting `elapsed-constancy-overrun-suspect`/`elapsed-constancy-exit0-wedge-suspect` inbox entry afterward has only the generic "died at a near-constant elapsed" prose and must guess the root cause blind. Concrete case: `improve-receipt-watcher-direct-dispatch` tripped exactly this overrun-suspect path twice (rc=1, elapsed=3s, both a kimi-k3 attempt and an opus fallback) with `usage_measurement` recording `source:none` (zero output captured by any usage-accounting layer) — the only path left to diagnose it is gone. Fix: append a bounded tail of `$capture` (e.g. last 40-60 lines, redacting nothing since this is the bot's own handler output) into both escalation transcripts before calling `report-error.sh`, so the inbox entry itself carries the evidence needed to triage.

- `minion-town-clipometer-esbuild-orchestration-resume-halted` — from orchestrator:minion-town-clipometer-esbuild-orchestration-resume-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-clipometer-esbuild-orchestration-resume-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: minion-town-clipometer-esbuild-orchestration-resume
> orchestration-status: halted
> child: minion-town-clipometer-esbuild-validate
> failure-kind: gated-outcome-unsatisfied
> children-completed: 0
> children-total: 3
> halt-parked-remainder: minion-town-clipometer-primer-esbuild-update minion-town-clipometer-esbuild-issue-report
>
> Orchestration minion-town-clipometer-esbuild-orchestration-resume HALTED: child minion-town-clipometer-esbuild-validate completed but declared its gated outcome unsatisfied (serial, on-child-failure=halt). 0/3 done before halt; parked remainder: minion-town-clipometer-primer-esbuild-update minion-town-clipometer-esbuild-issue-report

- `watchdog-budget-level-monk-preflight` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-preflight.md)

> WATCHDOG notice — occurrence #37 (first seen 2026-09-17T02:20:04Z, latest 2026-09-17T11:35:04Z).
> The SAME condition (`budget-level-monk-preflight`) has now been observed 37 times; this is ONE
> coalesced notice that updates in place, not 37 messages. Latest detail:
>
> fleet monk allocation frozen: anthropic:oros-studio-garden-ce242c49 missing/invalid monk physical cap. No monk count may rise; only a calibrated host already over its own high-water mark may step down toward the floor.

- `msg-minion-town-guest-peer-fetch-verify-a02887e8f0f8` — from gardener:minion-town-guest-peer-fetch-verify, reply_to `minion-town-guest-peer-fetch-verify` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-guest-peer-fetch-verify-a02887e8f0f8.md)

> minion.town guest peer-fetch ([kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58)): STILL BLOCKED on your decision — no work done, job re-gated.
>
> The job `minion-town-guest-peer-fetch-verify` was auto-promoted off the deferred plan queue by the foreman today (2026-09-16) and claimed, but its precondition is unmet: the daemon-exposure question you were asked on [kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58) (comment 5447765615, 2026-08-28) has never been answered. Every comment on that issue since is about other matters (hint format, the npm.minion.town proxy, press pause/resume, the checklist reframe, the Fable supervisor, sitreps). The promotion metadata itself records `cleared=none`.
>
> The remaining work (a peer `enlivenSturdyRef` fetch of a revealed guest) needs an infrastructure + security-posture change that only you can authorize, so I did NOT run it. I re-parked it as a **go-ahead** plan job `minion-town-guest-peer-fetch-verify-await-auth` (deferred was the wrong gate — the foreman auto-selects deferred jobs and ignores the prose condition; go-ahead is never auto-promoted). It will wait for your answer and not be re-promoted automatically.
>
> THE QUESTION (please answer to unblock): authorize exposing the guest-substrate daemon `endo-daemon.service` over a public OCapN-CBOR-Noise route so a peer can `enlivenSturdyRef` a revealed guest by its formula id — OR did you intend the app to run on the already-public pet-daemon? Once you answer, promote `minion-town-guest-peer-fetch-verify-await-auth`.

- `msg-design-sysop-attested-exec-op-20260916-27885127eacb` — from gardener:design-sysop-attested-exec-op-20260916, reply_to `design-sysop-attested-exec-op-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-design-sysop-attested-exec-op-20260916-27885127eacb.md)

> Verification found the stated boatman-is-out-of-reach invariant is not presently architectural on this host. Positive evidence: the garden launcher bind-mounts only the checkout and does not forward SSH_AUTH_SOCK; gh auth has only kriscendobot and ssh-add has no identities. But the container is launched --privileged, the garden user has passwordless sudo, and the container sees the host block device, so an arbitrary exec can become container root and plausibly mount/read the host filesystem (including human credentials if present). Also roles/boatman/AGENT.md and CLAUDE.md currently say a gardener in the full garden on the credentialed host claims ferry jobs and uses GARDEN_GH_IDENTITY=kriskowal, contrary to the directive that boatman is outside the garden/bus. I will design exec with an explicit build precondition/acceptance gate that must establish the corrected separation (and name these current contradictions), unless you direct a different interpretation.

- `build-rbra-cleanbreak-20260916-child-build-rbra-clean-break-20260916-failed` — from orchestrator:build-rbra-cleanbreak-20260916-child-build-rbra-clean-break-20260916-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-rbra-cleanbreak-20260916-child-build-rbra-clean-break-20260916-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: build-rbra-cleanbreak-20260916
> orchestration-status: running
> child: build-rbra-clean-break-20260916
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 10921s on host endolin-garden-ece02cb4 (handler-timeout=10800s, multiplier=1)
>
> Orchestration build-rbra-cleanbreak-20260916 observed child build-rbra-clean-break-20260916: stalled in flight for 10921s on host endolin-garden-ece02cb4 (handler-timeout=10800s, multiplier=1).

- `watchdog-triager-fetch-failed-kriscendobot-ocapn` — from watchdog:triager/kriscendobot-ocapn, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-ocapn.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-ocapn` has CLEARED (first seen 2026-09-17T00:33:01Z, cleared 2026-09-17T00:34:31Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-ocapn at /home/kris/garden/worktrees/kriscendobot-ocapn.git is SUCCEEDING again; kriscendobot-ocapn is being triaged normally.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1.md)

> WATCHDOG notice — occurrence #11 (first seen 2026-09-09T20:50:24Z, latest 2026-09-19T06:50:21Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-1`) has now been observed 11 times; this is ONE
> coalesced notice that updates in place, not 11 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 0 -> 1 (target 1): shared cleric demand active=1 queue=0 fleet-envelope=5 target=1

- `doomed-improve-ci-watcher-primary-quota-cooldown-too-short-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-improve-ci-watcher-primary-quota-cooldown-too-short-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/improve-ci-watcher-primary-quota-cooldown-too-short; it stays HELD until a human promotes it
> (promote-plan.sh improve-ci-watcher-primary-quota-cooldown-too-short) or removes it, so nothing is lost.
> Original job base: improve-ci-watcher-primary-quota-cooldown-too-short
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/common.sh
> ci-watcher.sh's rollup_hit_primary_quota() routes GitHub PRIMARY hourly-quota exhaustion (distinct from a transient 5xx/HTML blip) through common.sh's shared start_api_cooldown, whose window is hard-capped at 900s — far shorter than GitHub's real ~1hr rate-limit reset. Journalctl shows the same quota-exhaustion WARN re-firing every ~5min (12:26/12:31/12:37Z) because each short cooldown expires and re-hits the still-exhausted API, burning calls and repeating log noise for the whole outage window. mirror-closer.sh already solved this correctly with its own dedicated ~3600s cooldown (MIRROR_QUOTA_MARKER / mirror_quota_cooldown_secs, scripts/jobs/mirror-closer.sh). Add a second shared primary-quota cooldown helper to common.sh (e.g. start_primary_quota_cooldown/primary_quota_cooldown_active, default ~3600s, mirroring the existing blip-cooldown pattern) and switch ci-watcher.sh's rollup_hit_primary_quota (and any other watcher that detects the same "doomed until quota recovers" signal) onto it instead of the 900s-capped blip cooldown — retiring mirror-closer.sh's private duplicate in favor of the shared helper.

- `20260917T005044Z-369283` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260917T005044Z-369283.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: ironhorse-iterator-intrinsic-metadata
> - question (msgid msg-ironhorse-iterator-intrinsic-metadata-8bd9eab6e4eb.md)
> - tentative answer: proxy/tentative — this is a progress report, not a gating question, but treating it as if it asked "is this scope reduction OK?": yes, proceed. The fix is real and verified (106 passing cargo tests, zero test:xs divergence introduced), and the scope narrowing is well-justified: SES/lockdown/module/compartment failures are a documented separate engine gap (missing `lockdown`, SES-shim abort, unported modules/compartments), not an iterator-intrinsic-metadata issue. Don't hold the PR open trying to make the full 48-failure count move — that's out of this job's blast radius. Retry `ensure-pr.sh` once the GraphQL rate limit clears and get the draft PR open describing exactly this scope (2 intrinsic-shape bugs fixed, ~8 bare-Ironhorse entries resolved, structural SES/module gap called out as future work). If retries keep failing beyond a transient blip, flag that separately rather than blocking on it.

- `doomed-build-rbra-clean-break-20260916-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-build-rbra-clean-break-20260916-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 10800s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/build-rbra-clean-break-20260916; it stays HELD until a human promotes it
> (promote-plan.sh build-rbra-clean-break-20260916) or removes it.
> Original job base: build-rbra-clean-break-20260916
>
> --- original job body ---
> ---
> tier: mentor
> handler-timeout: 10800
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T02:34:51Z cleared=none -->
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> handler-timeout: 10800
> ---
> Step 2 (the CLEAN BREAK) of ReadableBlob range attenuation on
> endojs/endo-but-for-bots, per `designs/readableblob-range-attenuation.md`.
> Prerequisite: step 1 (range/textRange adopted additively on ALL producers) is
> merged into draft PR [endojs/endo-but-for-bots#1301](https://github.com/endojs/endo-but-for-bots/issues/1301)'s branch
> `kriscendobot:build/readableblob-range-attenuation`. STACK ON IT (resume via
> `ensure-project-worktree.sh` + `git reset --hard
> kriscendobot/build/readableblob-range-attenuation`; re-adopt #1301 with
> `ensure-pr.sh` by the job marker — never open a new PR).
>
> Replace `fetch`, `rangeRead`, and `rangeReadText` with `range`/`textRange` on
> EVERY producer in one clean break — NO deprecated aliases (resolved decision 2).
> `fetch` is NOT an alias of `range`: `fetch` returned a one-use
> `PassableBytesReader`; `range` returns a same-interface `ReadableBlob`. Separate
> the range-specific `fetch` from the unrelated HTTP / git-transport /
> content-store `fetch` methods (design's inventory table is authoritative — read
> it on the branch).
>
> Producers to strip of `fetch`/`rangeRead`/`rangeReadText`:
> `packages/platform/src/fs-node/local-blob.js`,
> `packages/platform/src/fs/extended/shared/blob-ref.js`,
> `packages/daemon/src/manager.js` (`makeReadableBlob`, `makeBytesBlob`),
> `packages/daemon/src/mount.js` (`makeMountFileExo`, `makeReadableBlobView`),
> `packages/git/src/native-git-backend.js` (`makeGitBlob`).
>
> Guards: drop `fetch` from `rangeReadMethodGuards`/`BlobRefInterface`/daemon
> `BlobInterface`, and drop `rangeReadConvenienceMethodGuards`
> (`rangeRead`/`rangeReadText`) from `ReadableBlobRangeReadInterface`.
>
> Consumers — update to the new cap shape, decoding/streaming through the normal
> blob surface where they formerly drained a bytes reader:
> - `packages/platform/src/fs/extended/cas.js` (`cacheBackedRead`: was
>   `E(blobRef).fetch(0n, info.size)` → drainBytesReader). Read the whole blob via
>   the surviving surface (e.g. `streamBase64` decoded, or the design's chosen
>   path) — there is NO `fetch` anymore.
> - `packages/platform/src/fs/extended/cached-fs.js` (`populateInBackground`: same
>   `fetch(0n,size)` pattern).
> - any daemon consumers that drained a range `fetch`.
>
> Tests: update `packages/platform/test/{local-blob,blobref,node-fs,optimal-querying}.test.js`
> and `packages/daemon/test/{endo,mount,git}.test.js` + mount conformance — remove
> `fetch`/`rangeRead`/`rangeReadText` assertions, keep/extend the range/textRange
> matrix and the method-set surface tests (which now must NOT list the removed
> methods). Update `packages/platform/test/fs-types-source.test-d.ts` key-set
> assertions. Update `packages/platform/src/fs/types.ts` +
> `packages/platform/src/fs/extended/types.ts` (remove fetch/rangeRead*, keep
> range/textRange) and `packages/exo-git/src/types.ts`.
>
> Verify: full `packages/{platform,daemon,git,exo-git}` lint + lint:types +
> test:types + ava. Push, keep #1301 draft. Report the consumer-rewrite approach
> taken and whether the rename child can proceed.

- `doomed-daily-progress-summary-20260919-070505-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-daily-progress-summary-20260919-070505-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/daily-progress-summary-20260919-070505; it stays HELD until a human promotes it
> (promote-plan.sh daily-progress-summary-20260919-070505) or removes it, so nothing is lost.
> Original job base: daily-progress-summary-20260919-070505
>
> --- original job body ---
> Scheduled dispatch context (computed by the scheduler at fire time):
>
> - window_start: 2026-09-18T07:00:00Z (UTC, inclusive)
> - window_end: 2026-09-19T07:00:00Z (UTC, exclusive)
> - pacific_date: 2026-09-18 (the Pacific day this periodical covers)
> - output: journal/periodicals/2026/09/18.md
>
> ---
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Daily midnight Pacific progress summary
>
> Act as the [journalist](../../roles/journalist/AGENT.md) with purpose
> `daily-progress-summary` (see that role's § Daily progress summaries). Write one
> daily progress-summary periodical covering the prior 24 hours across every project,
> then commit it to `journal2`.
>
> 1. **Window.** If the scheduler prepended a "Scheduled dispatch context" block
>    above (it does under the anchored `daily-at-00:00-America/Los_Angeles`
>    cadence), use its `window_start`, `window_end`, `pacific_date`, and `output`
>    verbatim. Otherwise fall back to the Pacific day that most recently closed:
>    window `[<pacific_date> 00:00, next-day 00:00)` in America/Los_Angeles, and
>    `output = journal/periodicals/<YYYY>/<MM>/<DD>.md` keyed by that `pacific_date`.
> 2. **Read.** Every entry under `journal/entries/<YYYY>/<MM>/<DD>/` whose `ts:` is
>    in `[window_start, window_end)` (a UTC window can straddle two day-directories;
>    scan both and filter by `ts:`), plus the board transitions in the window
>    (`jobs/{todo,doin,tada}` moves from `git -C journal log --since=... --until=...`).
>    Scope is intentionally everything: dispatches, results, ticks, messages, and
>    worktree-lifecycle entries alike.
> 3. **Write.** One abstract-first periodical at `output`, partitioned by project
>    (the `project:` slug; one section per project with any entry, plus a garden-meta
>    section for untagged entries) and, within each, by activity kind. Do not skip a
>    project for having only a couple of entries. Cite sources by relative path;
>    paraphrase, do not copy. House style applies (no em-dashes in prose, no Latin
>    shorthand, relative paths). Commit and push the one file with the usual CAS; if
>    the file already exists for that Pacific date, overwrite it (the periodical is a
>    function of the window, so a re-run is idempotent).
>
> Deliverable: the periodical file committed to `journal2`, or (empty window) a
> one-line periodical saying nothing moved. No board writes, no upstream actions.
>
> ---
> Translated from v1 `schedule/garden/20260513T070000Z--5a93f9.md`
> (recurrence `daily-at-00:00-America/Los_Angeles`, dispatch `journalist` /
> `daily-progress-summary`, window "prior 24 hours", scope all projects).
> The v1 trigger/short-id/fired machinery is dropped: v2 schedules are recurring
> specs keyed by cadence, not pre-computed per-fire event files. The v1 periodicals
> output tree is archived under `legacy/v1/periodicals/`. The v1 original is
> retained on `journal-v1` and `origin/journal`.
>
> The cadence is the anchored, DST-aware `daily-at-00:00-America/Los_Angeles` (which
> the scheduler learned on main2 commit 85a1cd8e6): due-ness is decided against the
> most recent Pacific-midnight anchor at-or-before now and `last_dispatched` is
> stamped to that anchor, so the fire never drifts off local midnight and a 23h/25h
> DST day is spanned correctly. It was flipped from the earlier fixed-interval
> `daily` (which drifted, firing at each actual dispatch time rather than at local
> midnight) once the anchored scheduler landed on the leader host; do not revert it
> to `daily` while any leader host still runs a pre-anchor scheduler, or that
> scheduler would treat the token as its weekly default.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `watchdog-triager-fetch-failed-kriscendobot-endo` — from watchdog:triager/kriscendobot-endo, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-endo.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-endo` has CLEARED (first seen 2026-09-17T02:30:24Z, cleared 2026-09-17T02:32:28Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-endo at /home/kris/garden/worktrees/kriscendobot-endo.git is SUCCEEDING again; kriscendobot-endo is being triaged normally.

- `msg-wire-siwe-onchain-authz-minion-town-followup-4c95a89e5d97` — from gardener:wire-siwe-onchain-authz-minion-town-followup, reply_to `wire-siwe-onchain-authz-minion-town-followup` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-wire-siwe-onchain-authz-minion-town-followup-4c95a89e5d97.md)

> SIWE on-chain authz (minion.town) — the maintainer-gated remainder is BLOCKED on two decisions that only you can make. This followup was auto-promoted from the deferred reservoir on 2026-09-16 with gate `cleared=none`; the predecessor already shipped ALL address-independent work (policy layer keys on iss+sub with intersection semantics, needs no code change for Tier 1; test/policy.test.ts covers the SIWE address-keyed shape, green). Nothing further can be built responsibly without your input — the addresses are production authorization identities and must not be invented.
>
> Please answer:
>
> 1) DECISION 3 (tier): Tier 1 only (the design's recommendation), or Tier 1 + Tier 2? If Tier 2, which asset first — registry (design recommends a purpose-built Ownable address→scope-bitmap contract on Base), safe_signer, erc721, or erc20_min_balance?
>
> 2) TIER 1 ALLOWLIST: for each address to authorize under iss=`https://siwe-idp.minion.town`, give:
>    - the wallet address (I will EIP-55 checksum it),
>    - scopes (mcp/tools, mcp/guest),
>    - optional guestFacetGrants (e.g. ["evaluator"]),
>    - a short note.
>
> Once you reply, Tier 1 is minutes of work (config/policy.json entries; harness already covers the shape). If you don't intend to authorize any SIWE identities yet, say so and I'll re-park this as deferred rather than loop.

- `20260901T175244Z-931faa` — from gardener:minion-town-remove-mcp-tool-prefixes, reply_to `minion-town-remove-mcp-tool-prefixes` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T175244Z-931faa.md)

> [kriscendobot/minion.town#75](https://github.com/kriscendobot/minion.town/issues/75) is merged and deployment run 33539977066 succeeded. The remaining required blind live discovery evaluation needs an authenticated minion.town MCP session. This worker container has no AWS CLI/credentials or minion.town OAuth connection, so it cannot read the sanctioned minion/test-cc-client secret or attach the live MCP to a context-free agent. Please either run a connected blind agent with only the directive "evaluate 2 + 2" and send the transcript/result, or make a short-lived sanctioned Bearer token available through this job inbox (do not paste a long-lived client secret).

- `watchdog-triager-fetch-failed-kriscendobot-minion.town` — from watchdog:triager/kriscendobot-minion.town, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-minion.town.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-minion.town` has CLEARED (first seen 2026-09-17T02:30:11Z, cleared 2026-09-17T02:32:23Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-minion.town at /home/kris/garden/worktrees/kriscendobot-minion.town.git is SUCCEEDING again; kriscendobot-minion.town is being triaged normally.

- `msg-claude-on-minion-town-press-20260919-103505-563702aabb72` — from gardener:claude-on-minion-town-press-20260919-103505, reply_to `claude-on-minion-town-press-20260919-103505` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-claude-on-minion-town-press-20260919-103505-563702aabb72.md)

> Arc [kriscendobot/garden#89](https://github.com/kriscendobot/garden/issues/89) (Claude on minion.town) — one go-ahead decision, high leverage:
>
> [endojs/endo-but-for-bots#1305](https://github.com/endojs/endo-but-for-bots/issues/1305) (guest-owned invitation, slice 3/3 — the LAST artifact-level blocker of arc item 7's CapTP half) is APPROVED (re-approved 09-19 05:50Z), mergeable-clean, CI-green (15 pass/15 skip). [endojs/endo-but-for-bots#1304](https://github.com/endojs/endo-but-for-bots/issues/1304) and [endojs/endo-but-for-bots#1306](https://github.com/endojs/endo-but-for-bots/issues/1306) already merged into llm. It is one conduct away from clearing the CapTP blocker entirely.
>
> Your 2026-09-19 "shepherd, retcon, conduct" directive on [endojs/endo-but-for-bots#1305](https://github.com/endojs/endo-but-for-bots/issues/1305) halted at 06:43Z: the shepherd child was doomed by the same transient requeue-exhausted quota event that doomed ~88 jobs that morning. The retcon+conduct children are now parked behind go-ahead gates — consistent with the foreman brake you set 2026-09-17 for quota conservation, so I did NOT autonomously re-drive against the throttle.
>
> Decision needed: land [endojs/endo-but-for-bots#1305](https://github.com/endojs/endo-but-for-bots/issues/1305) now, or hold until you lift the throttle?
> - If land now: retcon+conduct as you directed (retcon re-triggers CI, more spend), or conduct-only (CI is already green; minimal spend)?
> - Same question applies to the two other arc jobs parked by the same 09-19 quota doom: [endojs/endo-but-for-bots#1015](https://github.com/endojs/endo-but-for-bots/issues/1015) refresh-for-review (item 5 stdio-MCP build) and [endojs/endo-but-for-bots#1226](https://github.com/endojs/endo-but-for-bots/issues/1226) revision (item 5 design, changes-requested). Lower priority than [endojs/endo-but-for-bots#1305](https://github.com/endojs/endo-but-for-bots/issues/1305); happy to leave parked.
>
> No code review is pending from you this tick — the arc is machine-gated on the above.

- `msg-reconcile-gardener-alias-retirement-gate-20260916-70e30735a192` — from gardener:reconcile-gardener-alias-retirement-gate-20260916, reply_to `reconcile-gardener-alias-retirement-gate-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-reconcile-gardener-alias-retirement-gate-20260916-70e30735a192.md)

> Reconcile of the retirement-gate-1 failure for `retire-gardener-worker-kind-alias`.
> I re-gathered evidence on this host (endolin-garden-ece02cb4, the current LEADER)
> and checked the shared journal fleet-wide. NET: retirement is still correctly
> blocked — but the real blocker is a THIRD host the original plan never accounted
> for. I changed no code, journal state, or units, and did NOT requeue the cleanup.
> Requeuing now would just re-fail gate 1 (it already exhausted its 5 requeue cycles).
>
> Re-verified findings on THIS host (endolin-garden-ece02cb4):
> - `.garden-state/gardeners/` holds 100 legacy `*.garden` identity markers + a
>   `backend/{state,status}` probe-cache. Newest marker `1.garden` is
>   2026-08-31T02:10:35Z (= container recreate; content is the current host name).
>   (garden2 had 101 — different host, so a slightly different count is expected.)
> - Legacy `garden-gardener@1.service`: loaded, INACTIVE, dead (only @1 is present
>   here, not @1..4).
> - Monk count: the host declares `monks: 3` and `garden-monk@1..3` are enabled +
>   active. NO mismatch on this host. The "declares 4 / only 1..3 active" finding
>   was garden2-specific and is now stale (the leveler has since moved garden2 to
>   `monks: 2`).
>
> Are the markers dead / read by anything? Partly:
> - `<id>.garden` is a per-worker IDENTITY marker written by gardener.sh at every
>   spawn to `$GARDEN_STATE/<state_ns>/<id>.garden`, read by the scaler's
>   identity-drift guard. For the `monk` kind state_ns=monks, so live monks write
>   `.garden-state/monks/*.garden` (confirmed fresh today). The `gardeners/*.garden`
>   markers belong to the `gardener` kind (state_ns=gardeners).
> - On endolin-garden hosts no `gardener`-kind worker runs, so those markers are
>   dead residue LOCALLY. BUT they are NOT globally dead — see the blocker below.
> - I therefore did NOT delete them. On a monk host they are harmless, and marker
>   removal is the retirement cleanup's own gated responsibility (it plans to remove
>   them on both endolin hosts as host-side cleanup), not a side effect of a reconcile.
>
> Monk count reconciliation: nothing to reconcile here (3 == 3), and the declared
> count is BUDGET-LEVELER-OWNED (live pool anthropic:endolin-garden-ece02cb4 spend
> 43.8M / cap 143M). I left it untouched, per your directive not to fight the leveler.
>
> THE ACTUAL BLOCKER (new, not in the original plan): a third fleet host,
> `oros-studio-garden-ce242c49` (live follower, active as of 2026-09-15), still
> declares ONLY `gardeners: 2` with NO `monks:` key — it was never migrated to monk.
> So the legacy `gardener` worker kind is STILL IN ACTIVE FLEET USE, which means:
> - Gate 1 ("all fleet inventory reports zero legacy units and state markers")
>   genuinely fails — oros writes/reads `gardeners/*.garden` live.
> - Gate 3 ("all hosts have deployed the canonical release") is also in doubt: oros
>   is currently FAILING to deploy latest main2 (deploy test-gate rejection
>   2026-09-15, policy-refusal-quarantine-test rc=1).
> Retiring the alias now would break oros-studio outright. The plan job's premise
> ("both fleet hosts have cut over") predates oros and is no longer true.
>
> This is your call, so I stopped rather than guess:
>   (a) migrate oros-studio to monk first (`migrate-host-to-monk.sh cutover` ON that
>       host, followers-first per the design) and fix its deploy gate, THEN promote
>       the retirement cleanup; or
>   (b) decide oros stays gardener and the alias is NOT retired for now.
> I left `jobs/plan/retire-gardener-worker-kind-alias` parked (HELD) and did not
> promote/requeue it. Also the original prior-pass message
> `inbox/maintainer/unread/20260901T205650Z-59a6f5` can be marked read — its two
> asks (marker disposition + monk-count) are resolved above; the live blocker is oros.

- `20260917T012508Z-a9d562` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260917T012508Z-a9d562.md)

> awaiting maintainer — beyond proxy authority: gardener ironhorse-fuzz-fd8517d5f3071227-repair, msgid msg-ironhorse-fuzz-fd8517d5f3071227-repair-6602bc26dcbd.md — Whether to drop/advance work governed by the standing IronHorse pause ([kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91)) — and reconciling why this job was promoted via plan gate=go-ahead on 2026-09-16 despite that pause — is a policy question only a trusted maintainer can resolve, not a proxy-able progress call.


## Spend & quota
_Since Friday 20:00 Pacific reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 2.5M | $27.88 _(notional, rate-card)_ | 2% of 143.0M (ok) |
| Codex | 996.4k _(+5.8M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 1% _(plan; codex-reported)_ |

## Board
### todo (1)
- [`canary-probe-oros-studio-garden-ce242c49-fab63b7af6af`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/canary-probe-oros-studio-garden-ce242c49-fab63b7af6af.md) — rolling-deploy canary probe for oros-studio-garden-ce242c49 @ fab63b7af6af

### doin (0)
(none)

### tada (8427)
- [`canary-probe-endolin-garden2-5bcdff64-fab63b7af6af`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/19/canary-probe-endolin-garden2-5bcdff64-fab63b7af6af.md) — rolling-deploy canary probe — round trip OK
- [`improve-cursor-outage-herd-suppression`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/19/improve-cursor-outage-herd-suppression.md) — Completion report
- [`endo-guest-native-accept-primitive`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/19/endo-guest-native-accept-primitive.md) — Completion report
- [`endojs-endo-but-for-bots-pr1305-receipt`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/19/endojs-endo-but-for-bots-pr1305-receipt.md) — Cost
- [`endojs-endo-but-for-bots-pr1305-conduct-r5256145878`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/19/endojs-endo-but-for-bots-pr1305-conduct-r5256145878.md) — Cost
- … and 8422 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`ironhorse-fuzz-bd4559ecbc0432c1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bd4559ecbc0432c1-repair.md) — _normal_ · Repair Ironhorse engine defect bd4559ecbc0432c1 (target differential_source) ...
- [`kriscendobot-minion.town-pr56-review-5867a29b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-5867a29b-retro.md) — _normal_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`ironhorse-fuzz-baad1f22ef053213-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-baad1f22ef053213-repair.md) — _normal_ · Repair Ironhorse engine defect baad1f22ef053213 (target differential_regexp_s...
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`ironhorse-fuzz-fcbb16f5721e8fd2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fcbb16f5721e8fd2-repair.md) — _normal_ · Fix Ironhorse fuzz finding fcbb16f5721e8fd2 (target differential_source) and ...
- [`ironhorse-fuzz-89e303d17e33b117-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-89e303d17e33b117-repair.md) — _normal_ · Repair Ironhorse engine defect 89e303d17e33b117 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr431-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr431-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #431
- [`kriscendobot-minion.town-pr69-review-f7e1d07a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr69-review-f7e1d07a-retro.md) — _normal_ · Retrospective on kriscendobot/minion.town PR #69 (primary: kriscendobot-minio...
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr663-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr663-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #663
- [`endojs-endo-but-for-bots-pr356-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr356-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #356
- [`daily-progress-summary-20260919-070505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20260919-070505.md) — _normal_ · Daily midnight Pacific progress summary
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`ironhorse-fuzz-50834e82d3af453d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-50834e82d3af453d-repair.md) — _normal_ · Repair Ironhorse engine defect 50834e82d3af453d (target differential_regexp_s...
- [`improve-retro-doom-escalation-noise`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-retro-doom-escalation-noise.md) — _normal_ · ---
- [`self-heal-fix-garden-issue-inbox-cursor-get-failopen`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-failopen.md) — _normal_ · ---
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`improve-budget-level-single-host-cap-freeze`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-budget-level-single-host-cap-freeze.md) — _normal_ · ---
- [`ironhorse-fuzz-27824c75429b8581-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-27824c75429b8581-repair.md) — _normal_ · Repair Ironhorse engine defect 27824c75429b8581 (target differential_source) ...
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`improve-ci-watcher-primary-quota-cooldown-too-short`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-ci-watcher-primary-quota-cooldown-too-short.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr550-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr550-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #550
- [`endojs-endo-but-for-bots-pr945-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr945-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #945
- [`endojs-endo-but-for-bots-pr241-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr241-gauntlet-fix-6.md) — _normal_ · Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #241
- [`ironhorse-fuzz-12aca768c2e73c73-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-12aca768c2e73c73-repair.md) — _normal_ · Fix Ironhorse fuzz finding 12aca768c2e73c73 (target differential_regexp) and ...
- [`ironhorse-fuzz-c781c9b9de456ab2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c781c9b9de456ab2-repair.md) — _normal_ · Repair Ironhorse engine defect c781c9b9de456ab2 (target differential_regexp_s...
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`ironhorse-fuzz-bc9529ac5818aa24-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc9529ac5818aa24-repair.md) — _normal_ · Repair Ironhorse engine defect bc9529ac5818aa24 (target differential_regexp_s...
- [`ironhorse-fuzz-9001b34fa6dd2d80-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9001b34fa6dd2d80-repair.md) — _normal_ · Repair Ironhorse engine defect 9001b34fa6dd2d80 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr551-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr551-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #551
- [`endojs-endo-but-for-bots-pr1125-review-af33f29e`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-af33f29e.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1125
- [`build-e-untag-handled-promise-pipelining`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-e-untag-handled-promise-pipelining.md) — _normal_ · What already exists (do not re-derive; verify against current master
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`endojs-endo-but-for-bots-pr1125-aff3b059-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-aff3b059-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr539-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr539-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #539
- [`endojs-endo-but-for-bots-pr359-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr359-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #359
- [`endojs-endo-but-for-bots-pr1015-refresh-for-review-20260919`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-refresh-for-review-20260919.md) — _normal_ · Refresh the @endo/claude confinement-core build (endojs/endo-but-for-bots#101...
- [`improve-self-heal-run-handler-deadline`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-self-heal-run-handler-deadline.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1301-gauntlet-20260918-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1301-gauntlet-20260918-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1301
- [`improve-elapsed-constancy-escalation-include-capture`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-elapsed-constancy-escalation-include-capture.md) — _normal_ · ---
- [`ironhorse-fuzz-c6c71d428a37088c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c6c71d428a37088c-repair.md) — _normal_ · Repair Ironhorse engine defect c6c71d428a37088c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr1305-d4fa4360`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-d4fa4360.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1305
- [`endojs-endo-but-for-bots-pr1089-32c7e8f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1089-32c7e8f1.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1089
- [`kriscendobot-minion.town-pr32-review-93782d28-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr32-review-93782d28-retro.md) — _normal_ · Retrospective on kriscendobot/minion.town PR #32 (primary: kriscendobot-minio...
- [`ironhorse-fuzz-51c6a212946102f6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-51c6a212946102f6-repair.md) — _normal_ · Repair Ironhorse engine defect 51c6a212946102f6 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr1305-b982dc09`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-b982dc09.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1305
- [`ironhorse-fuzz-13b68e2edb67861a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-13b68e2edb67861a-repair.md) — _normal_ · Repair Ironhorse engine defect 13b68e2edb67861a (target differential_regexp) ...
- [`ironhorse-fuzz-e2a75557f762cd9c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e2a75557f762cd9c-repair.md) — _normal_ · Repair Ironhorse engine defect e2a75557f762cd9c (target differential_regexp) ...
- [`daily-progress-summary-20260918-070547`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20260918-070547.md) — _normal_ · Daily midnight Pacific progress summary
- [`endo-claude-agent-sdk-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-probe.md) — _normal_ · Probe: measure the Agent SDK's confinement claims against a live run
- [`upgrade-fleet-to-main2-uniform-20260918`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/upgrade-fleet-to-main2-uniform-20260918.md) — _normal_ · Why this is ONE looping orchestrator job, not a parked child set
- [`endojs-endo-but-for-bots-pr264-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #264
- [`endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1085
- [`fix-worktree-sweeper-leader-only-misgating-20260919`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-worktree-sweeper-leader-only-misgating-20260919.md) — _normal_ · Evidence (endolin-garden2-5bcdff64, a FOLLOWER, 2026-09-18/19)
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`split-pr1125-1304-gauntlet-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/split-pr1125-1304-gauntlet-shepherd.md) — _normal_ · Gauntlet + shepherd for endojs/endo-but-for-bots#1304 (slice 1/3 of the #1125...
- [`endojs-endo-but-for-bots-pr879-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr879-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #879
- [`self-heal-fix-garden-issue-inbox-cursor-get-pipefail`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-pipefail.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr897-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave-20260901.md) — _normal_ · Weave (rebase onto live llm) endojs/endo-but-for-bots PR #897
- [`improve-receipt-watcher-direct-dispatch`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-receipt-watcher-direct-dispatch.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr664-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr664-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #664
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`dependabotany-recheck-endo-but-for-bots-pr1268`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-pr1268.md) — _normal_ · botanist recheck: endojs/endo-but-for-bots PR #1268 (re-conduct after rebase)
- [`ironhorse-fuzz-1cd4ddc72d5801c4-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cd4ddc72d5801c4-repair.md) — _normal_ · Repair Ironhorse engine defect 1cd4ddc72d5801c4 (target differential_regexp_s...
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`ironhorse-fuzz-f2f53bb078bc8a4e-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f2f53bb078bc8a4e-repair.md) — _normal_ · Fix Ironhorse fuzz finding f2f53bb078bc8a4e (target differential_regexp) and ...
- [`endojs-endo-but-for-bots-pr266-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr266-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #266
- [`fix-minion-town-claude-harness-supply-chain-hardening`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-minion-town-claude-harness-supply-chain-hardening.md) — _normal_ · ---
- [`ironhorse-fuzz-cfdc1a28296f23a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-cfdc1a28296f23a1-repair.md) — _normal_ · Repair Ironhorse engine defect cfdc1a28296f23a1 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr360-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr360-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #360
- [`endojs-endo-but-for-bots-pr1304-0c373555`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-0c373555.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1304
- [`kriscendobot-oros-ckm-data-readiness-pr1-receipt`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-oros-ckm-data-readiness-pr1-receipt.md) — _normal_ · receipt (auto) — completion receipt for kriscendobot/oros-ckm-data-readiness ...
- [`endojs-endo-but-for-bots-pr990-refresh`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr990-refresh.md) — _normal_ · refresh directive on endojs/endo-but-for-bots PR #990
- [`retire-gardener-worker-kind-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-worker-kind-alias.md) — _normal_ · ---
- [`self-heal-fix-garden-issue-inbox-cursor-get-set-e`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-set-e.md) — _normal_ · ---
- [`ironhorse-fuzz-6ba52f2bdc534545-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ba52f2bdc534545-repair.md) — _normal_ · Repair Ironhorse engine defect 6ba52f2bdc534545 (target differential_regexp_s...
- [`kriscendobot-minion.town-pr79-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr79-conduct.md) — _normal_ · Finalize (curate -> merge) kriscendobot/minion.town PR #79
- [`endojs-endo-but-for-bots-pr1305-review-40fd197b`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-review-40fd197b.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1305
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-base-update-and-pin-alias.md) — _normal_ · ---
- [`ironhorse-fuzz-ccb76a40851925f9-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ccb76a40851925f9-repair.md) — _normal_ · Repair Ironhorse engine defect ccb76a40851925f9 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr877-review-a8763cf9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr877-review-a8763cf9-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #877 (primary: endojs-endo-but-f...
- [`ironhorse-fuzz-d5413146a257bc30-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d5413146a257bc30-repair.md) — _normal_ · Repair Ironhorse engine defect d5413146a257bc30 (target differential_regexp_s...
- [`kriscendobot-minion.town-pr68-retcon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-retcon.md) — _normal_ · retcon directive on kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr675-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr675-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #675
- [`ironhorse-fuzz-ad5b483fc5e0973f-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ad5b483fc5e0973f-repair.md) — _normal_ · Repair Ironhorse engine defect ad5b483fc5e0973f (target differential_regexp_s...
- [`ironhorse-fuzz-79f0475dd0440b2d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-79f0475dd0440b2d-repair.md) — _normal_ · Repair Ironhorse engine defect 79f0475dd0440b2d (target differential_regexp) ...
- [`kriscendobot-garden-pr72-review-e5ce867a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr72-review-e5ce867a-retro.md) — _normal_ · Retrospective on kriscendobot/garden PR #72 (primary: kriscendobot-garden-pr7...
- [`deadmail-issue-comment-5722768728`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deadmail-issue-comment-5722768728.md) — _normal_ · Issue follow-up — fold a late comment into the issue work
- [`ironhorse-fuzz-b95320dfb5dd9d3d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-b95320dfb5dd9d3d-repair.md) — _normal_ · Repair Ironhorse engine defect b95320dfb5dd9d3d (target differential_regexp_s...
- [`ironhorse-fuzz-7072dc2d72d9e2fd-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7072dc2d72d9e2fd-repair.md) — _normal_ · Repair Ironhorse engine defect 7072dc2d72d9e2fd (target differential_regexp) ...
- [`kriscendobot-minion.town-pr99-receipt`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr99-receipt.md) — _normal_ · receipt (auto) — completion receipt for kriscendobot/minion.town PR #99 (merged)
- [`improve-ci-watcher-outage-latch-flap-dedup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-ci-watcher-outage-latch-flap-dedup.md) — _normal_ · ---
- [`ironhorse-fuzz-ecae051e6e8f5a27-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ecae051e6e8f5a27-repair.md) — _normal_ · Repair Ironhorse engine defect ecae051e6e8f5a27 (target differential_source) ...
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-silent-exit1-no-err-trap`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-silent-exit1-no-err-trap.md) — _normal_ · ---
- [`ironhorse-fuzz-67ca18e4febe7a34-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-67ca18e4febe7a34-repair.md) — _normal_ · Repair Ironhorse engine defect 67ca18e4febe7a34 (target differential_source) ...
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr762-gauntlet-20260902`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr762-gauntlet-20260902.md) — _normal_ · Complete the gauntlet for endojs/endo-but-for-bots#762
- [`ironhorse-fuzz-d87697d49a5f8f67-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d87697d49a5f8f67-repair.md) — _normal_ · Repair Ironhorse engine defect d87697d49a5f8f67 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr463-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr463-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #463
- [`ironhorse-fuzz-e0fe14e41d5074a6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e0fe14e41d5074a6-repair.md) — _normal_ · Repair Ironhorse engine defect e0fe14e41d5074a6 (target differential_source) ...
- [`ironhorse-fuzz-ab41c5d203ace017-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ab41c5d203ace017-repair.md) — _normal_ · Repair Ironhorse engine defect ab41c5d203ace017 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr432-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr432-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #432
- [`deadmail-issue-comment-5737357338`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deadmail-issue-comment-5737357338.md) — _normal_ · Issue follow-up — fold a late comment into the issue work
- [`garden-build-follower-self-deploy`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-build-follower-self-deploy.md) — _normal_ · Implement — the design's recommended path
- [`kriscendobot-minion.town-pr56-review-7d4dc95d`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-7d4dc95d.md) — _normal_ · Review directive on kriscendobot/minion.town PR #56
- [`endojs-endo-but-for-bots-pr736-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr736-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #736
- [`foreman-requiesce-target-0`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-requiesce-target-0.md) — _normal_ · Reduce the foreman's active-job target back to 0
- [`endojs-endo-but-for-bots-pr1306-conduct-20260919`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1306-conduct-20260919.md) — _normal_ · Conduct endojs/endo-but-for-bots#1306 — merge (guest provisioning, 2/3 of #1125)
- [`endojs-endo-but-for-bots-pr871-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr871-weave-20260901.md) — _normal_ · Weave endojs/endo-but-for-bots#871 — the sturdyref agent-surface build
- [`amend-invitation-oauth-mcp-prerequisite`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/amend-invitation-oauth-mcp-prerequisite.md) — _normal_ · What's actually true today versus what's designed for later — verify,
- [`ironhorse-fuzz-bc3d0df623811a38-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc3d0df623811a38-repair.md) — _normal_ · Repair Ironhorse engine defect bc3d0df623811a38 (target differential_regexp_s...
- [`ironhorse-fuzz-fad9672dc7a6e6be-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fad9672dc7a6e6be-repair.md) — _normal_ · Repair Ironhorse engine defect fad9672dc7a6e6be (target differential_source) ...
- [`ironhorse-fuzz-197b32cc30bdd4fe-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-197b32cc30bdd4fe-repair.md) — _normal_ · Repair Ironhorse engine defect 197b32cc30bdd4fe (target differential_regexp_s...
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr982-0b4f9f5d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr982-0b4f9f5d-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #982 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1305-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-conduct.md) — _normal_ · Finalize (curate → merge) endojs/endo-but-for-bots PR #1305
- [`endo-pr3360-mirror`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-pr3360-mirror.md) — _normal_ · What "mirror" means here
- [`endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-conduct-authorized-20260918.md) — _normal_ · State verified at posting (re-derive it; do not trust these)
- [`endojs-endo-but-for-bots-pr1304-eb58df65`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-eb58df65.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1304
- [`endojs-endo-but-for-bots-pr1226-revise-stdio-config-20260919`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1226-revise-stdio-config-20260919.md) — _normal_ · Revise the stdio-MCP-scoped-to-one-guest design (endojs/endo-but-for-bots#122...
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`run-the-gauntlet-minion-town-pr90`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/run-the-gauntlet-minion-town-pr90.md) — _normal_ · ---
- [`ironhorse-fuzz-af5b4a677483eac3-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-af5b4a677483eac3-repair.md) — _normal_ · Fix Ironhorse fuzz finding af5b4a677483eac3 (target differential_regexp_surfa...
- [`ironhorse-fuzz-5eeb0aadb2004075-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5eeb0aadb2004075-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5eeb0aadb2004075 (target differential_regexp) and ...
- [`ironhorse-fuzz-ac8a8e3d9d3d7f96-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ac8a8e3d9d3d7f96-repair.md) — _normal_ · Repair Ironhorse engine defect ac8a8e3d9d3d7f96 (target differential_regexp) ...
- [`ironhorse-fuzz-378372c8706a48a8-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-378372c8706a48a8-repair.md) — _normal_ · Fix Ironhorse fuzz finding 378372c8706a48a8 (target differential_regexp_surfa...
- [`minion-town-endo-b3-daemon-deploy-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-endo-b3-daemon-deploy-verify.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-issue982-build-special-names`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-issue982-build-special-names.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr68-review-45cc89f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-review-45cc89f1.md) — _normal_ · Review directive on kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr1018-review-eccc706c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-eccc706c.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1018
- [`endojs-endo-but-for-bots-pr1306-review-3ed76637`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1306-review-3ed76637.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1306
- [`ironhorse-fuzz-05264cccae42245a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-05264cccae42245a-repair.md) — _normal_ · Repair Ironhorse engine defect 05264cccae42245a (target differential_source) ...
- [`ironhorse-fuzz-5c9d2506e6048f4a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5c9d2506e6048f4a-repair.md) — _normal_ · Repair Ironhorse engine defect 5c9d2506e6048f4a (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr897-shepherd-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-shepherd-20260901.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1304-conduct-relaunch-20260918`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-conduct-relaunch-20260918.md) — _normal_ · State verified at posting (re-derive it; do not trust these)
- [`ironhorse-fuzz-7637ac162a0b916a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7637ac162a0b916a-repair.md) — _normal_ · Repair Ironhorse engine defect 7637ac162a0b916a (target differential_regexp) ...
- [`deadmail-issue-comment-5715518921`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deadmail-issue-comment-5715518921.md) — _normal_ · Issue follow-up — fold a late comment into the issue work
- [`oros-ckm-dependabot-audit-0013418`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-ckm-dependabot-audit-0013418.md) — _normal_ · ---
- [`ironhorse-fuzz-931a687135cabb0c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-931a687135cabb0c-repair.md) — _normal_ · Repair Ironhorse engine defect 931a687135cabb0c (target differential_source) ...
- [`ironhorse-fuzz-9edaa2277fb90f03-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9edaa2277fb90f03-repair.md) — _normal_ · Repair Ironhorse engine defect 9edaa2277fb90f03 (target differential_source) ...
- [`build-usage-scrape-ingest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-usage-scrape-ingest.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr709-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr709-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #709
- [`endojs-endo-but-for-bots-pr887-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr887-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #887
- [`endojs-endo-but-for-bots-pr1097-fix-review`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1097-fix-review.md) — _normal_ · Fix PR #1097 per @kriskowal review (CHANGES_REQUESTED)
- [`ironhorse-fuzz-1dc231089278c110-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1dc231089278c110-repair.md) — _normal_ · Repair Ironhorse engine defect 1dc231089278c110 (target differential_regexp) ...
- [`ironhorse-fuzz-822848c732a1b805-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-822848c732a1b805-repair.md) — _normal_ · Repair Ironhorse engine defect 822848c732a1b805 (target differential_regexp) ...
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`ironhorse-fuzz-e4a8e011666d0362-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e4a8e011666d0362-repair.md) — _normal_ · Repair Ironhorse engine defect e4a8e011666d0362 (target differential_regexp_s...
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`endojs-endo-but-for-bots-pr697-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr697-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #697
- [`endojs-endo-but-for-bots-pr631-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr631-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #631
- [`endojs-endo-but-for-bots-pr711-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr711-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #711
- [`ironhorse-fuzz-fd8517d5f3071227-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fd8517d5f3071227-repair.md) — _normal_ · Repair Ironhorse engine defect fd8517d5f3071227 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr511-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr511-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #511
- [`self-heal-fix-garden-issue-inbox-cursor-read-fail-open`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/self-heal-fix-garden-issue-inbox-cursor-read-fail-open.md) — _normal_ · ---
- [`ironhorse-fuzz-284de587e16bce32-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-284de587e16bce32-repair.md) — _normal_ · Repair Ironhorse engine defect 284de587e16bce32 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr529-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr529-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #529
- [`ironhorse-fuzz-5e7a173f899ae7a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5e7a173f899ae7a1-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5e7a173f899ae7a1 (target differential_regexp) and ...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-6.md) — _normal_ · Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #1100
- [`kriscendobot-minion-town-pr68-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr68-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr648-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr648-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #648
- [`ironhorse-fuzz-e773681b6d831dc1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e773681b6d831dc1-repair.md) — _normal_ · Repair Ironhorse engine defect e773681b6d831dc1 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr1304-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1304
- [`build-kebab-case-lint-wildcard-test262-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #762
- [`build-minion-town-claude-agents-capability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-claude-agents-capability.md) — _normal_ · ---
- [`ironhorse-fuzz-bf6cfbd74a7487fc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bf6cfbd74a7487fc-repair.md) — _normal_ · Repair Ironhorse engine defect bf6cfbd74a7487fc (target differential_regexp) ...
- [`daily-progress-summary-20260902-070506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20260902-070506.md) — _normal_ · Daily midnight Pacific progress summary
- [`endojs-endo-but-for-bots-pr450-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr450-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #450
- [`ironhorse-fuzz-45f4af87eaf627c7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-45f4af87eaf627c7-repair.md) — _normal_ · Fix Ironhorse fuzz finding 45f4af87eaf627c7 (target differential_regexp) and ...
- [`date-sharded-tada-migrate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/date-sharded-tada-migrate.md) — _normal_ · date-sharded-tada stage 3: retroactive migration of jobs/tada/
- [`ironhorse-fuzz-37e026fd30cbae19-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-37e026fd30cbae19-repair.md) — _normal_ · Repair Ironhorse engine defect 37e026fd30cbae19 (target differential_source) ...
- [`ironhorse-fuzz-c9eaa7b5ae02437a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c9eaa7b5ae02437a-repair.md) — _normal_ · Repair Ironhorse engine defect c9eaa7b5ae02437a (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr1125-receipt`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-receipt.md) — _normal_ · receipt (auto) — completion receipt for endojs/endo-but-for-bots PR #1125 (cl...
- [`ironhorse-fuzz-d38f12f4884e186c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d38f12f4884e186c-repair.md) — _normal_ · Repair Ironhorse engine defect d38f12f4884e186c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr610-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr610-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #610
- [`endojs-endo-but-for-bots-pr249-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr249-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #249
- [`ironhorse-fuzz-29a24c1b1052ec91-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-29a24c1b1052ec91-repair.md) — _normal_ · Repair Ironhorse engine defect 29a24c1b1052ec91 (target differential_regexp) ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ironhorse-fuzz-6ca7a76e0bfe3435-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ca7a76e0bfe3435-repair.md) — _normal_ · Repair Ironhorse engine defect 6ca7a76e0bfe3435 (target differential_regexp_s...
- [`ironhorse-fuzz-aaa423e9c5d56067-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-aaa423e9c5d56067-repair.md) — _normal_ · Repair Ironhorse engine defect aaa423e9c5d56067 (target differential_source) ...
- [`build-rbra-clean-break-20260916`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-rbra-clean-break-20260916.md) — _normal_ · Build-review naming directives (PR #1301 review #5252703859, kriskowal, 2026-...
- [`endojs-endo-but-for-bots-pr569-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr569-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #569
- [`endojs-endo-but-for-bots-pr797-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr797-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #797
- [`endojs-endo-but-for-bots-pr674-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr674-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #674
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`ironhorse-fuzz-8ea950859db8a5f7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8ea950859db8a5f7-repair.md) — _normal_ · Repair Ironhorse engine defect 8ea950859db8a5f7 (target differential_regexp) ...
- [`kriscendobot-vattr97-pr1-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-vattr97-pr1-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/vattr97 PR #1
- [`endojs-endo-but-for-bots-pr1304-review-c8d04bad`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-review-c8d04bad.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1304
- [`build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — kriscendobot/minion.town PR #81
- [`endojs-endo-but-for-bots-pr1305-weave-conduct-20260918`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-weave-conduct-20260918.md) — _normal_ · Rebase then conduct endojs/endo-but-for-bots PR #1305 (3/3 of the #1125 split)
- [`kriscendobot-minion.town-pr78-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr78-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #78
- [`ironhorse-fuzz-6be90176ff07c648-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6be90176ff07c648-repair.md) — _normal_ · Repair Ironhorse engine defect 6be90176ff07c648 (target differential_regexp) ...
- [`kriscendobot-minion.town-pr80-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr80-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #80
- [`ironhorse-ocap-frozen-objects`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-frozen-objects.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr690-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr690-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #690
- [`endojs-endo-but-for-bots-pr508-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr508-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #508
- [`endojs-endo-but-for-bots-pr1306-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1306-conduct.md) — _normal_ · Conduct endojs/endo-but-for-bots#1306 — un-draft + merge (guest provisioning,...
- [`endojs-endo-but-for-bots-pr1305-shepherd-20260919`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-shepherd-20260919.md) — _normal_ · Shepherd endojs/endo-but-for-bots PR #1305 to green (1/3 of the belayed direc...
- [`ironhorse-fuzz-8adaa3bbc9cda1ce-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8adaa3bbc9cda1ce-repair.md) — _normal_ · Repair Ironhorse engine defect 8adaa3bbc9cda1ce (target differential_source) ...
- [`endojs-endo-but-for-bots-pr1282-review-eb0900a1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1282-review-eb0900a1.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1282
- [`ironhorse-fuzz-ed616f6ec22095dc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ed616f6ec22095dc-repair.md) — _normal_ · Repair Ironhorse engine defect ed616f6ec22095dc (target differential_regexp) ...
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`kriscendobot-minion.town-pr103-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr103-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on kriscendobot/minion.town PR #103
- [`endo-claude-agent-sdk-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-design.md) — _normal_ · Design: the Claude Agent SDK as an alternative confinement substrate for @end...
- [`ironhorse-fuzz-3fc02d8b57faa79a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3fc02d8b57faa79a-repair.md) — _normal_ · Repair Ironhorse engine defect 3fc02d8b57faa79a (target differential_source) ...
- [`endojs-endo-but-for-bots-pr933-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr933-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #933
- [`endo-claude-agent-sdk-backend`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-backend.md) — _normal_ · Build: a paid-tier Agent SDK backend behind @endo/claude's existing seams
- [`ironhorse-fuzz-2a2de75b75de4894-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2a2de75b75de4894-repair.md) — _normal_ · Repair Ironhorse engine defect 2a2de75b75de4894 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr938-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr938-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #938
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr62-review-353e723b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr62-review-353e723b-retro.md) — _normal_ · Retrospective on kriscendobot/minion.town PR #62 (primary: kriscendobot-minio...

### awaiting maintainer decision (answer at the linked question)
- [`minion-town-guest-peer-fetch-verify-await-auth`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-guest-peer-fetch-verify-await-auth.md) - [Should the guest run on the already-public pet daemon, or should the guest-substrate daemon get its own public OCapN-CBOR-Noise route?](https://github.com/kriscendobot/garden/issues/58#issuecomment-5447765615)
- [`ironhorse-computron-benchmark-baseline-build-after-approval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-computron-benchmark-baseline-build-after-approval.md) - [Will the maintainer lift the Ironhorse pause, approve design PR #1283 (or direct an early build), and answer its six open questions (or direct the recommended defaults)?](https://github.com/endojs/endo-but-for-bots/pull/1283)

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr1125-3193517b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-3193517b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-a74698d6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-a74698d6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1282-d101dbfb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1282-d101dbfb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1282 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1281-review-b373c832-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1281-review-b373c832-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1281 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1281-b2a4cb13-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1281-b2a4cb13-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1281 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1290-review-fe19b903-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1290-review-fe19b903-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1290 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1281-25caefdb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1281-25caefdb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1281 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-b73e4e34-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-b73e4e34-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`kriscendobot-garden-pr87-review-9fceaeef-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr87-review-9fceaeef-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #87 (primary: kriscendobot-garden-pr8...
- [`endojs-endo-but-for-bots-pr695-23a03130-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr695-23a03130-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #695 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1281-review-ca9db945-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1281-review-ca9db945-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1281 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-b786506c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-b786506c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1226-review-2fc247cc-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1226-review-2fc247cc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1226 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-23cf90c0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-23cf90c0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-af33f29e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-af33f29e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1304-review-96879182-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-review-96879182-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1304 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1304-review-2bc0b64c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-review-2bc0b64c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1304 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1304-review-c8d04bad-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-review-c8d04bad-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1304 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1305-review-254277ce-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-review-254277ce-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1305 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1304-6202f3ed-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-6202f3ed-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1304 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1306-review-2a0fedcf-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1306-review-2a0fedcf-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1306 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1301-review-34598631-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1301-review-34598631-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1301 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1282-review-eb0900a1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1282-review-eb0900a1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1282 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1306-review-3ed76637-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1306-review-3ed76637-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1306 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1301-review-e2671e4d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1301-review-e2671e4d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1301 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1304-0c373555-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1304-0c373555-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1304 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1305-b982dc09-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-b982dc09-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1305 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1305-d4fa4360-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-d4fa4360-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1305 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1305-review-40fd197b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-review-40fd197b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1305 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1305-review-049d4381-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-review-049d4381-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1305 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endo-sturdyref-agent-surface-gauntlet-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-gauntlet-20260901.md) — awaiting `endojs-endo-but-for-bots-pr871-weave-20260901` · Run the gauntlet for endojs/endo-but-for-bots#871 (sturdyref agent surface)
- [`build-minion-town-invitation-onboarding`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-onboarding.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1310` · Build invitation-only guest onboarding for minion.town — STILL BLOCKED (gate ...
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 3 gardeners
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 gardeners
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): 8 gardeners
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): 1 gardeners
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 4 gardeners
