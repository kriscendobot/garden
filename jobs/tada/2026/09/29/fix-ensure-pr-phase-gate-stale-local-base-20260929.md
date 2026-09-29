I fixed the phase/evidence gate so it compares against `origin/<base>` instead of a stale local base branch, and pushed it to `main2` as commit `44f2e02c5c4`.

**Cause:** `ensure-pr.sh` looked for the local `<base>` branch first and only fell back to `origin/<base>` when there was no local one. Per-job project worktrees don't fast-forward local branches, so on endojs/endo-but-for-bots#1370 the local `llm` was behind `origin/llm`. Commits the base had gained since then showed up in the design-only PR's diff, and the gate demanded an implementation ledger.

**What changed:**
- **`scripts/jobs/gardening/ensure-pr.sh`:** the gate's `--base` now prefers `refs/remotes/origin/<base>` and falls back to the local ref only if the remote one doesn't resolve.
- **`scripts/jobs/gardening/phase-evidence-gate.sh`:** the gate itself now turns a bare `--base <name>` into `origin/<name>` when that ref resolves. This is the same rule `panel.sh` already applies, so any caller gets the fresh base. A base given as `origin/...`, a sha, or `HEAD~N` is used as given.

**Regression tests** (both build a worktree whose local base is behind `origin/<base>`):
- **`scripts/jobs/test/phase-evidence-gate-test.sh`:** a bare `--base llm` now returns `clear reason=design-only-diff`. A control check confirms the stale sha passed explicitly still blocks with exit 20, so the fixture really does reproduce the problem.
- **`scripts/jobs/test/ensure-pr-test.sh`:** runs `ensure-pr.sh` end to end with the real gate and checks that the design-only PR over the stale base opens.

**Test results:** both suites pass (16 checks and 38 checks). Against the old code, both new tests fail with the same `blocked ... missing-phase` verdict seen on #1370. The ensure-pr test also passes with only the `ensure-pr.sh` change in place, so either fix is enough on its own. shellcheck shows only two warnings, both in lines this change didn't touch.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-ensure-pr-phase-gate-stale-local-base-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1061067 cached reads)
- Output: 9489 tokens
- Cost: $0.8727694
- Wall-clock: 470s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
