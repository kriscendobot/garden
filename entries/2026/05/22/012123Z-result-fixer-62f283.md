---
ts: 2026-05-22T01:21:23Z
kind: result
role: fixer
worktree: dispatches/fixer--fc2cd6/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/011300Z-result-barrister-8d06ae.md
---

# Fixer round 1 on PR #344 (`docs: populate READMEs`)

Mirror of endojs/endo#3047. Pre-fixer head 1fa8102b6 on branch `mirror/3047-readmes`. Addressed the barrister panel's 1 must-fix-loop + 3 summary-fix items in one dispatch.

## Disposition

| Item | Disposition | SHA |
| --- | --- | --- |
| **must-fix-loop**: `packages/cli/README.md:60` documents `--powers AGENT` but `run.js:50-57` accepts only `NONE \| HOST \| ENDO` (+ pet name) | fixed; replaced `AGENT` with `HOST` | `f2518bb38` |
| **summary-fix**: `cli/README.md` `make`'s `--powers` enum vs `run`'s | documented both shapes with examples; added a paragraph naming the asymmetry (`make`/`install` forward `NONE \| AGENT \| ENDO` (+ pet name) to the daemon's `assertPowersName`; `run` remaps to `NONE \| HOST \| ENDO` (+ pet name) before forwarding). "Pick one" would be a source-code change beyond this README PR's scope | `ce4de7115` |
| **summary-fix**: `packages/netstring/README.md:28` stray space before comma + `999_999_999` vs `999,999,999` mismatch | fixed both; comment now uses the same underscore separator as the code | `82d176ba5` |
| **summary-fix**: `packages/stream-node/README.md:7-8` second sentence appears to start mid-line | reflowed so each physical line ends at a clause boundary (the Overview is a single sentence; it now wraps at punctuation rather than mid-link) | `de9e80e5b` |

## Pre-push gate

Ran `garden/skills/pre-push-gates/pre-push-gates.sh --summary`. The gate's non-zero findings (`no-inline-import-jsdoc` in `packages/netstring/reader.js`, divergent `SECURITY.md` hashes across packages, sentence-per-line violations in unrelated package READMEs and `CONTRIBUTING.md`) are pre-existing repository state, not introduced by this PR. The four files I changed (`packages/cli/README.md`, `packages/netstring/README.md`, `packages/stream-node/README.md`) have no gate findings of their own. Format / lint pipelines did not run because the dispatch worktree is not `yarn install`ed; CI on the new head runs the canonical pipelines.

## Push and CI

Push `1fa8102b6..de9e80e5b` to `origin/mirror/3047-readmes` succeeded. CI re-queued on the new head; the prior head's matrix was fully green (browser-tests, lint, build, zizmor, all `test (22.x|24.x, ubuntu-latest|macos-15)` shards, test-async-hooks, cover, test262, test-hermes, check-action-pins, viable-release, test-xs, test-ocapn-python). README-only changes; CI is expected to remain green.

## Summary comment

Posted at https://github.com/endojs/endo-but-for-bots/pull/344#issuecomment-4514127664. Maps each of the four items to its fix commit. This is a kriscendobot-authored mirror PR; PR author and steward identity match, so no `@`-mention is needed in the summary.

## State

- PR remains DRAFT. The next stage owed (per `skills/pr-creation-flow/SKILL.md`'s jury-fixer loop) is **justice** dispatch: re-runs the code panel on the delta to confirm the must-fix-loop item is addressed and the summary-fix items did not introduce new findings.
- Followup ledger at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--344.md` is untouched; the three `parked` items there were not in this dispatch's scope.

Self-improvement: nothing this time.
