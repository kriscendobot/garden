---
title: Sensitive observation confinement
source: packages/workshop-shared/src/gatekeeper.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/gatekeeper.ts
source_line_range: "855-926, 1049-1108"
source_commit: 2c9d59098d852370f27882702dd39a159b3c12f5
comment_subject: Gatekeepers authorize every read before disclosure and can prohibit sharing globally or exclude named observers from a particular observation
source_authors: [Kenton Varda, "Yo'av Moshe", Phillip Jones, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
status: current
---

Read-only provider calls may fetch remote data before policy evaluation when the actual result is needed to describe risk, but the Gatekeeper must call `authorizeObservation()` and wait before returning any bytes to the gadget. Observation metadata supports two confinement strengths: owner-only information can prohibit all sharing and place the gadget in observation-only lockdown, while a narrower read can exclude named observers and proceed only if the Overseer can keep it out of their view.

## Authorization before disclosure

Every read operation crosses the observation authorizer. Fetching first is acceptable only when the provider operation has no side effects and the data remains inside the Gatekeeper until authorization succeeds. A thrown authorization error must propagate to the gadget. Agent catalogs and slash-command expansions derived from protected data follow the same rule, even though their discovery metadata or picker entries may be non-sensitive.

The description includes a concise title and a complete Markdown explanation for review and audit. Future policy hints are expected to describe free-form prompt-injection risk, data contributors, and the audience allowed to see secrets.

## Global sharing prohibition

`prohibitAllSharing` marks data that only the connected account owner may see. The Overseer must reject the observation if the gadget is already shared, forbid future sharing after the read, and put the gadget into a mode where it can observe but cannot act. Removing action authority prevents the gadget from exfiltrating the sensitive value through another Gatekeeper. This is explicitly a stopgap for sources whose safe shared-audience computation is not yet implemented.

## Per-observer exclusion

`excludeObservers` names previously admitted observer IDs who must not receive this observation. Success from the Overseer is a promise that those people cannot see it, perhaps because they were removed or because the observation remains inside a thread they cannot open. If the Overseer cannot enforce that boundary, authorization throws and the Gatekeeper blocks the read entirely.

Source: [packages/workshop-shared/src/gatekeeper.ts](https://github.com/cloudflare/cloudflare-os/blob/2c9d59098d852370f27882702dd39a159b3c12f5/packages/workshop-shared/src/gatekeeper.ts) at commit `2c9d59098d` (lines 855-926 and 1049-1108).
