---
role: assayer
tier: mentor
provider: anthropic
lane: pty
handler-timeout: 7200
dispatch: automatic
fallback-tier: minion
---

# Interactive pty-lane self-validation for garden PR #81

You are a test job dispatched to validate the experimental `lane: pty`
interactive context-introspection lane merged in kriscendobot/garden PR #81
(merge commit `4767705b28d`). Do real work, prove you are genuinely in the
interactive pty lane (not a headless `claude -p` fallback), and report evidence.
Run everything from your per-job worktree; never run git in the deployed garden
root. Do NOT modify any tracked file, open any PR, or post any GitHub comment —
your only deliverable is your stdout completion report.

Perform these steps and record concrete evidence for each. Keep a running
PASS/FAIL tally; a required assertion that fails must flip the final outcome to
FAILED.

1. **Identify host + deployed SHA.** Source the DEPLOYED
   `/home/kris/garden2/scripts/jobs/common.sh` and report `deployed_sha` and this
   worker's `GARDEN` identity (`hostname -s` fallback). Record both verbatim.

2. **Prove the interactive pty lane (REQUIRED).** The definitive behavioral proof
   is that Claude Code's statusLine fires — which only happens inside the driven
   pty session, never in a headless `claude -p`. Concretely:
   - Record `GARDEN_JOB_BASE` (the lane discriminator, exported by the spine),
     `GARDEN_STATE`, and `GARDEN_PTY_REPORT_FILE`. Note that
     `GARDEN_PTY_REPORT_FILE` is exported ONLY by `pty-lane/run.sh`, so a
     non-empty value is strong evidence you are in the lane. Also print the value
     of `GARDEN_PTY_LANE` and state explicitly whether it is set (the deployed
     lane does NOT export a `GARDEN_PTY_LANE` variable; per
     `designs/pty-context-introspection-lane.md` the discriminator is
     `GARDEN_JOB_BASE` and the behavioral proof is a fresh reader figure — do not
     fail solely because `GARDEN_PTY_LANE` is unset).
   - The REQUIRED assertion for "genuinely in the pty lane" is step 4 below
     returning a FRESH figure (exit 0). If the reader returns absent (exit 2) or
     stale (exit 3), you are NOT in the interactive lane (or the statusLine never
     fired) — that is a FAIL of this required assertion.

3. **Do useful work: inspect the deployed PR #81 implementation and run its
   hermetic test.** Read the deployed lane sources under
   `/home/kris/garden2/scripts/jobs/pty-lane/` (`run.sh`, `run.py`,
   `statusline.sh`) and `/home/kris/garden2/scripts/jobs/pty-context-read.sh`, and
   briefly describe what each does (2–3 sentences total). Then run
   `bash /home/kris/garden2/scripts/jobs/test/pty-context-test.sh` and report its
   exact pass count and whether it exited 0 (all pass). Quote the final
   `PASS/FAIL` summary line.

4. **Read your live context figure through the reader (REQUIRED).** While your
   interactive session is alive, invoke
   `/home/kris/garden2/scripts/jobs/pty-context-read.sh "$GARDEN_JOB_BASE" --format json`
   and record its exit code and full JSON output. Also run it with `--format env`
   and record the `used_percentage`, `input_tokens`, `output_tokens`,
   `context_window_size`, `epoch`, and `age_seconds` fields. If the reader returns
   exit 2 (absent), the statusLine has not fired yet — wait a short bounded
   interval (poll every ~10s, up to ~90s total, doing light real work between
   polls so the session stays active and the statusLine refreshes) and retry
   before concluding. Exit 0 with a fresh figure is the required PASS.

5. **Report.** In your stdout completion report state, clearly:
   - worker host (GARDEN identity) and deployed SHA;
   - whether the pty lane was genuinely selected, with the evidence
     (`GARDEN_PTY_REPORT_FILE` presence + the reader's fresh exit-0 figure);
   - the `pty-context-test.sh` pass count and pass/fail;
   - the context-reader result: exit code plus the context fields
     (used_percentage, tokens, window size, age);
   - the final outcome: PASSED (both required assertions — step 2/4 fresh figure,
     and step 3 test all-pass — held) or FAILED (with which assertion failed).

If ANY required assertion fails (the reader never returns a fresh exit-0 figure,
or `pty-context-test.sh` does not fully pass), emit the exact line
`<<<GARDEN-ORCHESTRATION-FAILED>>>` immediately BEFORE your completion signal.
Then, in all cases, emit `<<<GARDEN-JOB-COMPLETE>>>` as the very last line.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T23:22:59Z
