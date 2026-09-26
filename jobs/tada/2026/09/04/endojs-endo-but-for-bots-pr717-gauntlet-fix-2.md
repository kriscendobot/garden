CI is green (rc 0). The fix stage is complete.

## Completion report — FIX round 2, endojs/endo-but-for-bots PR #717

**PR:** `design: promise debug view` (design-only PR; new `designs/promise-debug-view.md` + `designs/README.md` index entry).

**What I did:** Applied the garden design panel's round-2 request-changes verdict (review `5109203199`, disposition `must-fix`) as a single review-feedback commit `d545e9e0fd` on the PR head `design/promise-debug-view`, then watched CI to a green terminal.

**Must-fix items addressed (by seat):**
- **critic / skeptic / decomplector** — Eviction policy now *protects the undelivered half* of a rejection→finalization pair: undelivered `unlistened-rejection` records live in a bounded `retained` map outside the recency FIFO; any loss under pressure is surfaced via an `evicted` count and a `priorEntryEvicted` marker instead of silently dropping the flagship signal.
- **critic / skeptic / decomplector** — The retained `reason` is now a **value-only projection** (message/name/quoted strings), preserving the weak-carrier invariant, keeping `harden` from freezing foreign error graphs, and leaking no authority.
- **critic / skeptic** — New explicit **weak-reachability constraint** (every runtime→carrier edge weak or value-only, including the debug view's own first-listener hook).
- **critic / skeptic** — Named the live-set structure (`Map` of `WeakRef`, pruned by settle hook + `FinalizationRegistry`), its settledness source, a long-pending output cap `L`, and the honest `O(R)+N+O(live)` memory bound.
- **decomplector / ergonomist** — Decomplected the snapshot into recorded `entries` vs a derived `longPending` query; dropped `carrierRef`; gave each shape a defined record time.
- **ergonomist** — Surfaced the headline as a first-class `undeliveredRejection` flag; snapshot now reports `capacity`/`retainedCapacity`/`evicted`/`longPendingThreshold`; named the four bound env-options.
- **skeptic** — Added the `FinalizationRegistry`-absent degradation path and cited the in-repo `unhandled-rejection.js` tracker as reuse + gating precedent.
- **copyeditor / critic** — Fixed the `forever-pending` defined-term equivocation and the unparseable OQ1 sentence; widened OQ1 to the owning package with a confidentiality deciding criterion.
- **pedant / copyeditor** — Reflowed the whole doc to the repo Markdown Style Guide (sentence-per-line, 80–100 cols); removed all 11 em-dashes; fixed heading spelling ("Pass-Style Promise"), OQ parallelism (all interrogatives), issue-citation form (fully-qualified), and the RFC-2119 uppercase slip.
- **novice** — Introduced `makePromise()` in the borrowed-vocabulary recap; removed the ring "replace a long-pending view" contradiction.

Also refreshed the `designs/README.md` index blurb (removed the "pass-style-promise *is* PR #169" ambiguity; updated to the new snapshot shape). Mermaid diagram re-validated (renders clean) and consolidated per the novice's diagram note.

**Result:** Pushed `86ebf4aeeb → d545e9e0fd` via `safe-push-pr-head.sh` (advance mode). CI terminal: all 5 checks pass (browser-tests, build, lint, test, zizmor) — **GREEN** (`ci-wait-merge` rc 0). Did not re-run the panel (driver re-posts panel-3).

**Follow-ups:** None. Remaining panel items were should-fix/comment-only and were addressed or left as the design's genuine Open Questions.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 64 tokens (2362324 cached reads)
- Output: 35455 tokens
- Cost: $3.2368024999999996
- Wall-clock: 812s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
