---
title: "Naming versus pointing and global names"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-September/
source_snapshot: http://web.archive.org/web/20160730010609id_/http://www.eros-os.org/pipermail/cap-talk/2003-September.txt.gz
source_content_sha256: 5fb31ec62affbe3433b9434885bee48621e4c91a8457cc32b739c14592165e02
source_authors: [Hal Finney, Mark S. Miller, David Wagner, Tyler Close, Norman Hardy, Ben Laurie]
source_date: 2003-09-01 to 2003-09-24
thread_subject: "Names and introductions; Do global names exist?; Naming vs. Pointing"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-theory, decentralized-identifiers]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The naming-versus-pointing threads separate three operations that ordinary web infrastructure blends together: introducing a particular entity, describing properties of that entity, and assigning a human-usable name. Pointing fixes which entity an introducer means without claiming a globally correct name. Names remain contextual and useful, but global naming authorities are costly because they must arbitrate socially contested mappings. The debate's practical conclusion is layered: use cryptographic pointers for machine references, then attach local pet names, descriptions, and reputations without mistaking any of them for the reference itself.

## An introduction precedes a name lookup

To ask a certificate authority for Carol's key, Bob must already have learned some designation for Carol. The first communication that made Carol relevant is therefore an introduction, even if it arrived through a web page, advertisement, conversation, or search result. A key passed in that introduction preserves which Carol was meant. A later global-name lookup adds another principal capable of changing the referent.

## Pointing solves a narrower problem

Tyler Close compares a YURL to pointing at a person at a dinner party. It prevents confusing two textual names because the reference is self-authenticating and not centrally allocated. It does not eliminate the human need to say "Microsoft," judge similar brands, or aggregate descriptive evidence. Those tasks can use pet names and keywords on top of the pointer.

## Global names are social institutions

Miller distinguishes descriptive naming from normative registries. Dictionaries, DNS, trademark systems, and certificate authorities do not discover an objective mapping; they summarize and influence social practice. Their legitimacy can be valuable, but it is different from the deductive claim that a cryptographic reference reaches the key intended by its introducer. The thread's recurring disagreement comes from comparing those different propositions under the single word "identity."

Source: [cap-talk 2003-September archive](http://www.eros-os.org/pipermail/cap-talk/2003-September/) (Internet Archive original-bytes snapshot `web/20160730010609id_/.../2003-September.txt.gz`, sha256 `5fb31ec6`), messages dated 2003-09-01 to 2003-09-24.
