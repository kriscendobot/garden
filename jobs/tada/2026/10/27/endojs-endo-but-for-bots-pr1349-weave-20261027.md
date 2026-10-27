I rebased PR #1349 (endojs/endo-but-for-bots) onto upstream `master` and moved its base to `master-ebc7904`. CI is fully green and I posted a summary comment on the PR. I did not ferry it.

**Base and head**
- **Base:** I checked upstream `endojs/endo` `master` at run time: it is still `ebc7904d87b1`, and the fork's `master-ebc7904` branch points at the same commit. The PR base moved from `master-6ee3fda` to `master-ebc7904`.
- **Old base is not an ancestor of upstream:** `master-6ee3fda` carries 77 commits that exist only on the fork. I rebased just the PR's 47 commits with `git rebase --onto master-ebc7904 master-6ee3fda`. The resulting diff touches 23 files, all of them the PR's own.
- **Head:** `91cca8a551` became `b122ff91ef` (46 commits), force-pushed with lease. The base move is done with `gh pr edit --base`.

**Conflicts.** Upstream had already shipped the TextEncoder/TextDecoder permits (#3322, ses 2.3.0) in a different shape:
- **Old changeset:** `.changeset/tender-lions-tickle.md` exists only on the fork, so I dropped the PR's edits to it. The PR's own `hardened-text-codecs-encapsulated` changeset still covers the change.
- **Renamed test file:** upstream renamed `text-encoder-decoder.test.js` to `text-codecs.test.js`. I carried the PR's edits to that test into the new file commit by commit. The end result is the "unaffected host codec constructors are retained" test, with `lockdown()` now called after the constructors are captured.
- **`ci.yml`:** the `check-action-pins` job only exists on the fork's `master`, so the three commits that edit its comment no longer apply. Those commits ended up empty and were dropped, plus one that only edited the dropped changeset (4 in total).
- **`packages/ses/docs/guide.md`:** I kept upstream's new URL exception paragraph and the PR's removal of `TextEncoder` from the removals list. The sentence now reads "The most surprising removal is `atob`."

**Two follow-up commits on the head**
- **Quotes restored:** an earlier PR commit (`b43f86c0d3`) had turned the curly quotes in both guides back into straight ones, after a previous commit restored them. I put them back so only the codec paragraphs differ from the base.
- **Lint fixes for the new base:** the new base's lint rules flagged the PR's codec tests. I removed the `/* global globalThis */` comments and renamed a function that shadowed `NewTarget`.

**Checks**
- **Local:** `packages/ses` tests pass (572 passed, 2 known failures, 2 skipped), and eslint and the type-definition check have no errors.
- **Local `tsc` error:** one error in `scripts/hermes-transforms.js`, a file the PR doesn't touch; likely from my local install. CI's lint check passed.
- **CI at `b122ff91ef`:** 16/16 checks pass, including lint, test-xs, test-hermes, browser-tests, test262, and the Node 22/24 × ubuntu/macOS matrix. No shepherd job was needed.

PR comment: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6453887493

**Follow-ups**
- The next orchestration child restages the ferry directive.
- Separate from this PR: upstream's top-level `docs/guide.md` still lists `URL` as unavailable even though upstream now permits it. I left that alone because the PR doesn't cover it.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `91cca8a5511d5c846eec173989fb025b5e4fa919`; this job presented `b122ff91ef98ac3e151852b58d2cb1110060fb26`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-weave-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (5007562 cached reads)
- Output: 24665 tokens
- Cost: $2.3612044
- Wall-clock: 868s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
