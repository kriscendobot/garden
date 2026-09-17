# Garden bulletin

_As of 2026-09-17T07:15:10Z_

## Latest

The foreman promoted ~60 ironhorse fuzz repairs to the queue with ~15 in progress. Two quarantined repairs need provider-policy re-scoping. Gauntlet triage cleared five September halts; [endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/pull/1100) confirmed base-drift requiring a weave/pin-merge-base. Garden infrastructure landed: awaiting-maintainer gate, sysop exec-op design (surfacing boatman isolation gaps), and thesaurus jury seat for Botese (cliché-phrase detection). The maintainer inbox holds multiple unresolved blockers on guest peer-fetch, SIWE tier selection, DNSSEC, clip publishing, and others.

## Parked for maintainer feedback

- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 4h)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 4h)
- [endojs/endo#3367](https://github.com/endojs/endo/pull/3367) — fix(immutable-arraybuffer): Avoid introducing unrelated properties (waiting 7h)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 5d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 13d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 15d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 15d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 15d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 15d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 16d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `doomed-ironhorse-fuzz-e773681b6d831dc1-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-e773681b6d831dc1-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-e773681b6d831dc1-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-e773681b6d831dc1-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:48:10Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect e773681b6d831dc1 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `e920afdac5ce7e95c1bc7584407e45fa0cff40756ed0c6493716bc07a31b495f` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/e773681b6d831dc1/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/e773681b6d831dc1.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `e920afdac5ce7e95c1bc7584407e45fa0cff40756ed0c6493716bc07a31b495f`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding e773681b6d831dc1).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `ev7-host-introduction-request` — from gardener:minion-town-eval-mail-pair, reply_to `minion-town-eval-mail-pair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ev7-host-introduction-request.md)

> Identity A's authenticated tools/list succeeded. The send schema says recipients are only @self, @host, or a pet name already held for another party; it has no discovery or attachment field. Please arrange a host-side introduction that gives identity A a pet name for identity B and identity B a reciprocal pet name for identity A, then complete the requested GitHub-federation login checkpoint for B. I will not send to @host because the evaluation cannot clean up a host-inbox message.

- `doomed-ironhorse-fuzz-bc3d0df623811a38-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-bc3d0df623811a38-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-bc3d0df623811a38-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-bc3d0df623811a38-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-17T01:18:25Z cleared=none -->
>
> # Repair Ironhorse engine defect bc3d0df623811a38 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `b2e8860df966da8a789c6b2e30db50f2de60bf11e03b6c0494925d3a1148c1e5` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/bc3d0df623811a38/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/bc3d0df623811a38.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `b2e8860df966da8a789c6b2e30db50f2de60bf11e03b6c0494925d3a1148c1e5`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding bc3d0df623811a38).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-37e026fd30cbae19-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-37e026fd30cbae19-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-37e026fd30cbae19-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-37e026fd30cbae19-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:41:39Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 37e026fd30cbae19 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `647d3c14b217f8fce6e2db6fc2ebd5f861669cbf3a48ca77a498505e7be15d36` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/37e026fd30cbae19/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/37e026fd30cbae19.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `647d3c14b217f8fce6e2db6fc2ebd5f861669cbf3a48ca77a498505e7be15d36`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 37e026fd30cbae19).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-09T20:50:15Z, latest 2026-09-17T01:35:17Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-2`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 3 -> 2 (target 2): shared cleric demand active=3 queue=20 fleet-envelope=5 target=2

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

- `doomed-ironhorse-fuzz-3fc02d8b57faa79a-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-3fc02d8b57faa79a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-3fc02d8b57faa79a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-3fc02d8b57faa79a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:41:50Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 3fc02d8b57faa79a (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `b79d35f1bef51f37955b7b7b82e9cc54bc54739c5fc7faac9403dd96e9f95d55` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/3fc02d8b57faa79a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/3fc02d8b57faa79a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `b79d35f1bef51f37955b7b7b82e9cc54bc54739c5fc7faac9403dd96e9f95d55`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 3fc02d8b57faa79a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `msg-ironhorse-fuzz-daf6694aec7856aa-repair-8f61d5e7263e` — from gardener:ironhorse-fuzz-daf6694aec7856aa-repair, reply_to `ironhorse-fuzz-daf6694aec7856aa-repair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-fuzz-daf6694aec7856aa-repair-8f61d5e7263e.md)

> ironhorse-fuzz finding daf6694aec7856aa (target differential_source): decimal-spelling divergence, NOT a port bug — no fix needed.
>
> The 3-byte input `1b 1b 74` folds into `(226492416 * 226492416)` = 51298814505517056 (729·2^46, > 2^53). XS's fx_dtoa prints the exact 17-digit integer; ironhorse prints the shortest round-tripping 51298814505517060 (spec-correct, matches V8/Node). This is the byte-identical program of already-locked finding 67a52af412f03a7b, reached from different fuzzer bytes. The results_agree(f64) suppression is already on the standing branch; the fuzz target exits 0 there.
>
> Landed on ironhorse-fuzz-findings / [endojs/endo-but-for-bots#1298](https://github.com/endojs/endo-but-for-bots/issues/1298): a CI-visible submodule-free ironhorse-vm regression test replaying the exact bytes + a fuzz _agrees lock + a disposition comment. New ironhorse-vm test verified passing locally under nightly-2026-08-15.
>
> Two FYIs:
> - Pre-existing UNRELATED failure on this host: ironhorse-vm math_determinism test acosh of DBL_MAX diverges (finite ~710.5 vs +Inf bits) — a host-libm platform-math issue, not touched by this finding.
> - Note the 2026-09-09 all-IronHorse pause ([kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91)) is nominally in effect, yet this -repair job was dispatched (promoted from plan, gate=go-ahead). I completed only the regression lock + PR comment (no gauntlet), matching prior peer handling of these already-fixed dtoa-spelling duplicates.

- `doomed-ironhorse-fuzz-6ba52f2bdc534545-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-6ba52f2bdc534545-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-6ba52f2bdc534545-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-6ba52f2bdc534545-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:42:48Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 6ba52f2bdc534545 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `bac79026fdb2ec1e1f65bd20757c6ac470891bc63821af6f9f0b4c56716c7fc1` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/6ba52f2bdc534545/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/6ba52f2bdc534545.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `bac79026fdb2ec1e1f65bd20757c6ac470891bc63821af6f9f0b4c56716c7fc1`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 6ba52f2bdc534545).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `msg-ironhorse-fuzz-8b8afc47fcfb223d-repair-348739f5c075` — from gardener:ironhorse-fuzz-8b8afc47fcfb223d-repair, reply_to `ironhorse-fuzz-8b8afc47fcfb223d-repair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-fuzz-8b8afc47fcfb223d-repair-348739f5c075.md)

