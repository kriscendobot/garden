---
title: "File API taming: name-free file/directory objects and the sibling-link problem (Tahoe)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-March.txt.gz
source_content_sha256: 1fc3830753ef60b463368e43af520bebbeb2040e1e905c1d4f4ac9c0110803d9
source_authors: [Zooko O'Whielacronx, Mark Miller, David-Sarah Hopwood, Kevin Reid, Nathan Wilcox]
source_date: 2009-03-19 to 2009-03-27
thread_subject: "[e-lang] File API taming"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity]
status: current
notes: "Derived summary, not the original messages. Cross-posted from e-lang."
---

Abstract: Zooko brings a concrete taming problem from Tahoe-LAFS (a capability-based distributed filesystem) to cap-talk. Tahoe's file API, like Ihab Awad's original proposal, makes first-class file and directory objects that *do not know their own names*: a file can be called different things by different directories, and a name is a per-directory binding rather than a property of the object. In a distributed system with no trusted server, there hardly seems to be any alternative — nobody is authoritative about "the" name of a capability-designated file. Tahoe also lets a user keep a list of names joined by "/" and dereference them in turn from a starting directory, and it hardly seems possible to forbid that either. The trouble is that real client code (a JavaScript library, a wiki that rewrites itself) routinely *assumes* an object knows where it lives — it wants to write a sibling file, follow a relative hyperlink, or save a backup next to itself — and a name-free capability cannot answer "what is next to me?" Zooko's practical fix is instructive: give the code not a bare self-reference but a **tuple of (a reference to the containing directory, the name of the object within that directory)**, restoring exactly enough naming context to compute siblings without reintroducing an ambient, forgeable global namespace. The thread is a real-world encounter with the naming-versus-designation distinction the archive has argued since the founding era.

## Name-free objects, by necessity

"Tahoe implements a file API rather like Ihab Awad's original proposal: the first-class file and directory objects don't know what they are called, and they can be called different different things by different directories. In the context of a distributed system with no trusted server, there hardly seems to be any alternative." Naming is a relation held by a *directory* (a capability), not an attribute of the *file* (also a capability). Tahoe additionally lets users keep and dereference "/"-joined name lists from a starting directory, which is likewise hard to prevent.

## The sibling-link problem

Real code breaks on the absence of self-naming. Nathan Wilcox wrote a JavaScript library and HTML docs whose relative hyperlinks pointed at sibling HTML files, and discovered "just before publicly announcing his project — that you can't follow those hyperlinks", because a name-free object has no notion of "the directory I am in". Zooko hit the same wall with a TiddlyWiki-on-Tahoe project: TiddlyWiki wants to write itself back to its original location (easy: it holds that reference), but also to write an RSS feed into the current directory under the same base name with a `.xml` extension, and to save numbered backups (`$FNAME.old-1`, `.old-2`) alongside itself. A bare self-reference cannot express "a file named like me but with a different extension, in my directory."

## The fix: carry the (directory, name) tuple

"After a few minutes of thinking about this I changed it from having a reference to its own original source file, to having a tuple of 1. a reference to a directory, and 2. the name of its original source within that directory. Then the RSS feed started working." The tuple restores the minimal naming context — a capability to the container plus the leaf name — that lets the code compute siblings and variants, while keeping the container reference an unforgeable capability rather than an ambient path into a global namespace. It is the capability-respecting way to give an object "a place", without giving it (or anyone) authority over a whole tree by name.

## Bearing on Endo

Endo's petname model and its formula/locator naming face the same design point: a reference designates an object, but human- or code-facing *names* are per-context bindings, not intrinsic to the object. Zooko's tuple is a concrete pattern for when code needs relative naming ("the thing next to me"): pass a container capability plus a leaf name rather than a bare object reference or an ambient path. It connects to the petname-identity questions in [`petnames-versus-e-order`](cap-talk-2009-2012--petnames-versus-e-order.md) and to the founding-era naming-versus-pointing discussions.

Source: [cap-talk 2009-March archive](http://www.eros-os.org/pipermail/cap-talk/2009-March/) (Internet Archive original-bytes `id_` snapshot of `2009-March.txt.gz`, sha256 `1fc38307`), thread "[e-lang] File API taming" (cross-posted to cap-talk), 2009-03-19 to 2009-03-27.
