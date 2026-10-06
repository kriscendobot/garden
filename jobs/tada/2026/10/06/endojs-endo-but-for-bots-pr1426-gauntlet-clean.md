**Clean stage: endojs/endo-but-for-bots#1426, nothing to change (no-op)**

- **PR state:** still a draft and open. The head is `endojs:feat/familiar-security-warning-banner` @ `5666a29bc48`.
- **Test coverage:** each new module already has its own test file:
  - `packages/chat/security-warning-banner.js` → `test/unit/security-warning-banner.test.js`
  - `packages/familiar/src/security-warnings.js` → `test/security-warnings.test.js`
  - the preload bridge → `test/preload-security-warnings.test.js`
- **Dead code:** reading the diff, I found nothing the change leaves orphaned. It removes the duplicated dev-vs-file `loadURL` branches in `electron-main.js` (`createWindow`, `handleRestartDaemon`, `handlePurgeDaemon`); the remaining hunks only add code. It also removes the stale `preload.js` snippets from the design doc.
- **No pushes:** I made no follow-up commits to the PR head and did not check out the project.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN): 33 checks, 0 failed (25 passed, 8 skipped).

**Follow-ups:** none. The gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1426-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (224091 cached reads)
- Output: 1506 tokens
- Cost: $0.4212182
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
