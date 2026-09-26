Inbox empty. Work is complete.

## Completion report

**Job:** Harden `scripts/jobs/clone-keeper.sh` so a missing tracked bare clone self-heals.

**Finding:** Most of this job's spec was *already implemented* on `origin/main2` across prior commits (`1bfbc108` re-clone, `05a261e5` basename-derive, `88a02508` fourth `<clone-url>` field, `c46fdfe5` maintainer escalation). Already present and verified:
- `GARDEN_TRACKED_CLONES` extended to `<dir>|<remote>|<branch>|<url>`, endo row defaulting to `https://github.com/endojs/endo.git`.
- Missing-clone re-clone with bounded `timeout "$GARDEN_FETCH_TIMEOUT" git clone --bare`, warn-and-skip on unreachable source, warn-and-skip / escalate when no URL, loud STALE (no clobber) for a present-but-corrupt dir.

**Gap I closed:** the spec's **temp path + atomic `mv`** requirement was *not* met — `bounded_clone` cloned straight into the tracked path `$abs`, so a timeout SIGTERM or a concurrent keeper tick / worktree-cut could observe a half-populated `$abs`.

**Change:**
- `bounded_clone` now clones into a **sibling temp path** (`$abs.reclone.$$.<attempt>`, same directory → same filesystem) and, only on a fully-successful clone, atomically `mv -T`s it into place. `$abs` is therefore only ever fully absent or fully complete. `mv -T` also refuses to move *into* an existing dir, so a racing tick that recreated `$abs` first is never clobbered — the temp is discarded and success is reported since the other tick's clone stands. Temps are scrubbed on failure and between retries.
- Updated the header paragraph and the `bounded_clone` comment to describe the atomic staging.
- Added two test assertions: no `.reclone.` staging dir survives a successful re-clone, nor an unreachable-source failure.

**Verification:** `bash -n` clean; shellcheck shows only pre-existing warnings (sourced `common.sh`, `GARDEN_TAG` used by `log`); full suite **40/40 pass**. `mv -T` confirmed available on this host.

**Pushed:** `c46fdfe5e..7cf55fc46` → `origin/main2` (single commit, rebase-CAS).

**Follow-ups:** None. Note the real `worktrees/endojs-endo.git` absence on this host is now self-healing on the next `garden-clone-keeper.timer` tick (~30m) via the deployed keeper once this lands in the root checkout on deploy.
