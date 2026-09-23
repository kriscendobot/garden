---
title: "Waterken ref_send and the eventual-reference API"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-April/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2007-April.txt.gz
source_content_sha256: 08a508401e7286c0194d43cee707cbff7e6730d49d7b23efd5a5891468cf41ba
source_authors: [David Wagner, Dean Tribble, Marc Stiegler, Tyler Close, Sandro Magi, Bill Frantz, Jonathan S. Shapiro, Kevin Reid]
source_date: 2007-04-02 to 2007-04-10
thread_subject: "Last Call for ref_send API 1.0"
ingested: 2026-09-16
ingested_by: scholar
topics: [eventual-send, patterns]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Waterken's `ref_send` API packages eventual reference operations for Java: send a message without blocking on a remote round trip, receive a promise for the result, and register continuation behavior for fulfillment or failure. The review focuses on naming, ordering, failure propagation, and how much of the distributed-reference machinery should be visible to ordinary Java callers.

The capability significance is compositional. The returned promise is itself a reference that can be passed and pipelined; a caller should not need ambient network authority or a global object identifier to continue a conversation. Failure is part of the reference protocol rather than an out-of-band transport exception.

The API is a direct historical neighbor of Endo's eventual-send surface. [*Concurrency Among Strangers*](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining--body.md) supplies the language-level rationale; this thread shows the same model being stabilized for a conventional Java library.

Source: [cap-talk 2007-April archive](http://www.eros-os.org/pipermail/cap-talk/2007-April/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2007-April.txt.gz`, sha256 `08a50840`), messages dated 2007-04-02 to 2007-04-10.
