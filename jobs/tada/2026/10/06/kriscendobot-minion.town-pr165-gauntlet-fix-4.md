I applied the round-4 panel's must-fix items to kriscendobot/minion.town#165 and pushed them, and CI is green. But the next panel will still return must-fix, because the phase-evidence gate blocks this PR whatever its disposition says.

**Code fixes**, pushed with `safe-push-pr-head.sh` (head d136726 → 96e1b18):
- `b61e5d5` `test(claude): property-test formulaIdOf's hint invariance`
  - **Fast-checker:** `formulaIdOf` is now exported, and a new fast-check property tests its documented contract: a locator names the same formula with or without `@`-joined connection hints.
  - **Stylist:** renamed `sync` to `synchronized` in the test's mock mailbox reader.
- `96e1b18` `docs(claude): list the inbox responder knobs in .env.example`
  - **Surfacer:** added `ENDO_CLAUDE_RESPONDER_STATE_PATH` and `ENDO_CLAUDE_RESPONDER_ENDPOINT` to `.env.example`, with their production defaults.
- The responder caplet tests (4/4) and `tsc --noEmit` pass.

**PR body changes:**
- **Integrator:** the "Out of scope" sentence now says what really happens: an existing child can't be opted in where it is. Its holder has to dismiss it, losing its mailbox and namespace, and create it again.
- **Integrator (should-fix):** the body now records that the per-child tunable rate cap is deferred.
- **Pruner:** the "What to attend to" section is cut from about 250 words to about 75, and "Out of scope" is folded into it. The whole body is still about 440 words, over the 300-word target, because the phase-evidence ledger is required by the gate and stays.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0; all 3 checks passed.

**Why panel-5 will fail again:** `phase-evidence-gate.sh` blocks a `deliverable` disposition while design Phase 1 is blocked and Phases 3–6 and Acceptance are open. In panel mode it also always blocks a `non-deliverable-probe` disposition. Rounds 3 and 4 both failed on this, so more fix rounds can't clear it. I left the disposition as `deliverable` and the PR as a draft, which is one of the two options the integrator offered. I've messaged the maintainer (msg-kriscendobot-minion.town-pr165-gauntlet-fix-4-fd2c6dcf128f) to decide between:
- parking the gauntlet until Phase 1 lands and the production observations (the root canary and the inbox-watch acceptance runs) are recorded, or
- reclassifying the PR as a probe.

**Not done (should-fix and comment-only items):**
- **Breaker #1/#2 (should-fix):** removing the `message-N` marker after dismiss. That would delete the only record of the effect, which the live-daemon test reads, so it needs a design decision.
- **Breaker #3 (should-fix):** a message longer than about 16 KB is silently consumed.
- **Breaker #4 (comment-only):** the rate window is charged before the live-child check.
- **Prover (should-fix):** no test covers the admission-window pruning loop.
- **Typist (should-fix):** the `provideChild` JSDoc makes an untested claim that `withInboxPins` has no effect on an existing child.
- **Integrator #3 (should-fix):** making the rate cap tunable through `create`. It is only recorded as deferred.
- **Integrator #5 (comment-only):** squash the follow-up commits before the PR leaves draft.
- **Prettier:** reports a style issue in `inbox-responder-caplet.ts`, but the file already had it before this round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2431431 cached reads)
- Output: 12692 tokens
- Cost: $1.3953902000000002
- Wall-clock: 1152s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