> ironhorse-fuzz finding 8b8afc47fcfb223d (differential_regexp) — resolved as an already-fixed oracle artifact, plus a standing-PR state issue worth your attention.
>
> FINDING: the 2-byte input folds into a nested `.*`-alternation pattern (flags `i`) over "babababa"@1 that backtracks 66496 metered steps → raw match meter 4357881856 (> u32::MAX). Reproduced at the fuzzed base 38ca1d18 (divergence "match meter ironhorse=4357881856 pin=62914560"; 4357881856 − 62914560 = 2^32 exactly). This is the regexp match-meter 32-bit truncation class: the port meters into u64 and is CORRECT; the pre-c8497fd8 XS oracle truncated the pin's 64-bit meterIndex into a 32-bit field. The oracle fix (c8497fd8, meter fields → u64) is ALREADY MERGED into current origin/llm, so it no longer reproduces on the standing branch or on llm. No port change needed. I landed the load-bearing ironhorse-vm regression test finding_8b8afc47fcfb223d_regexp_meter_overflow.rs (submodule-free) on the standing branch (commit 2470d91b5a), alongside a peer's f3d8863981 added 3 min earlier.
>
> STATE ISSUE (fuzz service): there is NO open standing PR. [endojs/endo-but-for-bots#1088](https://github.com/endojs/endo-but-for-bots/issues/1088) (gen 1) merged 2026-08-31 and journal standing.md bumped to gen 2 with branch ironhorse-fuzz-findings-2 — but that branch/PR do not exist; active repair work (the peer's test and mine) is instead landing on the OLD gen-1 branch ironhorse-fuzz-findings, freshly re-cut onto current llm. ensure-pr.sh refuses to open a PR because base llm is floating (needs a frozen snapshot). Net: regression tests are accumulating on a PR-less branch, invisible to CI/review. Also note the 2026-09-09 all-IronHorse pause ([kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91)) is nominally in effect, yet these repair jobs are being dispatched. You may want to (a) reconcile standing.md gen state, and (b) decide whether to open a frozen-base gen-2 standing PR or keep these paused.

- `doomed-ironhorse-fuzz-1dc231089278c110-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-1dc231089278c110-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-1dc231089278c110-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-1dc231089278c110-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:40:59Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 1dc231089278c110 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `unknown`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `18d835dd78d2328c010598a2e65abf126137e92a88cde2638f52e2d0bf67643a` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/1dc231089278c110/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/1dc231089278c110.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `18d835dd78d2328c010598a2e65abf126137e92a88cde2638f52e2d0bf67643a`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `unknown`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 1dc231089278c110).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-1cd4ddc72d5801c4-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-1cd4ddc72d5801c4-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-1cd4ddc72d5801c4-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-1cd4ddc72d5801c4-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:40:52Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 1cd4ddc72d5801c4 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `b847cc7498bb5806fe98bbe606eb2cd7c4fae4d8edfb208e991b56d5fb7bd031` (10 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/1cd4ddc72d5801c4/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/1cd4ddc72d5801c4.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `b847cc7498bb5806fe98bbe606eb2cd7c4fae4d8edfb208e991b56d5fb7bd031`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 1cd4ddc72d5801c4).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-89e303d17e33b117-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-89e303d17e33b117-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-89e303d17e33b117-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-89e303d17e33b117-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:43:53Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 89e303d17e33b117 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `66308cfa3e51ab95c81af5c77b1f25be27960d46982bfeaa3de9144dbc61226d` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/89e303d17e33b117/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/89e303d17e33b117.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `66308cfa3e51ab95c81af5c77b1f25be27960d46982bfeaa3de9144dbc61226d`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 89e303d17e33b117).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-17T00:05:35Z, latest 2026-09-17T02:35:16Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-2`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 3 -> 2 (target 1): shared cleric demand active=2 queue=1 fleet-envelope=5 target=1

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

- `doomed-ironhorse-fuzz-931a687135cabb0c-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-931a687135cabb0c-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-931a687135cabb0c-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-931a687135cabb0c-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:44:34Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 931a687135cabb0c (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `dca671e311ff51c7e982a8778381d2a16c177906a0465b373d68f95977589a67` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/931a687135cabb0c/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/931a687135cabb0c.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `dca671e311ff51c7e982a8778381d2a16c177906a0465b373d68f95977589a67`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 931a687135cabb0c).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-fd8517d5f3071227-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-fd8517d5f3071227-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-fd8517d5f3071227-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-fd8517d5f3071227-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:48:53Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect fd8517d5f3071227 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `69c4d5ae332ac1ddbf55119ab093eaf6d5ac592521784224b09f3e5befe82f4e` (30 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/fd8517d5f3071227/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/fd8517d5f3071227.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `69c4d5ae332ac1ddbf55119ab093eaf6d5ac592521784224b09f3e5befe82f4e`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding fd8517d5f3071227).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `20260904T231419Z-abbbf9` — from gardener:minion-town-clip-content-store-gc-build, reply_to `minion-town-clip-content-store-gc-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T231419Z-abbbf9.md)

> The clip GC implementation is committed and pushed on kriscendobot/minion.town branch feat/clip-content-store-gc at 1e4e0e9, but the required ensure-pr.sh cannot create the draft PR: this host cannot resolve a valid kriscendobot gh token, and the unauthenticated REST limit is also exhausted. Please restore the kriscendobot gh login/token on endolin-garden-ece02cb4; I will then rerun the idempotent PR opener and continue into the gauntlet.

- `doomed-ironhorse-fuzz-79f0475dd0440b2d-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-79f0475dd0440b2d-repair-policy-refusal.md)

> DOOM notice — occurrence #2 (first seen 2026-09-17T00:24:48Z, latest 2026-09-17T01:24:18Z).
> This job has been doom-parked 2 times for the same condition (policy-refusal);
> this is an AMENDED notice, not a new one. Latest detail:
>
> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-79f0475dd0440b2d-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-79f0475dd0440b2d-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-17T01:17:19Z cleared=none -->
>
> # Repair Ironhorse engine defect 79f0475dd0440b2d (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `df0ec7eb405a4384678271e613dac0a54682116e7684738d817cb2c201609b67` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/79f0475dd0440b2d/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/79f0475dd0440b2d.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `df0ec7eb405a4384678271e613dac0a54682116e7684738d817cb2c201609b67`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 79f0475dd0440b2d).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `20260917T021454Z-d00f80` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260917T021454Z-d00f80.md)

> awaiting maintainer — beyond proxy authority: gardener ironhorse-fuzz-triage-differential_source-efffacee3e2a, msgid msg-ironhorse-fuzz-triage-differential_source-efffacee3e2a-8a97a997e368.md — Whether/why the IronHorse pause ([kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91)) was violated and whether further IronHorse work may proceed is a policy-gate compliance question, not a progress/direction call the proxy can make.

- `doomed-ironhorse-fuzz-ed616f6ec22095dc-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-ed616f6ec22095dc-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-ed616f6ec22095dc-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-ed616f6ec22095dc-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:48:22Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect ed616f6ec22095dc (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `e15239bbb919b284ba91a83037f73cd30935a195fb38574f310c9647a6ecde10` (18 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/ed616f6ec22095dc/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/ed616f6ec22095dc.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `e15239bbb919b284ba91a83037f73cd30935a195fb38574f310c9647a6ecde10`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding ed616f6ec22095dc).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-bc9529ac5818aa24-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-bc9529ac5818aa24-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-bc9529ac5818aa24-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-bc9529ac5818aa24-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:53Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect bc9529ac5818aa24 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `c4b0b8c2b5ccf49a2608eab08cc79e770fbe892697379f8a91d99f49e11b12e4` (11 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/bc9529ac5818aa24/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/bc9529ac5818aa24.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `c4b0b8c2b5ccf49a2608eab08cc79e770fbe892697379f8a91d99f49e11b12e4`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding bc9529ac5818aa24).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-bf6cfbd74a7487fc-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-bf6cfbd74a7487fc-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-bf6cfbd74a7487fc-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-bf6cfbd74a7487fc-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:46:03Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect bf6cfbd74a7487fc (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `7438aae1a9b4a8675efb11242949c17d753770526152b8864a7b228b0ac030b6` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/bf6cfbd74a7487fc/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/bf6cfbd74a7487fc.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `7438aae1a9b4a8675efb11242949c17d753770526152b8864a7b228b0ac030b6`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding bf6cfbd74a7487fc).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-29a24c1b1052ec91-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-29a24c1b1052ec91-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-29a24c1b1052ec91-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-29a24c1b1052ec91-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:41:23Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 29a24c1b1052ec91 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `a60da2ec8405d7aa613dd967bc79a60a13e3af9ed90f42b038f14988a196ffc2` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/29a24c1b1052ec91/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/29a24c1b1052ec91.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `a60da2ec8405d7aa613dd967bc79a60a13e3af9ed90f42b038f14988a196ffc2`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 29a24c1b1052ec91).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-e0fe14e41d5074a6-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-e0fe14e41d5074a6-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-e0fe14e41d5074a6-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-e0fe14e41d5074a6-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:47:49Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect e0fe14e41d5074a6 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `0863e8c3609e900aaa74aac92dc110696bf0c485c630b4e14c655d5e61fb1e98` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/e0fe14e41d5074a6/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/e0fe14e41d5074a6.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `0863e8c3609e900aaa74aac92dc110696bf0c485c630b4e14c655d5e61fb1e98`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding e0fe14e41d5074a6).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-13b68e2edb67861a-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-13b68e2edb67861a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-13b68e2edb67861a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-13b68e2edb67861a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:40:34Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 13b68e2edb67861a (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `e0c61bad393fb669bbe423fe93e96d90353b9a9a374824d89c0dc9753540188b` (12 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/13b68e2edb67861a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/13b68e2edb67861a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `e0c61bad393fb669bbe423fe93e96d90353b9a9a374824d89c0dc9753540188b`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 13b68e2edb67861a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `minion-town-clipometer-esbuild-pipeline-gauntlet-review-budget-reached` — from gauntlet:minion-town-clipometer-esbuild-pipeline-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-clipometer-esbuild-pipeline-gauntlet-review-budget-reached.md)

> INFO: Gauntlet minion-town-clipometer-esbuild-pipeline-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `doomed-ironhorse-fuzz-ad5b483fc5e0973f-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-ad5b483fc5e0973f-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-ad5b483fc5e0973f-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-ad5b483fc5e0973f-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:21Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect ad5b483fc5e0973f (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `2cb19c84bdd3ba49bc1ac5004946f79f7c2757a5787b2153019a58cd7012a48e` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/ad5b483fc5e0973f/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/ad5b483fc5e0973f.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `2cb19c84bdd3ba49bc1ac5004946f79f7c2757a5787b2153019a58cd7012a48e`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding ad5b483fc5e0973f).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-e4a8e011666d0362-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-e4a8e011666d0362-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-e4a8e011666d0362-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-e4a8e011666d0362-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:48:05Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect e4a8e011666d0362 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `1c3ef6ed461f18060fd3607e8553fdddca6337002c20d38ffc83eaae980876d5` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/e4a8e011666d0362/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/e4a8e011666d0362.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `1c3ef6ed461f18060fd3607e8553fdddca6337002c20d38ffc83eaae980876d5`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding e4a8e011666d0362).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-ecae051e6e8f5a27-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-ecae051e6e8f5a27-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-ecae051e6e8f5a27-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-ecae051e6e8f5a27-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:48:16Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect ecae051e6e8f5a27 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `08008aee2c5d688bdab03d295c367c457bba1ed3706e802ff7ec2c6cd2e40c7d` (10 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/ecae051e6e8f5a27/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/ecae051e6e8f5a27.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `08008aee2c5d688bdab03d295c367c457bba1ed3706e802ff7ec2c6cd2e40c7d`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding ecae051e6e8f5a27).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

- `doomed-ironhorse-fuzz-27824c75429b8581-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-27824c75429b8581-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-27824c75429b8581-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-27824c75429b8581-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:41:11Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 27824c75429b8581 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `7fe960a158191d9bbf71e234947f5d3854f846606e3b44edb3e800f8e408b5af` (11 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/27824c75429b8581/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/27824c75429b8581.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `7fe960a158191d9bbf71e234947f5d3854f846606e3b44edb3e800f8e408b5af`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 27824c75429b8581).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-b95320dfb5dd9d3d-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-b95320dfb5dd9d3d-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-b95320dfb5dd9d3d-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-b95320dfb5dd9d3d-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:27Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect b95320dfb5dd9d3d (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `89590ab03d5ee8aa96ba12d1543906131941b2d6571f43808ae7f9d2eaed7d07` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/b95320dfb5dd9d3d/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/b95320dfb5dd9d3d.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `89590ab03d5ee8aa96ba12d1543906131941b2d6571f43808ae7f9d2eaed7d07`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding b95320dfb5dd9d3d).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-197b32cc30bdd4fe-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-197b32cc30bdd4fe-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-197b32cc30bdd4fe-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-197b32cc30bdd4fe-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:40:40Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 197b32cc30bdd4fe (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `ede13378ef6a99084bdae3f261735d41106e04e22fa8b0b51b3daf39056a9211` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/197b32cc30bdd4fe/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/197b32cc30bdd4fe.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `ede13378ef6a99084bdae3f261735d41106e04e22fa8b0b51b3daf39056a9211`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 197b32cc30bdd4fe).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-50834e82d3af453d-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-50834e82d3af453d-repair-policy-refusal.md)

