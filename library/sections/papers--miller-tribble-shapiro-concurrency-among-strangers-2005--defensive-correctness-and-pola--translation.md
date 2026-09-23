---
title: Translation
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola
---

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| reliance set | TCB (in Endo's daemon-design vocabulary); the paper's "rely" framing avoids the loaded "trust" term |
| defensive correctness | full incorruptibility under arbitrary client behavior; rarely achievable in Endo's distributed model either |
| defensive consistency | "incorruptible service to well-behaved clients" — the realistic Endo target |
| relevant authority | the bound on effects one party can cause given the reliance set |
| `def statusGetter { ... } def statusSetter { ... } return [statusGetter, statusSetter]` | `defineExoClassKit({ statusGetter: {...}, statusSetter: {...} })` in Endo (an exo class kit defines multiple facets sharing state) |
| POLA | same in Endo: Principle of Least Authority. Distinct from POLP (Least Privilege) by emphasis on *authority* (effects) over *privilege* (access). |
| Pluribus | Endo / Agoric's network protocol surface uses [[captp]] historically and the OCapN-family protocol going forward. The paper's Pluribus is the E-era predecessor of both. |
| swiss number | Endo's *formula identifier* serves the same role: an unguessable large number that designates a specific capability and grants access to it. |

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 207-211 (§7 Protection from Misbehavior, §7.1 Defensive Correctness, §7.2 POLA, §7.3 A Taste of E Across a Network); SHA-256 `4ff0c5bd07e1`.
