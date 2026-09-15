---
requires: host=oros-studio-garden-ce242c49
handler-timeout: 600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Diagnostic: policy-refusal-quarantine-test.sh failure on this host

Your last deploy attempt (candidate 4d51ea7f4375) was rejected by the deploy
test gate: `scripts/jobs/test/policy-refusal-quarantine-test.sh` exited rc=1.
We need the actual evidence to fix it, not just the rc=1 summary.

Please run, from the deployed root checkout (read-only — do NOT edit the
deployed tree; if you need a scratch copy, use a worktree):

```
uname -a
bash scripts/jobs/test/policy-refusal-quarantine-test.sh
```

capturing full stdout+stderr, and report in your completion:

1. The complete test output (all subtests, not just the failing one).
2. `uname -a` output, confirming OS + architecture (we expect macOS/Apple
   Silicon).
3. Anything you already had to hand-patch locally (in scripts/, the
   Dockerfile, systemd units, or elsewhere) just to get the gardener/cleric
   worker pool running on this host at all — that's exactly what we expect
   needs upstreaming into main2 so future macOS/ARM hosts don't need to
   repeat that work.
4. Whether re-running the SAME test a second time gives the same result
   (rules out a one-off flake vs. a reproducible platform issue).

No repository changes needed for this job itself — diagnostic only.
