Inbox empty. Work complete.

## Shepherd report — endojs/endo-but-for-bots PR #765

**PR:** `fix(compartment-mapper): cache global intrinsics (mirror of endojs/endo#2780)` — head branch `weizman/cache-globals-mirror`, mergeable (not conflicting).

### What I did
Re-fetched live CI (15 checks). Classified the red:

- **lint (PR-attributable — FIXED):** the PR's diff added `const { … } = globalThis;` to three compartment-mapper source files, tripping `no-undef` on `globalThis` (3 errors: `import-hook.js:82`, `node-powers.js:40`, `parse-cjs-shared-export-wrapper.js:15`). The repo's `@endo/internal` eslint config doesn't provide `globalThis` as a known global — the in-repo convention (`capture-lite.js:33`) is a `/* global globalThis */` directive. I added that directive at each destructuring site.
- Committed `fix(compartment-mapper): declare globalThis for eslint no-undef` (`0abbdecdc7`) and pushed to the PR head branch.
- New CI run (29555243829) confirmed the fix: lint went from **8 problems (3 errors, 5 warnings)** → **5 problems (0 errors, 5 warnings)**. All three PR-introduced errors are cleared.

### Residual red — pre-existing base-branch (master) breakage, NOT this PR
Verified against master's own CI (base SHA `fcbb540`, conclusion `failure`):
- **lint** still exits 1 on 5 pre-existing *warnings* (`--max-warnings 0`) in files the PR never touches — `policy-schema.ts:64` (invalid JSDoc `remarks` tag) and four `daemon/*.js` missing-`@param` warnings. **Identical failure on master.**
- **test (all matrix)** — `@endo/cbor` fails `Cannot find package '@endo/eventual-send'` (arrived with master's new cbor package). **Identical on master.**
- **zizmor** — exit 13 from workflow hash-pin comment mismatches across unmodified `.github/workflows/*`. **Identical on master.**

None of these are in this PR's diff; fixing them means editing master / unrelated packages, which would be scope creep on a globals-caching mirror PR. They will clear on this branch once master is repaired and the PR rebases.

### Definition of done
The PR's own CI contribution is green (3 lint errors fixed). The remaining red is inherited master breakage — an impasse for this PR's shepherd. No PR comment posted (no per-action authorization in the job body).

**next: liaison** — surface to the maintainer that base branch `master` is red on lint (5 JSDoc warnings), test (cbor missing `@endo/eventual-send`), and zizmor (workflow hash-pin comments); those need a separate master-fix effort, after which #765 goes green on rebase.
