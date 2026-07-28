# fixer: a warm-cache worktree has no yarn install state, so local-verify verifies nothing

Wear `roles/fixer/AGENT.md`. This is a garden-infrastructure defect on
`main2`, not a project-repo fix. It is the "environment divergence" class
that `skills/local-verify/SKILL.md` § Parity is the contract says must be
closed.

## The defect

`scripts/jobs/gardening/local-verify.sh` is the standing pre-push gate and
the gardening state machine's default `GARDEN_EVAL`. It discovers each step
as `<yarn> run <script>`. In any project worktree provisioned by a
**warm-cache hit**, `yarn run` fails immediately with:

```
Usage Error: The project in <wt>/package.json doesn't seem to have been
installed - running an install there might help
```

so **all six steps** (format, lint, build, codegen, test, docs) report
`STEP <name> FAILED` with the same blob SHA, and the gate verifies nothing.
It fails loud rather than silently passing, which is the safe direction, but
a gardener gets six identical bogus failures and no signal about the change.

Reproduced 2026-07-28 in
`/home/kris/garden/scratch/project-wt-endojs-endo-but-for-bots-pr868-lint-fix-a441ba6f`
(job `endojs-endo-but-for-bots-pr868-lint-fix`, `endojs/endo-but-for-bots`),
a `WARM-CACHE hit` worktree. Running `local-verify.sh .` there emitted six
`STEP ... FAILED` blocks all pointing at blob
`429b77fd4904afa60e85be37b992bef89499e661`, whose three lines are the yarn
usage error above.

## Root cause

`scripts/jobs/ensure-project-worktree.sh`:

- The **cold** path runs `yarn install --immutable` in the worktree. That
  writes `node_modules/**` *and* `.yarn/install-state.gz`.
- `list_node_modules()` snapshots only directories **named** `node_modules`
  (the root one plus each workspace package's).
  `.yarn/install-state.gz` lives **outside** any `node_modules`, so it is
  never captured into the cache.
- The **warm HIT** path hardlinks the cached `node_modules` trees back in and
  nothing restores `.yarn/install-state.gz`.

Yarn 4 (this repo pins 4.13.0, `nodeLinker: pnpm`) refuses `yarn run`
without that install state, even though every dependency is physically
present and correct: `node node_modules/eslint/bin/eslint.js` runs fine in
the same tree.

Corroboration across this host's worktrees: several warm-hit trees have
`node_modules/` but no `.yarn/install-state.gz` (for example
`project-wt-endojs-endo-but-for-bots-form-data-advisory-f4d57e5d`,
`project-wt-endojs-endo-but-for-bots-pr755-review-ea305fae-f4d57e5d`,
`project-wt-endojs-endo-but-for-bots-pr806-conduct-16c83935`), while
cold-build trees have both.

## What to do

Decide between these and implement one:

1. **Capture and restore the install state alongside the trees.** Snapshot
   `.yarn/install-state.gz` (and any sibling linker state a project uses)
   into the cache next to `trees/`, and restore it on a warm hit. Cheapest
   and most direct. Verify it is genuinely portable across worktree paths
   before relying on it -- yarn's install state may embed absolute paths, in
   which case this option is wrong and option 2 or 3 is the answer.
2. **Regenerate the state on a warm hit** with a cheap post-populate
   `yarn install --immutable` (which should be near-instant with every
   package already linked). Beware: `link_tree` hardlinks share inodes with
   the cache, and the script header assumes the toolchain treats
   `node_modules` as immutable, so confirm an install does not mutate shared
   inodes under other worktrees.
3. **Make `local-verify.sh` not depend on `yarn run`**, resolving each
   `package.json` script to a direct `node <bin>` invocation. Most robust
   against package-manager state, but the largest change.

Whatever lands, add a **regression check**: `local-verify.sh` run in a
warm-cache-populated worktree must exercise the real steps rather than
report every step failed. `scripts/jobs/test/local-verify-test.sh` is the
existing harness to extend.

Also consider having `local-verify.sh` **distinguish "the runner is broken"
from "the check failed"**: six identical failures whose text is a package
manager usage error is an environment fault, and saying so beats reporting
it as six failed verification steps.

Finally, append a dated note to `skills/local-verify/SKILL.md` § Notes from
the field, matching the two entries already there for the noexec `TMPDIR`
divergence and the `build:types:gen` coverage gap.

## Impact

Every gardener that pushed after a warm-cache hit while relying on
`local-verify.sh` had no local verification. The gate has been failing loud,
so this is a blind spot rather than a silent green -- but it means the
maintainer's standing "run every lint and test locally before pushing"
policy has not actually been met by the harness on warm worktrees.

<!-- garden-reaped: 2 -->
