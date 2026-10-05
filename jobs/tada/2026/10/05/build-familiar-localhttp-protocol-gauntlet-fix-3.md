## Fix round 3: endojs/endo-but-for-bots PR #1426

I applied all four must-fix items and the one should-fix from the panel-3 review (5415357840, at head `baeea40b81`). The fix is pushed and CI is green.

**Code and design doc** (commit `0b87f8828a`, pushed with `safe-push-pr-head.sh` from `baeea40b81` to `0b87f8828a`):
- **breaker:** `packages/chat/main.js` now calls `securityWarningBanner.mount()` after the "Gateway not configured" page replaces the body and before the `throw`. This matches the other three places that replace the body, so a warning already shown in Electron is no longer wiped by that page.
- **archivist / assessor:** finished the cut-off comment in the code sample in `designs/familiar-localhttp-protocol.md`. It now ends "…does not receive them:".
- **typist (should-fix):** added `@returns {{ show, mount }}` JSDoc to `makeSecurityWarningBanner`.

**PR body** (edited with `gh pr edit`):
- **pruner:** removed the "Scaling Considerations: None" and "Upgrade Considerations: None beyond the changeset" sections, and the Documentation sentence that repeated the Description.
- **coverage-auditor (overrides the pruner on the conflicting cut):** kept the sentence about the untested call sites and replaced it with the reason they can't be tested. `electron-main.js` imports `electron` and runs its whole startup when it loads (`app.whenReady`, starting the daemon, opening a `BrowserWindow`), while the ava suite runs under plain Node with no Electron or display. The logic behind the two call sites is in `src/security-warnings.js`, which has tests. I didn't add an Electron test.

**Not verified locally:** this checkout's `node_modules` is only partly installed, so I didn't run tsc or eslint. CI ran them.

**CI:** `ci-wait-merge.sh --no-merge` returned 0. All 32 checks passed, none failed (about 11 minutes).

No follow-ups from me. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (781877 cached reads)
- Output: 5055 tokens
- Cost: $0.6554034000000001
- Wall-clock: 837s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
