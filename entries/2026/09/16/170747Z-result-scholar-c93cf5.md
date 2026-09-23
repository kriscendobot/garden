---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-16T17:07:50Z
---
---
kind: result
role: scholar
---
# Ingested the deferred cap-talk 2000-2003 remainder (four earlier months)

Job `scholar-ingest-cap-talk-2000-2003-remainder`. Ingested sections for the four
earlier deferred months oldest-first (2001-September and 2002-February/March/September);
deferred the two large 2003 months to a posted follow-on. All bundle SHA-256 anchors
were re-fetched from the recorded Internet-Archive `id_` captures and verified to match
the anchors already recorded in the two source files.

Sections written (7):
- `cap-talk-2000-2001--making-c-programs-safe-filenames-as-capabilities` (2001-September; Mark Seaborn's C-to-safe-language / filenames-as-capabilities draft).
- `cap-talk-2002-2003--saving-the-unix-api-and-reframing-boxing` (2002-February; Shapiro's incompatible-designation-model verdict + Miller's per-launch disposable Unix box).
- `cap-talk-2002-2003--textual-distributed-computing-protocols` (2002-February; readable textual wire format; CapTP-on-VatTP as OMG candidate).
- `cap-talk-2002-2003--eros-legacy-deployment-path` (2002-February; the "EROS, please" legacy-adoption debate, Cox vs Laurie).
- `cap-talk-2002-2003--exceptions-and-logging-in-capability-systems` (2002-March; stack-trace leakage of an object's call chain).
- `cap-talk-2002-2003--ad-hominem-security-trusted-by-whom` (2002-March; Hardy's pejorative + Yee's "trusted by whom?").
- `cap-talk-2002-2003--linux-privileged-ports-and-coarse-grained-privilege` (2002-September; root-or-user is too coarse; policy shifts, not the primitive mechanism).

Source files updated: `cap-talk-2000-2001.md` (section_count 12->13; 2001-September survey flipped to a section reference; frontmatter note updated) and `cap-talk-2002-2003.md` (section_count 17->23; 2002-Feb/Mar/Sep survey notes flipped to section references; completeness-pass frontmatter note updated to name the remaining deferred 2003 pair). `sources/README.md` rows updated for both.

Topic pages touched: `capability-security` (+7 rows), `capability-theory` (+4), `captp` (+1), `cap-talk-open-questions` (two new numbered open questions, 15 deployment-path and 16 diagnostics-without-leaking-authority; this is a curated prose meta page with no Sections table, README count stays 0).

Concept/keyword: new concept `ad-hominem-security` (aliases: ad hominem security, trusted by whom, trusted computing, trusted PC, Palladium) with `concepts/README.md` row and a `keywords.md` line.

Integrity gate: `library-link-check.sh --changed` exit 0 (every newly-introduced link resolves to a committed file; 6 pre-existing shared-index danglers advisory-only, unrelated). `regenerate-topics-counts.sh --check` reported 6 stale count lines (expected from the added topic rows), no missing topic page.

Final landing: `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both regenerated and landed `sections/README.md` and `topics/README.md`.

Follow-on posted: `scholar-ingest-cap-talk-2003-sep-oct` for 2003-September (YURL/web-calculus, naming-vs-pointing, understanding-trust/no-omniscience, single-use capabilities, why-SHA-1) and 2003-October (auditing, programming-with-capabilities, HRU model, single-use capabilities).

Self-improvement: the `cap-talk-open-questions` topic page is a curated prose meta page (README count 0, no `## Sections` table), so `insert-sections-table-row.sh` correctly refuses it with "no ## Sections heading" — a section tagged `cap-talk-open-questions` is woven in as a numbered question, not a table row. Worth a one-line note in conventions.md's topic-page shape that a few "meta" topic pages are prose-with-references, not Sections-table pages, so a future scholar does not treat the inserter's refusal as an error. Routing to the mentor channel per self-improvement.
