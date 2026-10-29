---
orchestration-failed: true
---
orchestration-failed: true

**Gauntlet CLEAN stage for endojs/endo-but-for-bots#1584 failed: CI is RED at head `f6a05cde2b`.**

`ci-wait-merge.sh` returned rc 3 with 2 failures out of 15 checks. Neither failure involves a file this PR changes. The PR is a draft and only touches tests: `packages/ses/test/_xs*.js`, `scripts/generate-test-xs.js` and `package.json`. Its base is the frozen `master-6ee3fda`.

1. **build → "Check for cycles"** exited with code 127: `scripts/graph.sh: line 32: tred: command not found`. The CI runner image no longer has graphviz (`tred` is part of it), so this is a runner problem, not the PR. Sibling PR #1518 on the same base passed `build` on 2026-10-21, so this red is new.
2. **zizmor** exited with code 13 on this warning: `ci.yml:270: action's hash pin has mismatched or missing version comment` for `dorny/paths-filter@d1c1ffe… # v3`. The action's floating `v3` tag has moved, the same failure class as PR #546. `ci.yml` is unchanged from the base. zizmor passed on base `6ee3fda` in July, and sibling #1518 has failed the same way since 2026-10-21.

The other 13 checks are green, including `test-xs`, which runs this PR's XS smoke tests, plus lint, cover and the Node, Hermes and test262 legs.

**What I did:**
- **Coverage pass:** nothing to cover, since the change is test-only and adds no source code. I found no orphaned dead code, so I made no changes and pushed nothing.
- **CI wait:** waited for every check to finish and confirmed the result is RED.

**Follow-ups for the maintainer:** both fixes go to the base branch or the workflow, not to this PR's diff.
- **tred:** install `graphviz` in the `build` job of `ci.yml`, or move the job to a pinned runner image.
- **zizmor:** replace the `# v3` comment at `ci.yml:270` with the exact tag that commit `d1c1ffe` points to.

After that lands on a new frozen base, weave #1584 onto it and re-run the gauntlet. #1518 has the same zizmor red and would benefit from the same fix.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1584-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (423061 cached reads)
- Output: 3104 tokens
- Cost: $0.5503402
- Wall-clock: 129s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
