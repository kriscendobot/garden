---
id: log-and-swallow
aliases: [log and swallow, silent failure, fail loud without failing the push, never block the push, early-return-on-error swallow, per-exit distinct logging, log-content assertion, sentinel exit-code file, tests lock in wrong behavior, schema duplication drift, cross-reference not inline copy, no dead parsed fields]
topics: [repository-governance, testing]
---

# log-and-swallow

The costliest recurring bug class in a defensive, never-crash system: a real failure that is **logged and swallowed instead of surfaced**, staying invisible for days or weeks. Two individually-sound disciplines conspire — a git hook's "never block a push" rule and a daemon's defensive early-return-on-error paths — and both turn a real bug into a quiet no-op (a missing container git identity once masked a whole broken commit pipeline for weeks). The resolution holds both truths: **fail loud without failing the push** — do the defensive thing, but emit an unmistakable, *distinct*, *test-asserted* signal on the way out. Concretely: give every early-return/error path its own distinguishable log line ("failed at the git-identity check", not "it failed"); have tests assert the *specific* log line was or wasn't emitted so a regression that re-routes into a swallow path is caught by the test, not a human weeks later; and prefer sentinel exit-code files over parsing rendered output a no-op can fake. A second-order sibling trap: **tests lock in the code's *actual* behavior including when it's wrong**, so a doc-vs-code contradiction passes the build — the reason **schema duplication** (inline-copying a schema into a second doc) is the standing source of doc drift, cured structurally by one canonical definition + cross-references. From jcorbin's unum LORE.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--lore-engineering-discipline](../sections/unum--lore-engineering-discipline.md) | Fail-loud-without-failing-the-push, schema-duplication drift, no-dead-parsed-fields, and seam injection (how to test the swallow paths). |
| [unum--operations-standards](../sections/unum--operations-standards.md) | The runtime safety rule "prefer failing loudly over silent corruption" as a monorepo-wide standard. |

## See also

- [[design-out-the-hazard]] — the design-time sibling from the same discipline section.
- [[killswitch-source-guard]] — the lifecycle-safety sibling: fail toward the safe state.
- [[claim-state-triple]] — a claim wedged by a silent skipped-leg is this bug class at the coordination layer.
