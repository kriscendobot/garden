---
id: specification-authority-chain
aliases: [specification authority, specification-led development, spec-driven software, intent evidence boundary, authority evidence chain, generated source is disposable, independent acceptance, generation identity]
topics: [agentic-sdlc]
status: draft
---

# specification-authority-chain

In a specification-authority chain, human-reviewable specifications and pinned policy inputs authorize generation, while locks, generated source, test output, receipts, and packages are derived records that cannot silently rewrite that intent. Exact content identities let the harness decide what can be reused and what must be regenerated. Model-produced source remains a candidate until separately authorized build, generated-test, independent-acceptance, and admission boundaries succeed. The chain is therefore not simply “specification to code”: it is intent to exact plan to candidate to independently accepted artifact, with evidence flowing forward and review decisions flowing back into authority.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview and premise](../sections/literate-ai--readme--overview-and-premise.md) | The harness treats specifications and pinned authoring inputs as authority and generated source as disposable output. |
| [authority and evidence](../sections/literate-ai--readme--authority-and-evidence.md) | Changing an authority-bearing input changes generation identity; deleting cache changes cost, not meaning. |
| [Components, Flavors, and locks](../sections/literate-ai--docs-architecture-domain-model--components-flavors-and-locks.md) | Stable coordinates are separated from immutable content-bound revisions and exact target policy. |
| [bidirectional authoring](../sections/literate-ai--docs-architecture-domain-model--bidirectional-authoring.md) | Observed source behavior becomes a reviewable draft, never intent without explicit acceptance and qualification. |
| [workflow, acceptance, and receipts](../sections/literate-ai--docs-architecture-domain-model--workflow-acceptance-and-receipts.md) | Generated tests are not the independent oracle; admission depends on a separate acceptance boundary. |
| [intent and evidence formats](../sections/literate-ai--docs-architecture-authoring-and-record-formats--intent-and-evidence-boundary.md) | Markdown authority and canonical machine evidence are kept semantically distinct. |
| [skills and Flavors](../sections/literate-ai--docs-architecture-authoring-and-record-formats--skills-and-flavors.md) | Complete authored files are identity-bearing inputs, while resolver-owned digests remain derived. |
| [per-Component planning](../sections/literate-ai--docs-architecture-component-execution-plans--per-component-planning.md) | Generation keys bind every authority-bearing input before model egress. |
| [typed lifecycle](../sections/literate-ai--docs-architecture-component-execution-plans--lifecycle-and-build-boundary.md) | Model output is a candidate until typed build, test, acceptance, and admission checks succeed. |
| [design traceability](../sections/literate-ai--docs-architecture-design-traceability--authority-evidence-matrix.md) | The traceability matrix connects each concern to its authority, enforcement seam, and proofs. |
| [Component authority projection](../sections/literate-ai--docs-architecture-component-authority--append-only-authority-projection.md) | Implementation authority is an append-only projection; human acceptance stops at retained source until regenerative qualification. |
| [intent, lock, and evidence separation](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--intent-lock-evidence-separation.md) | Authored intent, the resolver's selected lock, its audit, and runtime evidence are separate identity-linked records. |
| [exact versioned identity triple](../sections/literate-ai--docs-architecture-exact-versioned-components--identity-triple.md) | Generation and linking require coordinate, SemVer, and content identity together. |
| [derivation engine versus agent ledger](../sections/literate-ai--docs-architecture-agent-ledger-boundary--ownership-split.md) | Ledger consent and learned experience never silently become generation authority or an execution grant. |
| [disposability premise and authority ladder](../sections/literate-ai--docs-architecture-framework-premise-assessment--fundamental-premise.md) | Prompt hashes prove the request, not reproducibility; fungibility must be earned through a four-step ladder, with shipped source retained as escrow. |
| [effective revision and Flavor spec fragments](../sections/literate-ai--docs-architecture-component-flavors--target-profile-and-effective-revision.md) | Target Flavors add to but never weaken base authority; the effective revision is a derived identity that generation, build authorization, and publication target. |
| [terminal document Components and the oracle](../sections/literate-ai--docs-architecture-documentation-artifacts--terminal-components-and-oracle.md) | Document artifacts follow the same chain: generation authority is a pinned skill, acceptance is an independent mutation-tested oracle, publication a separate authorization. |

## See also

- [content-address-versus-signature](content-address-versus-signature.md) — what content identity proves and what still requires an attributable assertion.
