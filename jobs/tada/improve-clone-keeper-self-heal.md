The requested work is already complete in `origin/main2` — nothing to commit.

## Completion report

**Job:** Harden `scripts/jobs/clone-keeper.sh` so a missing tracked bare clone self-heals instead of being skipped forever.

**Finding:** The work this job describes is **already fully implemented and merged** into `origin/main2` (HEAD `48053a960`). It landed across five incremental commits — `1bfbc1087`, `05a261e5e`, `88a025089`, `c46fdfe5e`, `7cf55fc46` — all confirmed ancestors of the current `main2`. The claimed job base evidently duplicated work already delivered by the fleet.

The committed `keep_clone()` (clone-keeper.sh:202) implements everything the spec asked for, and then some:
- **Re-clone branch on a missing dir** — when `<abs>` is absent, it picks a source and re-clones, then falls through to the normal fetch + fast-forward (exactly the requested behavior).
- **URL from the dir basename** — `derive_clone_url()` reverses `worktrees/<owner>-<name>.git` → `<GARDEN_CLONE_URL_BASE>/<owner>/<name>.git` (the requested derivation).
- **Optional explicit `|<url>` fourth field** — the `GARDEN_TRACKED_CLONES` row format is `<dir>|<remote>|<branch>[|<clone-url>]`, with the explicit URL preferred over derivation (the requested unambiguous override); the default endo row already carries `|https://github.com/endojs/endo.git`.
- **Every failure path logs and returns 0** — offline re-clone failure → WARN+return 0; present-but-corrupt dir → STALE+return 0; no derivable source → escalates to the maintainer inbox via `alert_maintainer` (a strict improvement over a bare WARN) + return 0.
- Beyond spec: atomic temp-staging (`bounded_clone` clones into a sibling temp and `mv -T`s it in) so a partial/racing clone never half-populates the tracked path, plus `remote.origin.fetch` refspec setup on the fresh clone.

**Verification:** Ran the keeper offline against a local fake upstream with a deliberately-missing tracked dir. It logged `REPAIRED: re-created missing bare clone …` and produced a valid bare clone at the tracked path with the expected `master` tip — the self-heal path works end-to-end.

**Changes made:** None — no code change was warranted; the requirement is satisfied in the current tree.

**Follow-ups:** None for the code. Note for producers: this job base duplicated already-shipped work; the deployed root's `worktrees/endojs-endo.git` will self-heal on the next `garden-clone-keeper` tick if it is genuinely missing there (that is a deploy/runtime concern, not a code one).
