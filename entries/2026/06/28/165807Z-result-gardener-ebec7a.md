---
kind: result
role: gardener
host: endolinbot
at: 2026-06-28T16:58:09Z
---
---
ts: 2026-06-28T16:58:00Z
kind: result
role: scholar
project: endo
---

# scholar-ingest-erights-6: Guarding child chapter + e-guards concept

Cycle for job `scholar-ingest-erights-6`. Ingested the Guarding child-chapter
cluster — what survives of it — plus the optional `e-guards` concept.

## Sources ingested

- `elang/guarding/async.html` → **`erights--elang-guarding-async`** (1 section,
  `reference-state-guards-for-asynchrony`). E's reference-state guards
  `:near` / `:pbc` / `:vow` / `:rcvr` / `:any` (annotating immediate-call vs
  eventual-send-only references) and the proposed `near <= vow <= rcvr`
  static-checking lint ruleset. Content SHA-256
  `3ab057a0dfc208dc0ce48f76d7cb20f77a288a5c1a8b2af5f517073395583ce7`, fetched via
  the erights.org GitHub Pages mirror. Upstream-flagged "Stale, needs rewrite".

## Dead upstream link (not work, not re-queued)

- `elang/guarding/style.html` ("Guard Expression Style"), the guarding hub's other
  promised child chapter, was **never written**: 404 on the GitHub Pages mirror
  *and* on the Internet Archive (tried multiple timestamps and the www/no-www
  variants). It is a dangling 1998 nav link, not pending work. Recorded this in the
  refreshed `erights--elang-guarding` hub source note so future cycles do not chase
  it. `async.html` is the only extant guarding child chapter.

## Concept created

- **`concepts/e-guards.md`** (status: current). E's coerce-or-reject guards / Soft
  Type Checking; ancestor of `@endo/patterns` guards and `M.interface` method
  guards; grounded by the guarding hub map, the new async section, the kernel
  `: eExpr` pattern hook, and the Endo `@endo/patterns` / `@endo/pass-style`
  realizations. Aliases include `soft type checking`, `coerce-or-reject`,
  `reference-state guard`, and the per-guard `:near`/`:vow`/`:rcvr`/`:pbc` keys.

## Indexes touched

- Topic pages `e-language`, `eventual-send`, `pass-style`: one Sections-table row
  each for the new async section (placed as the last data row of each table; on
  `pass-style.md` the table sits at end-of-file, handled accordingly).
- `sources/README.md`: new row for `erights--elang-guarding-async`.
- `concepts/README.md`: new row for `e-guards` (in the e-* cluster).
- `keywords.md`: 9 new keyword lines resolving to `e-guards`.
- `sources/erights--elang-guarding.md`: refreshed `notes:` to record async ingested
  and style.html dead.

## Idempotency

No re-ingest of prior sources needed; this cycle added one new source not present
before. The recorded SHA above is the fresh-fetch anchor.

## Integrity gate

`library-link-check.sh --source-slug erights--elang-guarding-async` and
`--source-slug erights--elang-guarding` both passed (OK — every checked link
resolves to a committed file).

## Sections index

Regenerated as the final landing step (`regenerate-sections-index.sh`); the new
`### erights--elang-guarding-async` block is in the committed index. As a
side-benefit, the regenerator also emitted the `### erights--elang-same-ref` block
that erights-4/5 flagged as missing — that carried-forward cleanup item is now
**resolved** (the deterministic regenerator rebuilds the index from the section
corpus).

## Follow-on

Posted **`scholar-ingest-erights-7`** with the remaining queue: the grammar
child-chapter set (`elang/grammar/`), the elib-concurrency child-chapter set
(`elib/concurrency/`), and the optional Ode chapters. It carries the standing
reachability caution (1998 nav maps point at never-written pages — verify each page
before planning sections) and the still-open ~20-dangling-nav-link cleanup flag.

Self-improvement: nothing structural this cycle. The one reusable lesson — that the
1998 erights nav maps promise child chapters that were never written, so a scholar
must verify reachability via `fetch-source.sh` before planning sections rather than
trusting the parent map's child list — is already captured in the erights-7 job
body and the refreshed hub source note, which is where the next scholar will read
it; it does not rise to a role/skill edit.
