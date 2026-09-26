Confirmed the daemon `EndoGuest` facet itself refuses all 40 Host-only methods; added a live CapTP regression test covering unconfined, endowment, host-minting, and `@host` lookup paths.

Opened draft [endojs/endo-but-for-bots#977](https://github.com/endojs/endo-but-for-bots/pull/977); local daemon suite passed 228 tests and all PR CI checks passed.

The deployed exposure was confirmed separately in minion.town’s public WebSocket gateway, not the daemon guest surface. Private remediation [kriscendobot/minion.town#44](https://github.com/kriscendobot/minion.town/pull/44) is green; deploy it urgently to contain the exposure.

Follow-up: deploy the minion.town remediation; #977 remains the daemon-boundary regression PR.

Self-improvement: nothing further identified.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-unconfined-from-tree.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 72 tokens (3283688 cached reads)
- Output: 32924 tokens
- Cost: $3.4407470000000004 (3 engagement(s) unpriced)
- Wall-clock: 3532s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
