---
title: Translation block (paper idiom → contemporary surface)
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "3-7 (§2.4 ACLs don't authorize correctly through §2.7 Avoiding Confused Deputy within a capability application)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat
---

| 2009 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| Delay-the-access-check structural failure | The *check-at-construction-time* discipline of `@endo/marshal` + `captp`: the capability is checked when the sender packages it, not when the receiver unpacks it. |
| RBAC / ABAC / IBAC / setuid / stack-introspection all fail | All ACL-variant mechanisms inherit the structural failure regardless of principal-identification mechanism. |
| Stack introspection's *single-authorization-chain-per-operation* limit | The capability model handles multi-argument authorization naturally: each argument carries its own permission. |
| Client authentication misleads access decisions | The fundamental wisdom of the *who-said-this-is-not-who-meant-it* distinction. The marshal package's slot-typing discipline encodes the principal-of-intent at construction time, not at receipt time. |
| §2.6 capability accountability via equality + Horton | The *delegation-trail-via-capability-identity* discipline. Contemporary Agoric Zoe's *invitation* primitive supports the same accountability shape. |
| §2.7 *crucial step* test — object identifier through deputy without access-matrix check | The diagnostic for *capability-application correctness*. Generalized version of the *passable-everywhere-but-not-string-keyed* discipline in `@endo/marshal`. |
| §2.7 file descriptors instead of filenames | The contemporary `@endo/pass-style` *Remotable* discipline: pass references not names. |
