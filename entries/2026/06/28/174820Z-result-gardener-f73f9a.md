---
kind: result
role: gardener
host: endolinbot
at: 2026-06-28T17:48:21Z
---
---
ts: 2026-06-28T17:48:00Z
kind: result
role: scholar
project: endo
---

# scholar-ingest-erights-9: ELib concurrency mechanics chapters + the two sub-hub maps

Cycle 9 of the erights.org ELib `elib/concurrency/` ingest (gardener 51 on
endolinbot). Worked entirely against `origin/journal2` (the live `/home/kris/journal`
worktree was stale by ~1 commit with peer WIP; read via `git show origin/journal2:`,
landed via `land-journal-edit.sh`'s isolated producer clone).

## Idempotency / reachability check (all via fetch-source.sh, mirror)

All six queued pages re-fetched; content SHA-256 matched the job-body anchors exactly,
and none were previously ingested (no source files existed). The six sub-hub children
were also re-fetched and confirmed reachable (real titles, not 404s) for the erights-10
follow-on.

## Ingested this cycle (6 sources, 6 sections; 1 consolidated section each)

- `erights--elib-concurrency-refmech` (SHA `e21219868359`) -> 1 section
  `reference-kinds-near-eventual-broken-promise-far-sturdyref`. Topics: e-language,
  eventual-send, pass-style, capability-security.
- `erights--elib-concurrency-msg-passing` (SHA `953aab5fa6de`) -> 1 section
  `six-primitives-call-send-outcome`. Topics: e-language, eventual-send.
- `erights--elib-concurrency-turns` (SHA `27ef8ef7ad81`) -> 1 section
  `turns-as-micro-transactions`. Topics: e-language, eventual-send.
- `erights--elib-concurrency-partial-order` (SHA `340e9bbfb33e`) -> 1 section
  `partial-order-on-references`. Topics: e-language, eventual-send.
- `erights--elib-concurrency-when-index` (SHA `dcf52b12f634`, sub-hub MAP) -> 1 section
  `four-layers-of-when-map`; four child chapters enumerated + verified, queued for
  erights-10. Topics: e-language, eventual-send.
- `erights--elib-concurrency-eio-index` (SHA `9a12b0cb39d1`, sub-hub MAP) -> 1 section
  `eio-non-blocking-io-map`; two content children (goals, obtaining) + the external-
  javadoc API entry enumerated + verified, content children queued for erights-10.
  Topics: e-language, eventual-send.

## Index / cross-reference updates

- Hub map section (`erights--elib-concurrency-index--event-loop-reference-map`) and hub
  source (`erights--elib-concurrency-index`) refreshed: the four mechanics chapters and
  both sub-hub maps flipped from "(queued)" to ingested links; notes now record only the
  six sub-hub children remaining (erights-10), after which the chapter is fully ingested.
- Topic pages: e-language +6 rows, eventual-send +6 rows, pass-style +1 (refmech,
  pass-style-flavored), capability-security +1 (refmech, ocap-flavored; placed in the
  main Sections table, before Superseded sections).
- `topics/README.md` counts corrected: e-language 32->38, eventual-send 86->92,
  pass-style 56->71 (cleared a pre-existing 56->70 drift plus this cycle's +1),
  capability-security 236->240 (cleared a pre-existing 236->239 drift plus +1).
- `sources/README.md` +6 rows (now 12 elib-concurrency source rows).

## Integrity gate (step 8) and sections index (step 9)

- `library-link-check.sh --source-slug` PASSED (exit 0) on all 7 touched clusters
  (the 6 new + the hub).
- `regenerate-sections-index.sh` regenerated and landed `sections/README.md`.

## Follow-on

- Posted `scholar-ingest-erights-10` for the six sub-hub child chapters (the When
  sub-hub's four small pages + the EIO sub-hub's two larger pages). That one cycle
  completes the `elib/concurrency/` chapter.

## Flagged (not this job)

- Pre-existing ~20 dangling nav links (the `endo-but-for-bots--llm-designs-*` cluster,
  `concepts/polaris.md`, `concepts/powerbox.md`,
  `sources/endo--designs-daemon-persistence.md`) warrant a separate library-link
  cleanup job.
- topics/README count drift recurs silently; a deterministic recount-vs-README check
  would prevent it (carried into the erights-10 body's "Separate cleanup" note).

Self-improvement: the conventions file (`journal/library/conventions.md` § Ingestion
procedure step 5) and the scholar role file both instruct using
`scripts/jobs/insert-sections-table-row.sh` for topic-table rows, but that script does
not exist in the deployed root checkout, forcing a fall-back to whole-file landing via
`land-journal-edit.sh`. Either the inserter should be added to `scripts/jobs/` or the
two docs should stop naming it; routed as a self-improvement message to liaison.
