Both failures are fixed and pushed; `4b0f53c918` is contained in `origin/main2`.

**What I did**

Fixed the two pre-existing `tests/checks/run.sh` failures. Full suite now reports **7 suites passed, 0 failed** (was 5/2).

**`test_run_all.sh` — 2 claude-stub assertions**

Root cause was not the assertions but the fixture: the stub was written under `mktemp`'s default base (`/tmp`), which the container mounts **`noexec`**. Bash's PATH search probes with the equivalent of `[ -x ]`, which honors `noexec`, so the stub was invisible and `run-all.sh` fell through to the **real `/usr/bin/claude`** — the non-dry subtest was spawning a live agent and burning tokens on every suite run (I caught it mid-repro answering the prompt), while both assertions still failed with no hint why.

- Added the house `pick_exec_base` probe (same pattern as `claude-bin-resolver-test.sh` / `gardener-worktree-test.sh`) so the fixture lands on an exec-capable filesystem.
- Added a **fail-closed guard** asserting the stub actually wins PATH resolution *before* any non-dry subtest can dispatch. Verified non-vacuous: with an unexecutable stub it fires (`resolved=/usr/bin/claude`), and with `GARDEN_TEST_TMP=/tmp` the probe correctly skips `noexec` and falls through to `/var/tmp`.

**`test_maintainer_inbox_information_hiding.sh` — allowlist drift**

The live drift was wider than the spec listed (`main2` had moved): `roles/COMMON.md` and `roles/botanist` were also offending. Decided per reference on one rule — *a file may carry a maintainer-inbox token only if every role that reads it is free-standing*:

- **Allowlisted** — `roles/orchestrator/AGENT.md` (added `orchestrator` to `FREE_STANDING_ROLES`: an orchestration drives a job tree on the board, not an issue/PR, and its documented definition-of-done surfaces halts to the maintainer), `skills/orchestration/SKILL.md`, `skills/restore/SKILL.md` (liaison-only; it operates *on* the inbox, acking POISON).
- **Scrubbed** — `roles/COMMON.md` (every gardener reads it, scoped ones included); `roles/botanist/AGENT.md` + `skills/schedule/SKILL.md` (the botanist is PR-scoped and must keep loading `schedule` for EMBARGO deferrals); `roles/prosecutor/AGENT.md` + `skills/review-retrospective/SKILL.md` (the prosecutor is scoped to one PR's review and cannot stop loading its own primary skill). In each case the maintainer escalation is rerouted to the job report, which the supervising gardener carries onward.

Mirrored the widened allowlist into the test's `ALLOWLIST` array. Shellcheck clean on all three shell files.

**Follow-ups**

1. **Worth a look:** `run-all.sh` has no fail-closed backstop of its own — the protection I added lives in the test. A gate runner that dispatches `claude -p` unconditionally is one bad fixture away from a repeat; a `GARDEN_TEST`-aware refusal in `run-all.sh` would match the philosophy already stated in `tests/checks/run.sh`'s header, but it would invert this suite's subtest 4, so it needs a deliberate design call rather than a drive-by change.
2. **Unrelated, flagging only:** `git fetch` in the shared repo emitted `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6` / `failed to run repack`, with a stale `/home/kris/garden2/.git/worktrees/.../gc.log` blocking automatic cleanup. Pre-existing and not something I touched — repo-health work in the garden root is off-limits to me.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-fix-identity-drift-guard-test-inbox-leak-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 77 tokens (3374457 cached reads)
- Output: 31591 tokens
- Cost: $3.4429384999999995
- Wall-clock: 493s

<!-- garden-usage-end -->
