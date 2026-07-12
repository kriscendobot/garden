<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-12T17:19:04Z -->

Designer job: create the "debug view for long-pending and
unsubscribed-rejection promises" design in endojs/endo-but-for-bots,
the forward-looking follow-up called out (as an explicitly separate,
non-blocking design) in designs/pass-style-promise.md (PR #169,
Subscription section and the "Debug view for long-pending and
unsubscribed-rejection promises" future-directions section).

Scope to design: a debug-view ring buffer of recent long-pending,
forever-pending, and unsubscribed-rejection pass-style/native promises,
inspectable while debugging without producing noise in production —
i.e. the "neither swallow nor eagerly throw" rejection-retention
principle made observable for a debugger without forcing a production
log line on every hop. Reconcile with the onFirstSubscribe /
rejection-retention contract already specified in the pass-style
promise design; do not re-specify that contract, layer on it.

Deliverable: a new design doc (e.g. designs/promise-debug-view.md) on a
design/ branch off `llm`, following the repo's design-doc conventions,
opened as a draft PR that closes/links the appropriate issue.

Provenance: requested by kriskowal in the PR #169 review
(pullrequestreview-4680376639), inline comment on
designs/pass-style-promise.md line 380: "And we should post a plan to
create that design." Posted as a parked plan by gardener job
endojs-endo-but-for-bots-pr169-review-ce5f9073.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  claimed_at: 2026-07-12T17:19:08Z
