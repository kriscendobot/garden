---
ts: 2026-06-23T06:35:06Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/designer--ec20aa/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/507
  - https://github.com/endojs/endo-but-for-bots/pull/507#pullrequestreview-4550444549
---

Revision 3 of `designs/notifier-pubsub-migration.md` addresses kriskowal's CHANGES_REQUESTED review on PR #507.
Four commits on `design/notifier-pubsub-migration`, new HEAD `7688d2ac1`, lease anchor was `25dea2f1e`.

## Revisions

- **Topic-object subscriber surface** (comment 3457385924, [a85bb30e2](https://github.com/endojs/endo-but-for-bots/pull/507/commits/a85bb30e2)).
  Factory now returns `{ publisher, topic, finish, fail }`; the `subscribe` method is gone.
  Topic exo carries `sinkLatest` (lossy) or `sinkChanges` (lossless deltas) as its distinguished sink method.
  `iterateLatest(topic, cancelled)` / `iterateChanges(topic, cancelled)` are local adapters mirroring the maintainer's example.
  *Method-name evolvability* section names sibling-method-name room for ack-driven coalescing (`sinkChangesAcked` or analogous) and consumer-side reduction (`sinkChangesReduced` or analogous) on change topics, per the maintainer's hint about richer change-topic trade-offs.
  Type signatures, InterfaceGuard sketches, example code, Exo-streams coherence table, Cross-design coordination table, Back-pressure section, and Consumer cancellation section all rewritten.
- **Migration plan removed** (comment 3457388996, [af46d777d](https://github.com/endojs/endo-but-for-bots/pull/507/commits/af46d777d)).
  `## Migration plan` section deleted entirely.
  `## What is the Problem Being Solved?` reframed: package is greenfield for Endo; `@agoric/notifier` continues to ship from agoric-sdk unchanged; only future in-tree call site (`formulaChangeTopic` in `packages/daemon/`) named as a follow-up, not a precondition.
- **Open questions trimmed to one** (comment 3457394053, [4505110fd](https://github.com/endojs/endo-but-for-bots/pull/507/commits/4505110fd)).
  Durable-pubsub resolved item moved to new `### Durable pubsub deferred` subsection under `## Scope and home`.
  Back-pressure, CapTP severance, snapshot-vs-future-values resolved items dropped (already covered in design body sections).
  Caller-survey and factory-name items dropped (migration plan gone; factory names are now in section headings).
  One truly-open item remains: final method names for additional change-topic sinks the design leaves room for.
  No new top-level Alternatives Considered section was needed; rejected alternatives are already inline as "Considered and rejected:" notes in Scope and home and `makeUpdateTopic (eliminated)`.
- **Consistency sweep** ([7688d2ac1](https://github.com/endojs/endo-but-for-bots/pull/507/commits/7688d2ac1)).
  Stale `*The three topic shapes*` cross-reference fixed to `*The topic shapes*`.
  Compatibility considerations pass-style bullet rewritten from "subscribers conform to PassableReader" to "topic exo's sinkLatest / sinkChanges ride PassableReader.stream's protocol".

## Sections moved / removed / added

| Change | Section |
|---|---|
| Removed | `## Migration plan` (two phases, codemod survey, dual-publishing) |
| Added | `### Durable pubsub deferred` under `## Scope and home` |
| Added | `### Subscriber surface: the topic object` under `## The topic shapes` |
| Renamed | `## Subscriber as a passable PassableReader<T>` → `## Topic exo and iterator adapters` |
| Renamed | `## Subscriber cancellation` → `## Consumer cancellation` |
| Rewritten | `### makeLatestTopic`, `### makeChangeTopic`, `### makeUpdateTopic (eliminated)` (API shape) |
| Rewritten | `## Producer as a passable PassableWriter<T>` (type signatures) |
| Rewritten | `## Exo-streams coherence` table |
| Rewritten | `## Cross-design coordination` (presence-severance and exo-stream rows) |
| Rewritten | `## Back-pressure and wire protocol` (subscriber → consumer language throughout) |
| Rewritten | `## Method-name evolvability` (single-sink-per-topic with sibling-method-name room) |
| Trimmed | `## Open questions` from seven items to one |

Document grew from 805 lines (revision 2) to 833 lines (revision 3); net diff was +334 / -307 across four commits.

## Outputs

- HEAD sha: `7688d2ac1`
- Lease anchor: `25dea2f1e`
- Branch: `design/notifier-pubsub-migration` (pushed via `git push --force-with-lease=design/notifier-pubsub-migration:25dea2f1e origin HEAD:design/notifier-pubsub-migration`)
- Summary comment: https://github.com/endojs/endo-but-for-bots/pull/507#issuecomment-4776411885
- Inline replies: r3457532001 (comment 1), r3457532725 (comment 2), r3457534014 (comment 3)
- PR remains DRAFT (not un-drafted, per dispatch directive)

Self-improvement: nothing this time.