> DOOM notice — occurrence #2 (first seen 2026-09-16T23:53:44Z, latest 2026-09-17T01:24:01Z).
> This job has been doom-parked 2 times for the same condition (policy-refusal);
> this is an AMENDED notice, not a new one. Latest detail:
>
> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-50834e82d3af453d-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-50834e82d3af453d-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-17T01:18:20Z cleared=none -->
>
> # Repair Ironhorse engine defect 50834e82d3af453d (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `d1902d4a0515ef8b070f7e77cd65ad31467a9042e37de8f68b00b2f771532cb7` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/50834e82d3af453d/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/50834e82d3af453d.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `d1902d4a0515ef8b070f7e77cd65ad31467a9042e37de8f68b00b2f771532cb7`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 50834e82d3af453d).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `ironhorse-ocap-optimization-campaign-halted` — from orchestrator:ironhorse-ocap-optimization-campaign-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ocap-optimization-campaign-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: ironhorse-ocap-optimization-campaign
> orchestration-status: halted
> child: ironhorse-ocap-frozen-objects
> failure-kind: handler-timeout
> children-completed: 2
> children-total: 4
> halt-parked-remainder: ironhorse-ocap-campaign-audit
>
> Orchestration ironhorse-ocap-optimization-campaign HALTED: child ironhorse-ocap-frozen-objects stalled in flight for 7359s on host endolin-garden2-5bcdff64 (handler-timeout=7200s, multiplier=1) (serial, on-child-failure=halt). 2/4 done before halt; parked remainder: ironhorse-ocap-campaign-audit

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0.md)

> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 0 (target 0): shared cleric demand active=2 queue=0 fleet-envelope=5 target=0

- `doomed-ironhorse-fuzz-c6c71d428a37088c-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-c6c71d428a37088c-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-c6c71d428a37088c-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-c6c71d428a37088c-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:46:10Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect c6c71d428a37088c (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `272379d23e2d29e2be4eb5db911281739f46a446eedbaa78c36b06dee0f66500` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/c6c71d428a37088c/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/c6c71d428a37088c.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `272379d23e2d29e2be4eb5db911281739f46a446eedbaa78c36b06dee0f66500`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding c6c71d428a37088c).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-bd4559ecbc0432c1-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-bd4559ecbc0432c1-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-bd4559ecbc0432c1-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-bd4559ecbc0432c1-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:59Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect bd4559ecbc0432c1 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `f0f8704523911b8babc757edfe36bcfb8950b021396395d84afb657de8387f49` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/bd4559ecbc0432c1/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/bd4559ecbc0432c1.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `f0f8704523911b8babc757edfe36bcfb8950b021396395d84afb657de8387f49`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding bd4559ecbc0432c1).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-fcbb16f5721e8fd2-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-fcbb16f5721e8fd2-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-fcbb16f5721e8fd2-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-fcbb16f5721e8fd2-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:48:43Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding fcbb16f5721e8fd2 (target `differential_source`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `fad46ca0784d81a835adc494ab8451891bfb14000c497d7a9a7aa1c72ae0e13e` (6 bytes)
> - Durable artifact (leader host): `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/fcbb16f5721e8fd2/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/fcbb16f5721e8fd2.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `fad46ca0784d81a835adc494ab8451891bfb14000c497d7a9a7aa1c72ae0e13e`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding fcbb16f5721e8fd2).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `msg-ironhorse-fuzz-triage-differential_source-efffacee3e2a-8a97a997e368` — from gardener:ironhorse-fuzz-triage-differential_source-efffacee3e2a, reply_to `ironhorse-fuzz-triage-differential_source-efffacee3e2a` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-fuzz-triage-differential_source-efffacee3e2a-8a97a997e368.md)

> The claimed job `ironhorse-fuzz-triage-differential_source-efffacee3e2a` was posted and claimed on 2026-09-17 despite the all-IronHorse zero-priority pause recorded in [kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91) and `roles/COMMON.md`.
>
> I confirmed issue 91 remains open with no lift comment. I performed no IronHorse reproduction, diagnostic, project checkout, triage-record write, or repair posting. Please inspect why this fuzz-triage job escaped the pause before any further IronHorse work is promoted.

