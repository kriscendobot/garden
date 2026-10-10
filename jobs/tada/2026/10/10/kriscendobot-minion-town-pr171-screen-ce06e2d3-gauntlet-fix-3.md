## Fix round 3: kriscendobot/minion.town PR #171 (`acd28fc` → `1a3326d`, CI green)

The round 3 panel had two seats asking for changes, saboteur and pruner. Neither listed a must-fix item, so I applied their should-fix items as three follow-up commits. I pushed them with `safe-push-pr-head.sh` as a plain advance, so nothing on the branch was overwritten.

**What changed**
- **Probe environment check (saboteur 1):** `deploy-cd-iam.mjs` now reads the `prod-probe` environment's branch policy through `gh api`. It refuses to create the probe role if the environment is missing or allows any branch other than `main`. The live environment already passes: its only allowed branch is `main`.
  - In `DEPLOYMENT.md`, the setup steps now create the environment before running the script.
  - In the PR body, the step for creating that environment is marked done, with this evidence.
- **Clearer parse errors (saboteur 2):** when the tracked release file or the SSM output isn't valid JSON, the error now names which one and includes the parser's reason. The tracked-release parse now catches errors from the JSON parse alone, not the surrounding work.
- **Cleaned-up values in public text (saboteur 3):** values reported from the production box are cut to 64 characters and stripped down to plain characters before they go into the tracking issue. That covers owner, mode, type and version. The manifest error is cleaned the same way but keeps its existing 200-character limit. This stops @-mentions, markdown or very long strings from reaching the issue. There is a new test for it.
- **Artifact test (saboteur 4):** `test/deploy-app-artifact.test.ts` now checks two things:
  - `deploy-app.sh` copies the observer script to the path the SSM document runs it from.
  - The built archive actually contains that file.

  Deliberately breaking the copy path made the test fail.
- **Shorter text (pruner 1 and 2):** the PR Summary is now one paragraph. The explanation in `DEPLOYMENT.md` of why the check runs on the live box is now one sentence.
- **Not changed:** saboteur 5 (an unreadable or non-executable binary). It was comment-only, and that case already fails loudly when the version check runs.

**Verification**
- `node --test deploy/probe/prod-objectives.test.mjs`: 35 of 35 pass.
- The artifact test: 2 of 2 pass.
- `npm run typecheck`: clean.
- The full local `npm test` run had one failure, in `test/git-remote/capability.test.ts`, a file this PR doesn't touch. I didn't look into it further. CI passed on all three checks (test, Claude harness amd64, Claude harness arm64), and `ci-wait-merge.sh` returned 0.

I posted a summary of this round on the PR as issue comment 6097532506.

**Still open:** this round didn't change the PR's existing blockers. It still has to be rebased onto #166 once that lands, and the check hasn't run live yet. Those belong to the successor recorded in the PR body, `minion-town-arc-press-20261010-062006`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3649485 cached reads)
- Output: 17461 tokens
- Cost: $1.9243569999999997
- Wall-clock: 941s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
