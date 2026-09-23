Planning and launch complete.

Opened draft [Endo PR #1332](https://github.com/endojs/endo-but-for-bots/pull/1332), commit `ec51cecdcf`, with the integration plan and dated roadmap reprioritization ahead of M3’s client-side bridge work.

Rechecked live repositories and PRs:

- #340 merged; #684, #688, #693, #990 and #1124 remain drafts.
- minion.town’s authenticated guest reveal exists, but returns a raw formula identifier.
- Endo’s `adoptFromLocator` exists without a CLI command.
- Formula-fetch support remains in #1124. The cited nonce-locator design file is absent; the actual specification is external-connectivity §2.
- Public demo routing and the account guest daemon need reconciliation.

Recorded orchestration **`endo-minion-town-guest-locator-federation`**, serial and halt-on-failure, with five durable children:

1. `endo-minion-town-federation-endo-build`
2. `endo-minion-town-federation-town-build`
3. `endo-minion-town-federation-release-gate`
4. `endo-minion-town-federation-deploy`
5. `endo-minion-town-federation-live-acceptance`

Verified all children’s ownership and the orchestration record against committed `journal2`; the watcher timer is active. Documentation diff checks passed.

Manual review remains required before deployment. Production acceptance is **not verified**; the final child owns the actual authenticated browser → locator → local Endo CLI → remote guest test. Human login participation may be needed.

Self-improvement: reported a blocked-child premature-retry issue to the liaison; release checks prevent those retries from authorizing deployment.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-minion-town-guest-locator-federation-supervisor.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 726s

<!-- garden-usage-end -->
