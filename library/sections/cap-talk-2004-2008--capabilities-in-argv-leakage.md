---
title: "Command-line arguments leak bearer capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-July/
source_snapshot: https://web.archive.org/web/20160730003425id_/http://www.eros-os.org/pipermail/cap-talk/2008-July.txt.gz
source_content_sha256: 8951e6620a5f940b5df1e678f9cc1d8607a32aaceae8eb6afe9f72d3b01fc942
source_authors: [Kevin Reid, Zooko Wilcox-O'Hearn, David Wagner, Rob Meijer, Raoul Duke, Dean Tribble, Jonathan S. Shapiro, Darius Bacon, Jasvir Nagra, Toby Murray, Mark Seaborn, David Hopwood]
source_date: 2008-07-12 to 2008-07-23
thread_subject: "Don't put capabilities in argv?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, tooling]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Unix command-line arguments are commonly visible through process listings and `/proc`, so an unguessable URL or other bearer capability passed in `argv` leaks to unrelated local processes. The Tahoe discussion turns a convenience concern into a security rule: pass a protected alias or file descriptor, not the secret itself.

Suggested mitigations include overwriting `argv` and the environment, restricting `/proc`, reading a capability from a permissioned file, or passing a local alias resolved by a trusted process. Overwriting leaves an observation window; global `/proc` hardening is platform-specific. Tahoe's alias mechanism therefore becomes the safe default rather than merely a usability feature.

The broader Endo lesson is that serialization channels inherit ambient readers. CLI adapters should keep bearer references out of arguments, environment variables, logs, shell history, and diagnostics, and exchange them through a capability-aware local channel.

Source: [cap-talk 2008-July archive](http://www.eros-os.org/pipermail/cap-talk/2008-July/) (Internet Archive original-bytes snapshot `web/20160730003425id_/.../2008-July.txt.gz`, sha256 `8951e662`), messages dated 2008-07-12 to 2008-07-23.
