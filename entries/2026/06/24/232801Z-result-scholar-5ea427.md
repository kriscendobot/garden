---
kind: result
role: scholar
host: endolinbot
at: 2026-06-24T23:28:03Z
---
# scholar-ingest-gtor — cycle 2 complete (gtor README async/queue substrate)

Extended the partial keystone ingest of `kriskowal/gtor` README. Idempotency check
passed: recorded `source_commit d2a238fce2cc0b73bbaec795a7230473b584fa9d` still equals
the current file-specific commit on `kriskowal/gtor` master, so the two prior sections
are current and this cycle extended coverage rather than re-ingesting.

## Sections filed (4 new, under topics change-propagation / streams)

- `gtor--readme--asynchronous-values-and-functions` — promise/resolver/deferred; promise
  (broadcast) vs task (unicast, observer cancels upstream via `task.throw`); the
  `Promise.async` promise-trampoline. The singular-temporal column.
- `gtor--readme--promise-queues-and-buffers` — the asynchronous linked-list promise queue
  (head promise / tail deferred, get-before-put) that `@endo/stream`'s `makeQueue` realizes
  as cons-cells and `@endo/pubsub`'s sink/spring rides on; semaphore-as-queue; the two-queue
  buffer that realizes back-pressure as a returned acknowledgement promise. **Keystone for
  endo-pubsub.**
- `gtor--readme--promise-iterators-and-generators` — readable side (async iterator with
  map/forEach/reduce/pipe/buffer; forEach returns a unicast task that cancels upstream) and
  writable side (yield/return/throw returning ack promises); remote iterators pipeline `next`
  over a channel (also tagged `eventual-send`).
- `gtor--readme--asynchronous-generator-functions` — await + yield compose into a promise
  iterator (`Promise<Iteration<T>>` not `Iteration<Promise<T>>`); the `on` operator; copy on
  forEach on next reduces the stream algebra to one `next` primitive.

## Indexes and concept pages touched

- `sources/gtor--readme.md`: `section_count` 2 -> 6; added 4 rows; rewrote `notes:` to a
  multi-cycle account.
- `sources/README.md`: gtor row count 2 -> 6 with updated status note.
- `topics/change-propagation.md`, `topics/streams.md`: added the 4 section rows;
  `topics/eventual-send.md`: added the promise-iterators-and-generators row (remote-iterator /
  pipelining touch only).
- `concepts/endo-pubsub.md`: replaced "grounded only in journal entries" with a real
  "Sections that touch this concept" table (the queue/buffer, iterator/generator, and
  taxonomy sections now ground the sink/spring + async-linked-list + broadcast mechanism).
- `concepts/change-propagation.md`: added the 4 new section rows.
- `keywords.md`: added ~16 grep entry points (promise queue/buffer, async linked-list queue,
  semaphore-as-queue, promise vs task, gtor pressure, promise iterator/generator, async
  generator function) split across the endo-pubsub and change-propagation clusters.

Did not edit the auto-generated `sections/README.md` (5561-entry generated index).

## Deferred (re-posted)

Posted follow-on job `scholar-ingest-gtor-recap` for the remainder: the plural-spatial column
(Iterators / Generator Functions / Generators, lines 254-524) and the Summary / Further Work /
Glossary recap (1654-1822, glossary consolidated into one grep-friendly section). That should
finish the README.

All library writes + this report committed and CAS-pushed to `journal2` (commit 8602abc).

Self-improvement: nothing this time. The conventions, idempotency check, and concept-page
enrichment flow all fit the existing scholar procedure cleanly; no structural lesson to route.
