## Completion report — `garden-fix-dispatch-prepare-journal-ref`

**Diagnosis confirmed.** `skills/dispatch-worktree/dispatch-prepare.sh` hardcoded the retired v1 branch names: `garden/` at `main` and `journal/` at `journal`. Under v2 the dev branch is `main2` (the root checkout is itself on `main2`) and the journal is the orphan `journal2`; the `journal` branch no longer exists, so every dispatch died at the `journal` worktree-add with `fatal: invalid reference: journal`, after the `garden/` add at the stale-but-extant `main` had already succeeded — leaving a garden-only orphan and never returning a `DISPATCH_ROOT` for teardown. Additionally, `main` is 268 commits diverged from `main2` (last touched Jun 23), so even the `garden/` add was silently checking out a stale role/skill tree.

**Resolution: Option 2 (make branches configurable), with v2-correct defaults.** Rationale: the path is still live — agents invoke `dispatch-prepare.sh` directly and the `gardener`/`liaison`/`boatman` role files still list the skill, and no script supersedes it — so retiring it (Option 3) would strand callers. A bare literal swap (Option 1) fixes only `journal` and leaves `garden/` on the stale `main`, and re-breaks on the next rename. Configurable env vars fix both failures and future-proof.

**Changes (committed `f65dd68bf`, pushed to `origin/main2`):**
- `skills/dispatch-worktree/dispatch-prepare.sh` — added `GARDEN_DEV_BRANCH` (default `main2`) and `GARDEN_JOURNAL_BRANCH` (default `journal2`); worktree-adds now use them; header comment updated; field note added to SKILL.md.
- `skills/dispatch-worktree/SKILL.md`, `roles/COMMON.md`, `CLAUDE.md` (dispatch prompt template) — swept the matching stale `main`/`journal` branch-name references to the v2 names.

**Verified:** `bash -n` clean; functional test created a valid triple (`garden`→local `main2`, `journal`→local `journal2`) with no `invalid reference`; `GARDEN_JOURNAL_BRANCH=journal-v1` override resolved correctly; teardown removed both; repo gate `scripts/checks/run-all.sh` passed. Built in an isolated worktree off `origin/main2` per garden-infra discipline (commit identity `endolinbot`); scratch torn down.

**Orphan sweep:** removed all six garden-only half-built triples (`designer--23837a`, `designer--93154f`, `fixer--804995`, `gardener--6de0ae`, `gardener--8bb704`, `gardener--ec9e2b`) via the teardown script and pruned their worktree registrations; `git worktree list` now clean of stale `/dispatches/` entries.

**Follow-ups:**
1. **Deploy-gated.** The fix is on `origin/main2` but the deployed root checkout still runs the buggy `dispatch-prepare.sh`, so new orphans can keep appearing until `scripts/jobs/deploy-garden.sh` advances this host. The `garden-upgrade-monitor` → liaison deploy-on-upgrade Monitor is the normal path; I did not force a deploy (it is the liaison's drained, host-wide operation).
2. **Pre-existing stranded roots (out of scope).** `dispatches/` holds ~45 older *complete* triples (garden+journal, dated May–Jun) left by orchestrators that never ran teardown — the "Stranded dispatch roots" pitfall the SKILL already flags for manual cleanup. Not this bug's signature; left untouched. Worth a future housekeeping job (and/or an age-based reaper) if desired.
