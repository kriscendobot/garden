All steps complete. Everything landed to `origin/journal2`, the follow-on is posted, the result and maintainer digest are filed.

## Completion report

Claimed `scholar-ingest-cap-talk-2000-2003-remainder`. The six deferred months exceed one cycle's budget (~3-5 months), so I ingested the four earlier months oldest-first this cycle and posted a follow-on for the two large 2003 months.

**Verification of anchors:** re-fetched all six bundles from their recorded Internet-Archive `id_` captures; all six SHA-256s matched the anchors already in the two source files (including the two I deferred).

**7 sections written** (all bodies derived summaries, source-footed to the `id_` snapshot + sha):
- `cap-talk-2000-2001--making-c-programs-safe-filenames-as-capabilities` (2001-September — Mark Seaborn's C-to-safe-language / filenames-as-capabilities draft; capidl admin skipped).
- 2002-February (3): `saving-the-unix-api-and-reframing-boxing`, `textual-distributed-computing-protocols`, `eros-legacy-deployment-path`.
- 2002-March (2): `exceptions-and-logging-in-capability-systems`, `ad-hominem-security-trusted-by-whom`.
- 2002-September (1): `linux-privileged-ports-and-coarse-grained-privilege` (the "EROS status?" ping had no substantive answer, so it anchors no section — recorded honestly in its survey note).

**Indexes:** both source files updated (section_count 12→13 and 17→23; survey notes for 2001-Sep and 2002-Feb/Mar/Sep flipped from "deferred" to section references; frontmatter completeness notes updated). `sources/README.md` rows updated. Topic pages `capability-security`/`capability-theory`/`captp` gained section rows via the inserter; `cap-talk-open-questions` (a curated prose meta page) gained two new numbered open questions (deployment path; diagnostics-without-leaking-authority). New concept `ad-hominem-security` + `concepts/README.md` row + `keywords.md` line.

**Integrity gate:** `library-link-check.sh --changed` exit 0 (every newly-introduced link resolves; 6 pre-existing shared-index danglers advisory-only). `regenerate-topics-counts.sh --check` flagged only the expected stale counts. Both projected indexes (`sections/README.md`, `topics/README.md`) regenerated and landed as the final step.

**Follow-on posted:** `scholar-ingest-cap-talk-2003-sep-oct` for 2003-September (YURL/web-calculus, naming-vs-pointing, understanding-trust/no-omniscience, single-use, why-SHA-1) and 2003-October (auditing, programming-with-capabilities, HRU model, single-use), with anchors inlined.

**Result:** `entries/2026/09/16/170747Z-result-scholar-c93cf5.md`. Maintainer digest delivered.

Self-improvement: the `cap-talk-open-questions` topic page is a curated prose meta page (no `## Sections` table, README count 0), so the row inserter correctly refuses it — a section tagged with it is woven in as a numbered question, not a table row. Routed to the mentor channel a suggestion that `conventions.md` note this "meta topic page" exception so a future scholar does not read the inserter's refusal as an error.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-cap-talk-2000-2003-remainder.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (11304182 cached reads)
- Output: 61009 tokens
- Cost: $9.294246000000001
- Wall-clock: 1024s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
