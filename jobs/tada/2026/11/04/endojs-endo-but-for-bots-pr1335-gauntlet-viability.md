**PR #1335 viability: proceed.** The gauntlet may begin. I changed nothing and spent no clean, panel, fix, CI-wait or un-draft budget.

Deciding question: Does current `llm` still let an authenticated OCapN peer reach an unbound gateway, with no newer implementation displacing #1335 and the guest-locator federation work still needing it? Yes.

Evidence:
- **PR state:** open and draft, not merged, head `d2c0bf314e`, stacked on `build/guest-locator-adoption-11e726e` (#1333, also an open draft).
- **The gap is still in the base:** on `llm` (tip `48d6f3e08b`, 2026-11-02), `followRetentionSet(peerNodeNumber)` in `packages/daemon/src/manager.js:1965` still answers for whichever node the caller names. `packages/daemon/src/networks/ocapn.js:260` still publishes one static peer entry, and it has no per-session greeter.
- **The need still holds:** #1647, opened 2026-11-03, calls "binding the peer gateway to the authenticated session (#1335)" the separate federation blocker. The #1332 federation plan is still open.
- **The maintainer is still engaged:** kriskowal requested changes on 2026-11-04 at 06:28Z and asked to simplify crossed-hello settling, and left an inline `makeExo` comment. `d2c0bf314e` and the reply at 11:48Z answer both. Kriskowal hasn't ruled on the answer yet, so that review still shows changes requested. Nothing in the discussion suggests dropping the PR.
- **Nothing has displaced it:** the related PRs are all unmerged and cover less:

| PR | State | Overlap with #1335 |
|---|---|---|
| #978, #979 | drafts, idle since August; #979 approved 2026-08-14 | Retention-set binding only, without the bearer or miss policy or the per-session entry |
| #1124 | draft, gauntlet stopped at the review budget | Adds a nonce-locator mechanism; its body says wiring it into `ocapn.js` is out of scope |
| #1647 | approved, gauntlet halted with CI red | Only the `ocapn-advertise-addr` part |
| #1482 | draft | Crossed-hello tiebreak for `ocapn-noise` reconnect, one layer down, not gateway binding |

Follow-ups for later stages, none of which block this gate:
- **`ocapn-advertise-addr` overlap:** #1647 and #1335 implement it differently, and both touch `networks/ocapn.js` and its test. Whichever lands second must drop or rebase its version. #1647 has the approval, so #1335 will probably be the one to shed it.
- **#978 and #979:** these look redundant once #1335 lands, so a maintainer could close them then. I didn't compare their diffs line by line.
- **Stale base:** `llm` is 795 commits ahead of the frozen base, and `manager.js` has changed there since. #1335 will likely need a weave after #1333 settles.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1335-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (240664 cached reads)
- Output: 4157 tokens
- Cost: $0.6096168
- Wall-clock: 398s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
