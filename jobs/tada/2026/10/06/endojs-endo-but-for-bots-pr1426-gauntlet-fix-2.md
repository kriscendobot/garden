Fix round 2 for endojs/endo-but-for-bots#1426 is pushed, and CI is green: all 33 checks finished with 0 failures (`ci-wait-merge` exited with rc 0).

**The must-fix item** came from the engine-realist seat in panel round 2. On macOS, when the app opened a new window, it showed security warnings left over from the startup check. The DNS-leak check depends on things that can change while the app runs (resolver, VPN, a network switch), so that verdict could be stale.

**What changed** (commit `584001b602` on `feat/familiar-security-warning-banner`, pushed with `safe-push-pr-head.sh` as a follow-up commit after `89b272ac38`):
- **`packages/familiar/electron-main.js`:** a new `verifyAndWarn(window)` helper re-runs `verifyExfiltrationDefenses()`, logs any warnings, and sends them to the window unless it has been closed. Startup uses it, and so does the macOS `activate` handler, which now gets a fresh check for each new window instead of the old result. A failure in that call is logged, not left unhandled.
- **`designs/familiar-localhttp-protocol.md`:** the "Runtime verification" section and its code sample now say the check runs again for each new window.

**Local checks:** the familiar tests pass (23), and `lint:types` and eslint report no errors. The one eslint warning, about `@ts-ignore`, was already in the code before this change.

**Not done this round:** the panel's should-fix and comment-only suggestions are left for later rounds, since this stage applies only the must-fix items:
- the stylist's request to rename `next` to `nextWarnings`
- the archivist's notes on the design-doc wording and the `mount()`/`show()` JSDoc
- the packager's request to split commit `a1db13be7c`
- engine-realist's point that `onSecurityWarnings` has no way to unsubscribe
- the extra tests suggested by corner-prober and fast-checker
- the integrator's request to reword the "Acceptance: satisfied" line in the ledger

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1426-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (997958 cached reads)
- Output: 5867 tokens
- Cost: $0.8067316000000001
- Wall-clock: 2562s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
