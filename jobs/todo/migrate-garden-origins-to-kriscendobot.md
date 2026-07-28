Migrate this host's garden git remotes from the pre-transfer path
`git@github.com:kriskowal/garden.git` to the canonical
`git@github.com:kriscendobot/garden.git`, on every host, after the compatibility
change is deployed there.

## Precondition — CHECK THIS FIRST, do not skip

The compatibility change (commit `ca328dd15b`, "accept kriscendobot/garden as the
canonical journal remote") MUST already be deployed on the host you are running
on. Verify:

    grep -c 'GARDEN_PRODUCTION_JOURNAL_REPO' $GARDEN_ROOT/scripts/jobs/common.sh

If that is 0, this host still runs pre-transfer code. STOP and requeue — do not
migrate. Old code classifies the new URL as the incident-2026-07-21 poison
(`_is_foreign_github_remote`), so it would log REFUSED, alert the maintainer from
root-repo-guard, and `_reheal_root_origin` would revert your change on the next
tick. There is no urgency: GitHub redirects the old path indefinitely and the
deployed change accepts it as a migration alias, so an un-migrated host is fully
functional.

## What to migrate

On this host (paths under `$GARDEN_ROOT`, which was `/home/kris/garden` on
endolin-garden-ece02cb4 — inventory afresh, do not assume the counts):

1. the root checkout's `remote.origin.url`
2. `.garden-state/config/journal-remote` (the per-host cache)
3. every per-instance clone under `.garden-state/*/journal` and
   `.garden-state/*/verify` (42 of them on endolin-garden-ece02cb4)
4. the `journal/` worktree's origin, if it carries one of its own

## Constraints

- **Never run git in `$GARDEN_ROOT`.** The root checkout and the `journal/`
  worktree share ONE repo; a stray git command there corrupts journal sync for the
  whole host (incidents 2026-07-17 / 2026-07-21). Root and journal origins are the
  one exception where you must write, so use `git -C "$GARDEN_ROOT" remote set-url
  origin <url>` — the single targeted write, nothing else, no fetch/checkout.
- **Do not force-push and do not rewrite history** on `main2` or `journal2`.
- Prefer doing this while the fleet is drained, or accept that a clone's origin may
  be rewritten under a running worker; the URLs are equivalent (same repo, one
  redirects), so a mid-flight worker is not harmed either way.

## Verify

For both branches, from a migrated clone:

    git ls-remote git@github.com:kriscendobot/garden.git main2 journal2

and confirm a real fetch and a real push both reach origin (a no-op CAS push
through the normal `commit_and_push` path is enough — do not invent traffic).
Confirm `journal_remote` returns the new URL with no REFUSED in the log, and that
`scripts/jobs/root-repo-guard.sh` reports the origin invariant clean.

## Other hosts

`endolin-garden2-5bcdff64` and `ps23` were not reachable from the job that posted
this. Each needs the same treatment once its own deploy lands. If you are running
on one of them, this job covers it; if you cannot reach a host safely, say so in
the completion report rather than leaving it silently unmigrated.

## Retiring the alias

Once NO host has any remote, cache, or clone still naming `kriskowal/garden`, the
migration alias in `scripts/jobs/common.sh`
(`GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES`) can be dropped, along with the
now-inert `cursors/comments/kriskowal-garden` and `cursors/issues/kriskowal-garden`
left on the journal. That is a separate, later change — do NOT do it in this job,
and do not do it while any host is unmigrated. Background:
`context/operations/repo-transfer.md`.

<!-- garden-reaped: 2 -->
