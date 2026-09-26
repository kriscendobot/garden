Done. Empty inbox, work pushed.

## Completion report

**Job:** Harden `journal_remote()` in `scripts/jobs/common.sh` so a missing journal-worktree origin self-heals instead of triggering a fleet-wide FATAL cascade.

**Context found:** The core of this job had already landed in prior commits (`556103da2` cache + self-heal, `cdd341056` root-origin fallback). Two pieces from the spec were still missing, and I implemented them:

**What I did:**
1. **Opportunistic worktree re-heal** — new helper `_reheal_journal_worktree_origin`. Whenever a fallback source resolves the URL, it `git remote add origin <url>`s it back onto the journal worktree (idempotent, best-effort, only when the worktree is a valid repo with genuinely-unset origin). This means the *next* tick reads origin straight from the worktree and never re-enters the fallback path — converting a persistent-until-repair condition into a one-tick self-heal.
2. **Per-instance-clone fallback** — new helper `_journal_remote_from_state_clones` scans any existing `$GARDEN_STATE/<svc>/journal` sibling clone for `remote.origin.url`, added as fallback (3) before `die`. Those clones almost always still carry the origin.
3. Wired both into `journal_remote()`'s fallback chain (cache → root origin → state clones), each fallback now also re-heals the worktree; updated the derivation comments.

**Verification:** Sourced `common.sh` against throwaway fixtures and exercised 5 cases: root-origin fallback + reheal (A), per-instance-clone fallback (B), **healed worktree read straight with no WARN on the next tick (C — the self-heal)**, cache-only reheal of a fresh broken worktree (D), and genuine no-origin still `die`s cleanly (E). `bash -n` clean.

**Changed:** `scripts/jobs/common.sh` (commit `aa1eb5519`, pushed to `origin/main2`).

**Follow-ups:** None. The genuine "no origin anywhere" case still FATALs by design (nothing to fall back to); everything transient now self-heals.
