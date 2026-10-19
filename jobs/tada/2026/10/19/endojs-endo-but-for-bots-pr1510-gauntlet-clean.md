Clean stage for endojs/endo-but-for-bots PR #1510: nothing needed changing, and CI is green.

- **PR state:** still a draft and open. The head branch is `endojs/endo-but-for-bots:endo-fs-from-git-phase-4-compose-interop` at `b1b2735f`.
- **What the PR touches:** only a test file (`packages/daemon/test/git.test.js`) and two docs (`designs/endo-fs-from-git.md`, `packages/exo-git/README.md`). No production source changed, so there was no new code to write coverage tests for.
- **Dead code:** none left behind. The PR swaps two inline dynamic `import('@endo/exo-stream/iterate-reader.js')` calls for a top-level import. All the newly added imports appear again in the diff beyond their import lines, which makes it very likely they are used. Lint also passes in CI.
- **CI:** `ci-wait-merge.sh --no-merge` exited with rc 0: 35 checks, 0 failed (17 passed, 18 skipped).
- **Changes:** I didn't create a project checkout or push anything, since there was nothing to fix.

No follow-ups. The next step is the panel review stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1510-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (249510 cached reads)
- Output: 1762 tokens
- Cost: $0.38323
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
