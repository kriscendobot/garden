Job `design-token-cost-ledger` complete.

**What I did.** Landed `designs/token-cost-ledger.md` on `main2` at `dabded82ad` (verified present at the `origin/main2` tip), grounded in the scholar's unum ingest (`journal2` library concept `cost-ledger` and sections `unum--token-cost-ledger.md`, `unum--cost-attribution-and-aggregation.md`).

**The design, in brief.** "Ledger measures, gate caps": an attributed per-job cost ledger that complements, never replaces, the `usage-meter.sh` quota gate. Key decisions:

- **Reconciled with prior art rather than duplicating it.** The accepted-but-unbuilt `designs/tada-token-accounting.md` (2026-07-09) already settled the write mechanics (code-only capture, engagement boundary, journal `usage/` store, footer stamp at doin→tada, fail-open). My design keeps all of it wholesale and widens the record; it directs the builder to implement the **merged shape once**: one ledger, one footer, one capture ladder.
- **Record**: one JSON line per engagement in `usage/<base>.jsonl` on `journal2` (format widened TSV→JSONL, with rationale), carrying the four token classes, CLI-computed `total_cost_usd` (notional under the Max subscription, noted), wall-clock, rusage, tagged base/role/model/host/gardener/session/outcome/source.
- **Capture ladder**: primary is the `claude -p --output-format json` terminal result envelope (unum's decision; `meter_claude` already proves the shape in this codebase); fallback is the accepted design's session-log delta widened to four classes (dollars omitted); last resort a tokenless `source:none` row, always counted as "unmetered", never dropped.
- **Storage / multi-host answer**: journal-as-shared-ledger beats unum's gitignored per-host file for a leader/follower fleet: every host appends host-tagged rows to the same branch, the completion row rides `complete-job.sh`'s existing push, and the fleet-wide view is one read of any synced clone (no rollup service). Per-base files avoid a single hot CAS path.
- **Read-time-only aggregation**: new `scripts/jobs/cost.sh --by job|role|model|day|host`, dollars-descending, RSS as max-not-sum, unpriced/unmetered counts surfaced.
- **Three surfaces**: the on-demand table; the tada `## Cost` stanza (the accepted design's marker-delimited machine footer, widened, strip-and-restamp); a leader-only bulletin chip riding the bulletin's existing push-gate.
- **Feeding the gate**: the ledger supplies `meter_window_total`'s missing multi-host sum (its `TODO(multi-host)` exactly); gate takes `max(session-log, ledger)` so it keeps its back-off-early bias and its plain-code, no-LLM role. Model-routing and vigil-charge are noted as follow-ons only (a separate design job recommended for vigil-charge, to be filed).
- **Open questions** for the maintainer: producer-stamped `trigger` provenance on the board schema; notional dollars as the default sort key; `usage/` archival (deferred).

**Also changed.**
- `designs/README.md`: index row added (same commit).
- Library writeback (library-lookup discipline): the `journal2` concept page `library/concepts/cost-ledger.md` now points at the landed design, landed via `land-journal-edit.sh` (verified: "landed library/concepts/cost-ledger.md on origin/journal2").
- Self-improvement, committed at `97d4ec5742`: `skills/mermaid-validation/SKILL.md` now extracts fences into a per-run `mktemp -d` directory; the fixed `/tmp/mm-N.mmd` paths collided with a concurrent peer's stale extractions during this very job.

**Verification.** The design's mermaid diagram parse-validated per the mermaid-validation skill (`OK /tmp/mm-1.mmd` via `mermaid.parse`); the file scanned clean for em-dashes (the one hit is the verbatim marker string quoted byte-identical from the accepted design) and Latin shorthand; both pushes confirmed on `origin/main2`.

**Follow-ups.** (1) The tada-token-accounting builder job should be pointed at the merged task list in `designs/token-cost-ledger.md` § Build phasing before it starts. (2) Phase-2 jobs (`cost.sh`, bulletin chip, gate ledger-source) and phase-3 follow-ons (service-turn rows, trigger provenance) are enumerated in the design for later posting. (3) A vigil-charge design job, if the maintainer wants it.
