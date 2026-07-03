Harden `journal_remote()` in `scripts/jobs/common.sh` (currently lines ~490–494) so a broken/missing canonical journal worktree no longer takes down the whole fleet.

Failure signature (recurring, deterministic): `ensure_clone` → `journal_remote` dies with `no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal`, preceded by `fatal: not a git repository: <…>/worktrees/journal`, whenever `$GARDEN_ROOT/journal/.git` is a dangling worktree pointer (its backing repo was removed — here `/home/kris/garden2` was deleted, orphaning `/home/kris/journal`).

Fix: after the `$JOURNAL_REMOTE` short-circuit, try reading the journal worktree's origin as today, but if that read fails (worktree missing/broken), FALL BACK to the garden repo's own origin: `git -C "$GARDEN_ROOT" config --get remote.origin.url`, and only `die` if that also fails. This is correct because `journal2` lives on the same remote as the garden repo (`git@github.com:kriskowal/garden.git`), so the fallback derives the identical URL. Concretely:

```sh
journal_remote() {
  if [ -n "$JOURNAL_REMOTE" ]; then printf '%s\n' "$JOURNAL_REMOTE"; return; fi
  git -C "$GARDEN_ROOT/journal" config --get remote.origin.url 2>/dev/null && return
  git -C "$GARDEN_ROOT" config --get remote.origin.url \
    || die "no JOURNAL_REMOTE set, and no origin on $GARDEN_ROOT/journal or $GARDEN_ROOT"
}
```

Add a shell test covering the fallback: a `$GARDEN_ROOT/journal` whose `.git` points at a nonexistent gitdir, plus a valid origin on `$GARDEN_ROOT`, must yield that origin (not die). Keep the `JOURNAL_REMOTE` override path (tests point it at a local bare repo) unchanged. Note for the implementer: the dangling `/home/kris/journal` worktree is separately environmental — repairing/re-adding it (or teaching `journal-worktree-keeper` to re-create a worktree with a dead backing gitdir instead of logging `WARN … skipping`) is a worthwhile follow-up but out of scope for this hardening.
