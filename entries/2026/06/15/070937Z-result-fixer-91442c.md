---
ts: 2026-06-15T07:09:37Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - entries/2026/06/15/065800Z-dispatch-fixer-91442c.md
  - entries/2026/06/15/063700Z-dispatch-fixer-d78877.md
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4705403884
next: liaison
---

# result: fixer — consolidate the remaining five SES + Node parity test pairs on PR #379

Extended the consolidation pattern from `cycle-rename-tdz-matrix.test.js` (commit ca17e11e4) to the five remaining parity pairs in `packages/compartment-mapper/test/`. One cohesive commit; tests pass; pre-push-gates clean for the changes I introduced (one pre-existing finding documented below).

## Head SHAs

- Pre: `f87d0eb0554525feab2306f283d19e00ba0384e1`
- Post: `3b0928fe3be6b051bf4433b02415fa8f097750ec` (pushed to `fix/issue-59-star-export-cycle`)

## Per-pair consolidation mapping

All in commit `3b0928fe3`:

| Parity file (deleted) | Merged into | Node-side treatment |
| --- | --- | --- |
| `cycle-cjs-reexporter-node-parity.test.js` | `cycle-cjs-reexporter.test.js` | Dynamic import of the same `main.js`, projected through `default` to reuse `assertCycleCjsReexporter` |
| `cycle-esm-in-cjs-node-parity.test.js` | `cycle-esm-in-cjs.test.js` | `spawnSync` of a fresh Node process; asserts `ERR_REQUIRE_CYCLE_MODULE` (the topology is rejected, so the test runner's own module graph must be isolated) |
| `cycle-rename-node-parity.test.js` | `cycle-rename.test.js` | Dynamic import of the same `main.js`; reuses `assertCycleRename` |
| `cycle-rename-unused-node-parity.test.js` | `cycle-rename-unused.test.js` | Dynamic import of the same `main.js`; reuses `assertCycleRenameUnused` |
| `subpath-patterns-node-parity.test.js` | `subpath-patterns.test.js` | Test-for-test pairing where both sides have a counterpart; single-side registration where only one side covers a scenario (SES-only: archive shape, policy gating, browser field, module field; Node-only: multi-star and globstar exclusions) |

Also updated prose in:

- `packages/ses/test/import-cjs.test.js` (the gauntlet's prose pointer to the cycle-cjs-reexporter and cycle-esm-in-cjs parity files)
- `packages/ses/test/import-gauntlet.test.js` (the prose pointers to the cycle-rename and cycle-rename-unused parity files)
- `packages/compartment-mapper/designs/subpath-pattern-replacement.md` (the parity-strategy bullet listing the subpath-patterns split-file shape)

Dropped bare `(issue #59 ...)` markers from test titles I touched per `no-pull-citations` (the probe rejects bare `#<n>` references in added lines). Qualified `endojs/endo#59` references in docstrings are preserved.

## Test result

`corepack yarn workspace @endo/compartment-mapper test`: 1014 tests passed, 6 known failures (the pre-existing baseline; unchanged). All ten consolidated test registrations (5 ses + 5 node parity) are present in the output.

## pre-push-gates result

All probes I introduced pass:

- `filename-no-stutter` pass
- `no-ascii-banners` pass
- `no-inline-import-jsdoc` pass
- `no-non-ascii-in-source` pass
- `no-pull-citations` pass (after dropping `(issue #59 ...)` from touched test titles)
- `sentence-per-line-md` pass (after reshaping the design-doc bullet)
- `test-package-no-main` pass

Remaining pre-existing finding (not introduced by this dispatch and out of scope per the "append only" directive):

- `security-md-hash-uniform` fail: `packages/immutable-arraybuffer/SECURITY.md`, `packages/bytes/SECURITY.md`, `packages/hex/SECURITY.md`, `packages/panic/SECURITY.md` carry divergent hashes. These align on `origin/master` via commit `3aded8af7 chore: align SECURITY.md across packages`, which landed after this branch diverged from master. Resolving requires a rebase onto current master and would be a separate dispatch (the maintainer's directive on this fixer dispatch was "append only").

The auto-fix stages (`yarn format`, `yarn lint --fix`) touched two unrelated files (`packages/evasive-transform/src/index.js` whitespace, `packages/ses/src/compartment.js`); I reverted both before committing so the diff stays scoped to the consolidation task.

## PR #379 surfaces

- Top-level comment: https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4705403884 (per-pair mapping, verification, head SHA, @-mentions @kriskowal)
- Re-request review: confirmed via `gh api repos/endojs/endo-but-for-bots/pulls/379/requested_reviewers --input -`; response shape carries `requested_reviewers: [{"login":"kriskowal", ...}]`

## Next stage

`next: liaison`. Awaiting kriskowal review on the consolidation; the `security-md-hash-uniform` pre-existing finding is also liaison-routed (whether to fold a rebase / sync into this PR or land it as a separate dispatch is a liaison decision).

Self-improvement: the `(issue #N)` marker pattern in test titles trips `no-pull-citations` on any rewrite that touches those lines. The prior fixer hit and pre-emptively scrubbed via commit `b7e77cf38`; future consolidations that bring split-file titles into one module should drop the markers in the same pass so the gate stays silent without a separate "retitle" commit.
