# PR #1633 (preact 11) is woven and green except one CI job that is red on llm itself, so it is not merged yet

The MERGE-NOW verdict still stands. The merge is waiting on a Node-version fix on llm, which I've posted as a new job.

**What I did**
- **Weave:** I commented `@dependabot rebase` on the PR. Dependabot hadn't regenerated the branch after about 20 minutes, so I wove it myself in the job's own project checkout:
  - Rebased onto llm 48d6f3e08b.
  - Took llm's side of the four conflicting `package.json` files and re-applied only the `preact` range change (`^11.0.2`).
  - Regenerated `yarn.lock` and force-pushed with lease: dc20718e12 → 908d56d62d. The commit author is still `dependabot[bot]`. The PR now reads MERGEABLE.
- **Moved set:** a fresh resolve pulled in `preact@11.1.1`, which the earlier verdict doesn't cover. I pinned the lockfile entry back to the reviewed `preact@11.0.2`, using the same checksum as Dependabot's own commit.
  - The only version that moves against llm is preact 10.29.8 → 11.0.2, so the earlier verdict covers it.
  - `yarn install --immutable` passes.
- **CI:** 37 of 38 checks are green. The only red is `test-xs`: the `@endo/hardened262` baseline for `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` flips from passed to failed. It failed again on rerun.
- **Why `test-xs` is red:** the base causes it, not preact.
  - `.node-version` is `lts/*`, which CI now resolves to Node 26.13.0. The last green llm run used Node 24.
  - Rerunning `test-xs` on llm's own run (job 125718398161) fails the same way.
  - The same failure appears on #1639, #667, #1588 and `ci/daemon-test-rust`.
  - Because the botanist gate requires green CI, I did not drive `ci-wait-merge` to a merge.

**What changed**
- **PR branch:** the head is now 908d56d62d, rebased on llm. I added a status comment: https://github.com/endojs/endo-but-for-bots/pull/1633#issuecomment-6596202923
- **New job `endojs-endo-but-for-bots-pin-node-version-24`:** a fixer job to pin `.node-version` to 24 in a standalone PR against llm. This follows the proxy's tentative direction in maintainer inbox message 20261103T010142Z-304820. Nobody had posted it, and it unblocks `test-xs` for every PR, not just this one.
- **Ledger:** non-terminal row at `entries/2026/11/03/052626Z-message-gardener-eb6a69.md`, with `project: endo-but-for-bots` and no terminal marker. It records the reason and the next owner. The daily `dependabotany-recheck-endo-but-for-bots` schedule already exists.

**Next owner**
After the Node pin lands on llm, the daily dependabotany recheck should conduct #1633:
1. Check that the lockfile still moves only `preact@11.0.2`.
2. Run `ci-wait-merge.sh endojs/endo-but-for-bots 1633 --dependabot-auto-merge`.

Real Node 26 compatibility for the hardened262 `caller`/`arguments` assertions is a separate follow-up that the maintainer should decide on.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1633-dependabot-rebase-conduct-endolin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 22 tokens (971174 cached reads)
- Output: 5853 tokens
- Cost: $2.4007304 (1 engagement(s) unpriced)
- Wall-clock: 7294s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
