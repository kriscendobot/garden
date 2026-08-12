Job complete. Here is my report.

---

## Completion report: `improve-automate-stale-dependabot-rebase`

**What the job asked:** Replace the rebase-stage placeholder in `scripts/jobs/gardening/garden-pr.sh` with a deterministic fresh-base/head check and safe rebase path, so the routine stale-branch recovery (as done by hand for the approved Dependabot PR endojs/endo-but-for-bots#868) is automated — while failing closed for non-deterministic conflicts.

**What I did**

- **New helper `scripts/jobs/gardening/safe-rebase.sh`** — the deterministic rebase stage, mirroring the shape/quiet-on-success/exit-code discipline of its sibling `safe-push-pr-head.sh`:
  1. **Fresh-base/head check** by ancestry. Optionally fetches the base branch fresh (`GARDEN_BASE_REMOTE`/`GARDEN_BASE_BRANCH`) so freshness is tested against the live base. A branch already carrying the base tip is a **quiet no-op**.
  2. **Rebase** replays the reviewed commits onto the fresh base. Clean → done.
  3. **Lockfile-only recovery** — the one conflict class git can resolve mechanically: if every conflicted path *and* the stopped commit are lockfile-only (the `yarn-lock-separate-commit` discipline guarantees the lockfile lives in its own commit), `git rebase --skip` drops the stale lockfile commit; the loop continues. **Any other conflict** (a code file, or a lockfile commit carrying non-lockfile changes) → `git rebase --abort` and **REFUSE (rc 3)** for a weaver/fixer.
  4. **Regenerate** the dropped lockfile against the new base and commit it as its own `chore: Update yarn.lock` (via `GARDEN_LOCKFILE_REGEN`, or a detected corepack yarn/pnpm/npm install). Regeneration failure is fail-closed (rc 3) — the worktree is left un-pushed, so nothing broken reaches the remote.
  - An unresolvable *local* base ref (e.g. the scaffold's default `HEAD~1` on a single-commit branch) is a quiet skip, not a wedge; the loud fetch-failure path covers a genuinely misconfigured remote base.
- **Wired it into `garden-pr.sh`** (`GARDEN_SAFE_REBASE`, default `safe-rebase.sh`), replacing the no-op placeholder; on rc 3 the gauntlet stops with a clear "needs a weave/rebase by hand" message before any push.
- **Hermetic test `scripts/jobs/test/safe-rebase-test.sh`** (5 cases, all pass): already-fresh no-op; clean replay preserving reviewed commits; lockfile-only conflict recovered (reviewed code commit survives, lockfile regenerated, exactly one lockfile commit at tip); code conflict REFUSED with the worktree left unchanged (no half-applied rebase); unresolvable-base skip. Includes the same `noexec`-`/tmp` exec-base probe the existing harness uses.
- **Docs:** updated `designs/gardening-state-machine.md` (stage 1 + the closing "placeholders" paragraph, since rebase and push are now real helpers) and added a pointer in `skills/yarn-lock-separate-commit/SKILL.md` § Rebase recovery.

**Verification:** new test green (5 checks); `safe-push-pr-head-test.sh` still green (7 checks, no regression); `tests/checks/run.sh` green (7 suites). Committed and pushed to `main2` as `b63befa87e`.

**Note:** early on I edited the design doc against the deployed root path by mistake; I reverted the root copy to byte-identical original (verified via `diff` against the worktree's committed version, no git run in the root) and applied the change in the worktree instead. Worktree clean; deployed root untouched.

**Possible follow-up (not blocking):** a rebase that stops on a *now-empty* commit (rather than a conflict) is treated as non-deterministic and refused — deliberately conservative; if that shape shows up in practice it could be extended to `--skip` empty commits too.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-automate-stale-dependabot-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (4423005 cached reads)
- Output: 38908 tokens
- Cost: $4.5059724999999995
- Wall-clock: 539s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
