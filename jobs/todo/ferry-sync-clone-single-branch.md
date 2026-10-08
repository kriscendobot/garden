---
role: fixer
---
## Repo

kriscendobot/garden (main2 — this is the garden's own meta-repo; land directly,
no PR, per CLAUDE.md § Conventions).

## What

`scripts/ferry.sh`'s `sync_clone()` does the first-time clone as:

```sh
git clone --quiet --branch "$BRANCH" "$REMOTE" "$CLONE"
```

`--branch journal2` only picks which branch gets checked out; without
`--single-branch` it still fetches full history for every ref on the remote
(verified 2026-10-06 on a bare credentialed host: ~1000 refs, ~800MB, ~2
minutes for a plain `--once` run's first clone — `main2`, the orphan `journal`
and `journal2` branches, every stray PR-mirror/dispatch branch, all pulled down
before the clone narrows to `journal2`). `scripts/ferry.sh` is explicitly meant
to run host-native on the credentialed host (`designs/dedicated-ferry-dispatch.md`)
outside the container's otherwise-warm caches, so this first-run cost lands on
every freshly provisioned credentialed host, cron invocation included.

## Fix

Add `--single-branch` to the clone invocation in `sync_clone()`:

```sh
git clone --quiet --single-branch --branch "$BRANCH" "$REMOTE" "$CLONE"
```

Verify: `rm -rf` a scratch `GARDEN_FERRY_STATE`, run `./scripts/ferry.sh --once`
with it, and confirm (a) the clone completes markedly faster / smaller than the
~800MB baseline above, (b) `git -C <clone> branch -a` shows only `journal2`
(plus its remote-tracking ref), and (c) the loop still finds/claims/dispatches a
`jobs/ferry/` directive correctly afterward (a fake pending directive is fine
for this check; do not dispatch a real `claude -p` boatman run against
production credentials as part of verification — stub or mock the dispatch
step, or verify only the clone-and-discover path and reason about dispatch from
the existing code, since this host-native script cannot be exercised through
the ordinary gauntlet).

## Out of scope

- No change to `sync_clone()`'s fetch-on-subsequent-runs path (`git -C "$CLONE"
  fetch --quiet origin "$BRANCH"`) — that's already scoped to one branch and
  unaffected by this.
- No change to the bash-3.2/BSD-portable dialect constraint
  (`designs/dedicated-ferry-dispatch.md` § 2) — `--single-branch` is a plain
  clone flag, not a bash-version-sensitive construct.
- No change to `jobs/ferry/` board semantics, the generic-board lockout
  (`post-job.sh`/`claim-job.sh`/`gardener.sh` refusing `role: boatman`), or
  anything else in the dedicated-ferry-dispatch design — this is a narrow
  clone-flag fix.
