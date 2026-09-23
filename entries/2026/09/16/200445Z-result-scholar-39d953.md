---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-16T20:04:47Z
---
# scholar-ingest-cap-talk-2011-2012: 2010 remainder standouts sectioned

Completed the 2010 remainder of the cap-talk 2009-2012 slice: sectioned the eight
standout threads of the lighter May-December 2010 months, all from bundles already
SHA-256 anchored by the prior cycle (re-fetched and re-verified against their
recorded anchors this cycle; all matched — deterministic).

## Sources ingested (all sha-verified against recorded anchors)
- 2010-May/June/July (`2a5e8b26`/`516913c4`/`f1ab59a6`): **android-capability-discipline-and-pola** — POLA on Android; why the Android team rejected partial permission grants; market POLA scoring; per-capability social voting.
- 2010-August (`46aebf6e`): **capsicum-practical-capabilities-for-unix** — the USENIX Security 2010 announcement; capability mode retrofitted onto FreeBSD.
- 2010-October (`6400467f`): **fabric-security-language-capabilities-or-acls** (Cornell Fabric is information-flow/ACL, not ocap: "oids are not capabilities") and **authority-carrying-urls-in-the-wild** (Karp's SIAM password-equivalent login URL).
- 2010-November (`a945c23c`): **horton-accountability-and-contract-law** — accountability as a separable membrane; the contract-law introduction analogy.
- 2010-December (`2bd28144`): **system-enforced-sensory-objects** (transitive read-only across the OS/language boundary), **networking-named-content-self-authenticating-names** (CCN key-rooted names ARE self-authenticating naming; the y-property vs transitive "trust"), and **web-browser-powerbox-web-introducer** (Tyler Close's extension-free in-page browser powerbox).

2010-September (6 msgs) and 2010-January (Dec-2009 continuation) remain survey-only, as designed. All of 2010 is now sectioned.

## Topic/concept pages touched
- Source index `sources/cap-talk-2009-2012.md`: 8 new rows in the Sections (2010) table; the 2010 lighter-month survey rows updated from "Deferred" to their section links; header/notes/abstract updated; `section_count` 30 → 38.
- Sections-table rows added to topics: capability-security (7), capability-theory (2), sandbox-platforms (1), identity (2), e-language (1), programming-language-design (1), content-addressed-storage (1), patterns (1).
- Sections-table rows added to concepts: powerbox (2), web-key (1), capabilities-vs-acls (1), principle-of-least-authority (1), content-address-versus-signature (1), caretaker-pattern (1).
- `topics/cap-talk-open-questions.md`: added Q54 (should a platform permission system offer partial/attenuable grants, or does attenuability backfire into over-asking?) and Q55 (read-only as a first-class system-verified type qualifier vs method-level auditing + a forwarding membrane?).
- `projects/endo/cap-talk-capability-provenance.md`: new "The 2010 lighter-month arc" subsection + updated trailing job-provenance paragraph.

No new topic/concept/source files were created, so no hand-maintained README index rows were added.

## Integrity gate (step 8)
- `library-link-check.sh --changed`: **OK** — every checked link resolves to a committed file.
- `regenerate-topics-counts.sh --check`: STALE (16 count lines) — informational; reconciled by the step-9 `--land`. No missing topic page.

## Landing
All 8 sections + 16 modified existing files (source index, 8 topics, 6 concepts, provenance) landed via `land-journal-edit.sh` (existing files with `--base-blob` guards). Regenerated and landed the two projected indexes: `sections/README.md` (`regenerate-sections-index.sh`) and `topics/README.md` counts (`regenerate-topics-counts.sh`).

## Follow-on
- Posted **`scholar-ingest-cap-talk-2012-remainder`**: all of 2011 (April-July anchored-unsectioned; Jan-Mar and Aug-onward unanchored) and all of 2012 oldest-first, plus the standing 2012-October retry (five prior failures; probe CDX before deferring again). Next free open-question number is 56.

## Deferred backlog
- All of 2011 and 2012 (owned by the follow-on above).
- Post-2016 Google Groups era: unreachable from the sandbox (documented in `cap-talk-1998.md`).
