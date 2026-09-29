The deliverable from my prior session is fully landed: working tree clean, and commit `27d21c86146` is contained in `origin/main2` (with one unrelated newer commit on top). Nothing remains to do — this requeue raced my earlier completion. Final report:

## Completion report

**Verdict: CONFIRMED.** I re-derived the design's central claim directly on this host rather than trusting the cited pass counts. Codex-cli 0.156.0 (installed) exposes `codex exec resume [SESSION_ID] [PROMPT]` — a session id plus a new prompt, exactly the primitive `designs/non-claude-completion-nudge-parity.md` describes — and the cleric handler already used it for requeue resume. Kimi Code 2.0.2 (installed) exposes `--continue` / `--session [id]` combinable with headless `--prompt`, and the mystic handler's private per-job `KIMI_CODE_HOME` scopes `--continue` to exactly this job's session. `GARDEN_APPLIED_HANDLER_BUDGET` is exported to every handler by `gardener.sh`, as the design's admissibility check assumes. Same-session continuation is a handler parity gap, not a backend capability gap: the design holds.

**Implemented and landed** as `27d21c86146` on `main2` (verified present on `origin/main2` this session):

- `scripts/jobs/handlers/worker-common.sh`: shared nudge policy — `GARDEN_COMPLETION_NUDGES` (default 1), a new `GARDEN_COMPLETION_NUDGE_MIN_SECONDS` remaining-wall-time floor (default 300s), and the shared `worker_unfinished_marker` helper, so backends cannot drift.
- `monk-claude.sh`: adopts the shared helpers; gains the wall-time floor alongside its existing per-call dollar floor.
- `cleric-codex.sh`: after a clean markerless exit, one bounded `codex exec resume <sid>` with the honest `continue` framing; two-call token rows summed; a failed nudge restores the first report and the ordinary exit-0 requeue (never a fresh-session fallback); the unfinished-end-turn marker selects `continue` framing on the next same-host claim.
- `mystic-kimi.sh`: same shape via a second `--continue --prompt` call in the job's private home; the usage snapshot now spans both turns; continue framing on resume.
- `opencode.sh`: same shape via `opencode run --session <sid>` — inert while the lane stays disabled pending its paid canary, per the design's own recommendation.
- `skills/job-board/SKILL.md`: the nudge is documented as every worker handler's behavior, not the monk's alone.

**Bonus defect fixed** (exposed by the new test): the cleric usage extraction indexed the jq-slurped event array with `.payload` — always an error, swallowed by `|| true` — so the codex lane had never captured a token row from a real multi-event stream. Fixed to `.[]`.

**Testing before push**: new `codex-completion-nudge-test.sh` 21/21; kimi harness extended to 53/53 (including its real-gardener-spine subtest); opencode harness extended to 15/15; regressions green — completion-signal 35/35, codex-policy-refusal-resume 7/7, fireworker 15/15. Two suites fail/hang **identically on pristine `origin/main2`** (verified against a clean `git archive` baseline): `gardener-worktree-test.sh` (its fixture copies `common.sh` without the `scripts/jobs/bin` dir common.sh now requires) and `worker-ensure-worktree-test.sh` (hangs with zero output) — pre-existing, not caused by this change.

**Follow-ups**: (1) repair `gardener-worktree-test.sh`'s fixture (copy `scripts/jobs/bin/`) and investigate the `worker-ensure-worktree-test.sh` hang — both pre-existing. (2) Live acceptance (one markerless-then-completing run on the active codex and kimi lanes) will surface in normal fleet operation; the `completion_nudges` field in the usage handoff makes those runs identifiable. (3) OpenCode acceptance stays gated on its existing paid canary. This requeue was a race with the prior attempt's completion; no new work was needed beyond verifying the landed state.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/confirm-implement-nudge-continue-parity-mentat-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 4 tokens (452400 cached reads)
- Output: 2203 tokens
- Cost: $17.495392000000006 (1 engagement(s) unpriced)
- Wall-clock: 2501s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
