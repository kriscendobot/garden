I made no changes, because PR #1428 already met the clean-stage bar.

**Why it was a no-op**
- **The PR:** endojs/endo-but-for-bots#1428, "chore: get upstream master 356d6e7 CI green". Head is `endojs:fix-upstream-master-ci`, base is the frozen branch `master-356d6e7`. It is open and still a draft.
- **CI is green on the current head.** All 14 checks passed: lint, build, zizmor, test on Node 22.x and 24.x for ubuntu and macos-15, cover, test262 on 22.x and 24.x, test-hermes, viable-release, test-xs and test-ocapn-python.
- **There was nothing to cover and no dead code.** The PR changes only build tooling and dependency files:
  - `package.json`: the `clean` script now keeps `.yarn/install-state.gz`, and there are two new `resolutions` entries (`configstore@npm:^1.4.0` → `5.0.1`, `nconf@npm:^0.8.2` → `0.13.0`).
  - `scripts/pack-all.mjs`: the same install-state exclusion in both `git clean` calls, plus updated doc comments.
  - `yarn.lock`: the matching descriptor rewrites.

  No package source is touched, so a coverage pass has no target, and none of these changes leaves code unused.

I didn't create a project worktree, push anything, or run `ci-wait-merge.sh`, since CI had already passed at the current head.

**Follow-ups:** none from this stage. The gauntlet moves on to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (115801 cached reads)
- Output: 978 tokens
- Cost: $0.38640019999999997
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
