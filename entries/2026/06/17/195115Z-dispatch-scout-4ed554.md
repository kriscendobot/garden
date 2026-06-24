---
ts: 2026-06-17T19:51:15Z
kind: dispatch
role: scout
host: endolinbot
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/scout--4ed554
short_id: 4ed554
refs: []
---

# dispatch: scout — Gateway → cloud marketplace artifact reconnaissance (AWS primary, Azure + GCP comparison)

Maintainer directive:

> We need to research the technical details of producing an
> artifact that can be sold on the Amazon Marketplace. We
> need to understand how to construct and deploy an artifact,
> based on the Gateway, to provide services to a user,
> especially starting with MCP but also later relaying
> services on behalf of users with designated keys. We should
> compare Azure and GCP options, or potentially engage all of
> them.

Scout produces a structured report covering:

- AWS Marketplace artifact shapes (AMI / Container Product /
  SaaS / CloudFormation Quick Start) and the technical
  requirements for each (build pipeline, listing review,
  metering integration, identity model).
- Gateway integration: how PR #410 (CLI/systemd) +
  PR #412 (distribution recipes) compose into a
  marketplace-ready image; what's missing.
- MCP-first staging: minimum-viable artifact that
  terminates MCP for a single buyer with attenuated
  capability grants per `endo-gateway-mcp` design.
- Designated-keys relaying: O2-shape (community hub)
  evolution per the resequencing-2026-06.md proposal.
- Azure Marketplace + GCP Marketplace comparison: artifact
  shapes, identity hooks, billing channels, review cadence.
- Recommendation: AWS-first sequencing, parallel surfaces
  for Azure/GCP, or engage-all-three with a unified
  packaging fan-out.

The scholar (dispatched in parallel) shelves the cited
references; the scout consumes the shelved material and
produces the assessment.
