CI is green (rc 0). Fix stage complete.

## Completion report

**Job:** gauntlet FIX round 3 for endojs/endo-but-for-bots PR #1227 (`docs: design guest bot incarnation on mailbox delivery`).

**Panel verdict addressed** (round-3 disposition must-fix; three request-changes seats):

1. **critic — crash-loop breaker flapping evasion.** Replaced the "eight *consecutive* failures + reset-on-60s-running" rule with a **rolling-window** breaker: eight failures within a fifteen-minute window trip it. Kept consecutive-count semantics only for the backoff *delay*. Explained why (a bot that runs ~61s then crashes each cycle would otherwise restart forever, invisibly cycling `starting → running → backoff` and never reaching `blocked`).

2. **skeptic — false `provideHost` premise.** Corrected the present-tense claim that `provideHost` already rejects an unrecognized `bot` key. Verified in source: `normalizeHostOrGuestOptions` (host.js:85) destructures only `introducedNames`/`agentName` and silently drops other keys today. Reworded to state the increment *introduces* the split (guest path resolves `bot`, host path rejects it), and updated Affected Packages `host.js` to name the helper split.

3. **skeptic — unenforced one-incarnation-per-guest.** Added a checked precondition: `provideGuest` rejects a `bot` identifier already bound to a *different* live guest (preventing shared `controllerForId` co-tenancy), naming the conflicting guest. Updated Affected Packages `manager.js`; extended Test 11 with the collision + `provideHost({bot})`-rejection cases.

4. **decomplector — operator-pause restart caveat.** Added inline at `stopBot`/`retryBot` that the `operator` pause is process-local and does not survive a routine restart (only the crash-loop bit persists), cross-referencing Deferred Work rather than leaving a reader to discover the gap.

Also updated Test 5 to exercise the rolling-window/flapping semantics.

**Push & CI:** committed (`2e36d0a73`), pushed to PR head via `safe-push-pr-head.sh`. Bounded CI wait returned **rc 0 — GREEN** (7 checks, 0 failed).

Comment-only seats (ergonomist, copyeditor, pedant, novice, orthographer) were non-blocking and left for the driver's re-panel; the ergonomist's options-type-split concern is partly addressed by the skeptic fix's explicit helper split.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1347401 cached reads)
- Output: 14711 tokens
- Cost: $1.7401884999999997
- Wall-clock: 648s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
