Fix round 4 on endojs/endo-but-for-bots#1403 is done, and CI is green on the PR head (`378e1345a3`, 33 checks, 0 failed). But neither must-fix item is resolved in code. The first needs a maintainer decision and the second can't be fixed in this package alone.

**Must-fix 1, starting version and bump level (packager).** I left the metadata alone as the panel instructed, at `0.1.0` with a `major` changeset. I added a "Release metadata (maintainer to confirm)" paragraph to the PR body. It says:
- Changesets will take this to **1.0.0** on first release.
- The precedent for this choice is four sibling packages, cbor, crc32, hardened262 and pubsub, not any repo rule. `CONTRIBUTING.md` says nothing on this.
- The alternative precedent is `0.0.0` with a `minor` bump, which first releases at `0.1.0`. host-spawner and exo-shell use it.
- It asks the maintainer which they want.

**Must-fix 2, "acknowledgement" in `packages/inference/SECURITY.md` (orthographer).** This finding is wrong for this repo. I committed the spelling fix (`67958fae11`) and it broke lint. `scripts/check-security-md.sh` requires every package's `SECURITY.md` to be byte-identical to `packages/skel/SECURITY.md`, so I pushed a revert (`378e1345a3`) explaining why. The only way to fix the spelling is in the canonical skel copy and all its copies across the repo, as a separate change.

**Should-fix items I did not do:**
- **CHANGELOG stub:** I kept `packages/inference/CHANGELOG.md`. The four siblings that use the same `0.1.0` + `major` shape each ship an identical header-only stub, so it's consistent with the version choice.
- **Squashing the 28 commits:** not done. It would rewrite the PR's history, which this push-only fix round doesn't do. The history now also has the spelling commit plus its revert, which cancel out, so a squash-type cleanup pass before merge would be worth doing.

**CI.** The first run on the new head failed one test leg (Node 22, Ubuntu) in `@endo/patterns`, "M.choose well-formedness". That is a randomly seeded property test that failed on one generated input, and this PR doesn't touch that package. A rerun of just that leg passed. The first waiting call hit its 3300s deadline while the rerun was still going, and a short follow-up wait confirmed green.

**Follow-ups:**
- The maintainer needs to decide the release version (first release at `1.0.0` or `0.1.0`).
- They also need to decide `cancelled` vs `canceled` in the API names (the orthographer marked this comment-only).
- Fixing "acknowledgement" in the shared skel `SECURITY.md` would be its own repo-wide change.
- Future panels should stop flagging per-package `SECURITY.md` spelling.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (3552717 cached reads)
- Output: 12855 tokens
- Cost: $1.5863314
- Wall-clock: 6155s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
