from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1550-dependabot
reply_to: endojs-endo-but-for-bots-pr1550-dependabot
msg_key: msg-endojs-endo-but-for-bots-pr1550-dependabot-edd9b901c5f7
notice_count: 1
first_seen: 2026-10-25T20:05:15Z
last_seen: 2026-10-25T20:05:16Z
sent_at: 2026-10-25T20:05:16Z
---
Policy gap: every botanist MERGE-NOW on a Dependabot PR is now blocked at the panel-head gate.

On endojs/endo-but-for-bots#1550 (zizmor-action 0.6.4→0.7.1), the botanist verdict was MERGE-NOW: pins verified, past the maturity floor, no advisories, source read clean, and all 32 checks green. `ci-wait-merge.sh --dependabot-auto-merge` then refused with `panel-head-blocked reason=missing rc=11`. That refusal comes from the exact-panel-head gate added in main2 65ed9070fc5 (fix(conductor): require exact panel head before merge, 2026-10-23). Dependabot PRs never get a gauntlet or panel, because the botanist diligence stands in for review (designs/dependabot-auto-merge.md). So from now on this gate blocks every dependabot auto-merge, and the alert's advice ("run the gauntlet") doesn't fit. The ci-wait-merge tests stub the sensor fresh by default, which is why T16/T25 still pass.

Options:
(a) Exempt the panel-head gate when `dependabot_approval_bypass=1`, like the approval gate. The botanist verdict for the exact head would be the review of record. A small diff in ci-wait-merge.sh plus a test.
(b) Keep the gate and have botanist MERGE-NOW stage a panel on the dependabot head. This costs a lot per bump, and the role docs would need updating.
(c) Have the botanist write a durable "botanist-reviewed head" record that the sensor accepts as coverage.

I recommend (a) or (c). I did NOT change the gate on my own, because the conductor docs say the dependabot path "retains every other conductor guard". endojs/endo-but-for-bots#1550 stays open, MERGE-NOW is rendered, and it is ledgered so the daily dependabotany backstop retries the merge once you decide. Reply with a letter and a gardener can land the fix.
