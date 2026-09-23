---
created: 2026-09-23
updated: 2026-09-23
author: gardener
---

# Design: TypeSafe Jev for classification work

| Field | Value |
| --- | --- |
| Status | **Accepted for a bounded Muster pilot.** This design was landed on `main2` before its review PR was opened; the PR remains an answer-surface under the garden's-own-repo open-questions carve-out, not a pending merge. |
| Directive | kriskowal, 2026-09-23: is TypeSafe AI's Jev a fit for classification-shaped work such as triage and muster? |
| Decision | Jev is a non-agentic structured-decision classifier, not a generative LLM. Do not onboard it as a worker kind or tier-inventory row. Pilot direct TypeSafe access as an optional advisory classification primitive at the beginning of Muster. Muster remains an interactive liaison session with regular-inference fallback and human disposition. |
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

## Pilot implementation

- [`scripts/jobs/muster-pilot.sh`](../scripts/jobs/muster-pilot.sh) calls TypeSafe directly with the maintainer-provisioned `TYPESAFE_API_KEY`. It accepts a bounded batch of unread messages and returns typed compaction treatment, recurring-pattern, and muster-class labels with confidence values. It does not appear in `worker_kinds()`, the tier inventory, or the reputation ledger.
- The liaison asks at the beginning of each muster whether to engage the pilot. It runs only when the maintainer opts in for that session.
- The pilot is advisory and read-only. A liaison verifies external state before coalescing, archiving, or reposting any message; existing muster commands remain the only mutation path.
- When credentials are absent, TypeSafe is unavailable, its request fails, or its response shape is invalid, the script reports the fallback and exits successfully. The liaison performs the same three passes with regular inference.
- Record cost per decision, if needed, outside the bid-market arm rate card.
- The maintainer accepted TypeSafe's retention and training terms for this trial. This acceptance covers the opt-in Muster pilot, not an autonomous watcher or broader PR-comment monitoring surface.

## Alternatives considered

- Considered and rejected: onboard Jev as a worker kind at a tier. Reason: it cannot drive a harness or complete a job.
- Considered and rejected: add an autonomous Jev muster board job. Reason: disposition is a maintainer conversation, and muster is liaison-session-only.

## Resolved pilot questions

- **Access:** use the garden's existing direct TypeSafe credential. Do not route the trial through OpenRouter.
- **Retention and training:** the maintainer considers TypeSafe's terms sufficient for this trial.
- **Muster shape:** begin with classification that helps the liaison coalesce recurring observations, recognize already-handled messages, and identify deploy-gap reposts. Keep regular inference as the fallback whenever Jev is unavailable.
- **First decision point:** pilot at the beginning of interactive Muster, behind an explicit session question.
- **Pricing and latency:** the reviewed figures are close enough for the trial. Recheck before any autonomous or materially larger deployment.

## Grounding

- Garden boundaries: [`roles/liaison/AGENT.md`](../roles/liaison/AGENT.md) section "Muster"; [`roles/triager/AGENT.md`](../roles/triager/AGENT.md); [CLAUDE.md](../CLAUDE.md) sections "Orchestrator vocabulary" and "Monitoring safety constraint."
- Provider precedent: [`designs/claude-ollama-cloud-worker-kind.md`](claude-ollama-cloud-worker-kind.md) and [`designs/openrouter-provider.md`](openrouter-provider.md).
- External descriptions: [TypeSafe docs](https://docs.typesafe.ai/models), [OpenRouter model entry](https://openrouter.ai/typesafe/jev-1.13), [Tom's Hardware](https://www.tomshardware.com/tech-industry/artificial-intelligence/typesafe-ais-jev-offers-an-alternative-to-llms-that-claims-to-be-193x-faster-and-445x-cheaper-system-one-type-model-is-bespoke-for-probabilistic-decision-making), and [LangChain](https://www.langchain.com/blog/building-a-harness-with-jev).
