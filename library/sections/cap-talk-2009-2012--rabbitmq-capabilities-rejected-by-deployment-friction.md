---
title: "RabbitMQ capabilities rejected by deployment friction, not mechanism complexity"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-October.txt.gz
source_content_sha256: 68456a3c01818f7a9058548bacac397ab922bcebceacde003f2bd129662a02f0
source_authors: [Zooko O'Whielacronx, David-Sarah Hopwood, Mark Miller, Ben Hood, Sandro Magi, Alan Karp]
source_date: 2009-10-07 to 2009-10-15
thread_subject: "caps tried and rejected for AMQP"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: RabbitMQ prototyped both ACL and capability access control and selected ACLs even though the capability-checking code was minimal and conversion to the production API was described as trivial. Ben Hood, who proposed the capability design, explains the real barriers: a protocol revision, changes across client libraries the broker team did not control, users and administrators asking specifically for ACLs, unfamiliar concepts, and unconvinced stakeholders. The capability design offered arbitrarily fine application-defined authority while ACLs forced broker developers to predict access categories in advance. The thread is a deployment lesson: technical locality is not enough when compatibility and operator vocabulary distribute migration cost across an ecosystem.

## Why ACLs won

AMQP had first mandated an ACL mechanism, which RabbitMQ implemented before other brokers declined to follow and the working group removed it. Administrators still wanted fine-grained control, so RabbitMQ began designing a proprietary broker-side ACL system. Hood prototyped capabilities in parallel.

The prototype's mechanism was not the obstacle. The costs sat at the edges: capability-aware messaging likely required a minor protocol revision and updates to every participating client library, only a few of which RabbitMQ maintained. Administrators understood ACLs and explicitly requested them. Introducing capabilities would require teaching a new model to users and persuading stakeholders who remained unconvinced.

The tradeoff was architectural. Broker ACLs make broker authors enumerate access-control categories in advance. Capabilities defer that policy to applications and permit narrower, composable grants. Miller asks whether technically trivial client changes were politically non-trivial, which captures the outcome more accurately than "capabilities were too hard."

## Why it remains open

The thread does not produce a migration pattern that preserves compatibility while obtaining the application-defined authority surface. Horton is offered as a way to layer familiar identity/accountability policy over capabilities, but it does not remove the need for protocol and client cooperation. Open question 47 records the ecosystem-adoption gap.

## Bearing on Endo

Endo protocols should make narrow references the compatibility primitive early. Adding them after an identifier-and-ACL ecosystem exists can make a small runtime change require coordinated revisions across every client. Where compatibility is fixed, adapters should translate at one explicit boundary and keep the internal protocol reference-based, rather than teaching every object to consult an ambient policy service.

Source: [cap-talk 2009-October archive](http://www.eros-os.org/pipermail/cap-talk/2009-October/) (Internet Archive original-bytes `id_` snapshot of `2009-October.txt.gz`, sha256 `68456a3c`), thread "caps tried and rejected for AMQP", 2009-10-07 to 2009-10-15.
