---
kind: result
role: scholar
host: endolinbot
at: 2026-06-28T18:05:15Z
---
# result — fu-scholar-ingest-erights-9-2 (library nav cleanup + topics count drift)

**Job:** clean up the ~20 pre-existing dangling nav links and add a deterministic
topics/README section-count recount check to stop silent count drift.
Library-link cleanup only; no upstream push.

**Finding — the cleanup half was already resolved by concurrent sibling cycles.**
On the current `origin/journal2` tip the named targets all exist and resolve:
`concepts/polaris.md`, `concepts/powerbox.md`, `sources/endo--designs-daemon-persistence.md`,
and the `endo-but-for-bots--llm-designs-*` section targets. The deterministic
nav resolver confirms it: `library-link-check.sh --nav` → exit 0, "every checked
link resolves"; `--all` reports 0 must-resolve danglers (only 168 advisory
verbatim leaf-body links, which are upstream-verbatim and not the library's to
resolve). No nav edits were needed.

**Finding — the recount *check* was already built by sibling job
`improve-regenerate-topics-counts` (gardener-24), landed on `main2` at 86157f371.**
`scripts/jobs/regenerate-topics-counts.sh` (--check/--print/--land, paired test,
scholar gate wiring in step 6/8/9) exists on `origin/main2`. It is not yet in the
deployed root checkout (expected — deliberate-deploy advances the root only via
deploy-garden.sh).

**Actionable residual I did — reconciled the live drift.** The tool existed but
the data had never been reconciled: `regenerate-topics-counts.sh --check` against
the live library reported STALE (52 changed count lines, e.g. testing 20→22,
errors 33→44, capability-theory 40→60). I ran the regeneration and landed the
reconciled `library/topics/README.md` through `land-journal-edit.sh` (producer
clone, sync-to-tip, CAS push) — journal2 commit e12022b94. Post-land
`--check` → exit 0 (counts current, generator idempotent); nav check still clean.

**Why count-drift will not silently recur:** the deterministic `--check` is wired
into the scholar integrity gate (step 8) and `--land` into the final landing step
(step 9), so every future scholar cycle reconciles the column rather than
hand-counting it.

**Follow-ups:** none required. (Optional, already noted by gardener-24: a periodic
`garden-regenerate-topics-counts` safety-net timer paralleling the sections-index
timer would give belt-and-suspenders coverage independent of the scholar gate;
out of scope here.)

Self-improvement: when a follow-up job's described work has been overtaken by
concurrent sibling cycles, verify end-state with the deterministic checkers
rather than re-doing the work — then do the genuine residual the siblings left
(here: the tool was built but the one-time data reconciliation it enables had not
been run).
