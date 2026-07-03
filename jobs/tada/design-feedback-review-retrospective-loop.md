Design landed on main2, result journaled. Completion report follows.

Completed job `design-feedback-review-retrospective-loop`: authored and landed the double-loop retrospective design on `main2`.

**What I did**
- Verified current state on `main2`: read `scripts/jobs/comment-watcher.sh` end to end (deterministic classifier, review-id fold, directive identity, post-verify/cursor discipline), `roles/mentor/AGENT.md` + `scripts/jobs/mentor.sh`, `skills/panel/SKILL.md`, `skills/panel-hints/SKILL.md`, `skills/context-library/SKILL.md`, `skills/job-board/SKILL.md`, `skills/journalism/SKILL.md`, `skills/model-selection/SKILL.md`, `scripts/jobs/foreman.sh` (deferred-plan promotion), `roles/COMMON.md`, and the journal2 top-level tree.
- Landed `designs/review-retrospective-loop.md` plus a `designs/README.md` index row, commit `63fdd9799` on `main2` (two CAS rebase retries against concurrent mentor-related pushes).
- Journaled the `result` entry (`entries/2026/07/03/055913Z-result-gardener-3eb31c.md`).

**Design choices (the six questions)**
1. **Dispatch + gate**: the comment-watcher mints `<primary-base>-retro` right after the primary post verifies, gated deterministically to `VERB=review` and `attention`-with-`reads_as_directive` (no LLM in the watcher, preserving the 2026-07-01 directive); the subjective "should review have caught this" discriminator runs inside the claimed job with recorded grounds.
2. **Store**: journal `review-misses/{misses,dismissed,clusters}/` (CAS-append evidence belongs in the journal, not the curated library or deployed main2), records keyed on the primary job base for free idempotency, bodies are the prosecutor's paraphrase so raw untrusted comment text never propagates; 14-category taxonomy mapped to juror seats.
3. **Threshold**: K≥3 misses across ≥2 PRs, or one `major` miss that violated an already-standing rule; judgment above the floor, `threshold_rationale` always recorded; event-driven evaluation at the tail of each retro; status + identity dedup prevent double-dispatch; recurrence after closure reopens and escalates to the maintainer.
4. **Improvement dispatch**: one `review-improve-<cluster>` builder-tier job with a mandatory dual contract — prevention (narrowest governing artifact, deterministic gate preferred) and review-sensing (seat-brief line + panel-hints probe in the same commit, or a pre-push gate; new seat only as last resort) — verified by a per-member re-litigation test against historical diffs.
5. **Reconciliation**: three non-overlapping loops by signal source — self-improvement (own friction, per job), mentor (automation telemetry), prosecutor (maintainer feedback on work products); panel-hints is the actuator, not a fourth loop.
6. **Cost**: verb-class filter, one-retro-per-review via the existing fold, `gate: deferred`/`priority: low` plan jobs the foreman promotes only on fleet slack, fleet-default model tier, cheap one-pass dismissal; per-repo rate cap noted as a follow-on.

**Notable discovery / follow-ups**
- `skills/self-improvement/SKILL.md` is a dangling reference: `roles/COMMON.md` and `roles/mentor/AGENT.md` cite it, the v1 reference README claims it was adopted, but the file does not exist on `main2` — the build plan's stage 0 repairs it.
- The build (5 stages: repair self-improvement → store/skill/role → watcher wiring → threshold/dispatch → observability) is a separate job blocked on this design, to be run as a serial orchestration per the standing multi-part pattern.
