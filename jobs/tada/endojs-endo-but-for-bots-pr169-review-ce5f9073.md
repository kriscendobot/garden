Both review asks are resolved. Inbox is empty. Work complete.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #169 (kriskowal review `pullrequestreview-4680376639`, CHANGES_REQUESTED, on the `design/pass-style-promise` branch).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved this). The review body carried only the deterministic preflight preamble (no additional substantive ask); the two inline comments were the full unit of work. All fetched bodies treated as untrusted data.

**Enumerated asks & resolution:**

1. **`designs/pass-style-promise.md:267` — "How does `subscribe` differ from `when`? We might want to call it `listen` or `watch`."**
   - Added a paragraph at the `subscribe` introduction crisply contrasting it with `E.when`: `subscribe` = one-hop, void, callback primitive firing with the *immediate* settlement target; `E.when` = recursively-unwrapping, Promise-returning, `await`-composing convenience layered on it.
   - Recorded the naming question as **Open Question 11** with a reasoned leaning to keep `subscribe` (it is fire-once per OQ 3; `listen`/`watch` connote continuous observation and invite the fire-many misreading OQ 3 rejects, whereas `subscribe`'s pub/sub reading is correct for a one-shot).
   - Cross-referenced the two additions (intro paragraph ↔ OQ 11).

2. **`designs/pass-style-promise.md:380` — "And we should post a plan to create that design."** (the separate debug-view ring-buffer design)
   - Posted a parked designer plan to the board: `endojs-endo-but-for-bots-design-promise-debug-view` (`post-plan.sh --deferred --by designer`), scoped to author the debug-view design as its own non-blocking follow-up doc layered on the existing rejection-retention/`onFirstSubscribe` contract, with full provenance to this review.

**Changes pushed:** commit `ecb7a8d97` on `design/pass-style-promise` (36 insertions, doc-only), pushed via rebase CAS loop.

**Threads answered:** inline replies posted to both comments (`discussion_r3566688164`, `discussion_r3566688311`) citing the commit and the parked plan.

**Follow-ups:** the parked plan `endojs-endo-but-for-bots-design-promise-debug-view` awaits promotion when the maintainer wants the debug-view design written. Naming (subscribe vs listen/watch) is left open per OQ 11 for the maintainer's call.
