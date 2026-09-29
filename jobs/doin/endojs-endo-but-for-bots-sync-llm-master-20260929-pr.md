---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---

# Open, shepherd, and merge the prepared upstream-master → llm sync PR on endojs/endo-but-for-bots

Successor of `endojs-endo-but-for-bots-sync-llm-master-20260929`. The merge work is done. That job ran on `oros-studio-garden-ce242c49`, whose bot PAT lacks **Pull requests: write** on endojs, so `gh pr create` failed with `Resource not accessible by personal access token (createPullRequest)`. This job is pinned to `endolin-garden-ece02cb4`, the host that commented on and closed #1356 today, so its PAT can write PRs.

## State

- Branch `merge-upstream-master-into-llm-20260929` is pushed to `endojs/endo-but-for-bots`, head `767d537c941ae072886f98bae45cd123ff9d5274`, and holds three commits on top of `llm` @ `3aa902d00`:
  1. `0b97b938a`: a true two-parent merge of `endojs/endo` `master` @ `aaf9ea4f4` (also the fork's frozen `master-aaf9ea4`) into `llm`. It follows the #1048 (2026-08-22) precedent, where "master" means UPSTREAM endojs/endo master. The fork's own `master` branch is a stale July staging lineage and was deliberately not merged; see the parent job's report.
  2. `chore: Update yarn.lock`: the regenerated lockfile, with fast-check deduped onto 4.10.2.
  3. `fix(patterns)`: passes `encodePassable` to the llm-only `M.safeInteger()` rank cover, because upstream changed `getPassStyleCover`'s arity.
- Local checks passed: `lint:types` in pass-style, marshal and patterns; `yarn test` in patterns (699 tests passed per config); prettier; eslint (warnings only).

## Task

1. Rediscover or open the PR. Use `ensure-pr.sh <this-base> endojs/endo-but-for-bots merge-upstream-master-into-llm-20260929 llm --title "Merge upstream master into llm (2026-09-29)" --body-file <file>` with `GARDEN_ALLOW_FLOATING_BASE=1`. The job directive and the #1048 precedent both target bare `llm`, because the merge is meant to land in `llm` itself, and a frozen base would only force a later weave. If `ensure-pr.sh` refuses at the phase-evidence gate with `designs/README.md` findings, your local `llm` ref is stale. Fast-forward it with `git update-ref refs/heads/llm origin/llm <old>`; the diff against current `origin/llm` touches no `designs/` file. Draft is fine. Use the PR body below, and keep the job marker line with THIS job's base.
2. Shepherd CI to green (`roles/shepherd/AGENT.md`). Fix any failure with atomic commits on the head branch. Never rewrite the merge commit, because `llm` history must stay two-parent.
3. Once CI is green, un-draft the PR and merge it with a merge commit (`gh pr merge --merge`), not a squash or rebase, so upstream history is kept, as #1048 did. The maintainer pre-authorized merging on green CI without a panel. The conflicts were mechanical, apart from `packages/pass-style/tools/arb-passable.js`, which adopted upstream's rewrite plus llm's one-line `new Uint8Array(...)` byteArray wrap. If a CI fix turns out to need a behavior change, post a gauntlet instead of merging solo, and say why.

## PR body (use verbatim, replacing the marker base with this job's base)

## Summary

- merge `endojs/endo` `master` at `aaf9ea4f4` (`feat(patterns): Add M.choose (#3073)`) into the `llm` roadmap branch with a true two-parent merge commit `0b97b938a` (parents `3aa902d00` and `aaf9ea4f4`), following the 2026-08-22 precedent (#1048)
- brings in the 24 upstream commits `llm` lacked: patterns `getRankCover` tightening, property-based rank-cover tests, the lifting passable arbitraries, `M.choose`, the SES `console.dir` error logging, compartment-mapper specifier fixes, and action pin bumps
- regenerate `yarn.lock` in a separate mechanical commit, deduplicating `fast-check` onto 4.10.2 so the pass-style arbitraries and `@fast-check/ava` share one type identity
- one compatibility fix for the llm-only `M.safeInteger()` helper

Upstream endo#3332 (URL/URLSearchParams shim) was already merged into `llm` by #1048, so this merge does not touch it.

## Conflict resolutions

- `.github/workflows/{ci,depcheck,ocapn-guile-interop}.yml`: kept `llm`'s change-detection gating, the Spritely source-availability guards, and the exact Node step names. Upstream's hunks only renamed those steps.
- `packages/marshal/package.json`, `tsconfig.composite.json`: took both sides, so `llm`'s `@endo/hex` and `@endo/immutable-arraybuffer` sit alongside upstream's `@endo/memoize`.
- `packages/{pass-style,patterns}/package.json`: kept `llm`'s `expect-type` and `prettier` and added upstream's `fast-check` devDependency.
- `packages/pass-style/tools/arb-passable.js`: adopted upstream's options-bag and lifting arbitraries. Kept `llm`'s byteArray generator, which wraps the immutable `ArrayBuffer` in a frozen `Uint8Array` to match `llm`'s byteArray pass style.
- `packages/marshal/test/encodePassable.test.js`: kept `llm`'s unexcluded `makeArbitraries(fc)`, because `llm`'s `encodePassable` encodes byteArray and upstream's excludes it.
- `yarn.lock`: the merge commit carries the pre-merge `llm` lockfile, and the next commit regenerates it.

## Follow-up compatibility fix

- `fix(patterns)`: upstream's `getPassStyleCover` now takes `encodePassable` to account for the compactOrdered prefix. The `llm`-only `M.safeInteger()` helper still called it with one argument, which failed `tsc`.

## Verification

- `yarn install` passed, with peer-dependency warnings only.
- `yarn lint:types` passed in `@endo/pass-style`, `@endo/marshal` and `@endo/patterns` after clearing stale `tsbuildinfo`.
- `yarn test` in `@endo/patterns`: 699 tests passed under each ses-ava configuration. `@endo/marshal` and `@endo/pass-style` tests passed, apart from ses-ava's concurrent-config `ENOENT .cache/ava/import-from-project.mjs` races on the local host. CI is the authoritative run.
- Prettier passed on every conflict-resolved file, and ESLint reported warnings only.

<!-- garden-job: endojs-endo-but-for-bots-sync-llm-master-20260929-pr -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T01:49:16Z
