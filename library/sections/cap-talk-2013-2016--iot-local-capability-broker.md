---
title: "A house-local capability broker for interoperable IoT"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2016-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2016-January.txt.gz
source_content_sha256: 506e6bfcc7289a1e2ac255d90759690f5d061e8c2aa81ffc68a29d635e06882e
source_authors: [Alan Karp, Tony Arcieri, Kenton Varda, Jack Dennis, Tim Coote, Valerio Schiavoni, Ben Kloosterman, William Leslie, Matt Rice, Bill Frantz]
source_date: 2016-01-15 to 2016-01-19
thread_subject: "Access control for IoT"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, distributed-objects, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The IoT discussion identifies vendor cloud accounts as both an interoperability failure and an authority concentration: every device reports to and accepts commands from its manufacturer's service, so cross-vendor composition requires identity federation or handing the home to one provider. Varda's capability alternative is a house-local broker, imagined as a Sandstorm server speaking Cap'n Proto protocols, that holds narrow device facets and composes them locally. Coote adds that a “thing” should not be equated with one hardware identity and that data retention should be opt-in; Arcieri warns that constrained devices still need strong cryptographic protocols, while contemporary lightweight proposals were repeatedly broken.

The open deployment problem is not just access-control notation. It combines discovery and petnames, device provisioning, delegation to household members and services, local availability, revocation after resale, constrained cryptography, and privacy of aggregated telemetry. A local broker reduces cloud ambient authority but becomes a high-value durable authority root whose backup and recovery semantics must be designed explicitly.

Source: [cap-talk 2016-January archive](http://www.eros-os.org/pipermail/cap-talk/2016-January/) (Internet Archive original-bytes `id_` snapshot of `2016-January.txt.gz`, sha256 `506e6bfc`), thread "Access control for IoT", 2016-01-15 to 2016-01-19.
