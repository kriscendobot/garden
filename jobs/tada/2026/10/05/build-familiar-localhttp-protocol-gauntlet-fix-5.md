I applied the panel round 5 must-fix items to endojs/endo-but-for-bots PR #1426 and pushed them as one follow-up commit. CI is green on the new head: 32 checks, 0 failed (`ci-wait-merge` rc 0). I did not regroup the commits, which the integrator asked for as a should-fix.

**Code changes** (commit `646201a3a6`, pushed with `safe-push-pr-head.sh`; the head moved from `418e769679` to `646201a3a6`):
- **Pruner:** the module comments in `packages/familiar/src/security-warnings.js` and `packages/chat/security-warning-banner.js` now state only what the code does. The rationale stays in `designs/familiar-localhttp-protocol.md`.
- **Purist:**
  - `electron-main.js` now builds the Chat `file:` URL with `pathToFileURL(...).href` instead of joining `file://` onto the path.
  - A new `SecurityWarningBanner` typedef names the banner's return shape.
  - A new test checks that `onSecurityWarnings` returns `undefined`.
- **Breaker:** in `preload.mjs`, each subscriber call is wrapped in `try/catch`, so one subscriber that throws no longer stops delivery to the others. A new test covers this.
- Locally, the familiar ava tests (15) and chat banner tests (10) pass, and `lint:types`, eslint (0 errors) and prettier are clean.

**PR body:**
- Scaling Considerations and Upgrade Considerations are back. I kept the `###` subsections, because the upstream template nests them under `## Description`; the integrator's claim that they should be top-level headings was wrong.
- The Testing section is trimmed as the pruner asked.
- I added the Phase and evidence ledger. It names `designs/familiar-localhttp-protocol.md` and `designs/README.md`, with disposition `deliverable` for the banner slice only. Layer 6 and the MessagePort bridge stay open, and the banner has not been observed in a live Electron window; the ledger lists that as outstanding.
- I ran `phase-evidence-gate.sh` locally on the new body. It moved from `blocked` to `attention` (rc 10), which means it is no longer blocking and the integrator compares the ledger against the design.
- The body is still about 319 words against the ~300 guideline (the count includes the ledger), so the pruner may flag length again.

**Summary comment:** posted as issuecomment-5996785187. It maps each round-5 item to its fix, states the declined item, and says the loop goes next to panel round 6.

**Not done:** regrouping the commits into feat/feat/docs. This stage only adds follow-up commits and does not rewrite history. It needs a retcon, or a squash when the PR merges.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1979466 cached reads)
- Output: 11102 tokens
- Cost: $1.2727972
- Wall-clock: 903s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
