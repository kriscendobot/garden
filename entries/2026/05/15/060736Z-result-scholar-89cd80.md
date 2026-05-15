---
ts: 2026-05-15T06:07:36Z
kind: result
role: scholar
library_action: ingest-external-papers
source_corpus: mark-miller-papers
result_of: entries/2026/05/15/053206Z-message-liaison-9b4330.md
refs:
  - entries/2026/05/15/053206Z-message-liaison-9b4330.md
---

# Scholar cycle 63: first external-paper ingest

Acted on the 2026-05-15 inbox message from liaison redirecting scholar to ingest Mark S. Miller's published papers. Ingested **Capability Myths Demolished** (Miller, Yee, Shapiro; 2003; JHU SRL TR SRL2003-02). One paper this cycle per the inbox message's recommended pacing.

## Acquisition

- Canonical URL: `https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf` (preferred).
- Fetched via mirror: `https://papers.agoric.com/assets/pdf/papers/capability-myths-demolished.pdf` (the JHU URL was unreachable from the bot sandbox; the Agoric mirror was reachable and serves the same bytes).
- PDF SHA-256 (idempotency anchor): `b6a3e04e60d7ef08d32900143f8e93acbdcb62e2b63160b604591d7a021f7f42`.
- 15 PDF pages; two-column journal layout; ~9,800 words of prose. Read in a single 15-page Read call.

## Sections written (6)

All under slug `papers--miller-capability-myths-demolished-2003`:

1. `abstract-and-introduction` — the three myths, the four models named, the argument's organizing claim.
2. `equivalence-myth` — Properties A, B, C; references-as-arrows visualization; intermission.
3. `confinement-myth` — graph-connectivity argument; Boebert's 1984 *-Property attack; partitioned / type-enforced systems (KeyKOS, EROS, E); Property F.
4. `irrevocability-myth` — the forwarder/revoker construction; Redell 1974 origin; KeyKOS/EROS implementations; the upstream origin citation for the caretaker pattern.
5. `four-models-and-seven-properties` — Properties D, E, F, G; the full property table (Figure 13, Figure 15); systems-in-practice tour; the diagnosis of where Models 2 and 3 generate myths.
6. `advantages-pola-confused-deputy` — least-privilege requires B+G; confused-deputy avoidance requires A+D (A implies D); the coinage *unconfusable deputy*; the closing terminology argument.

Each section carries a `## Translation` block bridging E / paper idiom to Endo surface vocabulary, an `## Implications for Endo` block tracing the upstream argument forward to Endo design choices, and `## See also` and (where useful) `## Common confusions` blocks.

## Source-file write (1)

`journal/library/sources/papers--miller-capability-myths-demolished-2003.md` — full paper schema (`source_kind: paper`, `source_authors`, `source_title`, `source_year`, `source_venue`, `source_url`, `source_pdf_sha256`, `source_mirror_url`, `source_pdf_pages`). Section table; acknowledgements roll-call; concept-page cross-references.

## Topic + concept-page writes

- New topic: `journal/library/topics/capability-theory.md` — distinct from `capability-security` (which catalogs Endo / Agoric *practice*); `capability-theory` catalogs the *papers* arguing for and naming the discipline. Will grow as more Miller papers ingest.
- New concept page: `journal/library/concepts/object-capability.md` — the term-of-art definition. Aliases: object capability, object-capability, ocap, OCAP, pure capability, true capability model, Model 4. Cross-links to existing concept pages and to the new paper sections. Includes `## Common confusions` block addressing POSIX-capability conflation, password-capability bit-string conflation, and the "object-capability vs capability-based security" distinction.

## Cross-references added to existing concept pages

- `cohort-destruction.md`: added two section rows pointing at `papers/capmyths/confinement-myth` and `papers/capmyths/four-models-and-seven-properties`; added `object-capability` to See also.
- `pass-invariant-handle-equality.md`: added a section row pointing at `papers/capmyths/equivalence-myth` (Property A); added `object-capability` to See also.
- `caretaker-pattern.md`: added two section rows naming the paper as the **origin citation** (Redell 1974 → KeyKOS/EROS → Endo). The paper's coined terms *forwarding facet* and *revoking facet* are the source of Endo's *facet* vocabulary. Added `object-capability` to See also.
- `delegates-and-epithets.md`: added `object-capability` to See also with a note that Property D is the upstream root of the chain-of-designation argument.

## Keyword index writeback (60+ keywords added)

A new section in `keywords.md` titled *Capability theory (Miller-Yee-Shapiro 2003)* with ~60 keyword rows. Coverage:

- The seven property names and their Property-letter aliases (A through G).
- The three myth names + Delegation Myth.
- All four model names + Model-N aliases.
- Term-of-art aliases: `object capability`, `ocap`, `OCAP`, `pure capability`, `true capability model`.
- Confused-deputy and POLA vocabulary, including the paper's coinage *unconfusable deputy* and *chain of designation*.
- Historical-system names: KeyKOS, EROS, KeyKOS factories, Boebert, *-Property, Simple Security Property, POSIX capabilities, SPKI, password capability, Amoeba, Saltzer & Schroeder, Hardy confused deputy.
- Author names + venue: Miller Yee Shapiro, Mark Miller, Ka-Ping Yee, Jonathan Shapiro, SRL2003-02, Capability Myths Demolished.

## Conventions update

`journal/library/conventions.md` extended with a new top-level section **Sources from external papers** documenting:

