---
role: assayer
tier: minion
model-burned: mentor
provider: anthropic
lane: pty
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
dispatch: automatic
fallback-tier: 
---

# Interactive pty-lane self-validation for garden PR #81 (host-pinned to a deployed host)

You are a test job dispatched to validate the experimental `lane: pty`
interactive context-introspection lane merged in kriscendobot/garden PR #81
(merge commit `4767705b28d`). This job is PINNED via `requires: host=` to a host
whose deployed garden already contains that merge, so the handler's `lane: pty`
branch is live and you should be running inside a driven pseudo-terminal, NOT a
headless `claude -p` fallback. Do real work, prove you are genuinely in the pty
lane, and report evidence. Run everything from your per-job worktree; never run
git in the deployed garden root. Do NOT modify any tracked file, open any PR, or
post any GitHub comment — your only deliverable is your stdout completion report.

Resolve the deployed garden root robustly instead of hardcoding a path: run
`root="$(source "${GARDEN_ROOT:-/home/kris/garden2}/scripts/jobs/common.sh" 2>/dev/null; printf '%s' "$GARDEN_ROOT")"`
and use `$root` for all deployed-tree references below (fall back to
`$GARDEN_ROOT` if set in your environment).

Perform these steps and record concrete evidence for each. Keep a running
PASS/FAIL tally; a required assertion that fails must flip the final outcome to
FAILED.

1. **Identify host + deployed SHA.** Source the deployed
   `$root/scripts/jobs/common.sh` and report `deployed_sha` and this worker's
   `GARDEN` identity (`hostname -s` fallback). Confirm
   `git merge-base --is-ancestor 4767705b28d <deployed_sha>` succeeds (run git
   only inside your per-job worktree after fetching origin/main2; never in the
   deployed root). Record all verbatim.

2. **Prove the interactive pty lane (REQUIRED).** The definitive behavioral proof
   is that Claude Code's statusLine fires — which only happens inside the driven
   pty session, never in a headless `claude -p`. Concretely:
   - Record `GARDEN_JOB_BASE` (the lane discriminator, exported by the spine),
     `GARDEN_STATE`, and `GARDEN_PTY_REPORT_FILE`. `GARDEN_PTY_REPORT_FILE` is
     exported ONLY by `pty-lane/run.sh`, so a non-empty value is strong evidence
     you are in the lane. Also print `GARDEN_PTY_LANE` and state whether it is set
     (the deployed lane does NOT export it; per
     `designs/pty-context-introspection-lane.md` the discriminator is
     `GARDEN_JOB_BASE` and the proof is a fresh reader figure — do not fail solely
     because `GARDEN_PTY_LANE` is unset).
   - The REQUIRED assertion for "genuinely in the pty lane" is step 4 returning a
     FRESH figure (exit 0). If the reader returns absent (exit 2) or stale
     (exit 3), you are NOT in the interactive lane — that is a FAIL.

3. **Do useful work: inspect the deployed PR #81 implementation and run its
   hermetic test.** Read the deployed lane sources under `$root/scripts/jobs/pty-lane/`
   (`run.sh`, `run.py`, `statusline.sh`) and `$root/scripts/jobs/pty-context-read.sh`,
   and briefly describe what each does (2–3 sentences total). Then run
   `bash $root/scripts/jobs/test/pty-context-test.sh` and report its exact pass
   count and whether it exited 0. Quote the final `PASS/FAIL` summary line.

4. **Read your live context figure through the reader (REQUIRED).** While your
   interactive session is alive, invoke
   `$root/scripts/jobs/pty-context-read.sh "$GARDEN_JOB_BASE" --format json` and
   record its exit code and full JSON output. Also run `--format env` and record
   `used_percentage`, `input_tokens`, `output_tokens`, `context_window_size`,
   `epoch`, and `age_seconds`. If the reader returns exit 2 (absent), the
   statusLine has not fired yet — wait a short bounded interval (poll every ~10s,
   up to ~90s total, doing light real work between polls so the session stays
   active and the statusLine refreshes) and retry before concluding. Exit 0 with a
   fresh figure is the required PASS.

5. **Report.** In your stdout completion report clearly state: worker host (GARDEN
   identity) and deployed SHA; whether the pty lane was genuinely selected, with
   the evidence (`GARDEN_PTY_REPORT_FILE` presence + the reader's fresh exit-0
   figure); the `pty-context-test.sh` pass count and pass/fail; the context-reader
   result (exit code plus the context fields); and the final outcome: PASSED (both
   required assertions held) or FAILED (with which assertion failed).

If ANY required assertion fails (the reader never returns a fresh exit-0 figure,
or `pty-context-test.sh` does not fully pass), emit the exact line
`<<<GARDEN-ORCHESTRATION-FAILED>>>` immediately BEFORE your completion signal.
Then, in all cases, emit `<<<GARDEN-JOB-COMPLETE>>>` as the very last line.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-29T02:23:06Z -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T02:40:13Z
