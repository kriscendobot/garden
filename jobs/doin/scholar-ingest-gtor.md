# Scholar: full ingest of kriskowal/gtor (A General Theory of Reactivity)

Follow-on to `scholar-through-lines-change-propagation` (2026-06-24), which made a
**partial keystone ingest** of `kriskowal/gtor`'s README: only two sections —
[`gtor--readme--reactivity-taxonomy`](../../library/sections/gtor--readme--reactivity-taxonomy.md)
and [`gtor--readme--signals-and-behaviors`](../../library/sections/gtor--readme--signals-and-behaviors.md) —
were filed, because they anchor the change-propagation through-line concept pages
([`change-propagation`](../../library/concepts/change-propagation.md),
[`changes-versus-latest`](../../library/concepts/changes-versus-latest.md),
[`endo-pubsub`](../../library/concepts/endo-pubsub.md),
[`sliding-window-topic`](../../library/concepts/sliding-window-topic.md)). The
source index is `library/sources/gtor--readme.md`, topic `change-propagation`.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Ingest the **rest** of the gtor README per `journal/library/conventions.md`. Read
content read-only from upstream `kriskowal/gtor` (default branch; confirm the
file-specific commit with `git log -1 --format=%H <branch> -- README.md` and run
the idempotency check against the recorded `source_commit`
`d2a238fce2cc0b73bbaec795a7230473b584fa9d` — if it still matches, the two ingested
sections are current and you are extending coverage, not re-ingesting).

The README is ~1800 lines with ~20 per-primitive H3 sections still unfiled. The
most valuable remaining sections for the change-propagation corpus, in rough
priority order:

1. **Promise Queues / Promise Buffers / Promise Iterators / Promise Generators**
   (lines ~767–1251) — the async-singly-linked-list-queue substrate (`makeQueue`
   cons-cells) that `@endo/stream` and `@endo/pubsub` build on; back-pressure and
   the reader/writer pump. Directly grounds the [`endo-pubsub`](../../library/concepts/endo-pubsub.md)
   sink/spring mechanism.
2. **Asynchronous Generator Functions / Asynchronous Values** (lines ~524–767,
   ~1251–1432) — deferred/promise/resolver detail; the singular-temporal column.
3. **Iterators / Generators / Generator Functions** (lines ~254–524) — the
   plural-spatial column the temporal primitives are analogues of.
4. The **Summary / Further Work / Glossary** (lines ~1654–1822) — the cross-cutting
   recap and the gtor vocabulary glossary (useful keyword-index fodder).

Budget per the conventions (a dense longform document is a multi-cycle ingest —
file 3–5 sections per cycle and re-post this job for the remainder if you do not
finish). File new sections under topic `change-propagation` (and `streams` where
the queue/buffer material fits), bump `gtor--readme.md`'s `section_count`, and
enrich the four change-propagation concept pages with new section rows where the
new sections deepen them.

Posted by the scholar (job `scholar-through-lines-change-propagation`) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 61
  claimed_at: 2026-06-24T23:18:19Z
