---
title: Derivation engine versus agent ledger ownership
source: docs/architecture/agent-ledger-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
---

> Abstract: Literate AI is a derivation engine and an agent ledger such as MAC is a control plane; they meet at one content-addressed run boundary where the ledger owns request, consent, conversation, and learning history while Literate AI owns specs, derivation records, evidence, and the typed execution grant.

Literate AI is a derivation engine; an agent ledger such as MAC is a control plane. They meet at one content-addressed run boundary and neither subsumes the other. The ledger sends a derivation request; Literate AI returns a run envelope plus artifact identities.

| Question | Owning system |
| --- | --- |
| What behavior and target were requested? | Literate AI specs and selected Flavors |
| Which exact skill, workflow, model route, and tool produced this candidate? | Literate AI derivation records |
| Did the candidate build, run, and satisfy current tests? | Literate AI evidence and acceptance records |
| Who requested, organizationally consented to, retried, or stopped the work? | Agent ledger |
| Which exact operation and resources were granted execution privilege? | Literate AI typed authorization evidence |
| Which conversation, task, lease, or customer iteration led to the request? | Agent ledger |
| Which retained experience should be proposed for future work? | Agent ledger |
| When does learned experience become generation authority? | Only after review and pinning as a Literate AI spec, Flavor, skill, workflow, or routing-policy revision |

The ledger may schedule a derivation and retain its organizational history, but customer or organizational consent is not the execution grant for a build, test, or publication step; Literate AI owns that exact typed privilege binding. Literate AI must remain usable without the ledger, and a ledger must not silently mutate a generation prompt, Flavor set, route, or authorization.

Source: [docs/architecture/agent-ledger-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/agent-ledger-boundary.md) at commit `fcc40bc`.
