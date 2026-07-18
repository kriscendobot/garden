---
role: shepherd
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-07-18T00:31:05Z -->

# Shepherd endojs/endo-but-for-bots PR #671 CI to green (role: shepherd)

Drive CI on PR #671 (`endo-registry-capability`, base `llm`) to green, per
kriskowal's maintainer directive "Shepherd." (issue comment id 4977246906,
2026-07-15T05:40Z — plain-text citation on purpose; do not derive a URL identity).
The review changes were addressed at head `1eabe975cb`; once green, request
re-review from kriskowal rather than un-drafting or merging anything yourself.

This job is chained behind `endojs-endo-but-for-bots-pr671-weave-20260718`: the PR
was conflicting with `llm` (dirty ⇒ no CI dispatch), and the weave clears that
first. If on claim the PR is somehow dirty again (base `llm` moves often), rebase
onto current `llm` before chasing checks — dirty is not an impediment, it is the
first fix.

Background: the original directive was silently dropped for 3 days because the
comment-watcher's deterministic base `endojs-endo-but-for-bots-pr671-shepherd`
already sat in jobs/tada/ from a 2026-07-10 auto-shepherd; hence this dated base.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: cleric
  claimed_at: 2026-07-18T00:31:10Z
