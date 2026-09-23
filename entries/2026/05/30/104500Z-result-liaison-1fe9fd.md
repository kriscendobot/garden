---
date: 2026-05-30T10:45:00Z
from: liaison
role: liaison
host: endolin
library_action: ingest-external-papers
source_corpus: mark-miller-papers
status: current
ingested_via: orchestrator-direct-draft
---

# Cycle 82: Distributed Electronic Rights in JavaScript (Miller-Van Cutsem-Tulloh 2013) — seventh Miller-coauthored paper; the JavaScript bridge to contemporary @endo/Agoric

## Maintainer context

The cycle-79 decomposition campaign closure entry listed *Distributed Electronic Rights in JavaScript* as a post-Miller-2003-2005 paper candidate. The /loop continuing-librarian-work sequence put cycle 82 on the **papers lane** of the three-lane rotation; this paper was the most-directly-Endo-relevant of the candidates.

## Ingested

**Source**: `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013`. PDF SHA-256 `061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593`, 20 pages, ESOP 2013 Springer LNCS 7792. **Seventh Miller-coauthored paper in the library.**

**Sections written (3)**:

1. **`dr-ses-architecture-and-q-promises`** — §1-§2. The Dr. SES platform (SES + Q + NodeKen); SES library (def, confine, Nat, WeakMap); Q library with the `!` eventual-send operator and promise combinators (Q.race, Q.all, Q.join, Q.passByCopy); web-keys as unguessable HTTPS URLs for pass-by-reference encoding; NodeKen for distributed orthogonal persistence via Ken consistent snapshots + reliable messaging.

2. **`rights-as-property-and-money-as-right`** — §3-§4. The rights-as-property framing: ocap systems pursue a property-rights strategy; ACL systems implement a governance strategy — different responses to the tragedy of the commons. Four dimensions where money differs from references (Shareable/Exclusive, Specific/Fungible, Opaque/Measurable, Exercisable/Symbolic). The makeMint code in JavaScript: WeakMap as brand, `def` as harden, six security properties verifiable by visual inspection.

3. **`escrow-exchange-and-contract-host`** — §5-§7. The escrow exchange contract (all-or-nothing trade in 22 lines): Q.all + Q.race + failOnly composition; dishonest-purse defense via Q.join on `makePurse`. The generic Contract Host: setup-and-play tokens; what Alice and Bob must agree on (issuers + contract source + side assignment + mutually-trusted host); the architectural ancestor of Agoric Zoe.

Each section carries Translation block (paper idiom → contemporary @endo / Agoric surface), Implications-for-Endo block (with explicit citations to existing concept pages), See-also threading to existing concept pages, and Common-confusions blocks.

## The Miller cluster is now SEVEN papers spanning 25 years (1988-2013)

| Year | Paper | Sections |
|------|-------|----------|
| 1988 | Markets and Computation (Miller-Drexler) | 3 |
| 2000 | Capability-Based Financial Instruments (Miller-Morningstar-Frantz) | 3 |
| 2003 | Capability Myths Demolished (Miller-Yee-Shapiro) | 6 |
| 2003 | Paradigm Regained (Miller-Shapiro) | 4 |
| 2004 | Structure of Authority (Miller-Tulloh-Shapiro) | 3 |
| 2005 | Concurrency Among Strangers (Miller-Tribble-Shapiro) | 7 |
| **2013** | **Distributed Electronic Rights in JavaScript (Miller-Van Cutsem-Tulloh)** | **3 (this cycle)** |

**Total: 29 sections of foundational capability-theory across seven Miller-coauthored papers spanning 1988-2013**, plus the 2026 Maloyan-Namiot Sleeper Channels paper extending the lineage to the present. The 2013 paper is the **JavaScript bridge** between the E-language lineage (1988-2005) and the contemporary @endo / Agoric stack: Dr. SES → @endo/ses + lockdown; Q → @endo/eventual-send; Web-keys → formula identifiers + OCapN; NodeKen → @endo daemon formula-graph persistence; Contract Host → Agoric Zoe.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 127 | 128 | +1 |
| Sections | 548 | 551 | +3 |
| Topics | 27 | 27 | 0 |
| Concepts | 42 | 42 | 0 (extensions threaded into existing pages) |
| Roles | 3 | 3 | 0 |
| Keywords | ~1031 | ~1031 | 0 (writeback batched with next cycle) |

## Index updates done

- `library/sources/README.md` — added Distributed Electronic Rights row under "External papers" cluster.
- `library/sections/README.md` — added cycle-82 entry; total 548→551 sections, 127→128 sources.
- `library/topics/README.md` — `capability-security` 140→143; `eventual-send` 57→58; `captp` 46→47; `persistence` 32→33; `patterns` 49→51.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `62e826b16ee1509fcd8c24d8d630e6c8b1f970b4` to `6d7d0710c61d452fdbd87740c7200c9c2881c7e3`.

## Notes for next cycle

Per the three-lane rotation, **cycle 83 picks chat lane**. Remaining chat-cluster candidates (verify against bare clone): `chat-slot-slash-commands`, `chat-test-coverage`, `chat-playwright-smoke`, plus any new chat designs added since the last survey. `chat-reply-chain-visualization` is deprecated and should not be ingested (superseded by chat-focus-message).

Subsequent papers-lane candidates (cycle 85+):
- **Robust Composition** (Miller PhD thesis 2006, ~250 pages, multi-cycle chapter-by-chapter) — the deepest unmined Miller work and the most-cited single Miller publication.
- **Reasoning About Risk and Trust in an Open World** (Stiegler 2006) — trust-system formalism extending the positive-vs-negative-reputation concept page.
- **The Digital Path: Smart Contracts and the Third World** (Stiegler + Miller 2002) — domain application.

## Self-improvement

- The 2013 paper is the most-Endo-relevant of the post-2005 Miller corpus; the architectural-ancestor links to contemporary Hardened JavaScript + @endo + Agoric are direct. The library now has the complete arc from 1988 vision through 2013 JavaScript bridge to contemporary production.
- The post-decomposition discipline (lean on existing concept pages instead of repeating material in section See-also blocks) worked well. Each section's See-also block cited ≥5 concept pages from the decomposition campaign; the cross-references make the library navigable without repetition.
- The Agoric mirror remains 100% reliable for Miller-cluster papers: seven fetches now, seven successes with stable PDF SHA-256 anchors.
