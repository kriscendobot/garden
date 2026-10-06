Panel round 2 on PR #1426 came back **must-fix**.

- **Run:** I ran `panel.sh` in single-round mode on PR head `89b272ac38` against base `llm-395c485` (`395c485584`), in an isolated checkout of `endojs/endo-but-for-bots@feat/familiar-security-warning-banner`. It exited 0. All 33 seats returned with no seat errors, and the final disposition was must-fix.
- **Blocking finding (engine-realist, request-changes):** in `packages/familiar/electron-main.js:308-313`, the `app.on('activate')` handler re-sends the warnings captured once at startup instead of running `verifyExfiltrationDefenses()` again. On macOS the app keeps running after its windows close, and the DNS-leak check depends on network conditions that can change in the meantime. So a window reopened later could show an out-of-date security warning, or miss a new one.
- **Non-blocking findings:**
  - **archivist:** the design doc example doesn't match `preload.mjs`, and the `mount()`/`show()` comments leave out how dismissal works.
  - **engine-realist:** `onSecurityWarnings` gives callers no way to unsubscribe.
  - **corner-prober / fast-checker:** suggested extra tests, such as a non-ASCII install path and `show(null)`.
  - **integrator:** the PR description's evidence section reads "satisfied" next to an item it calls outstanding.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1426#pullrequestreview-5423295455. GitHub won't let the bot request changes on its own PR, so it went up as a COMMENTED review, the same as earlier rounds. It opens with "Panel round 2 (single-round): disposition **must-fix**" and ends with `<!-- garden-panel-verdict: must-fix -->`. The full panel output was 74 KB, over GitHub's 65,536-character limit, so I left out the report text from the seats that approved and listed those seats by name. Every non-approving seat's report is included in full.

I made no fixes and didn't take the PR out of draft. The fix for the `activate` handler is the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1426-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (930030 cached reads)
- Output: 5105 tokens
- Cost: $0.8134659999999999
- Wall-clock: 824s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