- `doomed-ironhorse-fuzz-7637ac162a0b916a-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-7637ac162a0b916a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-7637ac162a0b916a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-7637ac162a0b916a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:43:21Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 7637ac162a0b916a (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `a62a861beeaae59d45ec4bad76a22ed6a371a620347a43673bc8d7114f5b1707` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/7637ac162a0b916a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/7637ac162a0b916a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `a62a861beeaae59d45ec4bad76a22ed6a371a620347a43673bc8d7114f5b1707`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 7637ac162a0b916a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-c9eaa7b5ae02437a-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-c9eaa7b5ae02437a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-c9eaa7b5ae02437a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-c9eaa7b5ae02437a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:46:35Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect c9eaa7b5ae02437a (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `6a9c7d5aa3c0a3cf59823601893c61abf251d4ec1d0cc6b933f51f4863f6155d` (27 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/c9eaa7b5ae02437a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/c9eaa7b5ae02437a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `6a9c7d5aa3c0a3cf59823601893c61abf251d4ec1d0cc6b933f51f4863f6155d`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding c9eaa7b5ae02437a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-67ca18e4febe7a34-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-67ca18e4febe7a34-repair-policy-refusal.md)

> DOOM notice — occurrence #2 (first seen 2026-09-17T00:44:08Z, latest 2026-09-17T01:33:35Z).
> This job has been doom-parked 2 times for the same condition (policy-refusal);
> this is an AMENDED notice, not a new one. Latest detail:
>
> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-67ca18e4febe7a34-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-67ca18e4febe7a34-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-17T01:18:31Z cleared=none -->
>
> # Repair Ironhorse engine defect 67ca18e4febe7a34 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `e19049016d8614f90c078f93b854af0cc1d7142ae509c60bbf5072f2353292df` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/67ca18e4febe7a34/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/67ca18e4febe7a34.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `e19049016d8614f90c078f93b854af0cc1d7142ae509c60bbf5072f2353292df`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 67ca18e4febe7a34).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

- `ironhorse-ocap-optimization-campaign-child-ironhorse-ocap-frozen-objects-failed` — from orchestrator:ironhorse-ocap-optimization-campaign-child-ironhorse-ocap-frozen-objects-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ocap-optimization-campaign-child-ironhorse-ocap-frozen-objects-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: ironhorse-ocap-optimization-campaign
> orchestration-status: running
> child: ironhorse-ocap-frozen-objects
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 7359s on host endolin-garden2-5bcdff64 (handler-timeout=7200s, multiplier=1)
>
> Orchestration ironhorse-ocap-optimization-campaign observed child ironhorse-ocap-frozen-objects: stalled in flight for 7359s on host endolin-garden2-5bcdff64 (handler-timeout=7200s, multiplier=1).

- `doomed-ironhorse-fuzz-ac8a8e3d9d3d7f96-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-ac8a8e3d9d3d7f96-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-ac8a8e3d9d3d7f96-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-ac8a8e3d9d3d7f96-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:16Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect ac8a8e3d9d3d7f96 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `806a67c0ca38cf31cd382ad906047d3c68c50b276920705b370f9d18c1f38093` (11 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/ac8a8e3d9d3d7f96/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/ac8a8e3d9d3d7f96.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `806a67c0ca38cf31cd382ad906047d3c68c50b276920705b370f9d18c1f38093`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding ac8a8e3d9d3d7f96).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-6ca7a76e0bfe3435-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-6ca7a76e0bfe3435-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-6ca7a76e0bfe3435-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-6ca7a76e0bfe3435-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:43:06Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 6ca7a76e0bfe3435 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `9123812342a612c521af0e2cb2c8677c90de5e5dd605d4163d3c49e93f78a55b` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/6ca7a76e0bfe3435/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/6ca7a76e0bfe3435.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `9123812342a612c521af0e2cb2c8677c90de5e5dd605d4163d3c49e93f78a55b`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 6ca7a76e0bfe3435).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-fad9672dc7a6e6be-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-fad9672dc7a6e6be-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-fad9672dc7a6e6be-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-fad9672dc7a6e6be-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:48:34Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect fad9672dc7a6e6be (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `676e2c8aa6e7d449bd966554684840708b84656330fadc8b69bff829ef18c94b` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/fad9672dc7a6e6be/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/fad9672dc7a6e6be.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `676e2c8aa6e7d449bd966554684840708b84656330fadc8b69bff829ef18c94b`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding fad9672dc7a6e6be).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-aaa423e9c5d56067-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-aaa423e9c5d56067-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-aaa423e9c5d56067-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-aaa423e9c5d56067-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:03Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect aaa423e9c5d56067 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `3f59968fa7d286a962d7f5db249db8b45793530987923928c9a6b708ed1d68b8` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/aaa423e9c5d56067/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/aaa423e9c5d56067.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `3f59968fa7d286a962d7f5db249db8b45793530987923928c9a6b708ed1d68b8`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding aaa423e9c5d56067).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-6be90176ff07c648-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-6be90176ff07c648-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-6be90176ff07c648-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-6be90176ff07c648-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:43:01Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 6be90176ff07c648 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `241b6de8342803a0d585b1a517ecfefd09d78913f0770cd44ce8ef3fbdd4aa12` (9 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/6be90176ff07c648/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/6be90176ff07c648.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `241b6de8342803a0d585b1a517ecfefd09d78913f0770cd44ce8ef3fbdd4aa12`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 6be90176ff07c648).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `msg-ironhorse-iterator-scenario-parity-58aa54c8fbd4` — from gardener:ironhorse-iterator-scenario-parity, reply_to `ironhorse-iterator-scenario-parity` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-iterator-scenario-parity-58aa54c8fbd4.md)

