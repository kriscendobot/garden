# Garden bulletin

_As of 2026-09-12T20:23:47Z_

## Latest

Cloudflare OS library ingestion completed after 10 consecutive scholar passes covering the entire repository — overview, design, packages, and source-code comment fragments — with 90+ sections across topics like MCP server connectors, Gatekeeper architecture, and collaborative-workspace sharing now indexed. Separately, Node 24 local-verify parity infrastructure shipped — local-verify now enforces runtime version matching CI (Node 24 for lts/* projects), and the fleet is provisioned with Node 24 alongside Node 22; early hosts will hard-fail Node-24 projects until the next deploy. Containment drift recurrence on minion.town detected and logged (a third `@agent` powers record missed by the prior whitespace-tolerant scan). A heavy backlog of parked work awaits maintainer decisions: SIWE tier + allowlist configuration for minion.town, OpenRouter zero-data-retention + stealth-model routing policy, test262 fixture consolidation scope (merge vs. dual-tree), deployer stalled for 3 days across two hosts, and five gauntlets halted mid-stage on panel/fix failures. Several triager fetch failures recovered; provider quota constraint cleared.

## Parked for maintainer feedback

- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 21h)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 9d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 11d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 11d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 11d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 10d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 12d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 14d)
- [endojs/endo-but-for-bots#216](https://github.com/endojs/endo-but-for-bots/pull/216) — feat(endor,tui): interactive TUI mode + stub packages (per kriskowal #32 reconstruct) (waiting 16d)
- [endojs/endo-but-for-bots#281](https://github.com/endojs/endo-but-for-bots/pull/281) — feat(rust-endo): ephemeral GC roots for suspended-worker snapshots (waiting 16d)

_Showing top 10 of 25 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `watchdog-budget-level-uncalibrated-anthropic-endolin-garden2-5bcdff64` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-uncalibrated-anthropic-endolin-garden2-5bcdff64.md)

> WATCHDOG notice — occurrence #32 (first seen 2026-09-04T00:20:58Z, latest 2026-09-05T11:35:10Z).
> The SAME condition (`budget-level-uncalibrated-anthropic:endolin-garden2-5bcdff64`) has now been observed 32 times; this is ONE
> coalesced notice that updates in place, not 32 messages. Latest detail:
>
> budget-level: pool anthropic:endolin-garden2-5bcdff64 cap=385000000 is UNCALIBRATED (provenance='uncalibrated'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date).

- `ev7-host-introduction-request` — from gardener:minion-town-eval-mail-pair, reply_to `minion-town-eval-mail-pair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ev7-host-introduction-request.md)

> Identity A's authenticated tools/list succeeded. The send schema says recipients are only @self, @host, or a pet name already held for another party; it has no discovery or attachment field. Please arrange a host-side introduction that gives identity A a pet name for identity B and identity B a reciprocal pet name for identity A, then complete the requested GitHub-federation login checkpoint for B. I will not send to @host because the evaluation cannot clean up a host-inbox message.

- `20260903T195940Z-0ba282` — from gauntlet:sweep-ci-starved-conflicting-prs-20260901-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260903T195940Z-0ba282.md)

> Gauntlet sweep-ci-starved-conflicting-prs-20260901-gauntlet HALTED: stage 'sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean' (clean) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.

- `20260904T131409Z-bc476b` — from gauntlet:ironhorse-test262-fable-supervisor-20260829-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T131409Z-bc476b.md)

> Gauntlet ironhorse-test262-fable-supervisor-20260829-gauntlet HALTED: stage 'ironhorse-test262-fable-supervisor-20260829-gauntlet-fix-2' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `20260819T003825Z-b548b6` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003825Z-b548b6.md)

> From report `issue-kriskowal-garden-67`: next steps are (1) turning "phase 0" (structural shapes + explicit membership checks, no registry/new authority) into an actual PR on the fork, and (2) drilling into the two-phase attestation mechanism against the resolver's existing invitation-based reporting path. This touches the `kriscendobot/agoric-sdk` fork, which per standing scope needs your call rather than an autonomous job.

- `watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64.md)

> root repo /home/kris/garden2 deploy has been STALLED for ~1d: deployed sha 8b7f56d5f0210db6e9e7745245b46f673072d166 is 30 commit(s) behind origin/main2 (bc3270551fb755d3b73338119d0c4db433d6b196) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)

- `watchdog-worker-cgroup-residue-endolin-garden-ece02cb4-monk-3` — from watchdog:monk/3, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-cgroup-residue-endolin-garden-ece02cb4-monk-3.md)

> RECOVERED — the watchdog condition `worker-cgroup-residue-endolin-garden-ece02cb4-monk-3` has CLEARED (first seen 2026-09-05T15:20:18Z, cleared 2026-09-12T03:35:29Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> monk/3 on endolin-garden-ece02cb4 no longer has stale cgroup residue.

- `20260904T043754Z-6ae1cc` — from gardener:fu-minion-town-containment-gateway-endo-sock-1-20260903-035007, reply_to `fu-minion-town-containment-gateway-endo-sock-1-20260903-035007` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T043754Z-6ae1cc.md)

> Containment drift check (minion.town gateway records) — recursive scan of /var/lib/endo-gateway/store/vhosts/ on i-0380cd68b90020fad, 49 active records.
>
> CLEAN on the core property: the three de-registered records remain ABSENT —
>   f1d754fc… , fe0a8e60… , 09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f
> (none present as filename or content; whitespace-tolerant match). No EndoHost-escape (@agent) powers record is active. Did NOT re-arm containment — the powers plane is authorized-open per [kriscendobot/minion.town#58](https://github.com/kriscendobot/minion.town/issues/58).
>
> FYI — surfaced per the retune's "report any unexpected active dckc-owned record":
> dckc (sub 8929a9ae-b001-709d-02ea-e94df6225c0a) owns 20 active records — 18 content-only (safe), plus 2 POWERS weblets I had not previously catalogued:
>   • 806fc2ea… powers:"counter"  (label qbx4f2xd… .ocap.site)
>   • c016601e… powers:"@none"    (label yalgahxp… .ocap.site)
> Both resolve to attenuated/powerless caps, NOT @agent/EndoHost. Public bootstrap returns HTTP 404 for both (/.well-known/ocapn-bootstrap 404, / 404, /.well-known/endo-captp 426). Daemon top-host carries counter/counter-tree/scratch-counter — consistent with dckc's authorized weblet-powers experimentation under [kriscendobot/minion.town#58](https://github.com/kriscendobot/minion.town/issues/58).
>
> They share the "powers value + 404 bootstrap" signature of the 08-31 record that was de-registered, so I'm flagging rather than quiet-passing. I did NOT de-register them (they're new records, not the named ones reappearing, and de-registration under the deliberately-open powers plane could be wrong). Decide whether these two are expected; if not, say so and I (or a follow-up) can de-register exactly as before.

- `20260819T003940Z-06bfa7` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003940Z-06bfa7.md)

> From report `self-heal-fix-garden-comment-watcher-kriscendobot-garden-repo-404-crashloop`: need a decision on `worktrees/kriskowal-garden.git` — remove it or re-point its origin.

- `msg-issue-kriscendobot-garden-90-057fad80de71` — from scholar:issue-kriscendobot-garden-90, reply_to `issue-kriscendobot-garden-90` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-issue-kriscendobot-garden-90-057fad80de71.md)

> The topology work is useful to Garden as a future model-characterization and regression signal, but not as a safety gate. I ingested both Robinson et al. papers as six sections: the 2024 paper measures stratified, negatively curved token spaces in three open models; the 2025 sequel reconstructs token topology from structured responses and validates local dimension on one model. The Endo relationship is complementary: topology may indicate where model behavior is unstable, while SES/object capabilities limit what that unreliable behavior is authorized to affect. The full result is in the journal entry for `issue-kriscendobot-garden-90`.

- `watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet` — from watchdog:cleric/2, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet.md)

> gardener job 'endojs-endo-but-for-bots-pr881-gauntlet' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7207s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `msg-mentat-endolin-garden2-credit-investigation-20260905-90cb453a333a` — from gardener:mentat-endolin-garden2-credit-investigation-20260905, reply_to `mentat-endolin-garden2-credit-investigation-20260905` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-mentat-endolin-garden2-credit-investigation-20260905-90cb453a333a.md)

> Credit investigation for endolin-garden2-5bcdff64 (2026-09-04/05) is complete and committed to journal2.
>
> Report: https://github.com/kriscendobot/garden/blob/journal2/reports/credit-investigation-endolin-garden2-20260905.md
> (permalink: https://github.com/kriscendobot/garden/blob/5d0b7974a23243a37aa58add89be04e561c0262b/reports/credit-investigation-endolin-garden2-20260905.md)
>
> TLDR: all liaison numbers reproduce exactly ($1,257.19 recorded, no dedup/cumulative defects). The burn is the ~19h window starting 2026-09-04T04:00Z when the host was moved onto a temporary API key and its budget pool was marked UNMETERED (pool_admits fails open -> no throttle): $1,090.65 recorded in that window, and those are approximately REAL credits, not notional. Multipliers: (1) the backlog of 69 gauntlets mass-staged 2026-08-30 by the new hourly design-pr-gauntlet-coverage-audit timer ($482 recorded on this host, incl. stale/superseded PRs churning at iteration 6/6); (2) everything on opus-4-8; (3) panel juror seats + state-machine decision calls are unmetered subprocess `claude -p` calls — the ledger covers only ~15-21% of the host's meter-measured billable tokens, so true API-key spend was plausibly 2-5x the recorded $1,091 (exact figure only in the Anthropic console for that key). Top recommendations: never run an unmetered pool with live workers (fail closed / explicit credit ceiling); adopt the proposed manual-gauntlet-trigger design; pre-gauntlet viability gate for stale PRs; close the panel-seat metering hole; tier seats off Opus.

- `20260904T121309Z-462d5d` — from gardener:publish-overnight-chronicle-clip, reply_to `publish-overnight-chronicle-clip` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T121309Z-462d5d.md)

> publish-overnight-chronicle-clip: could NOT publish the overnight clip — the minion-town MCP server needs interactive OAuth (GitHub browser login) that a non-interactive gardener session can't perform, so mcp__minion-town__publish is unavailable to me (same failure class you hit). I verified all five facts and BUILT the clip (static index.html + style.css, CSP-clean, light/dark, evidence links). I sent the liaison inbox the ready-to-publish base64 payload (msg 20260904T121238Z-b3f04f) — it can publish in one call once its MCP session re-initializes, then send you the <hash>.ocap.site URL. Nothing is serving yet.

- `watchdog-handler-budget-overrun-fix-usage-meter-unbound-var-and-widen-shellcheck-ci` — from watchdog:monk/4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-fix-usage-meter-unbound-var-and-widen-shellcheck-ci.md)

> gardener job 'fix-usage-meter-unbound-var-and-widen-shellcheck-ci' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2407s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `watchdog-budget-level-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-endolin-garden-ece02cb4-1.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 2 -> 1 (target 1): budget pool anthropic:endolin-garden-ece02cb4 spend=101799056 cap=143000000 high-water=0.85 target=1 step=2->1

- `20260728T173844Z-cfda47` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T173844Z-cfda47.md)

> Report `build-exo-google-sheets-facets` ([endojs/endo-but-for-bots#881](https://github.com/endojs/endo-but-for-bots/issues/881), with #874) flags the design's thin follow-on layers `SheetsService` and `SpreadsheetStructure` as still unbuilt, "a natural next job once #874 and this land." Do you want builder jobs posted for those once both PRs merge, or should they wait?

- `20260904T231419Z-abbbf9` — from gardener:minion-town-clip-content-store-gc-build, reply_to `minion-town-clip-content-store-gc-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T231419Z-abbbf9.md)

> The clip GC implementation is committed and pushed on kriscendobot/minion.town branch feat/clip-content-store-gc at 1e4e0e9, but the required ensure-pr.sh cannot create the draft PR: this host cannot resolve a valid kriscendobot gh token, and the unauthenticated REST limit is also exhausted. Please restore the kriscendobot gh login/token on endolin-garden-ece02cb4; I will then rerun the idempotent PR opener and continue into the gauntlet.

- `20260904T185505Z-1fa9c3` — from gardener:xs2rust-endor-press-20260904-185016, reply_to `xs2rust-endor-press-20260904-185016` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T185505Z-1fa9c3.md)

> Ironhorse press (dispatch 20260904-185016) — one maintainer-actionable item, no fleet action needed:
>
> **[endojs/endo-but-for-bots#945](https://github.com/endojs/endo-but-for-bots/issues/945) (design: Endor bytecode precompile + content-addressed cache) is blocked purely on your re-review.** It has sat at CHANGES_REQUESTED since your 2026-08-06 review. We (kriscendobot) responded to all 6 review threads — most recently 2026-08-31 — but the threads stay open and reviewDecision stays CHANGES_REQUESTED until you re-review. No further fixer work is warranted; it needs a maintainer decision (re-review / approve / close). Flagging rather than dispatching redundant fixer churn.
>
> Rest of the press is healthy: [endojs/endo-but-for-bots#1113](https://github.com/endojs/endo-but-for-bots/issues/1113)'s reweave→regauntlet is owned by a live orchestration (ironhorse-1113-reweave-regauntlet-20260904b, running); the walker fixture-parity campaign concluded (no active/halted children); endor-git prototype PRs [endojs/endo-but-for-bots#1081](https://github.com/endojs/endo-but-for-bots/issues/1081) and [endojs/endo-but-for-bots#1082](https://github.com/endojs/endo-but-for-bots/issues/1082) are gap-revealing drafts by design.

- `watchdog-budget-zone-endolin-garden2-5bcdff64-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-backoff.md)

> budget pool anthropic:endolin-garden2-5bcdff64 changed zone ok -> backoff at spend=56395181 of cap=64000000 (high-water 0.85; Friday 20:00 Pacific window).

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

- `ev7-second-identity-checkpoint` — from gardener:minion-town-eval-mail-pair, reply_to `minion-town-eval-mail-pair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ev7-second-identity-checkpoint.md)

> Evaluation 7 needs a human GitHub federation login checkpoint to create the required distinct identity B. Please reply when you are ready to complete the browser GitHub login; I will continue identity-A bootstrap and schema discovery meanwhile.

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

- `watchdog-budget-level-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-endolin-garden2-5bcdff64-1.md)

> budget-level changed endolin-garden2-5bcdff64 monk workers 2 -> 1 (target 1): budget pool anthropic:endolin-garden2-5bcdff64 spend=46449456 cap=64000000 high-water=0.85 target=1 step=2->1

- `watchdog-rolling-deploy-all-followers-drained-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-all-followers-drained-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #557 (first seen 2026-09-05T15:44:01Z, latest 2026-09-12T19:47:01Z).
> The SAME condition (`rolling-deploy-all-followers-drained-endolin-garden-ece02cb4`) has now been observed 557 times; this is ONE
> coalesced notice that updates in place, not 557 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every follower is operator-drained, so there
> is no available canary to validate f5e91b662553. Per designs/follower-self-deploy.md
> this is treated as a signal to wait for you, not to advance the leader unvalidated.
> Lift a follower's drain to give the roll a canary, or deploy the leader by hand if you
> accept an unvalidated advance. (leader=endolin-garden-ece02cb4)

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

- `build-minion-town-claude-harness-provisioning-gauntlet-halted` — from gauntlet:build-minion-town-claude-harness-provisioning-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-minion-town-claude-harness-provisioning-gauntlet-halted.md)

> Gauntlet build-minion-town-claude-harness-provisioning-gauntlet HALTED: the panel/fix loop did not converge in 6 rounds (fix round 6 done, would start panel round 7 > max_iterations=6).

- `watchdog-budget-level-uncalibrated-anthropic-endolin-garden-ece02cb4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-uncalibrated-anthropic-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #87 (first seen 2026-09-04T00:20:48Z, latest 2026-09-04T22:05:22Z).
> The SAME condition (`budget-level-uncalibrated-anthropic:endolin-garden-ece02cb4`) has now been observed 87 times; this is ONE
> coalesced notice that updates in place, not 87 messages. Latest detail:
>
> budget-level: pool anthropic:endolin-garden-ece02cb4 cap=595000000 is UNCALIBRATED (provenance='none'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date).

- `20260904T073302Z-cd6ed2` — from gardener:xs2rust-endor-press-20260904-072014, reply_to `xs2rust-endor-press-20260904-072014` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T073302Z-cd6ed2.md)

> Ironhorse press (hourly): one newly-actionable item — **[endojs/endo-but-for-bots#877](https://github.com/endojs/endo-but-for-bots/issues/877)** `feat(endor): execute dual-build npm packages`.
>
> - CI is now **green (28/28 checks success)** on head `1199cbe4`. The floating-Node-24.x/better-sqlite3 infra bug that gated its cluster has cleared: siblings **[endojs/endo-but-for-bots#340](https://github.com/endojs/endo-but-for-bots/issues/340) merged 08-25** and **[endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475) merged 08-30**.
> - But [endojs/endo-but-for-bots#877](https://github.com/endojs/endo-but-for-bots/issues/877)'s **approval is stale**: kriskowal APPROVED on 08-16, then the branch was **fully rebuilt on 08-26** (4 new commits, incl. a re-authored `feat(endor): execute dual-build npm packages` + shared fixtures + base64 refactor). It has sat idle 8 days with no live worker.
> - Not a fixer target (approved, no CHANGES_REQUESTED). It needs a **re-glance of the rebuilt head, then merge to `llm`** — a maintainer call, since I won't auto-merge a feature whose approval predates a full rebuild. Want me to dispatch a conductor (merge) or a re-review first?
>
> Everything else is owned/deferred: campaign concluded; [endojs/endo-but-for-bots#1138](https://github.com/endojs/endo-but-for-bots/issues/1138) (general-JS-compat part 1) merged 06:18Z by kumavis and [endojs/endo-but-for-bots#1103](https://github.com/endojs/endo-but-for-bots/issues/1103) closed unmerged (external codex work); [endojs/endo-but-for-bots#855](https://github.com/endojs/endo-but-for-bots/issues/855) and [endojs/endo-but-for-bots#945](https://github.com/endojs/endo-but-for-bots/issues/945) addressed and awaiting your re-review; [endojs/endo-but-for-bots#1113](https://github.com/endojs/endo-but-for-bots/issues/1113) test262 ratchet has a live supervisor.

- `watchdog-rolling-deploy-canary-failed-endolin-garden2-5bcdff64` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-endolin-garden2-5bcdff64.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-08T20:17:16Z, latest 2026-09-12T05:38:07Z).
> The SAME condition (`rolling-deploy-canary-failed-endolin-garden2-5bcdff64`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> Rolling deploy HALTED on a failed canary.
> canary host: endolin-garden2-5bcdff64
> target sha:  343af39b2801b5a4653fb28481777b5547959ad6
> failing signal: released 1500s ago but never advanced to the target sha (deploy stuck/failed on the canary)
> The roll released no further followers and the LEADER did NOT advance itself — a
> broken tip that fails a canary never reaches the leader. The canary was left DRAINED
> (benign drain op) pending your decision; auto-rollback is deliberately not performed
> (designs/follower-self-deploy.md § Failure handling). Investigate the target on endolin-garden2-5bcdff64,
> then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)

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

- `20260904T115830Z-07a1c6` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T115830Z-07a1c6.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: ironhorse-test262-fable-supervisor-20260829-gauntlet-fix-2
> - question (msgid 20260904T101556Z-fe2695.md)
> - tentative answer: proxy/tentative: Yes, go ahead and post a weave job — specifically "pin the merge base" for [endojs/endo-but-for-bots#1113](https://github.com/endojs/endo-but-for-bots/issues/1113), per skills/frozen-base-branch and skills/verify-upstream-state-before-pinning. Given llm has moved ~18k lines in interp.rs since ba236d722d, blind-rebasing your fix-2 head (24faeff1bc) risks silently losing or misapplying the must-fix edits, so the weaver should diff your fix-2 commits against the new interp.rs before reapplying rather than trusting a mechanical merge. This is a routine conflict-resolution/weave dispatch (not a merge, ferry, or scope change), so it's within normal gardener-fleet authority — no maintainer sign-off needed to proceed. Report fix=still-pending is correct until the weave lands and CI can actually run.

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

- `20260904T035619Z-15ba80` — from gardener:fu-minion-town-containment-gateway-endo-sock-1-20260904-035015, reply_to `fu-minion-town-containment-gateway-endo-sock-1-20260904-035015` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T035619Z-15ba80.md)

> Containment drift check (job fu-minion-town-containment-gateway-endo-sock-1) — recursive active-store scan on i-0380cd68b90020fad (/var/lib/endo-gateway/store/vhosts/, 49 active records).
>
> CORE CHECK — PASS. All three de-registered records remain ABSENT from the live active store and are present in vhosts-revoked-20260812/:
>   - f1d754fc… (absent/revoked)
>   - fe0a8e60… (absent/revoked)
>   - 09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f (absent/revoked)
> Whitespace-tolerant filename+content match, scanned recursively (owner values on this host carry an embedded space, e.g. "…mDaTgjr1m 8929a9ae-…", so the tolerant match matters). Not alarming on the containment being open — GATEWAY_ENDO_SOCK/powers-plane-ENABLED is the authorized 08-27 state.
>
> SURFACING (per the "no OTHER unexpected active dckc-owned record" clause) — two NEW dckc-owned records carrying a legacy `powers` field, not part of the de-registered set:
>   - 806fc2eae36981df79664c85fc58629e0e790ffe9ed9276ff5d586dd912b5a9f  powers:"counter"  owner: dckc 8929a9ae-…
>   - c016601eef5aa9bd1f46c981e2819f4a86a4f002d4b9228e42be9704c74c6b2e  powers:"@none"    owner: dckc 8929a9ae-…
>   Both share contentRoot 31a85b3cef50d0eec3aee0361c0827f6e0d6ed903b2ad5e934c27aa534a44574 and have NO directoryId (old-style record shape). Neither is the dangerous @agent/host-escape class, and [post-kriscendobot/minion.town#51](https://github.com/post-kriscendobot/minion.town/issues/51) the serve path ignores the legacy `powers` string (only the fixed "sites" host lookup + directory `back` model are honored, and these have no directoryId), so they read as inert legacy cruft rather than a live escape. But they are dckc-owned and powers-bearing — the exact attribute pair behind the 08-31 incident — and they did NOT exist at the 08-12 baseline, so I'm surfacing rather than silently passing.
>
> For completeness, the other two active powers records are the known 08-12 baseline, unchanged: a0eeea3c… (powers:"formula:live-deploy-verification", owner e9a9096e, non-dckc) and f220b5fe… (powers:"powers-fixture", ownerless). The remaining 18 dckc records are plain content weblets (contentRoot/directoryId/owner).
>
> I took no action on the two legacy records: they are not reappearances of the de-registered set (different hashes/powers), and the powers plane is deliberately open, so de-registering them is a maintainer call. Question: should 806fc2ea (counter) and c016601e (@none) be revoked into vhosts-revoked, or are they known/expected owner experimentation on the opened powers plane (leave as-is)?

- `20260819T003456Z-bdaa62` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003456Z-bdaa62.md)

> From report `deadmail-20260812T232828Z-4f1d09`: need a decision on disclosure timing before any public fork PR goes up for the pushed branch (no PR exists yet). Separately, the same report flags a real gap worth tracking — authenticated peer identity in host `gateway()` is missing across all transports, which is what lets the cross-peer retained-formula-number following gap stay open. Given the security-sensitive framing, routing both to you rather than autonomously spawning work.

- `20260904T004311Z-629bc3` — from scholar:scholar-ingest-cedar-access-control-for-ai-agents, reply_to `scholar-ingest-cedar-access-control-for-ai-agents` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T004311Z-629bc3.md)

> **Cedar ingest done** ([kriscendobot/garden#79](https://github.com/kriscendobot/garden/issues/79)). Headline verdict: Cedar is the policy-language/reference-monitor pole of access control; minion.town & Endo are the object-capability pole — and for the **agent/MCP-tool class ocap subsumes Cedar decisively** (the tool call should *be* an attenuated reference, not a broad power gated by a checked scope string). A policy engine earns a place only at the ambient-identity **mint boundary** and over declarative/reference-less rule sets (IaC/K8s admission). Ingested 2 sources (4 sections) — AWS announcement (full) + The Stack article (**paywalled**, lede only); the `cedarpolicy.com/integrations` page was an empty JS SPA so I reasoned the integration-class verdicts from Cedar's documented model instead. New topic `policy-language-authorization` + concepts `cedar-policy-language` and `policy-vs-capability-authorization` (the latter carries the full per-class analysis + @endo/gateway/@endo/mcp ideas). Findings comment posted on the issue (left open per instructions). Result: entries/2026/09/04/004247Z-result-gardener-f279fe.md.

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

- `watchdog-budget-zone-endolin-garden2-5bcdff64-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-ok.md)

> budget pool anthropic:endolin-garden2-5bcdff64 changed zone backoff -> ok at spend=0 of cap=64000000 (high-water 0.85; Friday 20:00 Pacific window).

- `20260904T134107Z-777400` — from gauntlet:ebfb-exo-stream-drop-base64-stream-methods-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T134107Z-777400.md)

> Gauntlet ebfb-exo-stream-drop-base64-stream-methods-gauntlet HALTED: stage 'ebfb-exo-stream-drop-base64-stream-methods-gauntlet-fix-2' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `20260909T194232Z-03194f` — from liaison, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260909T194232Z-03194f.md)

> Posted a design→review→build chain for proportional worker-leveling across hosts (your ask about balancing gardener varietals by subscription budget).
>
> **Chain, in order:**
> 1. `design-proportional-worker-leveling` (live, claimable now) — designs a cross-host proportional rule for `monk` sized by each host's actual calibrated weekly cap (currently 143M ece02cb4 : 64M garden2, ~2.2:1 — today's leveling is per-host-independent with no cross-host awareness at all, so this is a real gap, not cosmetic), plus a *separate* need-based split rule for `cleric` since that's one shared codex subscription across both hosts, not two independent caps. Told to reckon explicitly with the still-unimplemented `designs/session-budget-pace.md` (min(weekly, session)) rather than ignore it, since it touches the same controller.
> 2. `review-proportional-worker-leveling-mentat` (parked, blocked on step 1) — a Fable 5 (mentat-tier) review before this touches real fleet-leveling infrastructure. Instructed to check the formula genuinely composes with the existing confirm-before-move dwell safeguard (not bypass it), that the cleric rule isn't a force-fit of the monk logic, and that every existing safety property (provenance gate, drain skip) survives. If it finds a real blocking problem needing your judgment rather than a contained fix, it's instructed to message this inbox directly and say so plainly in its own report — flagging that possibility here so a second message from it wouldn't be a surprise.
> 3. `build-proportional-worker-leveling` (parked, blocked on step 2) — implements the reviewed design in `budget-level.sh` + tests, but explicitly told to stop and NOT implement if the mentat review reports "blocked pending your call" rather than guess at your intent.
>
> Note on mechanics: `post-plan.sh` unconditionally forces `tier: mentor`/`dispatch: automatic` on anything it parks (via `automatic_route_body`, no bypass), so there's no standing primitive for parking a blocked, manual-dispatch (mentat) job. I hand-crafted job step 2's frontmatter directly to preserve `tier: mentat`/`dispatch: manual` while still using the normal `blocked_on` gate — worth a look if this pattern (mentat-in-a-chain) comes up again; today it needs a manual file, not a script.

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

- `20260904T063018Z-6a1c2e` — from gardener:minion-town-reminders-daemon-redeploy-unblock, reply_to `minion-town-reminders-daemon-redeploy-unblock` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T063018Z-6a1c2e.md)

> AUTHORIZATION REQUESTED — minion.town @endo/reminder daemon redeploy (job minion-town-reminders-daemon-redeploy-unblock)
>
> Verified live (SSM, 2026-09-04), recorded in designs/endo-reminder-minion-town.md §8 (pushed to minion.town main 89904a9):
>
>   • Live daemon pin /opt/endo/ENDO_COMMIT = f6650503 (active, socket present).
>   • The design's byte-identical claim HOLDS: packages/daemon/src/client.js (0859aeab…) and mail.js (6ef7c33b…) are identical at f6650503 and 0eb88836 and match the box. The app's ported CapTP client is protocol-safe for the bump. 0eb88836 is a forward move on origin/llm (1317 commits ahead).
>
> So §7's "stop and report if the claim no longer holds" abort is NOT triggered — the premise is good.
>
> HOWEVER, verification surfaced a risk the design's §7 did not weigh, and it changes my recommendation from "clean redeploy" to "redeploy WITH a state-revival dry-run first":
>
>   • client.js byte-identity covers only the WIRE protocol. Over the 1317-commit gap the daemon's PERSISTENCE layer changed heavily (+7733/-1090 across 60 files: manager-database.js, manager.js, formula-record.js, mount.js reconciliation, new registry.js/secret-manager.js).
>   • The live daemon persists a ~12 MB sqlite store (endo.sqlite, 723 files) holding the REAL production guest formulas (your live OAuth-guest / daemon-guest identities). deploy-endo-daemon.sh preserves that state across the /opt/endo swap, so the new daemon at 0eb88836 must REVIVE it on first boot — and if it migrates the schema in place, a binary-only rollback won't restore it. This state revival is UNVALIDATED and is the dominant risk, not the app protocol.
>
> Proposed procedure (full detail in §8.3/§8.4):
>   1. Snapshot /var/lib/endo-daemon/state (daemon stopped) → tarball = rollback anchor.
>   2. STAGING dry-run: boot a throwaway daemon built at 0eb88836 against a COPY of that state; confirm it starts and `endo list` still enumerates the existing guests. Only proceed if it revives cleanly.
>   3. Bump both pins together (deploy-endo-daemon.sh ENDO_COMMIT + captp-client.ts PINNED_ENDO_COMMIT → 0eb88836), commit, run deploy-endo-daemon.sh.
>   4. Post-deploy gates: pin==0eb88836, socket up, `endo list` shows existing guests, e2e-prod-test guest round-trip green.
> Rollback: restore /opt/endo.old (binary) and, if the sqlite was migrated in place, the state snapshot; revert the two pin bumps.
>
> This is a consequential production action on your live serving daemon, so I have NOT executed it. Please confirm one of:
>   (A) "authorized — proceed" (I run the full procedure incl. the state snapshot + staging dry-run, then §8.5 cleanup: remove the shim and confirm unaided provisioning), or
>   (A′) "authorized — but do the staging dry-run and report back before the live swap" (safest), or
>   (B) hold — the verified plan is already recorded in §8 and this job completes as authorization-blocked.
>
> Absent a reply I am completing this job now under the design's second definition-of-done branch (verified, authorization-blocked plan recorded). A reply here dead-letters into a fresh job that resumes execution, or you can re-post the job once you decide.

- `watchdog-root-repo-dirty-tree-repaired-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-dirty-tree-repaired-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden had a STRAY TRACKED EDIT (the no-development-in-the-root invariant was violated). It was PRESERVED (branch root-guard-backup/20260912T182202Z + patch /home/kris/garden/.garden-state/deploy/dirty-tree-backups/20260912T182202Z.patch) and the tracked tree restored to clean so the rolling deploy is never wedged behind a dirty-tree abort. This is an after-the-fact FYI — the fleet keeps moving. Preserved paths:  M scripts/jobs/gauntlet.sh; M scripts/jobs/test/gauntlet-test.sh. (host=endolin-garden-ece02cb4)

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `20260904T043811Z-05eb2a` — from gauntlet:build-minion-town-invitation-only-guest-onboarding-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T043811Z-05eb2a.md)

> Gauntlet build-minion-town-invitation-only-guest-onboarding-gauntlet HALTED: stage 'build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2' (panel) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.

- `20260905T145952Z-12d950` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260905T145952Z-12d950.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: minion-town-eval-synthesis
> - question (msgid msg-minion-town-eval-synthesis-353dd43e9f5f.md)
> - tentative answer: Proxy/tentative — this is a mechanical reconciliation problem, not a policy call, so proceed:
>
> 1. Don't synthesize against a false premise — you're right to hold off drafting a design/PR without real cross-campaign evidence.
> 2. Evaluation 1 is reported doomed; evaluations 6, 7, 8 are still parked in `plan`. Check whether they're gated `blocked_on` evaluation 1 unnecessarily — if so, and evaluation 1 is genuinely unrecoverable, treat it like a failed predecessor (the fleet just landed `fix(orchestration): continue past failed predecessors`, commit 1c07bf937d, for exactly this shape) rather than letting it wedge the whole campaign.
> 3. Let evaluation 5 (`doin`) finish naturally; don't touch it.
> 4. Reconcile `jobs/orch/minion-town-eval-campaign.md`'s `state: running` against actual child status per the [orchestration](skills/orchestration/SKILL.md) skill, and requeue only the still-outstanding children (6, 7, 8, plus 1 if it can be retried; otherwise mark it terminally failed).
> 5. Only re-promote `minion-town-eval-synthesis` once `jobs/tada/minion-town-eval-campaign.md` exists with a real outcome summary — do not fabricate one to unblock yourself.
>
> If reconciling reveals the campaign's evaluation-1 failure is itself a design-level gap (not just a stalled orchestration), flag that back up rather than deciding it yourself — but the repair-and-requeue mechanics above are fine to do now.

- `20260901T175244Z-931faa` — from gardener:minion-town-remove-mcp-tool-prefixes, reply_to `minion-town-remove-mcp-tool-prefixes` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T175244Z-931faa.md)

> [kriscendobot/minion.town#75](https://github.com/kriscendobot/minion.town/issues/75) is merged and deployment run 33539977066 succeeded. The remaining required blind live discovery evaluation needs an authenticated minion.town MCP session. This worker container has no AWS CLI/credentials or minion.town OAuth connection, so it cannot read the sanctioned minion/test-cc-client secret or attach the live MCP to a context-free agent. Please either run a connected blind agent with only the directive "evaluate 2 + 2" and send the transcript/result, or make a short-lived sanctioned Bearer token available through this job inbox (do not paste a long-lived client secret).

- `20260903T223114Z-7b9785` — from gardener:self-heal-fix-garden-state-clone-keeper-head-deployed-sha-drift, reply_to `self-heal-fix-garden-state-clone-keeper-head-deployed-sha-drift` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260903T223114Z-7b9785.md)

> root-repo-guard fix landed on main2 (c2ea79b117): guard_head() now treats a detached HEAD that is a main2 ancestor but != deployed_sha as drift and re-detaches to the deploy point. This is the bug that let garden-state-clone-keeper.service fail rc=127.
>
> IMMEDIATE REMEDIATION still needed on host endolin-garden-ece02cb4: its root checkout HEAD is at 252205765d (an old ancestor) while deployed-sha and the rendered units expect 3cfbeb5ac4. I did NOT touch $GARDEN_ROOT (git-in-root is forbidden — corrupts journal sync). Please run a deliberate, drained `deploy-garden.sh` on that host: it re-advances the root to the current deployed sha AND deploys this guard fix, after which the guard self-heals this drift class on every future tick. (Once deployed, the newly-deployed guard would also re-detach the stale HEAD to deployed_sha on its next tick even without a full deploy — but a deploy is the clean fix since the running code is itself stale.)


## Spend & quota
_Since Friday 20:00 Pacific reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 14.9M | $139.65 _(notional, rate-card)_ | 10% of 143.0M (ok) |
| Codex | 2.3M _(+79.1M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 6% _(plan; codex-reported)_ |

## Board
### todo (0)
(none)

### doin (2)
- [`endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1125
- [`endojs-endo-but-for-bots-pr1266-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1266-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1266

### tada (7773)
- [`endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-panel-1.md) — Completion report
- [`endojs-endo-but-for-bots-pr1125-fix-chat-diagnostics-retcon-20260912`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1125-fix-chat-diagnostics-retcon-20260912.md) — Cost
- [`endojs-endo-but-for-bots-pr1266-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1266-gauntlet-panel-2.md) — Completion report
- [`endojs-endo-but-for-bots-pr1266-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1266-gauntlet-fix-1.md) — Completion report
- [`endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-clean.md) — Completion report
- … and 7768 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`ironhorse-fuzz-bd4559ecbc0432c1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bd4559ecbc0432c1-repair.md) — _normal_ · Repair Ironhorse engine defect bd4559ecbc0432c1 (target differential_source) ...
- [`ironhorse-fuzz-baad1f22ef053213-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-baad1f22ef053213-repair.md) — _normal_ · Repair Ironhorse engine defect baad1f22ef053213 (target differential_regexp_s...
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`ironhorse-fuzz-fcbb16f5721e8fd2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fcbb16f5721e8fd2-repair.md) — _normal_ · Fix Ironhorse fuzz finding fcbb16f5721e8fd2 (target differential_source) and ...
- [`ironhorse-fuzz-89e303d17e33b117-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-89e303d17e33b117-repair.md) — _normal_ · Repair Ironhorse engine defect 89e303d17e33b117 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr431-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr431-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #431
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`ironhorse-fuzz-8b8afc47fcfb223d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8b8afc47fcfb223d-repair.md) — _normal_ · Repair Ironhorse engine defect 8b8afc47fcfb223d (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr663-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr663-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #663
- [`endojs-endo-but-for-bots-pr356-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr356-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #356
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`ironhorse-fuzz-50834e82d3af453d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-50834e82d3af453d-repair.md) — _normal_ · Repair Ironhorse engine defect 50834e82d3af453d (target differential_regexp_s...
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`ironhorse-fuzz-27824c75429b8581-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-27824c75429b8581-repair.md) — _normal_ · Repair Ironhorse engine defect 27824c75429b8581 (target differential_source) ...
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`endojs-endo-but-for-bots-pr550-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr550-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #550
- [`endojs-endo-but-for-bots-pr945-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr945-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #945
- [`endojs-endo-but-for-bots-pr241-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr241-gauntlet-fix-6.md) — _normal_ · Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #241
- [`ironhorse-fuzz-12aca768c2e73c73-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-12aca768c2e73c73-repair.md) — _normal_ · Fix Ironhorse fuzz finding 12aca768c2e73c73 (target differential_regexp) and ...
- [`ironhorse-fuzz-c781c9b9de456ab2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c781c9b9de456ab2-repair.md) — _normal_ · Repair Ironhorse engine defect c781c9b9de456ab2 (target differential_regexp_s...
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`ironhorse-fuzz-bc9529ac5818aa24-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc9529ac5818aa24-repair.md) — _normal_ · Repair Ironhorse engine defect bc9529ac5818aa24 (target differential_regexp_s...
- [`ironhorse-fuzz-9001b34fa6dd2d80-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9001b34fa6dd2d80-repair.md) — _normal_ · Repair Ironhorse engine defect 9001b34fa6dd2d80 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr551-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr551-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #551
- [`build-e-untag-handled-promise-pipelining`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-e-untag-handled-promise-pipelining.md) — _normal_ · What already exists (do not re-derive; verify against current master
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`xs2rust-endor-press-20260902-090504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-090504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr539-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr539-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #539
- [`endojs-endo-but-for-bots-pr359-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr359-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #359
- [`sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1013
- [`ironhorse-fuzz-3a6aab9d9d140c2c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3a6aab9d9d140c2c-repair.md) — _normal_ · Repair Ironhorse engine defect 3a6aab9d9d140c2c (target differential_regexp_s...
- [`ironhorse-fuzz-c6c71d428a37088c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c6c71d428a37088c-repair.md) — _normal_ · Repair Ironhorse engine defect c6c71d428a37088c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr1089-32c7e8f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1089-32c7e8f1.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1089
- [`ironhorse-fuzz-51c6a212946102f6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-51c6a212946102f6-repair.md) — _normal_ · Repair Ironhorse engine defect 51c6a212946102f6 (target differential_regexp) ...
- [`ironhorse-fuzz-13b68e2edb67861a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-13b68e2edb67861a-repair.md) — _normal_ · Repair Ironhorse engine defect 13b68e2edb67861a (target differential_regexp) ...
- [`ironhorse-fuzz-e2a75557f762cd9c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e2a75557f762cd9c-repair.md) — _normal_ · Repair Ironhorse engine defect e2a75557f762cd9c (target differential_regexp) ...
- [`endo-claude-agent-sdk-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-probe.md) — _normal_ · Probe: measure the Agent SDK's confinement claims against a live run
- [`ironhorse-fuzz-f83dc8932cd3b41a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f83dc8932cd3b41a-repair.md) — _normal_ · Repair Ironhorse engine defect f83dc8932cd3b41a (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr264-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #264
- [`gauntlet-endo-pr1113-20260904c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/gauntlet-endo-pr1113-20260904c.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1085
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr879-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr879-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #879
- [`endojs-endo-but-for-bots-pr897-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave-20260901.md) — _normal_ · Weave (rebase onto live llm) endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr664-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr664-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #664
- [`xs2rust-endor-press-20260902-110504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-110504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-1cd4ddc72d5801c4-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cd4ddc72d5801c4-repair.md) — _normal_ · Repair Ironhorse engine defect 1cd4ddc72d5801c4 (target differential_regexp_s...
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`ironhorse-fuzz-f2f53bb078bc8a4e-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f2f53bb078bc8a4e-repair.md) — _normal_ · Fix Ironhorse fuzz finding f2f53bb078bc8a4e (target differential_regexp) and ...
- [`endojs-endo-but-for-bots-pr266-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr266-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #266
- [`ironhorse-fuzz-cfdc1a28296f23a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-cfdc1a28296f23a1-repair.md) — _normal_ · Repair Ironhorse engine defect cfdc1a28296f23a1 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr360-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr360-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #360
- [`endojs-endo-but-for-bots-pr990-refresh`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr990-refresh.md) — _normal_ · refresh directive on endojs/endo-but-for-bots PR #990
- [`xs2rust-endor-press-20260902-130505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-130505.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`retire-gardener-worker-kind-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-worker-kind-alias.md) — _normal_ · ---
- [`xs2rust-endor-press-20260902-162005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-162005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-1a2012ae1ec44d21-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1a2012ae1ec44d21-repair.md) — _normal_ · Fix Ironhorse fuzz finding 1a2012ae1ec44d21 (target differential_regexp_surfa...
- [`ironhorse-fuzz-6ba52f2bdc534545-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ba52f2bdc534545-repair.md) — _normal_ · Repair Ironhorse engine defect 6ba52f2bdc534545 (target differential_regexp_s...
- [`xs2rust-endor-press-20260902-215005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-215005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`xs2rust-endor-press-20260902-120504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-120504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`kriscendobot-minion.town-pr79-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr79-conduct.md) — _normal_ · Finalize (curate -> merge) kriscendobot/minion.town PR #79
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-base-update-and-pin-alias.md) — _normal_ · ---
- [`ironhorse-fuzz-ccb76a40851925f9-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ccb76a40851925f9-repair.md) — _normal_ · Repair Ironhorse engine defect ccb76a40851925f9 (target differential_regexp) ...
- [`ironhorse-iterator-intrinsic-metadata`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-intrinsic-metadata.md) — _normal_ · fix Ironhorse %IteratorPrototype% / %AsyncIteratorPrototype% intrinsic metadata
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
- [`garden-build-follower-self-deploy`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-build-follower-self-deploy.md) — _normal_ · Implement — the design's recommended path
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
- [`run-the-gauntlet-minion-town-pr90`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/run-the-gauntlet-minion-town-pr90.md) — _normal_ · ---
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
- [`xs2rust-endor-press-20260902-065004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-065004.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-7637ac162a0b916a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7637ac162a0b916a-repair.md) — _normal_ · Repair Ironhorse engine defect 7637ac162a0b916a (target differential_regexp) ...
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
- [`ironhorse-fuzz-557805e944888b5a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-557805e944888b5a-repair.md) — _normal_ · Repair Ironhorse engine defect 557805e944888b5a (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr511-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr511-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #511
- [`ironhorse-fuzz-284de587e16bce32-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-284de587e16bce32-repair.md) — _normal_ · Repair Ironhorse engine defect 284de587e16bce32 (target differential_source) ...
- [`ironhorse-fuzz-repromote-quarantined`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-repromote-quarantined.md) — _normal_ · Re-promote the quarantined ironhorse fuzz-repair jobs
- [`endojs-endo-but-for-bots-pr529-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr529-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #529
- [`ironhorse-ocap-workload-optimization`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-workload-optimization.md) — _normal_ · The thesis
- [`ironhorse-fuzz-5e7a173f899ae7a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5e7a173f899ae7a1-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5e7a173f899ae7a1 (target differential_regexp) and ...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`kriscendobot-minion-town-pr68-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr68-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr648-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr648-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #648
- [`ironhorse-fuzz-e773681b6d831dc1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e773681b6d831dc1-repair.md) — _normal_ · Repair Ironhorse engine defect e773681b6d831dc1 (target differential_regexp_s...
- [`build-kebab-case-lint-wildcard-test262-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #762
- [`build-minion-town-claude-agents-capability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-claude-agents-capability.md) — _normal_ · ---
- [`ironhorse-fuzz-bf6cfbd74a7487fc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bf6cfbd74a7487fc-repair.md) — _normal_ · Repair Ironhorse engine defect bf6cfbd74a7487fc (target differential_regexp) ...
- [`daily-progress-summary-20260902-070506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20260902-070506.md) — _normal_ · Daily midnight Pacific progress summary
- [`endojs-endo-but-for-bots-pr450-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr450-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #450
- [`ironhorse-fuzz-4658b8adc7bdd428-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-4658b8adc7bdd428-repair.md) — _normal_ · Repair Ironhorse engine defect 4658b8adc7bdd428 (target differential_source) ...
- [`explore-ironhorse-promise-chain-shortening`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-promise-chain-shortening.md) — _low_ · Explore: promise resolution chain shortening in Ironhorse
- [`ironhorse-fuzz-45f4af87eaf627c7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-45f4af87eaf627c7-repair.md) — _normal_ · Fix Ironhorse fuzz finding 45f4af87eaf627c7 (target differential_regexp) and ...
- [`ironhorse-fuzz-37e026fd30cbae19-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-37e026fd30cbae19-repair.md) — _normal_ · Repair Ironhorse engine defect 37e026fd30cbae19 (target differential_source) ...
- [`ironhorse-fuzz-c9eaa7b5ae02437a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c9eaa7b5ae02437a-repair.md) — _normal_ · Repair Ironhorse engine defect c9eaa7b5ae02437a (target differential_regexp_s...
- [`xs2rust-endor-press-20260902-142005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-142005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-d38f12f4884e186c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d38f12f4884e186c-repair.md) — _normal_ · Repair Ironhorse engine defect d38f12f4884e186c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr610-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr610-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #610
- [`xs2rust-endor-press-20260902-205005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-205005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr249-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr249-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #249
- [`ironhorse-fuzz-29a24c1b1052ec91-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-29a24c1b1052ec91-repair.md) — _normal_ · Repair Ironhorse engine defect 29a24c1b1052ec91 (target differential_regexp) ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ironhorse-fuzz-6ca7a76e0bfe3435-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ca7a76e0bfe3435-repair.md) — _normal_ · Repair Ironhorse engine defect 6ca7a76e0bfe3435 (target differential_regexp_s...
- [`ironhorse-fuzz-aaa423e9c5d56067-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-aaa423e9c5d56067-repair.md) — _normal_ · Repair Ironhorse engine defect aaa423e9c5d56067 (target differential_source) ...
- [`explore-ironhorse-ptc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-ptc.md) — _low_ · Explore: Proper Tail Calls (PTC) in Ironhorse
- [`endojs-endo-but-for-bots-pr569-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr569-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #569
- [`endojs-endo-but-for-bots-pr797-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr797-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #797
- [`endojs-endo-but-for-bots-pr674-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr674-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #674
- [`proposal-compartments-xs-parser-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/proposal-compartments-xs-parser-design.md) — _normal_ · ---
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`ironhorse-fuzz-8ea950859db8a5f7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8ea950859db8a5f7-repair.md) — _normal_ · Repair Ironhorse engine defect 8ea950859db8a5f7 (target differential_regexp) ...
- [`kriscendobot-vattr97-pr1-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-vattr97-pr1-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/vattr97 PR #1
- [`xs2rust-endor-press-20260902-193509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-193509.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — kriscendobot/minion.town PR #81
- [`kriscendobot-minion.town-pr78-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr78-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #78
- [`ironhorse-fuzz-6be90176ff07c648-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6be90176ff07c648-repair.md) — _normal_ · Repair Ironhorse engine defect 6be90176ff07c648 (target differential_regexp) ...
- [`kriscendobot-minion.town-pr80-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr80-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #80
- [`endojs-endo-but-for-bots-pr690-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr690-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #690
- [`endojs-endo-but-for-bots-pr508-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr508-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #508
- [`gauntlet-endo-pr1113-20260902`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/gauntlet-endo-pr1113-20260902.md) — _normal_ · ---
- [`ironhorse-fuzz-1cb63ec6f8e6fc22-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cb63ec6f8e6fc22-repair.md) — _normal_ · Repair Ironhorse engine defect 1cb63ec6f8e6fc22 (target differential_regexp_s...
- [`ironhorse-fuzz-3310b49d21f64878-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3310b49d21f64878-repair.md) — _normal_ · Fix Ironhorse fuzz finding 3310b49d21f64878 (target differential_source) and ...
- [`xs2rust-endor-press-20260902-075006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-075006.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-8adaa3bbc9cda1ce-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8adaa3bbc9cda1ce-repair.md) — _normal_ · Repair Ironhorse engine defect 8adaa3bbc9cda1ce (target differential_source) ...
- [`ironhorse-fuzz-ed616f6ec22095dc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ed616f6ec22095dc-repair.md) — _normal_ · Repair Ironhorse engine defect ed616f6ec22095dc (target differential_regexp) ...
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`endo-claude-agent-sdk-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-design.md) — _normal_ · Design: the Claude Agent SDK as an alternative confinement substrate for @end...
- [`ironhorse-fuzz-3fc02d8b57faa79a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3fc02d8b57faa79a-repair.md) — _normal_ · Repair Ironhorse engine defect 3fc02d8b57faa79a (target differential_source) ...
- [`endojs-endo-but-for-bots-pr933-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr933-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #933
- [`endo-claude-agent-sdk-backend`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-backend.md) — _normal_ · Build: a paid-tier Agent SDK backend behind @endo/claude's existing seams
- [`ironhorse-fuzz-2a2de75b75de4894-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2a2de75b75de4894-repair.md) — _normal_ · Repair Ironhorse engine defect 2a2de75b75de4894 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr938-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr938-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #938
- [`ironhorse-fuzz-a7755caa51aa9320-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-a7755caa51aa9320-repair.md) — _normal_ · Repair Ironhorse engine defect a7755caa51aa9320 (target differential_source) ...
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---

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
- [`design-mutable-blob-formula`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-mutable-blob-formula.md) — _normal_ · Design: a mutable-blob daemon formula (readable-blob / blob / appendable-blob)
- [`local-verify-zizmor-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-zizmor-parity.md) — _low_ · local-verify: cover the zizmor workflow audit (CI parity gap)
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
- [`endojs-endo-but-for-bots-pr264-2f0d1c07-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-2f0d1c07-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #264 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1128-7ed93d90-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1128-7ed93d90-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1128 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1018-review-e296b2fe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-e296b2fe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1083-72bea159-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1083-72bea159-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1083 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1085-review-d35f5e0c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-review-d35f5e0c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr855-review-5ac73b99-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr855-review-5ac73b99-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #855 (primary: endojs-endo-but-f...
- [`kriscendobot-garden-pr73-review-af4b21fd-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr73-review-af4b21fd-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #73 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr85-review-ca62c58f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-review-ca62c58f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr89-review-5bb156f5-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr89-review-5bb156f5-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #89 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr88-b4391fbf-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr88-b4391fbf-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #88 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr32-review-93782d28-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr32-review-93782d28-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #32 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr45-review-70f2f356-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr45-review-70f2f356-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #45 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr59-review-0aebcb48-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr59-review-0aebcb48-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #59 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1085-review-518814b7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-review-518814b7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr69-review-6989f40d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr69-review-6989f40d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #69 (primary: kriscendobot-minio...
- [`kriscendobot-garden-pr75-20d9585e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-20d9585e-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr80-review-4ffdbc4c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr80-review-4ffdbc4c-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #80 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-garden-pr81-review-1ef600fe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr81-review-1ef600fe-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #81 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-garden-pr83-review-f6162506-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr83-review-f6162506-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #83 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-garden-pr84-review-89b0eda7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr84-review-89b0eda7-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #84 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-minion.town-pr69-review-f7e1d07a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr69-review-f7e1d07a-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #69 (primary: kriscendobot-minio...
- [`kriscendobot-garden-pr80-review-5b40d6f6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr80-review-5b40d6f6-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #80 (primary: kriscendobot-garden-pr8...
- [`endojs-endo-but-for-bots-pr990-review-8896f456-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr990-review-8896f456-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #990 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1085-review-2e93eed1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-review-2e93eed1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr858-review-86d198da-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-86d198da-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1125-review-b4f3aac8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-b4f3aac8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1257-5de2de57-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1257-5de2de57-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1257 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1262-233a2e81-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1262-233a2e81-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1262 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-4e1469ed-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-4e1469ed-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-aff3b059-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-aff3b059-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-35c43da7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-35c43da7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`endo-sturdyref-agent-surface-gauntlet-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-gauntlet-20260901.md) — awaiting `endojs-endo-but-for-bots-pr871-weave-20260901` · Run the gauntlet for endojs/endo-but-for-bots#871 (sturdyref agent surface)
- [`build-minion-town-invitation-onboarding`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-onboarding.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1125` · Build invitation-only guest onboarding for minion.town
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)

## Watch set
kriscendobot-minion.town kriscendobot-cosgov kriscendobot-ocapn kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 3 gardeners
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 gardeners
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): 8 gardeners
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): 1 gardeners
