# Autonomous wedge resolution — clean the shared main2 tree on host endolinbot

HIGH PRIORITY. The shared garden checkout at `/home/kris` (branch `main2`) is WEDGED:
origin advanced to `00693cdbd5940c9950bb33429d7ed564d8f2320d` but the live tree is stuck at `1165774cd1e5c4d85e443f325e8f210408f76239` — tracked working-tree changes block the fast-forward.
Until the tree is clean this host will NOT pick up new roles/skills/scripts
(the deploy reconcilers fast-forward only a clean tree).

Blocking change(s):
```
 M scripts/jobs/mentor.sh
```

## What to do

The mechanical, LOSSLESS part is already scripted. Run it first — it operates
directly on the shared tree at `/home/kris` (the ONE case where editing the
shared tree in place is correct: you are CLEANING it, not adding work):

    "/home/kris/scripts/jobs/resolve-wedge.sh" main2

It re-surveys the tree and resolves EACH blocking path individually:
  * a tracked edit byte-identical to `origin/main2` (a redundant
    copy of landed work) → `git checkout HEAD -- <file>`;
  * an untracked file byte-identical to its incoming `origin/main2`
    version → `rm` it;
  * GENUINE WIP (differs from both HEAD and origin) → PRESERVED, never discarded:
    a tracked file is `git stash push`ed; a divergent untracked collision is
    moved into `/home/kris/scratch`. The script reports each preserved item on stderr.

It NEVER does a blind `git reset --hard`, `git checkout .`, or `git clean -fd`,
and it touches ONLY the blocking file(s). On exit 0 the tree is clean and the
watchman / deploy-sync fast-forward proceeds on its next tick.

## Your one judgment call: land the preserved WIP

If `resolve-wedge.sh` reported stashed or preserved WIP, decide per item whether
it is coherent work that should LAND on `main2`:
  * If so, recover it (`git -C "/home/kris" stash show -p` / the off-tree copy),
    apply it in an ISOLATED worktree off `origin/main2`, commit with
    an EXPLICIT pathspec (`git commit -m '…' -- <paths>`), and push
    HEAD:main2 through a `git pull --rebase`/push CAS loop.
  * If it is not yet coherent, LEAVE the stash / off-tree copy in place and note it
    in your report so it is not lost. Never discard it.

If `resolve-wedge.sh` exits non-zero (tracked dirt it could not classify
remains), re-survey by hand, resolve only the specific blocking file(s) the same
lossless way, and STOP if any unrelated tracked file is unexpectedly dirty.

---
claim:
  host: endolinbot
  gardener: 12
  claimed_at: 2026-06-27T17:09:54Z
