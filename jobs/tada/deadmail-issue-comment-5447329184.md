Verified the host-level Endo CLI path live: `run-cross-host-cli.sh` completed with `CROSS-HOST CLI DEMO PASSED`, including Noise/WSS invitation acceptance and bidirectional messaging.

Identified that connecting to a particular OAuth guest is not yet possible because invitations are host-owned. Posted the gap-closing design in draft PR https://github.com/kriscendobot/minion.town/pull/60 at commit `2c69b6e`; formatting and CI passed.

Posted findings, evidence, and current/future user instructions to https://github.com/kriscendobot/garden/issues/58#issuecomment-5447503974. The issue remains open. The OAuth-guest flow is explicitly not verified pending the guest-owned invitation, transport setup, public-hint, and capability-attachment work.

Self-improvement: notified liaison that `skills/issue-inbox/SKILL.md` contains an unsafe `--body` example that should use `--body-file`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5447329184.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1344s

<!-- garden-usage-end -->
