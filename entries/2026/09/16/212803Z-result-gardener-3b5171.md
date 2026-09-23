---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-16T21:28:05Z
---
Scholar cycle `scholar-ingest-cap-talk-2012`: sectioned the standout threads of the already-anchored 2011-August through 2012-March cap-talk bundles, oldest-first, completing all of 2011 and 2012 January-March in `library/sources/cap-talk-2009-2012.md` (section_count 54 -> 65).

Sources ingested (bundle SHA-256 verified equal to the recorded anchor via fetch-source.sh):
- 2011-August (`4ca3b6e3`): language-support-for-object-capabilities (Kevin Reid).
- 2011-September (`62af2753`): limits-of-program-verification-and-policy-verification (Shapiro on the Hoare mea-culpa thread).
- 2011-October (`8c308efd`): FOLDED into the existing avoiding-excess-authority-in-chained-access section (June+October, no new file), per the ask.
- 2011-November (`1b343432`, dense): supplanting-passwords-and-the-master-capability; openid-single-sign-on-critique; capabilities-for-legacy-web-programs; modeling-capability-propagation-and-horton.
- 2011-December (`b67c8937`): introduction-by-default-versus-proxy-by-default.
- 2012-January (`52782d21`, very dense): opinions-of-oauth (72-msg thread + web-key/YURL alternative); distributed-reference-counting-garbage-collection.
- 2012-February (`fd720c29`): survey-only (light; the [nodejs] capability-Web-apps item is a cross-post pointer, no on-list discussion).
- 2012-March (`6deacabd`): js-membranes-and-fine-grained-object-views; what-parts-of-a-url-are-safe-for-secrets.

11 new section files + 1 folded section. Topic pages updated (31 section rows across programming-language-design, hardened-javascript, capability-security, capability-theory, identity, oauth-credentials, distributed-objects, persistence, patterns, revocation). Concept pages updated (oauth-client-credentials-vs-authorization-code, web-keys, confused-deputy, powerbox) and one new concept page created (introduction-by-default) with keywords.md lines. Open questions 60-63 added to cap-talk-open-questions (distributed GC / space recovery unsolved; master-capability bootstrap residue; OAuth-2 practical-vs-principled; URL secret-safety / spyware). `projects/endo/cap-talk-capability-provenance.md` gained a "late-2011 and early-2012 arc" section and an updated job trailer. sources/README and concepts/README rows updated.

Integrity gate (step 8): `library-link-check.sh --changed` = OK (every checked link resolves to a committed file, EXIT 0) after committing the new files in the staging clone. `regenerate-topics-counts.sh --check` reported STALE (informational; reconciled by the step-9 --land regen). Step 9: regenerate-sections-index.sh --land and regenerate-topics-counts.sh --land both landed EXIT 0. All 32 content files landed via land-journal-edit.sh (with --base-blob for the 20 pre-existing files).

2012-October: NOT retried this cycle (correctly). Per the ask, an eighth attempt is warranted only after the Internet Archive CDX index confirms a capture of `2012-October.txt.gz` exists; the `2id_` redirect form has 404'd consistently.

Follow-on posted: `scholar-ingest-cap-talk-2012-april-onward` (fetch/anchor/survey/section 2012-April onward; open questions from number 64; the CDX-gated 2012-October eighth-attempt rule carried forward). A distinct base was used because `scholar-ingest-cap-talk-2011-2012-remainder` and `scholar-ingest-cap-talk-2012-remainder` are already in tada (completed).

Self-improvement: there are two overlapping web-key concept pages (`concepts/web-key.md` and `concepts/web-keys.md`) with near-duplicate keyword clusters in keywords.md; a maintainer-authorized consolidation pass would reduce the concepts axis's ambiguity. Flagged, not landed (concept merges are a scholar-discretion restructuring but this one spans a pre-existing duplication worth a deliberate decision).
