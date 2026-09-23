---
title: "Authority versus information flow"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-February/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2008-February.txt.gz
source_content_sha256: 6311a1d96d5fd5efa6d7e5ab1fd2fdf1d5372b3a5b260450839bf424ca74d3ce
source_authors: [Toby Murray, Charles Landau, Alan H. Karp, Jack Lloyd, David Wagner]
source_date: 2008-02-13 to 2008-02-18
thread_subject: "Authority vs. Information Flow"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Toby Murray asks whether Alice having authority over Bob necessarily implies an information flow from Alice to Bob. Simple examples suggest yes: Alice can press a button that changes Bob's observable light. More indirect examples strain the equivalence when an intermediary deterministically transforms, suppresses, or triggers behavior and when the observer knows the intermediary's behavior but cannot identify a transmitted message.

The discussion distinguishes causal influence, possible communication, actual information transfer, and object-capability authority. These relations overlap but are not interchangeable. A capability can establish a potential causal path even when no useful bit is transmitted during a particular execution. Conversely, shared resources and covert channels can carry information without a designated application-level capability edge.

David Wagner concedes that one small example defeats his preferred causal account, leaving the thread intentionally unresolved. For authority-analysis tools, the lesson is to name the relation being computed. A reachability graph, a noninterference proof, and a trace-level causal analysis answer different questions.

Source: [cap-talk 2008-February archive](http://www.eros-os.org/pipermail/cap-talk/2008-February/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2008-February.txt.gz`, sha256 `6311a1d9`), messages dated 2008-02-13 to 2008-02-18.
