---
ts: 2026-06-11T05:24:09Z
kind: result
role: journalist
project: endo
refs:
  - entries/2026/06/11/051929Z-dispatch-liaison-a0a95f.md
---

Authored essay B3, the operator's pitch (prospective O1 user), per the Endo strategy brief § 4. Draft at `projects/endo/drafts/operators-pitch-2026-06.md`.

**Abstract.** The essay addresses a developer already using an MCP client (Claude Desktop, Cursor) who wants always-online agent tools without handing a SaaS the keys, and leads with the attenuation story per brief positioning: today's MCP integrations are ambient-authority grants (a bearer token to your whole GitHub or Notion), where an Endo node grants the agent a capability instead, a directory not your disk, one repo not your account, and shows the three properties concretely as a grant, a revocation, and a single audit line. The day-one experience (marketplace deploy, OAuth sign-in, point your client at your node, grant a capability) is told in product-vision register, then the widening horizon (substitutable inference, exportable state, the node later serving a community) follows. Register is practical, second person, British understatement, zero manifesto; the politics is felt through the capability properties rather than argued.

**Cited sources.** "A Choice of Giants" (`library/sections/kriskowal-com--giants--overview.md`) for the giants problem, user-agent fiction, and self-custody register; the MCP gateway landscape shelf (`library/sections/mcp-landscape--gateway-hosting-category.md`) for the ambient-authority status quo, the MCP security spec's scope-minimisation guidance, and the hosting-commoditisation differentiator; the design ledger (`project/designs/README.md`, tip 72d1c764c) as the sole status source. No metrics, latencies, prices, or customers invented; meters described as units of account, explicitly not crypto assets, per brief § 2.

**Stage-honesty handling.** A dedicated section ("A word on what exists today, and what does not") draws the now/near-term boundary unmistakably once, and each forward-looking claim is flagged inline thereafter: OAuth bonding, marketplace deploy, metered billing, and state-custody machinery are each marked as roadmap work (gateway-package stack in PRs #388-#397 with phases 10/11 pending; endo-gateway-mcp Not Started; gateway-oauth-bonding / gateway-key-recovery / gateway-stripe-adapter / gateway-resource-classes as designed gaps in M5), while the capability discipline (daemon, daemon-mount-capabilities Complete, gateway-bearer-token-auth Implemented, familiar-electron-shell / familiar-daemon-bundling Complete, ocapn-noise-network Complete) is stated as landed today. The two-stage O1/O2 objective is framed as the maintainer's plan, not a shipped product.

**Canon discrepancies.** None found between the ledger, the giants canon, and the brief for this essay's scope. The ledger's M3/M5/M6 status and the brief's two-stage O1 objective are consistent; reported here per brief § 6 (report, do not resolve) that none surfaced.

Self-improvement: nothing this time. The journalist role file is bulletin-focused and the dispatch explicitly stretched it to essay authoring as a one-off maintainer commission; no recurring pattern across engagements yet warrants a role or skill change, and adding essay-authoring norms on a single dispatch would be a premature rule per skills/self-improvement § Threshold.
