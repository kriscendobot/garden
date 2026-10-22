**PR #1538 viability report** (endojs/endo-but-for-bots, `build/daemon-git-clone` → `llm-54d3d2a`, draft, open, not merged)

The PR is still needed and nothing has replaced it, so the gauntlet can begin.

Deciding question: Does `llm` still ship the old options-bag `provideGitClone(opts)`, with origin defaulting to fetch+push and no discard on failure, and does no other PR or commit already implement the `daemon-git-clone` design from #709?

Evidence:
- **The PR:** It was built today (2026-10-22) by job `fu-design-daemon-git-clone-provide-git-clone-bootstrap-1`. It has two commits. One fixes how `@endo/git` aborts a credentialed git call by signalling the whole process group. The other implements phases 1–4 of the #709 design: the new `(destMount, petName, { endpoint, identity, origin })` signature, an origin that defaults to fetch-only, names stored last, and the destination emptied on failure. It has no reviews or comments yet.
- **Base code:** On current `llm`, `packages/daemon/src/host.js:1665` still defines `provideGitClone = async opts => …` with the old options-bag shape. The change this PR makes has not landed by any other route.
- **Base drift:** `llm` is only 2 commits ahead of the frozen base `54d3d2a`. Both are the unrelated `design(parcel)` layer-1 shim design (#1389), so the premise is unchanged.
- **Competing work:** Searching for `provideGitClone` finds no other build PR. The design PRs #709, #1367 and #988 are still open and are what this PR implements or references. The related merged PRs (#365, #538, #706, #835, #906) are earlier groundwork, not replacements.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (160159 cached reads)
- Output: 1342 tokens
- Cost: $0.37441579999999997
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
