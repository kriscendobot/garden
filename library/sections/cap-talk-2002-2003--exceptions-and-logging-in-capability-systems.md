---
title: "Exceptions and logging in capability systems"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-March/
source_snapshot: http://web.archive.org/web/20160730001520id_/http://www.eros-os.org/pipermail/cap-talk/2002-March.txt.gz
source_content_sha256: 5f07dc5aa961c927cd53ac66447d99492bb660c966fc9ca14ca79038e847c4dc
source_authors: [Constantine Plotnikov, Mark S. Miller]
source_date: 2002-03-03
thread_subject: "exceptions and logging"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. The substantive technical discussion was moved to the e-lang list and is not in this bundle."
---

Abstract: Constantine Plotnikov (author of the sebyla capability language) raises how to provide two ordinary statically-typed-language conveniences, exceptions and logging, without breaking capability security. His concern is that Java-style exception stack traces are very useful but let an object learn about its environment (who called it, through what chain), and could leak secrets in an uncontrolled way; a scheme that works in a strongly-typed setting may not work for E. Logging poses the parallel problem: design it so it is convenient to use yet does not compromise security. Miller redirects the substantive discussion to the e-lang list (where capability-language design is discussed), so this bundle records the problem framing rather than its resolution.

## The stack-trace leakage problem

A stack trace hands the code that catches an exception a description of the call chain that reached it. In a capability setting that is an authority/information leak: an object should learn only what it was explicitly told, but a trace reveals its callers and their callers, information the callers never chose to grant. Plotnikov notes an idea that seems to work in a strongly-typed environment but is unlikely to carry over to E, and points at his sebyla design notes on exceptions, logging, and member access for the detailed treatment. The general tension is between the developer-ergonomics value of rich diagnostics and the confinement requirement that an object not observe its environment.

## Where it went

Miller asked to move the discussion to e-lang rather than cross-post, on the grounds that sebyla and E share many of these language-design issues and that cap-talk subscribers interested in capability *language* design are generally on e-lang. The thread therefore leaves cap-talk as an open question; the substantive answers were pursued elsewhere. It stands here as an early statement that diagnostics and logging are a genuine capability-security design surface, not an afterthought.

Source: [cap-talk 2002-March archive](http://www.eros-os.org/pipermail/cap-talk/2002-March/) (Internet Archive original-bytes snapshot `web/20160730001520id_/.../2002-March.txt.gz`, sha256 `5f07dc5a`), messages dated 2002-03-03.
