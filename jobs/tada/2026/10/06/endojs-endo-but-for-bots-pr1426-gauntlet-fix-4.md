# Gauntlet fix round 4: endojs/endo-but-for-bots PR #1426

I fixed both must-fix items from the panel-4 review, pushed one follow-up commit (`7d0aa13ec4`) to `feat/familiar-security-warning-banner`, and CI is green. `ci-wait-merge` returned rc 0 with 33 of 33 checks passing and none failing.

**Must-fix 1: a daemon restart or purge reloaded the Chat page with the old security result.** Raised by saboteur and assessor, and by wire-watcher as should-fix.
- **New reporter.** `packages/familiar/src/security-warnings.js` now has `makeSecurityWarningReporter({ verifyDefenses, chatPageUrl, onWarnings })`. Each window gets one page-load listener that always sends the newest warnings. Its `verifyAndWarn(window)` runs the defense checks again every time it is called.
- **Clean-start gap closed.** Before, a window whose first check found nothing never got a listener, so a problem found later could never reach it. Now it does.
- **Wiring in `electron-main.js`.** It uses the reporter at launch and when macOS reopens a window from the dock. Restart and purge now re-run the checks before reloading the page (`reverifyBeforeReload`). A failed check is logged and does not block the reload.
- **Dismissal wording.** The banner's doc comment in `packages/chat/security-warning-banner.js` used to say a dismissal lasts until a new warning arrives. It now also says a reload clears the dismissal, because the page is reloaded with a freshly checked result.
- **Changeset.** Updated to say the checks also re-run before a restart or purge reload.

**Must-fix 2: no regression test for re-checking a recreated window.** Raised by prover. I added six tests to `packages/familiar/test/security-warnings.test.js`:
- A window reopened from the dock gets a new result, not the one from launch.
- A reload after re-checking sends the new result exactly once.
- A window that started clean still receives a warning found later.
- A clean re-check stops the warnings.
- Warnings are logged, and nothing is sent to a closed window.
- A text check of `electron-main.js` confirms that restart and purge re-check before `loadURL` and that dock reopen re-checks. This one only reads the source; it does not run the Electron main process.

**Local checks:** the familiar package's 29 tests and the 10 chat banner tests pass. `tsc` and eslint report no errors; the only warning is an existing one in `electron-main.js` that this change didn't touch.

**Follow-ups:** none. The driver posts panel-5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1426-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1644195 cached reads)
- Output: 14195 tokens
- Cost: $1.2071869999999998
- Wall-clock: 2831s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
