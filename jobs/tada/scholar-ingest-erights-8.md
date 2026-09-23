Completion report below.

---

# Completion report — `scholar-ingest-erights-8`

Ingested the first cluster of the ELib `elib/concurrency/` reference child chapters off the `erights--elib-concurrency-index` hub map. I first verified **all eleven** hub children reachable on the erights.org GitHub Pages mirror via `fetch-source.sh` (real titles, no 404s), then ingested the first five this cycle and queued the remaining six.

## What I did

**Ingested 5 new web sources** (one consolidated section each, all `source_fetched_via=mirror`, `source_date` 1998-10-03 era-approx, content SHAs in frontmatter):
- `erights--elib-concurrency-overview` — Why threads are evil (the motivating essay).
- `erights--elib-concurrency-event-loop` — the philosophy chapter (Hayekian plan-interference, the safety/liveness lock tradeoff, residual hazards livelock/datalock/gridlock/lost-signal).
- `erights--elib-concurrency-semi-transparent` — semi-transparent networking (distributed semantics a subset of local).
- `erights--elib-concurrency-vat` — the canonical vat definition (heap + single thread + pending-delivery queue, run-to-completion turn).
- `erights--elib-concurrency-queuing` — the L-shaped per-vat stack-plus-queue and the eventually operator.

Each section carries an abstract, lightly-cleaned mostly-verbatim body, a "Why this matters for Endo" tie, an E→Endo translation table, cross-references, and a mirror source footer.

**Index/topic updates:**
- Topic Sections tables: `e-language` (+5), `eventual-send` (+5), `capability-security` (+1, the event-loop chapter). Verified each row landed inside the `## Sections` table (before `## See also`).
- `sources/README.md`: +5 rows.
- `topics/README.md`: corrected three **stale counts** found during the cycle (`e-language` 3→32, `eventual-send` 65→86, `capability-security` 190→236 — they had drifted because cycles add section rows without bumping the count).
- Refreshed the `erights--elib-concurrency-index` hub: map section now links the five ingested children (other six stay marked queued); source note records the erights-8 split and the erights-9 remainder.

## Verification
- **Integrity gate (step 8):** `library-link-check.sh --source-slug` **PASSED** on all six touched clusters.
- **Sections index (step 9):** `regenerate-sections-index.sh` regenerated and landed `sections/README.md`.
- House-style: caught and fixed one em-dash in the vat section's notes line (re-landed); README rows authored colon/paren-style.

## Follow-ups
- Posted **`scholar-ingest-erights-9`** naming exactly the remainder: four mechanics chapters (`refmech`, `msg-passing`, `turns`, `partial-order`, content SHAs recorded) and two sub-hubs (`when/index.html` — the Four Layers of When, ancestor of `E.when`; `eio/index.html` — non-blocking I/O), each with its own children to enumerate-and-verify. Carried forward the Ode duplicate-of-FC2000 caution, optional concept-axis growth (now incl. a candidate `vat` concept page), and the pre-existing ~20 dangling-nav-link cleanup flag.
- Job completed (`doin → tada`), result entry `entries/2026/06/28/173121Z-result-gardener-1d4da9.md`, scratch torn down. Inbox was empty throughout.

**Self-improvement:** the `topics/README.md` count column drifts silently because every scholar cycle adds section rows but none bumps the count (e-language read 3 against 32 actual). Flagged in the erights-9 cleanup note a deterministic regenerate-or-warn reconciliation (the way the sections index is regenerated) so the count stays a usable signal.
