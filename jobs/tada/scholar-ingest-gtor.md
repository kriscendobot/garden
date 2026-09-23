All verified. `scholar-ingest-gtor` is in `tada/` (completed), all 6 gtor section files are on `origin/journal2`, and the follow-on `scholar-ingest-gtor-recap` was already claimed by another gardener (now in `doin/`).

---

# scholar-ingest-gtor — complete (cycle 2 of the gtor README ingest)

**What I did:** Wore the scholar role and extended the partial keystone ingest of `kriskowal/gtor`'s README. Idempotency check passed first — the recorded `source_commit d2a238fce2cc0b73bbaec795a7230473b584fa9d` still equals the current file-specific commit on `kriskowal/gtor` master, so the two prior sections are current and I extended coverage rather than re-ingesting. Filed the priority-1/2 async + queue substrate that grounds `@endo/stream` and `@endo/pubsub`.

**Sections filed (4 new, topics change-propagation / streams):**
- `gtor--readme--asynchronous-values-and-functions` — promise/resolver/deferred; promise (broadcast) vs task (unicast, cancels upstream); the `Promise.async` trampoline.
- `gtor--readme--promise-queues-and-buffers` — **the keystone for endo-pubsub**: the asynchronous linked-list queue (head promise / tail deferred) that `makeQueue` realizes as cons-cells and the sink/spring rides on; semaphore-as-queue; the two-queue buffer that makes back-pressure concrete.
- `gtor--readme--promise-iterators-and-generators` — reader/writer stream sides; async map/forEach/reduce/pipe; forEach returns a unicast task that cancels upstream; remote iterators pipeline `next` (also tagged eventual-send).
- `gtor--readme--asynchronous-generator-functions` — await + yield → a promise iterator (`Promise<Iteration<T>>`); the algebra reduces to one `next`.

**Indexes/concepts enriched:** bumped `gtor--readme.md` `section_count` 2→6 (and the `sources/README.md` row) with a multi-cycle `notes:` rewrite; added rows to the change-propagation, streams, and eventual-send topic pages; replaced `endo-pubsub.md`'s "grounded only in journal entries" stub with a real sections table (the queue/buffer + iterator/generator + taxonomy sections now ground the sink/spring + async-linked-list + broadcast mechanism); added the 4 rows to `change-propagation.md`; added ~16 grep entry points to `keywords.md`. Left the 5561-entry auto-generated `sections/README.md` to its generator.

**Changed/pushed:** all library writes committed and CAS-pushed to `journal2` (commit `8602abc`); a `result` entry posted; the job completed (`doin → tada`).

**Follow-ups:** Re-posted job `scholar-ingest-gtor-recap` for the remainder (the plural-spatial column — Iterators / Generator Functions / Generators; and the Summary / Further Work / Glossary recap), which finishes the README. Used a distinct basename to avoid the idempotent no-op against my own still-in-flight job; it has already been claimed by another gardener.

Self-improvement: nothing this time — the conventions, idempotency check, and concept-page enrichment flow fit the existing scholar procedure cleanly.
