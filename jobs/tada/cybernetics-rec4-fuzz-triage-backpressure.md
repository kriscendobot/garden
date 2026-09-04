No pending messages. The job is complete.

## Completion report

Implemented recommendation 4 of `designs/cybernetics-audit.md` § 7 by realizing `designs/ironhorse-fuzz-triage-and-batch.md` in the producer **before** the lane is ever un-paused. Landed bare on `main2` (commit `aa028b78e1`); no open maintainer question surfaced, so no review PR. The fuzz lane stays paused — `garden-ironhorse-fuzz.{timer,service}` remain in `EXCLUDED_UNITS` (unchanged).

**What changed (5 files, +952/−154):**

- `scripts/jobs/ironhorse-fuzz.sh` — three producer-side controllers now sit between capture and release:
  1. **Triage stage.** Capture still records finding markers; release no longer opens a per-finding repair. The producer releases a bounded **triage job** (≤12 oldest untriaged markers, one target) that writes durable `ironhorse-fuzz/triage/<id>.md` records (`status: pending|genuine|artifact|duplicate`). Only genuine findings are **batched** into clusters (≤8 sharing a root signature) → one **cluster repair** per generation amends the one standing PR (`ironhorse-fuzz/clusters/<id>.md`). A finding already triaged (even `pending`) is never auto-re-triaged.
  2. **Doom-signature feedback** (the reaper's `doom_signature` had zero readers): the producer scans doom-parked jobs per target and stops that target's release once N same-signature dooms accumulate (default 3), depth-independent — the policy-refusal cluster is the stop signal. Attribution reads a machine-readable target marker in the bodies, with a finding-marker fallback for legacy repairs.
  3. **Hysteretic band** (the only one in the repo): counts nonterminal findings before fuzzing; high water 24 total / 8 per target stops all runs, resume only below 12 total **and** 4 per target; state persists to `ironhorse-fuzz/backpressure.md`, written only on a flip; self-reverts to 24/8 over 12/4 if an override inverts the ordering; still releases one triage/cluster job while stopped so the backlog drains.
- `scripts/jobs/ironhorse-fuzz-migrate-backlog.sh` (new) — one idempotent journal CAS op (its own clone, never the deployed root's journal worktree) that supersedes every legacy `ironhorse-fuzz-<id>-repair` and the `repromote-quarantined` job without deleting any finding marker, seeds a `pending` triage record for each unresolved finding, and writes `ironhorse-fuzz/migrations/triage-batch-v1.md`. It is a CAS over board files, **not** a promoter, and fails closed on a missing marker or a legacy job live in `doin/`.
- `scripts/jobs/test/ironhorse-fuzz-test.sh` — reworked to the triage-and-batch contract and grown to **73 assertions** (Q backpressure band, R doom feedback, S migration idempotency + fail-closed, T paused-lane guard); rebased cleanly over an intervening upstream commit that added test P.
- `scripts/jobs/test/ironhorse-fuzz-rehearsal.sh` — narrates the triage flow.
- `context/operations/ironhorse-fuzz.md` — documents the controllers, new journal state, and the deliberate re-arming sequence.

**Verification:** 73/73 hermetic assertions pass; rehearsal passes; `bash -n` + `shellcheck -S error` clean; pre-push probes pass (the typist auto-fixer rewrote arrows/comparison glyphs in the doc to ASCII). Confirmed on `origin/main2`: migration script present, EXCLUDED_UNITS still lists the fuzz lane.

**Deliberately NOT done (these are re-arming steps, a maintainer act):** I did not execute the migration against production `journal2` (re-arm step 2), did not remove the EXCLUDED_UNITS entry, and did not enable the timer. The operator doc's "Re-arming" section captures the ordered sequence (deploy → run migration below low water → un-exclude + deploy → enable).

**Follow-up:** the per-target diagnostic adapter that computes `failure_kind`/`failure_site`/`semantic_relation`/`root_signature` and the deterministic matchers for the three proven artifact families are the LLM triage job's internal work (engine-specific, not producible deterministically here); the producer owns the whole deterministic control loop and reads the records those jobs write.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cybernetics-rec4-fuzz-triage-backpressure.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 153 tokens (15497464 cached reads)
- Output: 108751 tokens
- Cost: $14.118185000000004
- Wall-clock: 1481s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
