All work is complete and verified. Here is my report.

---

## Completion report: `scholar-cap-talk-cdx-completeness-2000-2003`

**What I did.** Retried the full Internet Archive enumeration for `eros-os.org/pipermail/cap-talk/2000-*` through `2003-*` after the 2026-09-16 outage. The CDX index was still in a hard 503 "Temporarily Offline" state and the Wayback availability API was rate-limited (429), but the `web/<ts>id_/` playback endpoint worked. Rather than depend on the down CDX, I enumerated **authoritatively from the Pipermail archive index page** (capture `20160913020234`, a single fetch), which lists every monthly `.txt.gz`: **34 bundles** for 2000-2003.

**Key finding.** Comparing against `cap-talk-2000-2001.md` (11 recorded) and `cap-talk-2002-2003.md` (12 recorded) — 23 total, **0 phantom rows** — surfaced **11 previously omitted bundles** the earlier CDX-503 cycle missed: 2001-September; 2002-February/March/May/September/October; 2003-February/March/May/September/October. All 11 were fetched and SHA-256 anchored (hash over the compressed `.txt.gz` bytes, matching the existing convention, verified against a known bundle) and surveyed.

**What changed.**
- **Anchored all 11** new months into the two source files' Monthly-bundle-anchors tables, with survey notes, plus updated `source_months`/`source_authors`/`section_count`/notes and the two `sources/README.md` rows.
- **Ingested 6 new sections across 5 months** (2002-May confused-deputy redux + Chander-Dean-Mitchell state-transition model; 2002-October EROS-vs-L4 persistent capability systems; 2003-February authz-vs-authn; 2003-March USENIX rejection of *Capability Myths Demolished*; 2003-May access-matrix column-vs-row). Added rows to `capability-theory`/`capability-security` topic pages and the `confused-deputy`/`capabilities-vs-acls` concept pages.
- **Integrity gate:** `library-link-check.sh --changed` exit 0; `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` landed clean (no DANGLING). Result entry `entries/2026/09/16/165118Z-result-scholar-b105c3.md` and a maintainer digest posted.

**Follow-up.** The 6 remaining substantive months (2001-September; 2002-February/March/September; 2003-September/October — including the large "Saving the Unix API" and "YURL/web-calculus" threads) are anchored with survey notes and deferred to the posted follow-on **`scholar-ingest-cap-talk-2000-2003-remainder`** (already on the board). The enumeration itself is now complete: every 2000-2003 month has a recorded anchor.

Self-improvement: When the IA CDX index is in an outage, the Mailman/Pipermail **archive index page** is a more robust enumeration source than CDX — one `id_` fetch of `pipermail/<list>/` yields the authoritative complete month list. Worth encoding into `fetch-source.sh`/`check-source-children.sh` (or the library conventions) as the enumeration fallback alongside the existing bounded-CDX path, which is itself useless when CDX is down.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-cap-talk-cdx-completeness-2000-2003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 168 tokens (10709670 cached reads)
- Output: 75084 tokens
- Cost: $9.365995000000002
- Wall-clock: 1373s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
