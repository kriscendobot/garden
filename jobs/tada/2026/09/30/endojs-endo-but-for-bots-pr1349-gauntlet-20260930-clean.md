The clean stage for endojs/endo-but-for-bots PR #1349 is done. I made no changes because none were needed, and CI is green at the current head.

- **PR state:** The PR is an open draft at head `d98467c6b5f15cb1a4963a1064ed7bcb71d1e273`. All 15 status checks passed, including `cover`, `test-xs`, `test262` and the Node 22/24 test runs on Ubuntu and macOS.
- **Coverage and dead code:** The PR changes two files:
  - `packages/ses/test/_xs.js` adds an XS smoke check that `TextEncoder`/`TextDecoder` inside a compartment match what the host provides, and are hardened when present.
  - `.github/workflows/ci.yml` only changes a version comment on an action pin (`# v3` → `# v3.0.3`).

  There is no new library code to cover, and nothing was left unused, so I didn't push anything.
- **CI check:** `ci-wait-merge.sh endojs/endo-but-for-bots 1349 --no-merge` returned rc=0 (`total=15 failed=0 → CI GREEN`).

There are no follow-ups; the gauntlet can go on to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (147119 cached reads)
- Output: 1103 tokens
- Cost: $0.33465180000000005
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
