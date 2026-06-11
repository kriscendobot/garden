---
ts: 2026-06-11T05:32:36Z
kind: result
role: journalist
project: endo
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/11/052803Z-dispatch-liaison-58f7ba.md
  - projects/endo/drafts/resequencing-2026-06.md
---

# Result: synthesis document "The Road to Maturity" (Workstream C / brief §5)

Draft authored at `projects/endo/drafts/road-to-maturity-2026-06.md`
(frontmatter `status: draft-for-maintainer-triage`, `identity_sensitive: true`,
with a "Draft for maintainer review; not for publication or attribution until
explicitly approved" banner under the title). Written in the maintainer's
first-person voice matching the Giants essay's register, per the
identity-sensitive instruction.

## Four-sentence abstract (one per movement)

1. **The argument** restates the giants thesis (pens, the browser-as-failed
   user-agent, the app-store rent) and widens it by one move into the platform
   thesis: Endo selectively endows peers, apps, and agents with attenuated
   capabilities, agents propose attenuations as zero-authority code, inference
   is a substitutable input, and the Familiar is the trusted compute base.
2. **The machine** walks each piece (Familiar TCB, daemon and capabilities,
   zero-authority agents, policy-as-code, attestations, substitutable
   inference, OCapN-Noise, gateway/MCP/OAuth, weblets and chat, federated hubs)
   and cites each to its design slug with the ledger's own status word, naming
   plainly where a piece is a gap with no design file.
3. **The road** lays out O1 (turn-key node) then O2 (community hub) then the
   ecosystem milestones from the resequencing proposal, with exit criteria in
   the ledger's terms and the funding-the-commons logic stated in both
   directions (commons not a loss leader; product not a betrayal).
4. **Maturity** names four properties (durable artifacts, substitutable
   everything, communities running hubs, a market in attested policy) each with
   a measurable falsifiable sign, and scores them honestly as one amber and
   three red on a real-and-merged substrate.

## Design slugs cited in the machine section, with statuses (ledger words)

Complete/Implemented: `familiar-electron-shell`, `familiar-daemon-bundling`,
`familiar-bundled-agents`, `familiar-gateway-migration`, `platform-fs`,
`daemon-mount-capabilities`, `daemon-content-store-gc`, `daemon-cross-peer-gc`,
`daemon-xs-worker-metering`, `daemon-guest-eval-simplification`,
`daemon-form-request`, `daemon-value-message`, `ocapn-noise-network`,
`gateway-bearer-token-auth`, chat UI designs (collectively).
In Progress: `familiar-unified-weblet-server`, `daemon-mount`,
`endo-posix-sandbox` (Phases 0-1 shipped), `ocapn-network-transport-separation`.
Proposed: `daemon-git-capability`/`-remotes`/`-next-steps`,
`registry-capability`, `mvs-resolver`, `snapshot-mapper`,
`daemon-worker-import-from-mount`, `endo-gateway`, `endo-gateway-mcp` (design
merged, impl Not Started), `exo-zip-package`, `endo-app-sharing`,
`familiar-app-ui-hosting`, `familiar-deep-link-invitations`,
`ocapn-noise-session-reconnect`, `endopi-provider-registry-and-oauth`
(partially satisfied by `packages/genie`).
Not Started: `familiar-chat-weblet-hosting`, `daemon-agent-tools`,
`daemon-weblet-application`, `daemon-capability-bank`,
`daemon-capability-persona`.
Reference: `trust-on-first-bind`.
Named gaps with NO design file (stated as such): `gateway-oauth-bonding`,
`gateway-key-recovery`, `gateway-resource-classes`, `gateway-stripe-adapter`,
`gateway-state-custody`; the attestation format / endorsement graph / policy
market (flagged as the largest vision-to-ledger gap); the cogitron inference
unit; the entire O2 multi-tenancy/economics/abuse/liability cluster;
the gateway virtual-users mode (deferred open question in `endo-gateway`).
Status conflict noted in-line: `daemon-agent-network-identity` (table Not
Started vs file In Progress).

## Proposal-vs-approved framing in the road section

The road section opens by stating outright that the staging follows
`resequencing-2026-06.md`, which is a draft for maintainer triage and not an
applied ledger edit; that today's ledger numbering is M1-M11; and that the
proposal would insert one new milestone and shift the tail down by one. Every
renumbering, every new gap file, the O1 critical-path correction (MCP not on
the longest chain; packaging track is the binding constraint), the
design-forward identity decision, the resource-class unfolding, and the
dedicated O2 milestone are all marked "proposed, not applied." The one
maintainer open decision I surfaced inline is whether O1's exit criterion
requires OAuth bonding implemented or can ship on bearer-token auth with
bonding as a fast follow. O1/O2 exit criteria are quoted in the ledger's own
words.

## Canon discrepancies (recorded, not resolved)

A closing "Note on status and discrepancies" section records three (re-noted
from the scout entry, all bearing on claims I made):
1. `daemon-agent-network-identity` status conflict (table Not Started vs file
   In Progress) — bears on the attestation/federation claims.
2. `gateway-package`/`gateway-packaging-ci`/`gateway-aws-deployment`/
   `gateway-aws-attuned` listed Proposed but absent from `llm` (live on an
   unmerged PR branch) — bears on the road section's packaging-track claims.
3. `familiar-release.md` referenced in M8 but absent from `llm` — I
   deliberately did not lean the gateway upgrade-channel discussion on it
   since it targets the desktop app.
The scout's fourth item (brief-vs-ledger P4 sequencing) I treated as a
strategy decision the resequencing reconciles along the design/implementation
seam, not a canon self-contradiction, consistent with the resequencing draft's
own framing.

Self-improvement: nothing this time. The essay-authoring role-stretch sat
cleanly outside the journalist's bulletin-ownership norms exactly as the
dispatch scoped it; no structural lesson warrants a role/skill change.