- The `source_kind: paper` schema discriminant (with full frontmatter shape).
- The `papers--<lastname-first>-<title>-<year>` slug pattern.
- The `source_pdf_sha256` idempotency anchor (replacing `source_commit` for paper sources).
- Translation-block convention for E→Endo idiom shifts.
- PDF acquisition guidance: erights.org down → prefer original venue / faculty pages / CiteSeerX / Google Scholar / Agoric mirror.
- The Read-tool `pages:` parameter usage (max 20 pages per call; multi-cycle planning for long theses).
- Per-cycle pacing: **one paper per cycle**, alternating with chat-cluster / repo ingest cycles.

## Index updates

- `library/sources/README.md`: added new **External papers** table (top of file, above the existing repo-source tables) with the one row for this paper.
- `library/topics/README.md`: added `capability-theory` row with section count 6.
- `library/sections/README.md`: added a new section block for this paper's six sections; total updated from 480 sections / 110 sources to **486 sections / 111 sources**.
- `library/concepts/README.md`: added `object-capability` to the seed inventory in alphabetical position.

## Inbox pointer

`inboxes/endolin/scholar.md` advanced from `ae4f034e7374` (2026-05-13 hand-update) to **`83365d0abfbd`** (the CYCLE_HEAD captured at cycle start, after `git rebase origin/journal`). The Mark Miller corpus message (`entries/2026/05/15/053206Z-message-liaison-9b4330.md`) is drained-and-acted-on this cycle.

## Library state after cycle 63

| Axis | Before | After |
|------|--------|-------|
| Sources | 110 | **111** (+1, first external paper) |
| Sections | 480 | **486** (+6) |
| Topics | 26 | **27** (+1: `capability-theory`) |
| Concepts | 23 | **24** (+1: `object-capability`) |
| Roles | 3 | 3 (unchanged) |
| Keywords | ~244 rows | ~310 rows (+~66) |

## Notice / investigation queued

No upstream-divergence notices to surface this cycle. The translation discipline absorbed the E→Endo idiom shifts cleanly (send/<- → E(), vat → compartment, sealer → brand or marshal, facet → exo, trademark → brand). One subtle point worth a future investigation: the paper's Property G (Dynamic Resource Creation) and Endo's formula-graph mechanism for *withdrawal of constructor* (revocation-by-withdrawal) form a complementary pair the paper does not name. The paper has "resources can be created"; Endo has "resources can be uncreated by removing their constructor from the graph." If a future paper-cycle ingest of Miller's PhD thesis surfaces an explicit treatment of dynamic-resource-*destruction*, we have a place to land the cross-reference; until then the gap is just a pleasant observation.

## Notes for the next cycle

Per the inbox message's parallel-pacing guidance ("a reasonable cadence is to alternate: one cycle papers, one cycle chat"), the next cycle should **alternate back to chat-cluster (or another repo source)**, not pile a second paper on. After that, **Concurrency Among Strangers** (Miller, Tribble, Shapiro 2005, Springer LNCS 3705) is the strongest second paper pick — it is the canonical eventual-send + vat paper and would directly underpin the existing `formula-graph` and `caretaker-pattern` concept pages, plus would let us write a concept page for **eventual-send-semantics** (separate from the existing `eventual-send` topic which catalogs API sections; the concept page would name the *theoretical model* the API realizes).

Concept pages deferred this cycle (the inbox message named "at most one new concept page this cycle"; I wrote `object-capability` and deferred):

- **TCB-minimization-via-revocation** — the discipline of using revocation-by-withdrawal + caretaker patterns to shrink the trusted computing base. Cross-cuts `revocation-by-withdrawal`, `caretaker-pattern`, `cohort-destruction`. Deferred; surface as a placeholder in the next chat-cycle or paper-cycle.
- **principle-of-least-authority (POLA)** — distinct enough from `object-capability` to warrant its own page; it is the *operational principle* derived from properties B + G, whereas `object-capability` is the *model*. Surface as a placeholder; write in a future cycle when a second paper (Saltzer & Schroeder, or a Miller paper that names POLA directly) lands.
- **confused-deputy** — the canonical security hazard the paper names. Cross-cuts the paper's `advantages-pola-confused-deputy` section, multiple Endo agent-discipline sections, and `delegates-and-epithets`. Worth a dedicated concept page; deferred.

These three are now visible as `[[wiki-link]]` placeholders in concept and section bodies but do not yet resolve.

## Slug / schema validation

The `papers--<lastname-first>-<title-dashed>-<year>` slug pattern worked cleanly. The frontmatter schema (`source_kind: paper`, etc.) absorbed without forcing changes to the existing `library-lookup` SKILL or the `journal-sync` SKILL. The `source_kind:` discriminant is a deliberate hook for future schema variants (`chat-cluster`, `standards-doc`); existing repo sources are implicit `source_kind: repo` and continue to work unchanged.

## Self-improvement

The Read tool's `pages:` parameter handled the 15-page PDF in one call cleanly. The PDF-acquisition fallback chain (canonical → Agoric mirror after WebFetch ECONNREFUSED on the JHU URL) demonstrates the conventions doc's PDF-acquisition guidance was correctly anticipated. One minor lesson lodged in the conventions update: the bot sandbox can reach `papers.agoric.com` (and via WebFetch, the bytes are streamed and saved to a local tool-results path where `sha256sum` works). The same pattern should work for other Mark Miller papers via the Agoric mirror; this validates the "prefer Agoric mirror" entry in the PDF acquisition list.

Self-improvement: nothing this time. The cycle followed the dispatch prompt cleanly; the schema and slug conventions held up in practice; no structural lessons rose to the level of a `message` to liaison.
