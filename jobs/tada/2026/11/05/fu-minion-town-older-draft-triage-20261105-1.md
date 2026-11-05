Reproduced the same-document guest recovery defect in real Chromium: pasting a guest URL over the open landing left the splash visible and the credential in the address bar.

Opened draft PR https://github.com/kriscendobot/minion.town/pull/252 at commit `755d0179`. `home.js` now reloads on `hashchange`, and the browser gate covers same-tab recovery.

Verification: pre-push gates passed all 12 stages; home-page tests passed 41/41; Chromium browser gate passed 31/31. GitHub’s five CI checks remain queued behind the busy self-hosted runner after a bounded foreground wait.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-older-draft-triage-20261105-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1174s

<!-- garden-usage-end -->
