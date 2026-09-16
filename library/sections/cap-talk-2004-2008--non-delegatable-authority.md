---
title: "Non-delegatable authority still permits proxying"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-December/
source_snapshot: https://web.archive.org/web/20160729225002id_/http://www.eros-os.org/pipermail/cap-talk/2007-December.txt.gz
source_content_sha256: a9acaaf16fcdb2df322bea252e8643dd37bac1f1ccb15d0d4e4d03ff09f5c1df
source_authors: [Toby Murray, Mark S. Miller, Kevin Reid, Jed Donnelley, Alan H. Karp, Jonathan S. Shapiro]
source_date: 2007-12-06 to 2007-12-22
thread_subject: "Non-Delegatable Authorities in Capability Systems"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Murray and Grove show that an unconfined holder can be prevented from handing another party the exact same authority object, even though it can still exercise that authority as a proxy. The construction challenges the claim that capability systems cannot express any non-delegation, but the list disputes its practical value and compositional cost.

The accepted paper uses membranes and control over returns to make an authority non-transferable in the narrow reference-passing sense. Reviewers probe distributed operation, one-shot returns, language assumptions, and whether E needs a restricted subset. Murray concedes the motivating scenario is contrived and frames the result chiefly as an expressiveness result.

The debate preserves the permission/authority distinction: blocking reference transfer constrains direct permission but not effective authority through proxying. It may also prevent a component from refactoring work into a helper, forcing permanent mediation. Endo should treat non-transferability as a protocol-specific wrapper property, not a general guarantee that influence cannot be delegated.

Source: [cap-talk 2007-December archive](http://www.eros-os.org/pipermail/cap-talk/2007-December/) (Internet Archive original-bytes snapshot `web/20160729225002id_/.../2007-December.txt.gz`, sha256 `a9acaaf1`), messages dated 2007-12-06 to 2007-12-22.
