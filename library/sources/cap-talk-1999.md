---
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/
source_months: [1999-January, 1999-April, 1999-June, 1999-July, 1999-August, 1999-September, 1999-October, 1999-November, 1999-December]
source_authors: [Jonathan S. Shapiro, Norman Hardy, Charles Landau, Mark S. Miller, Alan Cox, Ben Laurie, Dave Long, Bill Frantz, Eyal Lotem, R. J. Shaw, Gavin Thomas Nicol, Paul Snively, Al Gilman]
source_date: 1999
retrieved: 2026-09-16
ingested: 2026-09-16
ingested_by: scholar
section_count: 11
status: current
notes: |
  Year-level index over nine independently hashed Pipermail `.txt.gz`
  bundles. The canonical host is offline; every bundle was fetched through
  the Internet Archive `id_` original-bytes route. Each section carries the
  exact hash for the month from which it derives. Multi-author attribution
  is per thread. These files are derived summaries, not the original posts.
---

Abstract: The 1999 cap-talk archive moves from the founding definitions into engineering consequences: persistent capability graphs and transactions, the cost of tracking shared-object lifetime, whether a principal can be attributed through proxies, confinement as a program-channel property rather than a human-identity guarantee, unforgeability by partitioning or tagging, the trusted authority of DMA drivers, rights amplification from equality and seals, and distributed capabilities as the security discipline missing from ordinary RPC. The year also preserves live disagreements: whether principal-based policies become enforceable inside pre-existing compartments, whether reclaimed storage may safely reveal last-reference events, and how much identity a destroyed or disconnected reference should retain.

## Monthly bundle anchors

The archive index contains no February, March, or May 1999 bundle. December contains only Shapiro's pointer to a forthcoming architectural-retrospective series on `eros-arch`; it is surveyed and anchored here but does not justify a separate content section.

| Month | Original-bytes snapshot | SHA-256 | Survey |
|---|---|---|---|
| 1999-January | `web/2id_/.../1999-January.txt.gz` | `dcec08bb49ef757ef1e9dfa76e04d8af2cc6a88dd5b54f610569da091dc6d38a` | Shared-object lifetime puzzle. |
| 1999-April | `web/2id_/.../1999-April.txt.gz` | `9303164e97395ed5fbf794f7ffaef257609bbb0d72c28e12e29457ac8ed375b6` | Grant matching and comparison authority. |
| 1999-June | `web/2id_/.../1999-June.txt.gz` | `751f38ec0ce03d66083cf9bc3fae6ca07f1c2b32b1b0e94a817feb2f5dbca6ab` | Linux cross-list scrutiny of EROS persistence and OS architecture. |
| 1999-July | `web/2id_/.../1999-July.txt.gz` | `3262da95439fd9dab4a1736482fa651abb9f59818a159ea2bb168092e6137a45` | Principal attribution, confinement, persistent GC, and unforgeability. |
| 1999-August | `web/2id_/.../1999-August.txt.gz` | `7800fc19e7a8155ce7ca63144a72b3319d767cc0c276f406dddd73d5323d4c3d` | DMA driver trust and rights amplification from seals. |
| 1999-September | `web/2id_/.../1999-September.txt.gz` | `010be5fcf0f6dcd963ef7fee29915302180537f19436473e896cb2f8ee14ca22` | Persistence versus transaction correctness. |
| 1999-October | `web/2id_/.../1999-October.txt.gz` | `476c44f473c633a47e37e9ace68a41ee7c29b8a7317f2f8979b150af6fd38cb8` | RPC, distributed capabilities, behavior facets, and closures. |
| 1999-November | `web/2id_/.../1999-November.txt.gz` | `e8ae4d7b298314e98a9030b008c37daeb846a9cb0f457751c6a889fd5fa298aa` | Capability-versus-ACL policy debate. |
| 1999-December | `web/2id_/.../1999-December.txt.gz` | `bfa3aa176c8ef383c7b0596c2895494bf020f51f9f1a73c13542a43cd93749e7` | Pointer to planned EROS architectural retrospectives on another list. |

## Sections

| Section | Topics | Status |
|---|---|---|
| [shared-object-lifetime-reference-counting](../sections/cap-talk-1999--shared-object-lifetime-reference-counting.md) | capability-security, persistence, cap-talk-open-questions | current |
| [grant-matching-and-object-sameness](../sections/cap-talk-1999--grant-matching-and-object-sameness.md) | capability-theory, capability-security | current |
| [single-level-store-checkpointing-tradeoffs](../sections/cap-talk-1999--single-level-store-checkpointing-tradeoffs.md) | persistence, capability-security | current |
| [principal-attribution-proxies-and-confinement](../sections/cap-talk-1999--principal-attribution-proxies-and-confinement.md) | capability-theory, capability-security, cap-talk-open-questions | current |
| [storage-gc-and-covert-channels](../sections/cap-talk-1999--storage-gc-and-covert-channels.md) | persistence, capability-security, cap-talk-open-questions | current |
| [four-unforgeability-techniques](../sections/cap-talk-1999--four-unforgeability-techniques.md) | capability-theory, capability-security | current |
| [driver-trust-dma-and-least-authority](../sections/cap-talk-1999--driver-trust-dma-and-least-authority.md) | capability-security, cap-talk-open-questions | current |
| [rights-amplification-from-seals-and-equality](../sections/cap-talk-1999--rights-amplification-from-seals-and-equality.md) | capability-theory, capability-security | current |
| [persistence-and-transaction-failure](../sections/cap-talk-1999--persistence-and-transaction-failure.md) | persistence, capability-security | current |
| [distributed-capabilities-rpc-and-closures](../sections/cap-talk-1999--distributed-capabilities-rpc-and-closures.md) | capability-theory, capability-security, captp, eventual-send | current |
| [principal-policy-and-confinement-debate](../sections/cap-talk-1999--principal-policy-and-confinement-debate.md) | capability-theory, capability-security, cap-talk-open-questions | current |

## Archive boundary

The usable Pipermail archive continues through January 2016. The current home at [Google Groups](https://groups.google.com/g/cap-talk) is a JavaScript single-page application whose message bodies are not fetchable from this sandbox. Post-2016 ingestion therefore remains blocked on a stable export or alternate archive.
