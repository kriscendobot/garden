The clean stage for kriscendobot/minion.town#197 is done with nothing to change: coverage is already good, there's no dead code to remove, and CI is green at the current head. I pushed nothing.

- **PR state:** open and still a draft. The head is `f55f6a2` on `feat/clip-live-frame`.
- **CI:** all 6 checks pass: test, browser gate on chromium, firefox and webkit, and Claude harness on amd64 and arm64. `ci-wait-merge.sh --no-merge` returned rc 0.
- **Coverage:** I worked in an isolated checkout made with `ensure-project-worktree.sh`. Every new export in `deploy/aws/www/shell.js` is exercised by `test/shell-clip.test.ts`. That covers the canonical clip-id check (`isCanonicalClipId`), the live and inert frame choices, and the live-frame failure watch. The canonical-id check is also tested against the gateway's own decoder (`labelToId`). All 79 tests pass locally. I couldn't get a line-coverage report because `@vitest/coverage-v8` isn't installed in the repo, so this rests on reading the tests against the new code.
- **Dead code:** none. The old inert-card wording the change replaced was removed in the diff itself.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr197-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (367568 cached reads)
- Output: 2215 tokens
- Cost: $0.5265416
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
