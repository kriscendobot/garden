---
title: "ADR 0023: Institutional event context"
source: docs/decisions/0023-mutagenic-cli-channel-fan-out.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: Significant CLI mutations need one institutional record of actor, revision, command, and outcome across Jira, Slack, and Outlook, while inbound Outlook uses the same vocabulary to propose queued work rather than grant authority.

The three delivery surfaces share ADR 0022's envelope. The original premise that only
agents speak MCP was later amended by ADR 0025, but the separation between optional
delivery, durable event meaning, and inbound queue admission remains. ADR 0031 also
moves event journals from configuration to the platform-resolved state root without
changing their contract.

Source: [docs/decisions/0023-mutagenic-cli-channel-fan-out.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0023-mutagenic-cli-channel-fan-out.md) at commit `fcc40bc6` (source lines 1-27).
