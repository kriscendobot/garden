CI is green. Fix stage complete.

## Completion report — gauntlet FIX round 4, endojs/endo-but-for-bots PR #1227

Applied the panel-4 must-fix items to `designs/daemon-guest-bot-incarnation.md` on the PR head (`kriscendobot:design/endo-daemon-guest-bot-incarnation`), pushed one follow-up commit (`c98690585`), and watched CI to terminal.

**Items addressed** (from the three request-changes seats):

- **pedant (must-fix)** — removed all five em-dashes flagged (lines ~148, ~346, ~352), rewriting each as a parenthetical per `skills/em-dash-style`. Re-grep confirms the doc is now clean of em-dashes and other typist-hostile code points.
- **critic (must-fix)** — the `operator`-breaker non-persistence no longer borrows the credential/quota re-probe rationale. Scoped that rationale explicitly to *external* self-repairing state, and argued the `operator` case separately: its non-persistence is a first-increment *scope* decision (an operational, not security, pause), with rebind/collect as the durable lever for a pause that must survive a restart, and persisting the `operator` reason noted as deferred next-increment work.
- **skeptic (should-fix ×2)** — (1) added a paragraph on the closed `BotBlockedReason` union's shared-upstream-outage gap, the consumer-side mapping onto the `needs-auth`/`retryWhen` seam, and a deferred first-class `upstream-unavailable` reason (also added to the deferred-work list); (2) added Test Plan item 12 covering the unbound-guest query/command asymmetry (`getBotStatus` → `{ type: 'unbound' }`; `stopBot`/`retryBot` throw `TypeError`).

Comment-only findings from decomplector/ergonomist/novice/orthographer/copyeditor were not applied (not blocking; panel re-runs as panel-5). The critic "Formula shape" atomicity item in the aggregate must-fix list is, per the full per-seat verdict, an out-of-scope implementation-level note for the code panel, so it was not applied here.

Also reverted an unrelated stray `packages/floot/package.json` change (a `\u2014`→literal em-dash normalization introduced by the warm-cache install) so it stayed out of the commit; only the design file was committed with an explicit pathspec.

**CI:** `rollup-terminal … total=7 failed=0 → CI GREEN` (rc 0).

**Follow-ups:** none for this stage; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (2760830 cached reads)
- Output: 16233 tokens
- Cost: $2.4953830000000004
- Wall-clock: 930s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
