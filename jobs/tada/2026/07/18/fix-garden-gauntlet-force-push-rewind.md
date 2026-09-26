Inbox is empty. Work complete.

## Completion report

**Job:** fix-garden-gauntlet-force-push-rewind — close the branch-rewind hazard where a gauntlet force-pushes over a peer's newer commits (endojs/endo-but-for-bots #792).

**Root cause found:** The fleet's job scripts had **no literal `git push --force`/`+refspec` targeting a project PR head** — the docs already recommend `--force-with-lease`, and `garden-pr.sh`'s push stage was an *elided scaffold comment* (`# git -C "$wt" push --force-with-lease ...`). The actual rewinding force-push was done ad hoc by the supervising gardener/fixer. The real gap was the absence of a deterministic, safe push path with a behind-the-live-head guard.

**What I did:**

1. **New helper `scripts/jobs/gardening/safe-push-pr-head.sh`** — the deterministic safe push:
   - Fetches the live PR head **fresh** immediately before pushing (so the lease can't rot against a stale worktree ref).
   - **Ancestry gate:** refuses (exit 3) when the outgoing HEAD is an **ancestor of** (strictly behind) the live head — the exact #792 case — in *every* mode; a rewind is never allowed.
   - Pushes with `--force-with-lease=<branch>:<freshly-fetched-sha>`, guarding the fetch→push race window.
   - Two modes: `advance` (default; history-preserving — also refuses a *diverged* head, telling the caller to rebase onto the live head) and `rewrite` (allows a divergent rebase/retcon but still refuses a strictly-behind head). Handles brand-new-branch creation and up-to-date no-ops.

2. **Wired it into `scripts/jobs/gardening/garden-pr.sh`** — replaced the elided push comment with a real `advance`-mode call gated on `GARDEN_PR_REMOTE`/`GARDEN_PR_HEAD` (skipped when unset, so the scaffold/tests stay clean); a refusal `fail`s loudly so the supervisor rebases rather than clobbers.

3. **Documented the hazard and helper** in `skills/pr-creation-flow/SKILL.md` pitfalls, directing every head push (state-machine CI push + `GARDEN_PANEL_FIXER`-wired follow-ups) through the helper and forbidding `--force`.

4. **Hermetic regression test `scripts/jobs/test/safe-push-pr-head-test.sh`** (style of `auto-gauntlet-handoff-test.sh`): reproduces the #792 ancestor-rewind on throwaway git fixtures and asserts the live head is left intact, plus fast-forward/no-op/diverged/create cases across both modes — 7 checks, all passing.

**Verification:** new test passes; `auto-gauntlet-handoff-test.sh` still passes; `garden-pr.sh` smoke-runs with the push correctly skipped when no remote is wired; syntax-checked both scripts.

**Committed & pushed:** `4a2a3a2882` on `main2` (rebase-CAS push, first attempt).

**Follow-ups (optional):** The `advance`-mode invariant is enforced deterministically only when a supervisor exports `GARDEN_PR_REMOTE`/`GARDEN_PR_HEAD`; project-specific fixer handlers that push heads outside `garden-pr.sh` should be migrated to call `safe-push-pr-head.sh` too (documented, not yet mechanically enforced since those handlers are project-wired stubs today).
