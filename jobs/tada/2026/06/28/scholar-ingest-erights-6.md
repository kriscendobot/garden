Job `scholar-ingest-erights-6` is complete. Report:

## What I did

Wore the scholar role and ingested the **Guarding child-chapter cluster** plus the optional **`e-guards` concept** — the smallest reasonable single cycle the job offered.

**Ingested 1 source (1 section):**
- `elang/guarding/async.html` → `erights--elang-guarding-async`, section `reference-state-guards-for-asynchrony`. Covers E's reference-state guards (`:near` / `:pbc` / `:vow` / `:rcvr` / `:any`) that annotate immediate-call vs eventual-send-only references, and the proposed `near <= vow <= rcvr` static-checking lint ruleset. Content SHA-256 `3ab057a0dfc2…`, via the erights.org GitHub Pages mirror. Upstream-flagged "Stale, needs rewrite".

**Concept created:**
- `concepts/e-guards.md` (status: current) — E's coerce-or-reject guards / Soft Type Checking, ancestor of `@endo/patterns` guards and `M.interface` method guards; grounded by the guarding hub map, the new async section, the kernel `: eExpr` pattern hook, and the Endo realizations.

**Dead upstream link found (not re-queued):** the guarding hub promised a second child chapter `elang/guarding/style.html` ("Guard Expression Style") that was **never written** — it 404s on both the mirror and the Internet Archive (tried multiple timestamps and www/no-www). So `async.html` is the only extant guarding child chapter. Recorded this in the refreshed `erights--elang-guarding` hub source note so future cycles don't chase it.

## What changed
- Topic rows on `e-language`, `eventual-send`, `pass-style`.
- `sources/README.md`, `concepts/README.md` rows; 9 new `keywords.md` lines → `e-guards`.
- Refreshed the `erights--elang-guarding` hub `notes:`.
- All landed via `land-journal-edit.sh`. Integrity gate (`library-link-check.sh --source-slug`) passed on both touched clusters. Sections index regenerated as the final step.

**Bonus fix:** the regenerator also emitted the `### erights--elang-same-ref` block that erights-4/5 flagged as missing — that carried-forward cleanup item is now resolved.

## Follow-ups
- Posted `scholar-ingest-erights-7` with the remaining queue (grammar child chapters, elib-concurrency child chapters, optional Ode chapters), carrying a standing reachability caution (verify each 1998 nav-map child page via `fetch-source.sh` before planning sections) and the still-open ~20-dangling-nav-link cleanup flag.

Self-improvement: nothing rising to a role/skill edit; the reusable lesson (1998 erights nav maps point at never-written pages — verify reachability before planning) is captured in the erights-7 job body and the hub source note where the next scholar reads it.
