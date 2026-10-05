The clean stage for endojs/endo-but-for-bots PR #1426 needed no changes, and CI is green at the current head `d9acaed022`.

- **Idempotence check:** PR #1426 is open and still a draft. All 32 checks at head `d9acaed022` finished with none failing. That includes `cover (22.x/24.x, ubuntu)`, `familiar-bundle`, `lint`, and `test` on Node 22.x and 24.x for both Ubuntu and macOS.
- **Coverage:** I reviewed the diff rather than running a local coverage pass, because the PR was already in the right shape. It touches `packages/chat` and `packages/familiar`, and each new module ships with its own tests:
  - `security-warning-banner.js` is tested by `test/unit/security-warning-banner.test.js`. The tests cover rendering, dismissing, empty or malformed payloads, warning text not being treated as markup, re-mounting after the page body is replaced, a dismissal lasting until a new warning arrives, and subscribing to the preload channel.
  - `src/security-warnings.js` is tested by `test/security-warnings.test.js`. The tests cover waiting for a page that is still loading, sending at once to a loaded page and again on reload, sending nothing when there are no warnings, and the channel name matching the one in the preload script.
- **Dead code:** none. The old inline `webContents.send` in `electron-main.js` was replaced in place by `deliverSecurityWarnings`. The `onSecurityWarnings` change in `preload.mjs` rewrites its old listener rather than leaving it behind. Nothing was left unused.
- **Pushes:** none.
- **CI wait:** `ci-wait-merge.sh endojs/endo-but-for-bots 1426 --no-merge` returned rc 0 (CI GREEN).

Follow-ups: none from this stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (225134 cached reads)
- Output: 1813 tokens
- Cost: $0.46952679999999997
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
