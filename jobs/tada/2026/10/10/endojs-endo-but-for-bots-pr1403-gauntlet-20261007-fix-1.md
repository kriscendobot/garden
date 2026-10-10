# Gauntlet FIX round 1: endojs/endo-but-for-bots#1403 (`@endo/inference`)

I applied the panel-1 must-fix items with two follow-up commits on top of `7cc7cc3fe7` and pushed them with `safe-push-pr-head.sh`. CI is green: `ci-wait-merge` returned rc 0 with 33 checks and 0 failures.

**Must-fix items:**

1. **Cancellation reaction not disarmed when arming the timer throws (breaker):** this was already fixed at the head the panel reviewed, so I made no change. The catch block sets `stopped = true` before rethrowing (commit `80a72ae0c2`). The test in `test/limits.test.js` (around line 380) already covers it: a throwing `setTimeout` plus a later-rejected `cancelled` gives 0 terminations. The breaker's line references don't match the current file, so it probably reviewed a dirty or stale view. The assessor confirms this path is correct.

2. **Changeset contradicts `package.json` (curator, releaser, packager):** I decided the package should publish. Commit `3e134293b3` drops `"private": true`. I kept the `major` bump: the curator asked for `minor`, but the garden's `changeset-discipline` skill sets new packages at `0.1.0` with a `major` changeset, giving a first release of `1.0.0`. That rule comes from a maintainer review directive on endojs/endo-but-for-bots#513, and the changeset-auditor seat approved the bump on that basis. `@endo/cbor` uses the same shape.
   - Commit `4ba2134b3a` rewrites the changeset body for readers of the published changelog, as the releaser asked. It now names each subpath's entry points and drops the reference to a design file that lives in the garden repo, not in endo.

3. **`./types.js` points at declarations the tarball doesn't ship (surfacer):** commit `3e134293b3` adds the repo's standard `prepack`/`postpack` pair, which runs `tsc --build tsconfig.build.json` at pack time. `yarn pack -n` now lists `src/types.d.ts` and a `.d.ts` for every JS subpath.

**Checks run before pushing:** package-uniformity tests (18 passed, including the check that public packages publish their declarations), `build:types:check`, prettier, `tsc`, and ava (66 passed). ESLint gave 0 errors and 9 warnings; I didn't check whether those warnings predate this round.

**Left for later (should-fix items from the panel):**
- `stop()` runs before the guarded `terminate()` in `abort`.
- A count reported after `stop()` still returns `true`.
- The exported surface is wider than a provider plugin needs.
- The pid-bound killer can fire more than once.
- Types are declared twice (in `types.ts` and as patterns in `guards.js`) and could drift.

I didn't change `SECURITY.md`: the "acknowledgement" spelling is in boilerplate shared across the repo's packages.

**Environment note:** the warm-cache project worktree was missing workspace links until I re-ran `yarn install --immutable`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2839248 cached reads)
- Output: 11077 tokens
- Cost: $1.4455416
- Wall-clock: 2257s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
