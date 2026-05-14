---
ts: 2026-05-14T18:07:01Z
kind: result
role: scholar
project: garden-library
refs:
  - entries/2026/05/14/175638Z-result-liaison-b796b7.md
  - entries/2026/05/14/175822Z-result-liaison-35ecd8.md
---

# Forty-fourth scholar cycle — act on the round-1 A/B test recommendations

This cycle closes the loop on the round-1 A/B test (entry `175638Z-result-liaison-b796b7.md`) by implementing all three of its suggested library improvements, plus formalizing three structural patterns from cycles 41-43 in `library/conventions.md`.

## Cycle work

### 1. Lifted smallcaps sigil specifics into the abstract

Round-1 finding: Q7 (smallcaps vs JSON) — the control agent won on specificity because it listed actual sigil characters (`#`, `+`/`-`, `%`, `$`, `&`, `!`) while the treatment was correct but abstract. The sigils were in the body of `endo--pkg-marshal-docs-smallcaps-cheatsheet--overview` but not surfaced in the abstract; topic-page abstracts often serve as the agent's first scan.

**Fix**: rewrote the abstract of `endo--pkg-marshal-docs-smallcaps-cheatsheet--overview` to enumerate each sigil with its meaning and example (`#` for `#undefined`/`#NaN`/`#Infinity`/`#-Infinity`, `+`/`-` for BigInt `+7`/`-3`, `%` for `%foo` Symbols, `$` for `$0.tag` remotables, `&` for `&1` promises, `!` as escape prefix), plus the wire-compat invariant ("byte-identical to JSON when no special-prefix strings"), plus the historical context (replaces older `@qclass` tagged-object form).

### 2. Added `persistence` topic page

Round-1 finding: sections on persistence zones, durable exos, and prepare lifecycle scatter across `exo`, `hardened-javascript`, `capability-security`. Treatment had to go directly to known section names rather than via topic.

**Fix**: created `journal/library/topics/persistence.md` and tagged 18 sections with the new `persistence` topic:

- endo--pkg-exo-docs-exo-taxonomy--{heap-virtual-durable, make-vs-prepare}
- endo--pkg-exo-readme--{virtual-durable-exos, state-management}
- endo--pkg-ses-docs-preparing-for-stabilize--{overview, how-passable-objects-should-prepare, how-proxy-code-should-prepare}
- agoric-sdk--pkg-vat-data-readme--{overview, tips-synchronous-makers}
- agoric-sdk--pkg-base-zone-readme--overview
- agoric-sdk--pkg-store-readme--overview
- agoric-sdk--pkg-zoe-readme--upgrade
- agoric-sdk--pkg-inter-protocol-readme--persistence
- agoric-sdk--pkg-async-flow-readme--{overview, loopholes-for-purely-diagnostic-information}
- agoric-sdk--pkg-async-flow-docs-async-flow-states--overview
- agoric-sdk--agents--async-flow-model-notes
- endo-but-for-bots--llm-designs-trust-on-first-bind--policy-storage-and-revocation

### 3. Added `async-flow` topic page

Round-1 finding: `agoric-sdk--pkg-async-flow-readme--*` was filed only under `capability-security` + `agent-conventions`; treatment had to grep over `sections/` to locate.

**Fix**: created `journal/library/topics/async-flow.md` and tagged 5 sections with the new `async-flow` topic:

- agoric-sdk--pkg-async-flow-readme--{overview, loopholes-for-purely-diagnostic-information}
- agoric-sdk--pkg-async-flow-docs-async-flow-states--overview
- agoric-sdk--agents--async-flow-model-notes
- agoric-sdk--pkg-orchestration-readme--orchestration-flows (the stricter no-`E()` variant; cross-cuts naturally)

Both topic pages were authored hand-curated first, then regenerated from frontmatter via the cycle-33 generator to ensure consistency with the rest of the topic-page corpus.

### 4. Documented three structural patterns in conventions.md

Per the round-1 self-improvement note and the cycles 41-43 result-entry note ("worth promoting to library principles"), added a new `## Structural principles from cycles 41-43` section to `journal/library/conventions.md` covering:

- **Shape, not content, for upstream meta-tables** — when an upstream's value is a meta-index changing at upstream's cadence (every-design-status, every-package-state), capture shape + taxonomy + query-upstream pointer, NOT the rows. Library would otherwise become a stale mirror.
- **Consumers own rendering; producers own typed shape** — typed value is the backbone; each consumer (CLI / chat / JSON) owns its rendering. Producer-side string rendering forces other consumers to re-parse strings.
- **Hidden-intrinsic sampling via throwaway-instance-prototype-walk** — for built-ins whose methods return objects with their own prototype chain, sample by constructing a throwaway instance and walking `Object.getPrototypeOf` from a method return.

Each principle cites the specific cycle-41/42/43 section that exemplifies it.

## Index work

- `topics/README.md`: +2 new topics (`persistence` 18 sections, `async-flow` 5 sections); other topic counts unchanged this cycle.
- Section frontmatter: 18 sections tagged `persistence`, 5 sections tagged `async-flow` (some overlap — 4 sections tagged both).
- `conventions.md`: +3 structural-principle subsections.
- One abstract rewritten (`endo--pkg-marshal-docs-smallcaps-cheatsheet--overview`).

No new section files this cycle (the work is purely topic-page + abstract + conventions).

## Library state

- **406 sections** from **90 source documents** across **4 repos** (unchanged from cycle 43; no new ingest).
- **23 topics** (up from 21): persistence and async-flow added.
- Topic-page drift: 0 across all 23 pages.

## Inbox state

Empty. Next cycle is idle-mode.

## Self-improvement

- The round-1 A/B test's "three suggested improvements" took one cycle to implement end-to-end (this cycle). The pattern is useful: evaluation entries with concrete actionable findings translate directly into a cycle's worth of work.
- The conventions.md structural-principles section is the durable home for cross-cycle patterns that don't fit any one source document. Future cycles surfacing similar generalizable patterns should add them there.
- **The library now has its first acted-on evaluation feedback loop**: A/B test → durable journal entry → next cycle's work. This is the closing of the loop the round-1 self-improvement note named. Worth repeating for round 2 when (if) it runs.
- One useful generalization from this cycle's frontmatter-tagging work: when a new topic is created, *both* the topic page AND the relevant section frontmatters need updating; the topic page alone is invisible to future generator runs. The 23 frontmatter edits this cycle were mechanical but necessary. A future skill for "introduce a new topic" should bundle these two steps.
