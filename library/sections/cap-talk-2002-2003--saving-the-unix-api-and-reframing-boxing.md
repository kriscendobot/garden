---
title: "Saving the Unix API, and Reframing Boxing"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-February/
source_snapshot: http://web.archive.org/web/20160730014719id_/http://www.eros-os.org/pipermail/cap-talk/2002-February.txt.gz
source_content_sha256: aec16198892bf9cc85916e2c7fa81e609bb807b797c312755b7509ca7c809a85
source_authors: [Eric S. Raymond, Jonathan S. Shapiro, Mark S. Miller, Alan Cox, Bill Frantz, Tyler Close]
source_date: 2002-02-10
thread_subject: "Saving the Unix API / Reframing Boxing"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages. The dominant thread of the month."
---

Abstract: The longest thread of 2002-February asks whether the Unix/POSIX API can be preserved on a capability operating system. Eric Raymond proposes per-process namespaces filtered in a capability-clean way; Miller finds a show-stopper (a parent-created private namespace is visible to the parent), and Shapiro locates a deeper flaw: the entire Unix designation model is incompatible. Shapiro enumerates the POSIX features that cannot survive (command-line strings instead of capability arguments, `fork`/`exec`, `setuid`/`setgid`, the principal-id notion and `chown`/`chgrp`/`chmod`, plus the absence of persistence that safe encapsulation requires). Miller then reframes the goal as bug-for-bug emulation taken to its extreme ("Reframing Boxing"): each legacy program launch runs in its own disposable minimal Unix box, created per launch and discarded when its processes exit, with the outside EROS world mapped in through a synthesized per-launch file system, so the Unix API and legacy binaries need no change.

## The show-stopper for a filtered namespace

Raymond, Shapiro, and Miller had explored using per-process namespaces (as in Plan 9, and available in Linux 2.5) to filter each spawned process's view of the file store capability-cleanly. Miller's objection: in that design the child's private namespace is created by the parent and therefore known to (visible to) the parent, defeating encapsulation. Raymond's proposed repair is a dedicated namespace manager that receives encapsulated capabilities from the parent, can pass them to the child but cannot itself use them, and constructs the child's capability set. Shapiro rejects this as too much overhead on the time-critical spawn path, and says Miller's flaw is deeper than the visibility problem: "the entire designation model is screwed."

## Why the Unix API cannot be rescued wholesale (Shapiro)

Shapiro reframes "saving Unix" as "does GCC, Emacs, a SQL engine, and a web server run", not "does the POSIX API survive verbatim", and walks the conversion cost of nativizing each program to EROS:

- **Command line.** EROS programs receive capabilities as arguments, not strings; the relevant code is usually well localized.
- **`fork`.** Does not survive, but nearly every `fork` is followed by `exec`, so a "create process" interface substitutes cleanly. The real friction is "pass args by descriptor, not by name" at `exec`.
- **`setuid`/`setgid`.** Must go; most target programs do not need it, and the few that do get better isolation from restructuring.
- **Principal.** `chgrp`/`chown` go; `chmod` has reduced function. Principal ids are "unrescuable" because they are a de-facto universal namespace.
- **Persistence.** Unix's lack of persistence means it cannot encapsulate and mediate authority. Shapiro calls this "really big."

His conclusion: the intermediate approaches are "messes of mixed semantics"; the only clean choices are full rewrite or true bug-for-bug emulation.

## Reframing Boxing (Miller)

Miller argues everyone has underestimated bug-for-bug emulation by not taking it to the extreme. Rather than one large, long-lived virtual Unix box holding many installed programs and files, each legacy program launch is contained in its own separate Unix box, created per launch and thrown away when all processes of that launch terminate. Bill Frantz and Alan Cox's observation that multiple isolated Unix instances are very cheap makes this plausible. Each legacy program is installed wrapped in a "Unix box maker"; at launch the wrapper synthesizes a file system on the fly, maps the EROS capabilities the program was given into the file names that program expects, and invokes the program inside the fresh box. Miller's worked example: invoking a rehosted `vim` from an E command line with a capability to an editable file, where the wrapper mounts that file as `file-to-be-edited.txt` in a per-launch synthesized file system. This has the flavor of the Plan 9-inspired plans but requires no change to the Unix API or to legacy programs. Miller flags one hazard raised against Mark Seaborn's rival capability-tagged-bytes scheme: accumulating unions of capabilities and selecting whichever will do reintroduces ambient-authority problems like the confused deputy.

Source: [cap-talk 2002-February archive](http://www.eros-os.org/pipermail/cap-talk/2002-February/) (Internet Archive original-bytes snapshot `web/20160730014719id_/.../2002-February.txt.gz`, sha256 `aec16198`), messages dated 2002-02-10 to 2002-02-15.
