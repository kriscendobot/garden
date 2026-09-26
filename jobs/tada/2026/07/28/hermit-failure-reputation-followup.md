Inbox empty. The job is complete and pushed to main2.

## Completion report

**Built the hermit-failure capability probe + verified demerit** (maintainer directive 2026-07-27), landed on `origin/main2` as commit `d9a9a0cc62` (direct push, no PR per CLAUDE.md).

**What it does:** when a local/ollama (hermit) worker *deterministically* fails a job, a bounded, measurement-only follow-up re-attempts the same work on a capable reference model (claude). If the capable model completes what the hermit couldn't, a **verified demerit** is recorded against the local arm's reputation, driving its `acceptance_rate` down for that (model=local, harness=hermit, work-class×target) tuple — the signal future routing reads to learn which job classes local inference is unfit for.

**Changes:**
- `scripts/jobs/reputation.sh` — `rep_record_demerit` / `rep_demerit_event_relpath` / `GARDEN_REP_DEMERIT_SUFFIX`: writes an `accepted:false`, non-censored event under a demerit-suffixed base so it never collides with a later completion event for the same base; the reducer folds it as an un-accepted attempt.
- `scripts/jobs/hermit-capability-probe.sh` (new) — the bounded probe. Guards: hermit-only, once-per-base (committed probe marker dedups across requeues), single `timeout`-wrapped attempt per agent, skipped under the fleet brake (budget freeze), and **measurement-only** (isolated throwaway worktree, prompt forbids push/PR/board/ferry/messaging) so it never double-runs live work. `GARDEN_HERMIT_PROBE=0` kill switch.
- `scripts/jobs/gardener.sh` — invokes the probe from the **hermit real-failure branch only** (transient/environmental/timeout failures are excluded — they don't indict the model).
- `designs/hermit-failure-capability-demerit.md` (new) — rationale, feeding the sibling `gnome-backend-verified-autotune.md` routing/provisioning design (which I discovered is a pre-existing, *unrelated* design that I preserved intact rather than clobbering the filename collision).
- `scripts/jobs/test/hermit-capability-probe-test.sh` (new) — 19 hermetic assertions: success→demerit, fail→no-demerit, dedup, guards (non-hermit + disabled), and the reducer folding the demerit to `acceptance_rate=0`.

**Verification:** new test 19/0, auction/reputation regression 43/0, worker-spine-kinds 136/0, CI-scoped shellcheck clean, `bash -n` clean across all scripts. The two failing check suites in `tests/checks/run.sh` are pre-existing (confirmed identical on the stashed clean tree) and unrelated (an unrelated-roles inbox-leak flag on the real tree, and a sandbox with no executable `claude`).

**Follow-ups:** consuming the signal is the open next step — bid-time it's automatic (the auction already draws from `acceptance_rate`); a hard `model_routing` gate and codex as a second probe agent (`GARDEN_HERMIT_PROBE_AGENTS`) are documented extension points. As noted in the spec, this won't exercise until hermits are re-enabled — it's the measurement that justifies re-enabling or retiring the local tier per job class.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/hermit-failure-reputation-followup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 141 tokens (10115985 cached reads)
- Output: 79921 tokens
- Cost: $10.4033625
- Wall-clock: 1489s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
