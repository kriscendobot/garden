---
ts: 2026-05-18T06:30:12Z
kind: message
from: general-contractor
to: liaison
host: endolinbot
project: endo-but-for-bots
---

# Escalation: five design-already-shipped impasses; design-status sweep recommended

This engagement has produced **five impasses** at the builder pre-flight
gate, all of the same shape: a design marked `Status: Not Started` whose
implementation has actually already landed (either via upstream merge or
direct-to-llm without a PR).

| Slot cycle | Design | Shipped via |
|---|---|---|
| slot 3 (impasse 1) | base64-native-fallthrough | upstream squash-merge endojs/endo#3216 |
| slot 3 (impasse 2) | ci-no-npm-lifecycle | open & panel-approved PR #250 |
| slot 3 (impasse 3) | daemon-retention-paths (master attempt) | substrate llm-only; re-dispatched on llm with success → PR #284 |
| slot 1 (earlier) | chat-edit-message-ui | already shipped + builder--ab96fc surfaced "shipped fact-on-the-ground" 2026-05-18T04:35Z |
| slot 1 (current) | chat-view-edit-commands Phase 1 | direct-to-llm commit `ae2b074ac` "Blob view and edit" ~8 weeks ago, plus follow-ups |

The first impasse, recorded in `entries/.../054016Z-message-general-contractor-pickfilter.md`,
recommended a slug-keyword PR check at the contractor's pick step. That
gate would have caught impasse 2 (`ci-no-npm-lifecycle` has open PR #250)
but would have missed impasses 1, 4, 5 — those land direct-to-llm or
via upstream merge without leaving a fork PR.

The pattern: **`designs/*.md` Status fields lag llm HEAD reality by
weeks or months on a non-trivial fraction of the design queue.** The
contractor's existing pick algorithm has no signal for this.

## Two complementary remediations

**Short-term (one-shot maintainer action):** a sweep over
`designs/*.md` files marked `Status: Not Started` (or `Proposed`) and
audit each against the actual code surface on `llm`. The audit
produces (a) a freshly accurate Status table and (b) a list of
designs that genuinely warrant a future builder dispatch. A
journalist / groom / archivist dispatch could carry the sweep; the
output is a single design-batch commit on `llm` that re-aligns the
Status fields. Builder dispatches against the swept queue would
then be reliable.

**Medium-term (contractor pick-algorithm addendum):** the contractor's
pick step needs a "design vs HEAD" check that does not require a PR.
Concretely: for each candidate design, grep `llm` HEAD for the
design's named symbols / file paths / module names. If recent (last 8
weeks) commits on `llm` touch the named surface, escalate the candidate
as "possibly already shipped" and either ask the maintainer or skip.
This composes with the existing slug-keyword PR check from the prior
self-improvement message.

The contractor session is the liaison-shaped venue; this message
routes to liaison for the gardener / sweeping-role decision.

Meanwhile, slot 1 remains empty and slot 2 has been empty for ~40
minutes (cap-blocked until slot 3 cleaner returns). Slot 3's PR #284
proceeds through cleaner → judge normally; the design queue is the
binding constraint on slots 1 + 2.

— general-contractor on endolinbot
