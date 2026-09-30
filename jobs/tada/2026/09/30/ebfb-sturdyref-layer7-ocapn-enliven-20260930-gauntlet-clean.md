---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage — endojs/endo-but-for-bots#1397: CI is RED (rc=3), stage failed

I pushed nothing to the PR. I also didn't run the coverage pass: coverage can't be measured while the build graph is broken, and both failures come from lower in the stack.

**CI at head `f2121918`:** `ci-wait-merge.sh --no-merge` returned **rc=3 (RED)**. 7 of 33 checks failed: `lint`, `test` (22.x and 24.x on ubuntu and macos-15), and `cover` (22.x and 24.x on ubuntu).

**Two root causes, both inherited from the base branch.** The base, `build/sturdyref-captp-construct-ef45f1d` (the layer below, PR #1396), fails the same 7 jobs with the same errors:

1. **Build dependency cycle (breaks all test and cover jobs).** turbo reports `Cyclic dependency detected: @endo/sturdyref#build <-> @endo/pass-style#build`. `packages/pass-style/package.json` depends on `@endo/sturdyref`, and `packages/sturdyref/package.json` depends on `@endo/pass-style`. #1397 touches neither file.
2. **Lint: tsconfig drift.** `yarn build:types:check` fails with `Drift detected: packages/ocapn/tsconfig.composite.json`. In that file the `../sturdyref` reference comes before `../stream`, which is out of alphabetical order. The cycle may also be confusing the generator. The failure appears on the base first.

**What #1397 changes:** `packages/ocapn/src/client/sturdyrefs.js` (+32/−17), a new `packages/ocapn/test/sturdyref-enliven.test.js` (+248), and a changeset. None of these files causes either failure.

**Other notes:**
- I started setting up the isolated project checkout (`ensure-project-worktree.sh`), but it made no progress for about 7 minutes, so I stopped it. A second `ensure-project-worktree.sh` process for this same job base (PID 1488740, started 09:08) was still running when I looked. I left it alone. I got everything above from the GitHub API instead.
- **Next step:** fix the stack at #1396 or below. Remove one side of the `pass-style` ↔ `sturdyref` dependency, then run `yarn build:types:gen` so the ocapn composite tsconfig is regenerated. After that, weave #1397 onto the fixed base and re-run the gauntlet for #1397.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (827945 cached reads)
- Output: 5261 tokens
- Cost: $0.6564890000000001
- Wall-clock: 670s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
