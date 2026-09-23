---
created: 2026-09-23
updated: 2026-09-23
author: gardener
---

# Design: TypeSafe Jev for classification work

| Field | Value |
| --- | --- |
| Status | **Draft; carries open questions.** Landed on `main2` and presented as a PR answer-surface per the garden's-own-repo open-questions carve-out ([`roles/designer/AGENT.md`](../roles/designer/AGENT.md) section "Operating norms"). Not a pending merge. |
| Directive | kriskowal, 2026-09-23: is TypeSafe AI's Jev a fit for classification-shaped work such as triage and muster? |
| Decision | Jev is a non-agentic structured-decision classifier, not a generative LLM. Do not onboard it as a worker kind or tier-inventory row. Consider it as a bounded classification primitive at a specific decision point. Muster remains an interactive liaison session with human disposition. |
| Related design | [Opus 5.5 tier placement](opus55-tier.md) |

## Evidence

TypeSafe AI's Jev (`jev-1.13`) is a non-autoregressive structured-decision model. It accepts state plus typed questions and returns bounded typed answers with probabilities or confidence scores, rather than prose. Vendor material lists $0.042 per million input tokens and no output-token charge, with roughly 100 ms latency. It is available through TypeSafe's API and as `typesafe/jev-1.13` through OpenRouter. Live pricing, access, and retention terms must be checked before a build.

## A primitive, not a worker kind

The existing worker kinds run an agentic CLI harness to claim and complete jobs. A model in `model-tier-inventory.tsv` can drive that loop at a capability tier. Jev emits no prose, tool calls, code, or agent loop. It therefore cannot claim a job, occupy a tier, or compete as a `(role, model)` reputation arm.

Treat Jev as a classification primitive called by deterministic garden code. Its bounded answer set reduces prompt-injection leverage because input cannot make it emit arbitrary prose or tool calls. A hostile input can still cause a wrong choice within the answer set. This does not solve data egress: sending inbox or PR-comment text to an external service still requires policy review and maintainer authorization.

## Candidate decision points

In order of fit:

- **Muster pre-classification.** Tag unread inbox items with a recurring class, confidence, and likely-dead flag. Feed those annotations to the interactive muster; do not dispose of items.
- **Triager residual classification.** Keep the fixed verb-to-job table authoritative. For comments with no deterministic match, return a typed job kind and confidence. Low confidence preserves the current no-match path.
- **Panel-kind or web-frontend classification.** These are typed decisions, but deterministic sensors already cover them, so the marginal value is smaller.

## Muster boundary

[CLAUDE.md](../CLAUDE.md) and [`roles/liaison/AGENT.md`](../roles/liaison/AGENT.md) define muster as a liaison-session-only conversation over compact, classify, and dispose passes. It is never a board job. A Jev integration must preserve that boundary:

- Jev may annotate unread items with a typed class, confidence, and likely-dead flag.
- The liaison and maintainer still conduct muster.
- Human disposition remains the only operation that resolves an item.

```mermaid
flowchart LR
  inbox["Unread maintainer inbox"] --> jev["Jev pre-classification<br/>(class, confidence, dead flag)"]
  jev --> classify["Interactive muster<br/>(compact and classify)"]
  classify --> dispose["Human disposition"]
```

## Onboarding shape if adopted

- Add a `jev_decide` primitive that accepts state plus typed questions and returns a structured decision with confidence. It does not appear in `worker_kinds()`, the tier inventory, or the reputation ledger.
- Choose direct TypeSafe access or the OpenRouter route. Keep credentials out of the repository and ship the integration inert until a host supplies them.
- When credentials are absent or the call fails, fall through to the existing deterministic path. Classification must not block a job.
- Record cost per decision, if needed, outside the bid-market arm rate card.
- Before sending maintainer-inbox or PR-comment text, establish acceptable retention and training terms and record the required maintainer authorization for the wider monitoring surface.

## Alternatives considered

- Considered and rejected: onboard Jev as a worker kind at a tier. Reason: it cannot drive a harness or complete a job.
- Considered and rejected: add an autonomous Jev muster board job. Reason: disposition is a maintainer conversation, and muster is liaison-session-only.

## Open questions

- **Which access path should the garden use?** Direct TypeSafe API with a `TYPESAFE_API_KEY`, or OpenRouter's `typesafe/jev-1.13` route? Does the garden already have the needed credential?
- **What retention and training terms apply?** Are TypeSafe's terms, and OpenRouter's terms if used, sufficient for maintainer-inbox and PR-comment text?
- **Should Jev feed interactive muster?** Is pre-classification with human disposition the intended shape, should muster remain entirely hand-driven, or is another use intended?
- **Which decision point warrants the first pilot?** Muster has the clearest candidate value; the deterministic triager already covers common directives.
- **Are the pricing and latency figures still current?** Check the live vendor documentation before a build lands.

## Grounding

- Garden boundaries: [`roles/liaison/AGENT.md`](../roles/liaison/AGENT.md) section "Muster"; [`roles/triager/AGENT.md`](../roles/triager/AGENT.md); [CLAUDE.md](../CLAUDE.md) sections "Orchestrator vocabulary" and "Monitoring safety constraint."
- Provider precedent: [`designs/claude-ollama-cloud-worker-kind.md`](claude-ollama-cloud-worker-kind.md) and [`designs/openrouter-provider.md`](openrouter-provider.md).
- External descriptions: [TypeSafe docs](https://docs.typesafe.ai/models), [OpenRouter model entry](https://openrouter.ai/typesafe/jev-1.13), [Tom's Hardware](https://www.tomshardware.com/tech-industry/artificial-intelligence/typesafe-ais-jev-offers-an-alternative-to-llms-that-claims-to-be-193x-faster-and-445x-cheaper-system-one-type-model-is-bespoke-for-probabilistic-decision-making), and [LangChain](https://www.langchain.com/blog/building-a-harness-with-jev).
