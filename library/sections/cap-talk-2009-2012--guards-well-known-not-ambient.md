---
title: "Guards are well-known, not ambient: data validation versus authority validation"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-October.txt.gz
source_content_sha256: 68456a3c01818f7a9058548bacac397ab922bcebceacde003f2bd129662a02f0
source_authors: [Grant Husbands, Kevin Reid, Rob Meijer]
source_date: 2009-10-07 to 2009-10-29
thread_subject: "Are Guards Ambient Authorities?"
ingested: 2026-09-16
ingested_by: scholar
topics: [e-language, capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Grant Husbands asks whether E's ubiquitous guards undermine capability discipline by becoming ambient authorities and by rejecting duck-typed substitutes. Kevin Reid separates *well-known* from *ambient*: a guard is explicitly designated by its lexical name and can in principle be replaced by evaluating code in a different environment. Data-structure guards such as integers can safely be well-known because they recognize a canonical value protocol. Guards that recognize external authority, such as "real OS file," should instead be supplied through a privileged environment so code must be parameterized by the authority definition. This is the direct conceptual split behind Endo's freely available pass-style/pattern guards versus explicitly endowed host powers.

## Designation removes the ambience

Husbands initially used "ambient" to mean available to all code. Reid corrects this against the June definition: a well-known binding is still designated when code names it, and a host can evaluate the code in an environment where that binding is absent or replaced. Availability by default is not the same as automatic selection of authority.

The harder question is whether the guard itself conveys authority. An integer guard can coerce or reject values without reaching external mutable state. There is ordinarily no useful counterfeit integer protocol that should pass as a standard integer. A file guard is different: code often should accept a virtual, wrapped, remote, or attenuated file-like object. A guard that accepts only host filesystem objects both blocks useful substitution and embeds a privileged definition of "real file."

Reid's rule is therefore semantic, not nominal: guards for pure data structures may be well-known; guards that recognize external authority, and perhaps mutable authority-bearing objects more generally, belong in the privileged environment and must be passed explicitly.

## Bearing on Endo

Endo's `@endo/patterns` can safely expose well-known guards for passable data because those guards validate representation, not entitlement to a host resource. An interface guard for a file, socket, signer, or service facet must not become a global registry lookup that upgrades an arbitrary value into host authority. The authority-bearing reference and any brand that amplifies it should arrive as explicit endowments. This preserves mockability and attenuation while still validating the shape of messages at exo boundaries.

Source: [cap-talk 2009-October archive](http://www.eros-os.org/pipermail/cap-talk/2009-October/) (Internet Archive original-bytes `id_` snapshot of `2009-October.txt.gz`, sha256 `68456a3c`), thread "Are Guards Ambient Authorities?", 2009-10-07 to 2009-10-29.
