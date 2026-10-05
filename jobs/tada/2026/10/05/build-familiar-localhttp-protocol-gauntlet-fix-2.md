Fix round 2 for endojs/endo-but-for-bots#1426 is pushed and CI is green (32 of 32 checks passed).

**The must-fix from the round-2 panel (breaker):** `isChatPageUrl` treated any `file:` URL and any `http://127.0.0.1` port as "the Chat page". The navigation guard lets the window open any `file:` page without asking, so a foreign local page could have received the security-warning payload, which says which exfiltration defense failed.

**What I changed** (commit `baeea40b81`, pushed with `safe-push-pr-head.sh` on top of `5f9d47573d`):
- **`packages/familiar/src/security-warnings.js`**: `isChatPageUrl(url, chatPageUrl)` now requires an exact match on protocol, host, port and path against the one Chat URL, ignoring only the query and fragment. `deliverSecurityWarnings` takes `chatPageUrl` as a third argument.
- **`packages/familiar/electron-main.js`**: there is now a single `chatPageUrl` constant. In dev mode it is `http://127.0.0.1:${vitePort}/`, which pins the port the same way `navigation-guard.js` does (this also covers the saboteur's should-fix). Otherwise it is `file://${chatDistPath}`. Every `loadURL` call and both delivery calls use it, which also removes the duplicated dev/file branches in the restart and purge handlers.
- **`packages/familiar/test/security-warnings.test.js`**: new tests for a foreign `file:` page (`file:///tmp/evil.html`), wrong paths, a different dev port, `localhost`, `https`, and a malformed Chat URL. All 10 tests pass locally, and `yarn lint` shows only warnings that were already there.
- **The design doc and changeset**: updated to say the warnings go only to the exact Chat page, not to weblets or other pages in the same window.

**Not addressed:** the breaker's should-fix that `window.familiar.onSecurityWarnings` is exposed to every page in the window, along with the preload's replay buffer. This is not a must-fix; restricting the send already closes the practical path, but the exposure itself is still open if a later round wants it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1082557 cached reads)
- Output: 7990 tokens
- Cost: $0.9031834000000001
- Wall-clock: 730s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
