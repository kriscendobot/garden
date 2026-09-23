---
title: "Rights amplification from seals and equality"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-August/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-August.txt.gz
source_content_sha256: 7800fc19e7a8155ce7ca63144a72b3319d767cc0c276f406dddd73d5323d4c3d
source_authors: [Jonathan S. Shapiro, Norman Hardy]
source_date: 1999-08-15
thread_subject: "trusty scheme reinvented? / On the other hand"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Shapiro and Hardy connect Jonathan Rees's secure Scheme work to Trusty Scheme and to the capability pattern later standardized as sealer/unsealer pairs and brands. Hardy argues that general rights amplification can be built from pointer equality; Shapiro suggests a primitive `SEAL` keyed by a unique object pointer and a matching `UNSEAL`. The primitive operation must be trusted, but the sealing tool itself need not be restricted: safety comes from possession of the matching identity, not from hiding access to the generic constructor.

## Authority appears only when references meet

One holder can seal a value and another holder can unseal values of the matching brand. Neither reference alone exposes the content or forges a match. Equality supplies the unforgeable identity test, while closures or sibling facets distribute the complementary powers.

## Benevolent maker versus privileged instance

The discussion distinguishes a generally available maker from the private pair it creates. Letting anyone invoke the maker does not grant access to anyone else's brand, just as letting anyone allocate an object does not grant references to existing objects. This is the key Endo connection: `makeBrand` or a sealer/unsealer constructor can be ambiently callable while every resulting brand remains capability-scoped.

Source: [cap-talk 1999-August archive](http://www.eros-os.org/pipermail/cap-talk/1999-August/) (Internet Archive original-bytes snapshot, sha256 `7800fc19`), messages by Jonathan S. Shapiro and Norman Hardy, 1999-08-15 to 1999-08-23.
