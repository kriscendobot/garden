---
title: "Unix file descriptors and a confused deputy in the namespace"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-April/
source_snapshot: http://web.archive.org/web/20160729222525id_/http://www.eros-os.org/pipermail/cap-talk/2002-April.txt.gz
source_content_sha256: 037e0c3f6770f79a92e9caf0a4fad2c3b8f2e7e27f53a1f2ba6149bc6524e740
source_authors: [Kragen Sitaker, Mark S. Miller, Jonathan S. Shapiro]
source_date: 2002-04-29
thread_subject: "interesting Unix confused-deputy problem"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A FreeBSD advisory supplies a subtle counterexample to the slogan that Unix file descriptors automatically impose capability discipline. A caller closes descriptor 2; a privileged program opens a protected file and the kernel reuses slot 2; the program's later diagnostic to `stderr` corrupts the protected file. Sitaker calls this a confused deputy despite the descriptor's designation-plus-authority shape. Miller and Shapiro locate the missing property in namespace control: `open()` chooses a name in the process's descriptor namespace, so code cannot lexically bind the returned authority independently of inherited slot conventions. KeyKOS/EROS c-list indices behave like lambda-calculus names; the namespace owner controls binding. Shapiro's general rule is that the owner of a namespace should control assignment of names within it.

## The bug

The privileged program correctly opens a file its caller cannot access and separately believes descriptor 2 names a caller-provided error stream. Because descriptor allocation implicitly chooses the lowest free number, those beliefs collide. The deputy is confused not about the file opened but about which authority an inherited ambient index designates.

## Why `fd` is not enough

File descriptors still combine target identity and access rights, so the thread does not deny their capability-like nature. It identifies a stricter object-capability / lambda-capability requirement: authority-bearing names must be explicitly bound, not silently assigned by a shared numeric convention. That distinction foreshadows *Capability Myths Demolished*'s separation of capability-as-key from the full object-capability model.

Source: [cap-talk 2002-April archive](http://www.eros-os.org/pipermail/cap-talk/2002-April/) (Internet Archive original-bytes snapshot `web/20160729222525id_/.../2002-April.txt.gz`, sha256 `037e0c3f`), messages dated 2002-04-29.
