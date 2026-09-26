The harness completes the job (doin→tada) from the `<<<GARDEN-JOB-COMPLETE>>>` signal — I should not run `complete-job.sh` manually. All work is landed and verified. Here is my report.

---

## Completion report — `scholar-ingest-cap-talk-2012`

**What I did:** Sectioned the already-anchored 2011-August through 2012-March cap-talk bundles oldest-first, completing all of 2011 and 2012 January–March. Every bundle was re-fetched through `fetch-source.sh` and its SHA-256 verified equal to the recorded anchor before ingest.

**New sections (11) + 1 fold:**
- 2011-Aug: `language-support-for-object-capabilities` (Kevin Reid)
- 2011-Sep: `limits-of-program-verification-and-policy-verification` (Shapiro / Hoare mea-culpa thread)
- 2011-Oct: **folded** the "Avoiding excess authority in chained access" continuation into its existing June section (no new file), per the ask
- 2011-Nov (dense legacy-web/OpenID/Horton month): `supplanting-passwords-and-the-master-capability`, `openid-single-sign-on-critique`, `capabilities-for-legacy-web-programs`, `modeling-capability-propagation-and-horton`
- 2011-Dec: `introduction-by-default-versus-proxy-by-default`
- 2012-Jan (dense "Opinions of oauth?"): `opinions-of-oauth`, `distributed-reference-counting-garbage-collection`
- 2012-Feb: survey-only (light; the `[nodejs]` capability-Web-apps item is a cross-post pointer with no on-list discussion)
- 2012-Mar: `js-membranes-and-fine-grained-object-views`, `what-parts-of-a-url-are-safe-for-secrets`

**Index/curation updates:** source index `cap-talk-2009-2012.md` (section_count 54→65, anchor-table survey rows, new Sections (2012) table, notes + abstract); 31 topic-page section rows across 10 topics; concept rows on `oauth-client-credentials-vs-authorization-code`, `web-keys`, `confused-deputy`, `powerbox`; a **new concept page** `introduction-by-default` + keyword lines; open questions **60–63** added; `projects/endo/cap-talk-capability-provenance.md` gained a late-2011/early-2012 arc section; `sources/README.md` and `concepts/README.md` rows updated.

**Verification (real-execution evidence):** `library-link-check.sh --changed` = **OK, EXIT 0** (every checked link resolves to a committed file, after committing new files in the staging clone). `regenerate-topics-counts.sh --check` reported STALE (informational; reconciled by step-9 `--land`). All **32** content files landed via `land-journal-edit.sh` (EXIT 0 each; `--base-blob` for the 20 pre-existing files). `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both landed **EXIT 0**.

**2012-October:** deliberately **not** retried — per the ask, an eighth attempt is warranted only after the Internet Archive CDX index confirms a surviving capture of `2012-October.txt.gz`; the `2id_` redirect form has 404'd consistently.

**Follow-up:** posted `scholar-ingest-cap-talk-2012-april-onward` (2012-April onward; open questions from #64; the CDX-gated October rule carried forward). Used a distinct base because `-2011-2012-remainder` and `-2012-remainder` are already completed in tada.

**Flag for maintainer:** two overlapping web-key concept pages (`concepts/web-key.md` and `concepts/web-keys.md`) with near-duplicate keyword clusters — a consolidation pass would tighten the concepts axis (flagged, not landed).

Result entry: `entries/2026/09/16/212803Z-result-gardener-3b5171.md`. Maintainer digest delivered.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-cap-talk-2012.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 234 tokens (27630495 cached reads)
- Output: 107548 tokens
- Cost: $19.961075500000003
- Wall-clock: 2124s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