> [endojs/endo-but-for-bots#1299](https://github.com/endojs/endo-but-for-bots/issues/1299) has completed the iterator-metadata fix on every IronHorse scenario the hardened262 harness actually executes: bare `sloppy` and `strict`. Commit `07af274dfbe` also adds a direct XS-differential regression. A complete baseline regeneration still has 44 Iterator/AsyncIterator entries, all caused by pre-existing scenario infrastructure: module/compartment cells are `structural:scenario-not-supported`, lockdown scripts stop at the absent `lockdown` global, and every SES-IronHorse script stops in the SES prelude (the SES-IronHorse passed baselines are empty repository-wide).
>
> The predecessor's 48-entry acceptance criterion therefore conflates the focused intrinsic-metadata defect with implementing all missing IronHorse module, compartment, lockdown, and SES execution. Please explicitly choose one:
>
> 1. Revise acceptance to require these probes to pass in all currently supported IronHorse scenarios (the two bare script cells), accepting the 44 structural/infrastructure entries until their own engine/harness work lands; or
> 2. Keep the 48-entry criterion, which expands this job into real module/compartment/lockdown/SES engine integration.
>
> Also, `roles/COMMON.md` says IronHorse work is paused unless a trusted maintainer explicitly lifts the pause. The predecessor job was promoted from plan with `gate=go-ahead` on 2026-09-16, but please confirm whether that promotion was the explicit exception for [endojs/endo-but-for-bots#1299](https://github.com/endojs/endo-but-for-bots/issues/1299). I will not relabel or suppress unsupported cells.

- `doomed-ironhorse-fuzz-d38f12f4884e186c-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-d38f12f4884e186c-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-d38f12f4884e186c-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-d38f12f4884e186c-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:47:14Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect d38f12f4884e186c (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `a28c0d2756d1b3e68325325c49b7d19651960a203207a3a2a1f37f486ed1c85e` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/d38f12f4884e186c/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/d38f12f4884e186c.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `a28c0d2756d1b3e68325325c49b7d19651960a203207a3a2a1f37f486ed1c85e`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding d38f12f4884e186c).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

- `msg-ironhorse-fuzz-3310b49d21f64878-repair-bc018d1bd2e0` — from gardener:ironhorse-fuzz-3310b49d21f64878-repair, reply_to `ironhorse-fuzz-3310b49d21f64878-repair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-fuzz-3310b49d21f64878-repair-bc018d1bd2e0.md)

> Ironhorse fuzz finding 3310b49d21f64878 (target differential_source) is fixed and pushed to the standing PR [endojs/endo-but-for-bots#1298](https://github.com/endojs/endo-but-for-bots/issues/1298) (branch ironhorse-fuzz-findings; commit landed via CAS).
>
> Re-discovery of the known large-integer dtoa-spelling class (siblings d99d263fcf6ca7a7 / 4658b8adc7bdd428): 4-byte input 24 00 1b 1b generates arithmetic whose value is the exact double 273593678570717184; XS prints the exact integer, IronHorse prints the ECMA-262 shortest decimal 273593678570717200 — same f64. No port fix needed; the causal fix (results_agree comparing by f64) already exists. Added a submodule-free ironhorse-vm regression (verified passing on Rust 1.91.1) plus the oracle-linked _agrees lock.
>
> ACTION NEEDED: could NOT post the per-finding PR comment or edit the PR body — this follower host (oros-studio-garden-ce242c49) has a fine-grained PAT with push+triage but no issue/PR write on endojs/endo-but-for-bots (GraphQL "Resource not accessible by personal access token" on both addComment and updatePullRequest). Prior sibling comments were posted from the leader host. Please post the finding comment (below) from a capable host to [endojs/endo-but-for-bots#1298](https://github.com/endojs/endo-but-for-bots/issues/1298).
>
> ------8<------ finding comment to post ------8<------
> ### Finding `3310b49d21f64878` — `differential_source` — large-integer dtoa spelling (already suppressed)
>
> **Disposition: no port fix needed.** Re-discovery of the dtoa non-shortest-spelling class (`d99d263fcf6ca7a7` / `4658b8adc7bdd428` / `7277b0fc4a72d8d6` / `284de587e16bce32`). IronHorse is conformant; the divergence was decimal *spelling* only, already suppressed harness-side by the numeric `results_agree` (IEEE-754 f64) comparison.
>
> **Reproducer.** 4-byte minimized input `24 00 1b 1b` (sha256 `8052cd0fe6de647863a6803fad31515cf631d6fccc45ead2e8092630456f566d`), target `differential_source`, toolchain `nightly-2026-08-15`, fuzzed at project SHA `38ca1d18`. `ironhorse_fuzz::gen_program` folds it into:
>
> ```js
> ((((true * true) + (true * true)) * ((226492416 + true) * (301989888 * true)))
>  + (((true * true) + (true * true)) * ((226492416 + true) * (301989888 * true))))
> ```
>
> The `226492416` / `301989888` operands are the generator's `27 << 23` / `36 << 23` large-integer atoms (`gen_atom` case 3, driven by the cyclic input bytes `0x1b`/`0x24`).
>
> **Analysis.** In ECMAScript Number semantics `true * true` is `1`, `(true*true)+(true*true)` is `2`, `226492416 + true` is `226492417`, and `301989888 * true` is `301989888`. Each half is `2 * (226492417 * 301989888)` and the whole is their sum — `4 * (226492417 * 301989888)`, the exactly-representable double whose real value is `273593678570717184`.
>
> - XS `fx_dtoa` prints the exact integer `273593678570717184` (18 digits).
> - IronHorse — like V8/Node and ECMA-262 §6.1.6.1.20 ("k as small as possible") — prints the shortest round-tripping decimal `273593678570717200` (16 significant digits).
>
> Both parse to the identical f64 (`0x438e600002400000`), so the engines computed the same value.
>
> **Verification.**
> - The submodule-free `ironhorse-vm` regression **passes** on Rust `1.91.1` (`cargo test -p ironhorse-vm --test finding_3310b49d21f64878_large_integer_dtoa`), reconstructing the program value in f64 and pinning `number_to_ecma_string(273593678570717184.0) == "273593678570717200"` (shortest, not XS's exact integer) and that both spellings are the same double.
> - Divergence occurs only against a harness that byte-compares numeric completions (the pre-`d99d263` state / the old fuzzed SHA `38ca1d18`); the current `results_agree` compares parsed f64, so `differential_check(gen_program(24 00 1b 1b))` does not diverge at this branch head.
> - The oracle-linked `_agrees` lock was **not** built locally: the `c/moddable` submodule is unpopulated on this host and the continuous-fuzz lane is paused ([kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91)), so I did not perform the multi-GB XS-oracle build. It is validated by the standing PR's gauntlet/CI, exactly like the sibling `_agrees` locks.
>
> **Regression locks added:**
> - `rust/engine/ironhorse-vm/tests/finding_3310b49d21f64878_large_integer_dtoa.rs` — submodule-free, **CI-visible**; verified passing here.
> - `rust/engine/ironhorse-fuzz/src/lib.rs::tests::finding_3310b49d21f64878_large_integer_dtoa_agrees` — oracle-linked `_agrees` lock: `differential_check(gen_program(<bytes>))` must not diverge.
>
> No meter constant or engine code changed.
>
> <sub><!--garden-provenance-->model <code>claude-opus-4-8</code> · harness <code>claude</code> · provider <code>anthropic</code> · host <code>oros-studio-garden-ce242c49</code> · job <code>ironhorse-fuzz-3310b49d21f64878-repair</code></sub>

- `doomed-ironhorse-fuzz-cfdc1a28296f23a1-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-cfdc1a28296f23a1-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-cfdc1a28296f23a1-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-cfdc1a28296f23a1-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:46:58Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect cfdc1a28296f23a1 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `0603c5237ff20137251a9f7ce92fccd95d7ba0d80ebd5e300dd82dbfd6453f4d` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/cfdc1a28296f23a1/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/cfdc1a28296f23a1.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `0603c5237ff20137251a9f7ce92fccd95d7ba0d80ebd5e300dd82dbfd6453f4d`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding cfdc1a28296f23a1).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-45f4af87eaf627c7-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-45f4af87eaf627c7-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-45f4af87eaf627c7-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-45f4af87eaf627c7-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:41:55Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 45f4af87eaf627c7 (target `differential_regexp`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `4999211e387d6bd25b5e5abdaf5cf4210531e28c7e80abf9771d01593200300a` (3 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/45f4af87eaf627c7/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/45f4af87eaf627c7.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `4999211e387d6bd25b5e5abdaf5cf4210531e28c7e80abf9771d01593200300a`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 45f4af87eaf627c7).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-d87697d49a5f8f67-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-d87697d49a5f8f67-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-d87697d49a5f8f67-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-d87697d49a5f8f67-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:47:30Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect d87697d49a5f8f67 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `b4814c1b47ca2297e26e5e27a1151a79dc222cd408f51d4130a07d423229311b` (7 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/d87697d49a5f8f67/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/d87697d49a5f8f67.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `b4814c1b47ca2297e26e5e27a1151a79dc222cd408f51d4130a07d423229311b`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding d87697d49a5f8f67).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

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

> WATCHDOG notice — occurrence #18 (first seen 2026-09-17T02:20:04Z, latest 2026-09-17T06:50:03Z).
> The SAME condition (`budget-level-monk-preflight`) has now been observed 18 times; this is ONE
> coalesced notice that updates in place, not 18 messages. Latest detail:
>
> budget-level: fleet monk allocation frozen: anthropic:oros-studio-garden-ce242c49 missing/invalid monk physical cap. No monk count may rise; only a calibrated host already over its own high-water mark may step down toward the floor.

- `msg-minion-town-guest-peer-fetch-verify-a02887e8f0f8` — from gardener:minion-town-guest-peer-fetch-verify, reply_to `minion-town-guest-peer-fetch-verify` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-guest-peer-fetch-verify-a02887e8f0f8.md)

> minion.town guest peer-fetch ([kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58)): STILL BLOCKED on your decision — no work done, job re-gated.
>
> The job `minion-town-guest-peer-fetch-verify` was auto-promoted off the deferred plan queue by the foreman today (2026-09-16) and claimed, but its precondition is unmet: the daemon-exposure question you were asked on [kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58) (comment 5447765615, 2026-08-28) has never been answered. Every comment on that issue since is about other matters (hint format, the npm.minion.town proxy, press pause/resume, the checklist reframe, the Fable supervisor, sitreps). The promotion metadata itself records `cleared=none`.
>
> The remaining work (a peer `enlivenSturdyRef` fetch of a revealed guest) needs an infrastructure + security-posture change that only you can authorize, so I did NOT run it. I re-parked it as a **go-ahead** plan job `minion-town-guest-peer-fetch-verify-await-auth` (deferred was the wrong gate — the foreman auto-selects deferred jobs and ignores the prose condition; go-ahead is never auto-promoted). It will wait for your answer and not be re-promoted automatically.
>
> THE QUESTION (please answer to unblock): authorize exposing the guest-substrate daemon `endo-daemon.service` over a public OCapN-CBOR-Noise route so a peer can `enlivenSturdyRef` a revealed guest by its formula id — OR did you intend the app to run on the already-public pet-daemon? Once you answer, promote `minion-town-guest-peer-fetch-verify-await-auth`.

- `doomed-ironhorse-fuzz-8ea950859db8a5f7-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-8ea950859db8a5f7-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-8ea950859db8a5f7-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-8ea950859db8a5f7-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:44:22Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 8ea950859db8a5f7 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `74718c926b43f7719a57c58fd90e170eb5e9ee1872dd4973f321e07ce3025859` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/8ea950859db8a5f7/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/8ea950859db8a5f7.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `74718c926b43f7719a57c58fd90e170eb5e9ee1872dd4973f321e07ce3025859`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 8ea950859db8a5f7).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

> WATCHDOG notice — occurrence #2 (first seen 2026-09-09T20:50:24Z, latest 2026-09-17T06:35:15Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-1`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 0 -> 1 (target 1): shared cleric demand active=1 queue=0 fleet-envelope=5 target=1

- `doomed-ironhorse-fuzz-baad1f22ef053213-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-baad1f22ef053213-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-baad1f22ef053213-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-baad1f22ef053213-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:42Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect baad1f22ef053213 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `acb62697b33de3dda0995721979c11600eef65c7d2544621556d3f401b7d284a` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/baad1f22ef053213/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/baad1f22ef053213.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `acb62697b33de3dda0995721979c11600eef65c7d2544621556d3f401b7d284a`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding baad1f22ef053213).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-8adaa3bbc9cda1ce-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-8adaa3bbc9cda1ce-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-8adaa3bbc9cda1ce-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-8adaa3bbc9cda1ce-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:44:09Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 8adaa3bbc9cda1ce (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `ae3640c01867b87df0ac9300ea7bc73ac273a010780e949beb393d945d0821bd` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/8adaa3bbc9cda1ce/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/8adaa3bbc9cda1ce.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `ae3640c01867b87df0ac9300ea7bc73ac273a010780e949beb393d945d0821bd`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 8adaa3bbc9cda1ce).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-5c9d2506e6048f4a-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-5c9d2506e6048f4a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-5c9d2506e6048f4a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-5c9d2506e6048f4a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:42:33Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 5c9d2506e6048f4a (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `cf677bd6b6eee5fe9ed8394911852ed267fe6057e827df87ef1ffd2abdee8302` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/5c9d2506e6048f4a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/5c9d2506e6048f4a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `cf677bd6b6eee5fe9ed8394911852ed267fe6057e827df87ef1ffd2abdee8302`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 5c9d2506e6048f4a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `20260917T005044Z-369283` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260917T005044Z-369283.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: ironhorse-iterator-intrinsic-metadata
> - question (msgid msg-ironhorse-iterator-intrinsic-metadata-8bd9eab6e4eb.md)
> - tentative answer: proxy/tentative — this is a progress report, not a gating question, but treating it as if it asked "is this scope reduction OK?": yes, proceed. The fix is real and verified (106 passing cargo tests, zero test:xs divergence introduced), and the scope narrowing is well-justified: SES/lockdown/module/compartment failures are a documented separate engine gap (missing `lockdown`, SES-shim abort, unported modules/compartments), not an iterator-intrinsic-metadata issue. Don't hold the PR open trying to make the full 48-failure count move — that's out of this job's blast radius. Retry `ensure-pr.sh` once the GraphQL rate limit clears and get the draft PR open describing exactly this scope (2 intrinsic-shape bugs fixed, ~8 bare-Ironhorse entries resolved, structural SES/module gap called out as future work). If retries keep failing beyond a transient blip, flag that separately rather than blocking on it.

- `doomed-ironhorse-fuzz-51c6a212946102f6-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-51c6a212946102f6-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-51c6a212946102f6-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-51c6a212946102f6-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:42:16Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 51c6a212946102f6 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `a7224c7f8068466ff6259c1236ad389b6e86d577975d5842ea71b71573cc02f6` (31 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/51c6a212946102f6/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/51c6a212946102f6.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `a7224c7f8068466ff6259c1236ad389b6e86d577975d5842ea71b71573cc02f6`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 51c6a212946102f6).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-284de587e16bce32-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-284de587e16bce32-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-284de587e16bce32-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-284de587e16bce32-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:41:17Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 284de587e16bce32 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `05b1ea60cf0ed92291daeb24a160652baaa07e231d88d84f48548d261b517c33` (9 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/284de587e16bce32/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/284de587e16bce32.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `05b1ea60cf0ed92291daeb24a160652baaa07e231d88d84f48548d261b517c33`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 284de587e16bce32).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-ccb76a40851925f9-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-ccb76a40851925f9-repair-policy-refusal.md)

> DOOM notice — occurrence #2 (first seen 2026-09-17T00:24:20Z, latest 2026-09-17T01:24:07Z).
> This job has been doom-parked 2 times for the same condition (policy-refusal);
> this is an AMENDED notice, not a new one. Latest detail:
>
> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-ccb76a40851925f9-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-ccb76a40851925f9-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-17T01:18:14Z cleared=none -->
>
> # Repair Ironhorse engine defect ccb76a40851925f9 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `8876046ff9e64aad9dacb15b75288ecaaef453d2324d137682ca05923270247c` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/ccb76a40851925f9/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/ccb76a40851925f9.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `8876046ff9e64aad9dacb15b75288ecaaef453d2324d137682ca05923270247c`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding ccb76a40851925f9).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-9001b34fa6dd2d80-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-9001b34fa6dd2d80-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-9001b34fa6dd2d80-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-9001b34fa6dd2d80-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:44:28Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 9001b34fa6dd2d80 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `5e2b476e505da46d7a2151149cf5a8ac93173736cfd1fd136bea0152cae2318c` (5 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/9001b34fa6dd2d80/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/9001b34fa6dd2d80.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `5e2b476e505da46d7a2151149cf5a8ac93173736cfd1fd136bea0152cae2318c`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 9001b34fa6dd2d80).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

- `msg-ironhorse-fuzz-repromote-quarantined-1719457af4c6` — from gardener:ironhorse-fuzz-repromote-quarantined, reply_to `ironhorse-fuzz-repromote-quarantined` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-fuzz-repromote-quarantined-1719457af4c6.md)

> ironhorse-fuzz repromote: STOPPED after the bounded probe — the reword does NOT fix the refusal on Anthropic, and this job is superseded by design.
>
> FINDING (empirical): I regenerated 5 quarantined repair bodies with the NEW engine-defect framing (commit 37fdea27b0's reworded template) and promoted them. Within ~6 min, 3 of 5 were re-doomed `policy-refusal` on this host's Anthropic monks (79f0475d/ccb76a40/50834e82, re-doomed 01:23:53Z). The blocker job proved acceptance only on gpt-5.6-terra (OpenAI: POLICY_FILTER_ACCEPTED); that does NOT generalize to Anthropic, which still refuses the reworded body.
>
> STORM (ongoing, upstream of promotion): the LEADER host endolin-garden-ece02cb4 is posting fresh per-finding repair jobs that ALSO carry the reworded framing and STILL get policy-refused every ~10 min (e.g. e4a8e011 doomed 01:13:40Z). The plan/ backlog is GROWING (28 -> 39 during this job), all at one project_sha 38ca1d18 across 3 targets (differential_regexp / _regexp_surface / _source) — heavy duplication (likely a handful of root causes). No ironhorse-fuzz repair has completed recently.
>
> SUPERSEDED: scripts/jobs/ironhorse-fuzz-migrate-backlog.sh (designs/ironhorse-fuzz-triage-and-batch.md § Migration) explicitly marks THIS job (ironhorse-fuzz-repromote-quarantined) superseded and says "never promote the old files one by one" — it routes findings into deduplicated cluster repairs. It has NOT run (no migration record, 0 triage records). Root cause: the leader runs an old deployed garden (reworded per-finding template, pre-cluster/pre-migration, ~08-31..09-04); its fuzz lane keeps re-posting per-finding jobs the Anthropic filter refuses. Promotion cannot win against that.
>
> RECOMMEND (needs your decision — I stopped rather than grind 34 jobs through a filter that is still rejecting):
> 1. Pin the ironhorse-fuzz repair lane's dispatch to gpt-5.6-terra (OpenAI), where the reword is proven to pass — otherwise Anthropic will keep refusing every one.
> 2. Deploy main2 to the leader endolin-garden-ece02cb4 to stop the stale-storm producer and arm the cluster batcher + migration.
> 3. Then run ironhorse-fuzz-migrate-backlog.sh to take custody of the backlog (dedup into cluster repairs) instead of per-finding promotion.
>
> I promoted 5 as the probe (mostly re-quarantined now); left the remaining ~34 quarantined. Nothing lost.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `doomed-ironhorse-fuzz-2a2de75b75de4894-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-2a2de75b75de4894-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-2a2de75b75de4894-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-2a2de75b75de4894-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:41:28Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 2a2de75b75de4894 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `ad63534a58b0bed2901e28c08837180c41ee82dde81e780bde94367b9e924a4e` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/2a2de75b75de4894/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/2a2de75b75de4894.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `ad63534a58b0bed2901e28c08837180c41ee82dde81e780bde94367b9e924a4e`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 2a2de75b75de4894).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `watchdog-triager-fetch-failed-kriscendobot-endo` — from watchdog:triager/kriscendobot-endo, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-endo.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-endo` has CLEARED (first seen 2026-09-17T02:30:24Z, cleared 2026-09-17T02:32:28Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-endo at /home/kris/garden/worktrees/kriscendobot-endo.git is SUCCEEDING again; kriscendobot-endo is being triaged normally.

- `doomed-ironhorse-fuzz-c781c9b9de456ab2-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-c781c9b9de456ab2-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-c781c9b9de456ab2-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-c781c9b9de456ab2-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:46:16Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect c781c9b9de456ab2 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `1daa22f72981a1c640bc9c5d96a4a5779a0f8d78f1ad0c171d5ab847f5a29902` (14 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/c781c9b9de456ab2/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/c781c9b9de456ab2.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `1daa22f72981a1c640bc9c5d96a4a5779a0f8d78f1ad0c171d5ab847f5a29902`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding c781c9b9de456ab2).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-e2a75557f762cd9c-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-e2a75557f762cd9c-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-e2a75557f762cd9c-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-e2a75557f762cd9c-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:47:57Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect e2a75557f762cd9c (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `85095187c6aeec9c687faa7157f09e51d8f91b247fde5a65bb1c84c1be31e512` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/e2a75557f762cd9c/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/e2a75557f762cd9c.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `85095187c6aeec9c687faa7157f09e51d8f91b247fde5a65bb1c84c1be31e512`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding e2a75557f762cd9c).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

- `doomed-ironhorse-fuzz-05264cccae42245a-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-05264cccae42245a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-05264cccae42245a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-05264cccae42245a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:40:29Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 05264cccae42245a (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `fe91a16f9299c9c0d4dc9a35f1f1394d57adb1f9c4de97befb98afd383949f52` (3 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/05264cccae42245a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/05264cccae42245a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `fe91a16f9299c9c0d4dc9a35f1f1394d57adb1f9c4de97befb98afd383949f52`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 05264cccae42245a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `20260901T175244Z-931faa` — from gardener:minion-town-remove-mcp-tool-prefixes, reply_to `minion-town-remove-mcp-tool-prefixes` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T175244Z-931faa.md)

> [kriscendobot/minion.town#75](https://github.com/kriscendobot/minion.town/issues/75) is merged and deployment run 33539977066 succeeded. The remaining required blind live discovery evaluation needs an authenticated minion.town MCP session. This worker container has no AWS CLI/credentials or minion.town OAuth connection, so it cannot read the sanctioned minion/test-cc-client secret or attach the live MCP to a context-free agent. Please either run a connected blind agent with only the directive "evaluate 2 + 2" and send the transcript/result, or make a short-lived sanctioned Bearer token available through this job inbox (do not paste a long-lived client secret).

- `doomed-ironhorse-fuzz-822848c732a1b805-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-822848c732a1b805-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-822848c732a1b805-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-822848c732a1b805-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:43:44Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 822848c732a1b805 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `97e615f499ff68ab4f640dc00725dbedf3ce2eece7005c90b37e1f1643d082be` (20 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/822848c732a1b805/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/822848c732a1b805.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `97e615f499ff68ab4f640dc00725dbedf3ce2eece7005c90b37e1f1643d082be`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 822848c732a1b805).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `msg-ironhorse-fuzz-fd8517d5f3071227-repair-6602bc26dcbd` — from gardener:ironhorse-fuzz-fd8517d5f3071227-repair, reply_to `ironhorse-fuzz-fd8517d5f3071227-repair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-fuzz-fd8517d5f3071227-repair-6602bc26dcbd.md)

> BLOCKED / recommend DROP: job `ironhorse-fuzz-fd8517d5f3071227-repair` (target differential_regexp).
>
> I claimed this on follower host oros-studio-garden-ce242c49 and found three hard blockers; I did NOT build, reproduce, or push any engine change.
>
> 1. STANDING PAUSE. context/operations/ironhorse-fuzz.md + [kriscendobot/garden#91](https://github.com/kriscendobot/garden/issues/91) (2026-09-09): the garden "does not run or advance any IronHorse work until a trusted maintainer explicitly lifts the pause." Units are in PAUSED_UNITS; the backlog migration never ran (empty manifest). Repairing the engine + amending the standing PR would advance paused IronHorse work. (This legacy job was promoted from plan gate=go-ahead on 2026-09-16 — that go-ahead conflicts with the still-active pause; only you can reconcile that.)
>
> 2. INFEASIBLE ON THIS HOST. This is a follower, not the leader (endolin-garden-ece02cb4). No cargo-fuzz, no nightly-2026-08-15, no project checkout under GARDEN_STATE, no c/moddable oracle build. The durable reproducer artifact is on the leader's garden2 host. The spec's own step 3 says: if it cannot be reproduced at the pinned SHA, report and STOP. I cannot reproduce here within budget.
>
> 3. STALE GENERATION. Standing PR has rolled to generation 2 (branch ironhorse-fuzz-findings-2); this job targets the gen-1 branch/marker ironhorse-fuzz-findings, which no longer receives amendments. This ironhorse-fuzz-<id>-repair job is the legacy shape the triage-and-batch backlog migration is meant to supersede.
>
> Finding is NOT lost: journal/ironhorse-fuzz/findings/fd8517d5f3071227.md durably records it (input_base64 verified, sha256 matches). When the pause lifts and the migration runs, the triage-and-batch pipeline takes custody of the backlog including this id.
>
> Recommendation: DROP this job (and any sibling legacy ironhorse-fuzz-*-repair jobs) from the board; let the triage/backlog pipeline own these findings once IronHorse is unpaused. If you instead want this specific finding repaired now, it must run on the LEADER host with the pause explicitly lifted for it.

- `doomed-ironhorse-fuzz-ab41c5d203ace017-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-ab41c5d203ace017-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-ab41c5d203ace017-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-ab41c5d203ace017-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:45:09Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect ab41c5d203ace017 (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `b9c2c014ed3f9ee4dccbc06af2f048d3399c9b9be27b9bb49d13ed00cc0dd51e` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/ab41c5d203ace017/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/ab41c5d203ace017.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `b9c2c014ed3f9ee4dccbc06af2f048d3399c9b9be27b9bb49d13ed00cc0dd51e`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding ab41c5d203ace017).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-9edaa2277fb90f03-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-9edaa2277fb90f03-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-9edaa2277fb90f03-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-9edaa2277fb90f03-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:44:46Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 9edaa2277fb90f03 (target `differential_source`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `3add41810a522cd14a50ab2b5c48b49e76625f9b82dc4cef0b85841efb4891d2` (4 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/9edaa2277fb90f03/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/9edaa2277fb90f03.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `3add41810a522cd14a50ab2b5c48b49e76625f9b82dc4cef0b85841efb4891d2`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 9edaa2277fb90f03).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `watchdog-triager-fetch-failed-kriscendobot-minion.town` — from watchdog:triager/kriscendobot-minion.town, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-minion.town.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-minion.town` has CLEARED (first seen 2026-09-17T02:30:11Z, cleared 2026-09-17T02:32:23Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-minion.town at /home/kris/garden/worktrees/kriscendobot-minion.town.git is SUCCEEDING again; kriscendobot-minion.town is being triaged normally.

- `doomed-ironhorse-fuzz-d5413146a257bc30-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-d5413146a257bc30-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-d5413146a257bc30-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-d5413146a257bc30-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:47:25Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect d5413146a257bc30 (target `differential_regexp_surface`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `957c39a802d5b3a9f09413832ea4c03dba2d2fed67d8b6da0553a6cb6cef0563` (6 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/d5413146a257bc30/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/d5413146a257bc30.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `957c39a802d5b3a9f09413832ea4c03dba2d2fed67d8b6da0553a6cb6cef0563`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding d5413146a257bc30).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

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

- `doomed-ironhorse-fuzz-7072dc2d72d9e2fd-repair-policy-refusal` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-7072dc2d72d9e2fd-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden-ece02cb4.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-7072dc2d72d9e2fd-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-7072dc2d72d9e2fd-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:43:12Z cleared=none -->
>
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Repair Ironhorse engine defect 7072dc2d72d9e2fd (target `differential_regexp`) and amend the standing PR
>
> The `ironhorse-fuzz` service recorded a reproducer that makes the Ironhorse JS
> engine port produce incorrect behaviour or abort. Own BOTH a load-bearing
> regression case AND the causal fix, then amend the ONE standing pull request.
>
> ## Recorded reproducer (bounded metadata — never paste the input bytes into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under test: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `5ab98e6f44d2cb2f00cccdfd8e0624fd95a797a8ec4c1214a06ae1f5848bf8f9` (10 bytes)
> - Durable reproducer artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/7072dc2d72d9e2fd/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/7072dc2d72d9e2fd.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `5ab98e6f44d2cb2f00cccdfd8e0624fd95a797a8ec4c1214a06ae1f5848bf8f9`.
> 3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and confirm the incorrect behaviour or abort
>    from that file before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts correct completion (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 7072dc2d72d9e2fd).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.


## Spend & quota
_Since Friday 20:00 Pacific reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 77.6M | $580.15 _(notional, rate-card)_ | 54% of 143.0M (ok) |
| Codex | 20.3M _(+504.8M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 93% _(plan; codex-reported)_ |

## Board
### todo (0)
(none)

### doin (2)
- [`endojs-endo-but-for-bots-pr1125-review-b786506c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1125-review-b786506c.md) — Review directive on endojs/endo-but-for-bots PR #1125
- [`ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-panel-6.md) — Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1100

### tada (8200)
- [`ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-fix-5.md) — Cost
- [`daily-progress-summary-20260917-070513`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/daily-progress-summary-20260917-070513.md) — Cost
- [`endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned.md) — gauntlet endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned — review bud...
- [`endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-fix-6.md) — Completion report
- [`endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-panel-6.md) — Cost
- … and 8195 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`ironhorse-fuzz-bd4559ecbc0432c1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bd4559ecbc0432c1-repair.md) — _normal_ · Repair Ironhorse engine defect bd4559ecbc0432c1 (target differential_source) ...
- [`ironhorse-fuzz-baad1f22ef053213-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-baad1f22ef053213-repair.md) — _normal_ · Repair Ironhorse engine defect baad1f22ef053213 (target differential_regexp_s...
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`ironhorse-fuzz-fcbb16f5721e8fd2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fcbb16f5721e8fd2-repair.md) — _normal_ · Fix Ironhorse fuzz finding fcbb16f5721e8fd2 (target differential_source) and ...
- [`ironhorse-fuzz-89e303d17e33b117-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-89e303d17e33b117-repair.md) — _normal_ · Repair Ironhorse engine defect 89e303d17e33b117 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr431-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr431-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #431
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
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
- [`ironhorse-fuzz-c6c71d428a37088c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c6c71d428a37088c-repair.md) — _normal_ · Repair Ironhorse engine defect c6c71d428a37088c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr1089-32c7e8f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1089-32c7e8f1.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1089
- [`ironhorse-fuzz-51c6a212946102f6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-51c6a212946102f6-repair.md) — _normal_ · Repair Ironhorse engine defect 51c6a212946102f6 (target differential_regexp) ...
- [`ironhorse-fuzz-13b68e2edb67861a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-13b68e2edb67861a-repair.md) — _normal_ · Repair Ironhorse engine defect 13b68e2edb67861a (target differential_regexp) ...
- [`ironhorse-fuzz-e2a75557f762cd9c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e2a75557f762cd9c-repair.md) — _normal_ · Repair Ironhorse engine defect e2a75557f762cd9c (target differential_regexp) ...
- [`endo-claude-agent-sdk-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-probe.md) — _normal_ · Probe: measure the Agent SDK's confinement claims against a live run
- [`endojs-endo-but-for-bots-pr264-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #264
- [`endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1085
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr879-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr879-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #879
- [`endojs-endo-but-for-bots-pr897-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave-20260901.md) — _normal_ · Weave (rebase onto live llm) endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr664-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr664-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #664
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`xs2rust-endor-press-20260902-110504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-110504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`dependabotany-recheck-endo-but-for-bots-pr1268`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-pr1268.md) — _normal_ · botanist recheck: endojs/endo-but-for-bots PR #1268 (re-conduct after rebase)
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
- [`ironhorse-fuzz-6ba52f2bdc534545-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ba52f2bdc534545-repair.md) — _normal_ · Repair Ironhorse engine defect 6ba52f2bdc534545 (target differential_regexp_s...
- [`xs2rust-endor-press-20260902-215005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-215005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
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
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
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
- [`ironhorse-fuzz-bc3d0df623811a38-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc3d0df623811a38-repair.md) — _normal_ · Repair Ironhorse engine defect bc3d0df623811a38 (target differential_regexp_s...
- [`ironhorse-fuzz-fad9672dc7a6e6be-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fad9672dc7a6e6be-repair.md) — _normal_ · Repair Ironhorse engine defect fad9672dc7a6e6be (target differential_source) ...
- [`ironhorse-fuzz-197b32cc30bdd4fe-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-197b32cc30bdd4fe-repair.md) — _normal_ · Repair Ironhorse engine defect 197b32cc30bdd4fe (target differential_regexp_s...
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
- [`xs2rust-endor-press-20260902-100504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-100504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endo-pr3360-mirror`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-pr3360-mirror.md) — _normal_ · What "mirror" means here
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
- [`xs2rust-endor-press-20260902-152005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-152005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-05264cccae42245a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-05264cccae42245a-repair.md) — _normal_ · Repair Ironhorse engine defect 05264cccae42245a (target differential_source) ...
- [`ironhorse-fuzz-5c9d2506e6048f4a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5c9d2506e6048f4a-repair.md) — _normal_ · Repair Ironhorse engine defect 5c9d2506e6048f4a (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr897-shepherd-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-shepherd-20260901.md) — _normal_ · ---
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
- [`endojs-endo-but-for-bots-pr511-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr511-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #511
- [`ironhorse-fuzz-284de587e16bce32-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-284de587e16bce32-repair.md) — _normal_ · Repair Ironhorse engine defect 284de587e16bce32 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr529-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr529-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #529
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
- [`build-rbra-clean-break-20260916`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-rbra-clean-break-20260916.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr569-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr569-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #569
- [`endojs-endo-but-for-bots-pr797-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr797-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #797
- [`endojs-endo-but-for-bots-pr674-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr674-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #674
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`ironhorse-fuzz-8ea950859db8a5f7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8ea950859db8a5f7-repair.md) — _normal_ · Repair Ironhorse engine defect 8ea950859db8a5f7 (target differential_regexp) ...
- [`kriscendobot-vattr97-pr1-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-vattr97-pr1-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/vattr97 PR #1
- [`xs2rust-endor-press-20260902-193509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-193509.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — kriscendobot/minion.town PR #81
- [`kriscendobot-minion.town-pr78-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr78-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #78
- [`ironhorse-fuzz-6be90176ff07c648-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6be90176ff07c648-repair.md) — _normal_ · Repair Ironhorse engine defect 6be90176ff07c648 (target differential_regexp) ...
- [`kriscendobot-minion.town-pr80-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr80-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #80
- [`ironhorse-ocap-frozen-objects`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-frozen-objects.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr690-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr690-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #690
- [`endojs-endo-but-for-bots-pr508-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr508-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #508
- [`xs2rust-endor-press-20260902-075006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-075006.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-8adaa3bbc9cda1ce-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8adaa3bbc9cda1ce-repair.md) — _normal_ · Repair Ironhorse engine defect 8adaa3bbc9cda1ce (target differential_source) ...
- [`ironhorse-fuzz-ed616f6ec22095dc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ed616f6ec22095dc-repair.md) — _normal_ · Repair Ironhorse engine defect ed616f6ec22095dc (target differential_regexp) ...
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`endo-claude-agent-sdk-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-design.md) — _normal_ · Design: the Claude Agent SDK as an alternative confinement substrate for @end...
- [`ironhorse-fuzz-3fc02d8b57faa79a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3fc02d8b57faa79a-repair.md) — _normal_ · Repair Ironhorse engine defect 3fc02d8b57faa79a (target differential_source) ...
- [`endojs-endo-but-for-bots-pr933-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr933-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #933
- [`endo-claude-agent-sdk-backend`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-backend.md) — _normal_ · Build: a paid-tier Agent SDK backend behind @endo/claude's existing seams
- [`ironhorse-fuzz-2a2de75b75de4894-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2a2de75b75de4894-repair.md) — _normal_ · Repair Ironhorse engine defect 2a2de75b75de4894 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr938-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr938-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #938
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---

### deferred (top by priority; foreman auto-promotes when idle)
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
- [`endojs-endo-but-for-bots-pr945-review-e4e7a891-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr945-review-e4e7a891-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #945 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr877-review-a8763cf9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr877-review-a8763cf9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #877 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1125-review-da14cc53-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-da14cc53-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-b58d5a3f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-b58d5a3f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
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

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endo-sturdyref-agent-surface-gauntlet-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-gauntlet-20260901.md) — awaiting `endojs-endo-but-for-bots-pr871-weave-20260901` · Run the gauntlet for endojs/endo-but-for-bots#871 (sturdyref agent surface)
- [`build-minion-town-invitation-onboarding`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-onboarding.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1125` · Build invitation-only guest onboarding for minion.town
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-cosgov kriscendobot-ocapn kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 3 gardeners
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 gardeners
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): 8 gardeners
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): 1 gardeners
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 4 gardeners
