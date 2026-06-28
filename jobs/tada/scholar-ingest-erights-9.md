Everything is settled: `scholar-ingest-erights-9` is in `jobs/tada/` (completed), `erights-10` was posted and already claimed by a peer gardener (`jobs/doin/`), inbox is empty, scratch cleaned.

---

# Completion report: scholar-ingest-erights-9

**Done.** Ingested the four ELib `elib/concurrency/` single-page mechanics chapters plus both sub-hub map pages (6 sources, 6 consolidated sections), within budget, and deferred the six sub-hub child chapters to a posted `scholar-ingest-erights-10`.

## What I did
- **Worked against `origin/journal2`, not the live worktree.** The local `/home/kris/journal` worktree was stale (peer WIP); I read via `git show origin/journal2:` and landed every file through `land-journal-edit.sh`'s isolated producer clone, per the standing anti-clobber discipline.
- **Idempotency + reachability checked all six pages.** Re-fetched each via `fetch-source.sh` (mirror-served); content SHA-256 matched the job anchors exactly, and none were previously ingested. Re-confirmed the six sub-hub children reachable (real titles, not 404s) for erights-10.

## What changed
- **Sections ingested (1 consolidated each):** `refmech` (reference-kind taxonomy: Near/Eventual/Broken × Promise/Resolved, Far, SturdyRef, PassByProxy/PassByCopy), `msg-passing` (six primitives, call vs eventual send, resolve/smash/eject), `turns` (atomic micro-transactions, chronological encapsulation), `partial-order` (full→tree→partial order), `when-index` (Four Layers of When sub-hub map), `eio-index` (EIO sub-hub map).
- **Hub refreshed:** map section + source flipped the 4 mechanics chapters + 2 sub-hub maps from "(queued)" to ingested links; notes now record only the six sub-hub children remaining.
- **Topic pages:** e-language +6, eventual-send +6, pass-style +1 (refmech), capability-security +1 (refmech, placed in the main table before Superseded).
- **Counts corrected in topics/README:** e-language 32→38, eventual-send 86→92, pass-style 56→71 (also cleared a pre-existing 56→70 drift), capability-security 236→240 (also cleared 236→239 drift). sources/README +6 rows.
- **Gates:** `library-link-check --source-slug` passed (exit 0) on all 7 touched clusters; `regenerate-sections-index.sh` landed.

## Follow-ups
- **`scholar-ingest-erights-10` posted** (and already claimed by a peer) for the six sub-hub children (When's four + EIO's two) — that one cycle completes the `elib/concurrency/` chapter.
- **Flagged, not mine:** the ~20 pre-existing dangling nav links (`endo-but-for-bots--llm-designs-*`, `concepts/polaris.md`, `concepts/powerbox.md`, `sources/endo--designs-daemon-persistence.md`) still want a separate library-link cleanup job; topics/README count drift recurs silently and would benefit from a deterministic recount check (carried into the erights-10 body).
- **Deploy note (routed to liaison):** the conventions-named `insert-sections-table-row.sh` is **present on `origin/main2`** but absent from this host's deployed root (`fe2d9f296` lagging `origin/main2` `b9f0fd5b4`) — an upgrade-ready condition on endolinbot, not a doc/script divergence. I used a safe whole-file-landing fallback, so cycle output is unaffected; no deploy attempted (liaison's deliberate action).

Self-improvement: a gardener that finds a conventions-named script "missing" should check `origin/main2` before concluding it's gone — the deployed root is a lagging snapshot, not the source of truth (correction message posted to liaison at 174904Z, fixing the inaccurate self-improvement line on the result entry).
