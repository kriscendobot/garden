---
ts: 2026-06-11T04:57:39Z
kind: result
role: scout
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/11/045450Z-dispatch-liaison-b77b29.md
---

# Reconnaissance Report: Endo Strategy Gap Analysis

Scout dispatch for Workstream A gap reconnaissance.
Ledger source: `project/designs/README.md` on the `llm` branch at tip `72d1c764c`.

---

## Part 1: Critical-Path Validation

### Brief's expectation

The brief (§3.1) expects the O1 critical path to be:

> M3 gateway stack completion with Phases 10 (HTTPS proxy compat) and 11 (OS
> packaging) promoted to load-bearing → M6 P1 (MCP termination) co-scheduled
> with M5 P4 (OAuth bonding + key recovery) → P2 (AWS hosting) and P3 (Stripe +
> resource classes).

### What the ledger actually says

**M3 gateway-package phase completion (P0 in M6 slice table).**
The ledger's M3 `endo-gateway` row records phases 1–9 open as PRs #388–#397.
Phases 10 (HTTPS proxy compat) and 11 (OS packaging) are listed as "pending"
without open PRs. The M6 slice table (README.md lines 663–664) states explicitly:

> "Phase 10 (Feature 9 HTTPS proxy compat) and Phase 11 (Feature 10 OS
> packaging) pending; **shortest-route blocker on P2.**"

Brief expectation: phases 10/11 are "load-bearing." Ledger language:
"shortest-route blocker on P2." This is effectively the same claim —
both assert that a marketplace listing (P2, AWS) cannot ship without a
packaged image that terminates HTTPS. The brief and ledger agree here.

**P1 gating clarification the brief does not state.**
The M6 P1 row (README.md line 665) says:

> "P1 is gated on M3 gateway-package phases 2 (UDS bootstrap), 7 (admin /
> AppsNameHub), and 8 (ResourceLedger) **but not on 10 or 11**."

This is a meaningful nuance absent from the brief: P1 (MCP termination)
can begin as soon as phases 2, 7, and 8 of the gateway stack land —
it does NOT wait for OS packaging. The brief's framing implies P1 and P4
are both sequential behind M3 completion, but the ledger says P1 can
start in parallel with phases 9–11.

**P4 (OAuth bonding + key recovery) placement.**
The brief co-schedules P4 with P1 (M6). The ledger assigns both gaps to
M5 (not M6): the M6 slice table cites P4 as a "gap" homed in M5 (lines
668–669). The M6 text (lines 671–676) states:

> "The phases admit parallelism: P1 (MCP) and P2 (AWS) are independent
> once M3 gateway-package phases 2, 7, 8 land; P3 (Stripe) is independent
> of P1 and P2. P4 (OAuth + rotation) is the only slice that materially
> extends the user-identity model and is the one most likely to spawn design
> churn; **sequencing it last** keeps the rest of the milestone from being
> held by its design cycle."

The brief says "co-scheduled with P1." The ledger says "sequence P4 last."
This is a genuine divergence. The brief's §2 ("co-prioritization") is a
strategic decision that the ledger has not absorbed; the ledger instead
records P4 as a sequencing-last recommendation for design stability.

**M4 (daemon-agent-network-identity) placement relative to M5/P4.**
The M5 `gateway-oauth-bonding` gap row (README.md line 617) references
`daemon-agent-network-identity` for "the Ed25519 keypair side." M4 precedes
M5 in the ledger's milestone order, so the dependency is correctly sequenced.
However, `daemon-agent-network-identity` itself (the design file) has status
"Not Started" in the README summary table (line 131), but the design
file's metadata says "In Progress" and lists items 1 and 2 as "Done."

**Status discrepancy (ledger inconsistency, per brief §6).**
`daemon-agent-network-identity` is listed as "Not Started" in the
README summary table (line 131) and the M4 milestone table (line 585),
but the design file itself carries:
- metadata `Status: In Progress` / `Updated: 2026-03-18`
- items 1 ("Locator construction") and 2 ("LOCAL_NODE for formula
  storage") marked `~~Done~~`.

These two sources disagree. The README summary table has not been
reconciled with the file's own status section.

**The corrected critical path (reconciling brief with ledger):**

1. M3 P0: gateway-package phases 2, 7, 8 (UDS bootstrap, AppsNameHub,
   ResourceLedger) — gates P1.
2. M3 P0: gateway-package phases 10, 11 (HTTPS proxy compat, OS
   packaging) — gates P2 (AWS hosting). These two tracks can run in
   parallel once phases 2/7/8 land.
3. M6 P1: MCP termination — starts after phases 2/7/8, independent of
   10/11.
4. M5 P2: AWS hosting — starts after phases 10/11.
5. M5 P3: Stripe billing — independent of P1 and P2; depends only on
   gateway-package phase 8 (ResourceLedger) being merged.
6. M5 P4: OAuth bonding + key recovery — ledger sequences LAST among P0–P4
   for design-churn reasons. Builds on M4 `daemon-agent-network-identity`
   (Ed25519 keypair side).

The brief's O1 path is largely correct but conflates two parallelizable
sub-tracks (P1 can start before phases 10/11 land) and conflicts with
the ledger on P4 sequencing (brief says co-schedule with P1; ledger says
last).

---

## Part 2: Seed-Gap Coverage Survey

Sweep of `designs/` tree against each brief §3.3 seed gap.

### gateway-oauth-bonding

Status in ledger: named gap (M5), no design file exists yet (only the
designation in the README). The M6 slice table (lines 681–691) specifies
what the design must cover: OAuth-to-formula-id bonding, user-facing flow,
daemon-side persistence model. Cross-references: `daemon-agent-network-identity`
(Ed25519 keypair side), `endoclaw-oauth` (agent-side OAuth client, M7),
`endopi-provider-registry-and-oauth` (LLM-provider OAuth).

Verdict: **uncovered** (gap exists; no design file at this path; no partial
coverage in adjacent designs beyond the specification of what is needed).

### gateway-key-recovery

Status in ledger: named gap (M5), no design file. The M5 milestone table
(line 617) and the M6 slice table (lines 692–697) scope it as:
bearer-token re-issue on OAuth-proof, deprecation window for old bearer,
audit log. Narrower than `endo-gateway.md` Open Question 1 (Pass-Invariant-Eq).

Partial coverage note: `endo-gateway.md` Open Question 1 (lines 903–926
of that file) names the Pass-Invariant-Eq problem; `endo-gateway-mcp.md`
Design Decision 2 and the "Rotate" deferred affordance touch the bearer
rotation question but do not design it.

Verdict: **partially covered** (problem statement in endo-gateway.md Open
Question 1; MCP design defers rotation; no design file for the recovery
ceremony itself).

### gateway-stripe-adapter

Status in ledger: named gap (M5). The M5 row (line 618) and M6 slice
table (line 667) note that PR #396 (ResourceLedger) lands
`verifyPaymentProof(tokens, proof)` as an injected power; the Stripe
adapter (webhook validation, Stripe API integration, idempotency,
refund handling) is described as "may be small enough to live as
implementation rather than design."

Verdict: **partially covered** (the `verifyPaymentProof` interface
in the ResourceLedger design defines the injection point; the Stripe-specific
implementation is not designed; no design file).

### gateway-resource-classes

Status in ledger: named gap (M5, "may fold into stripe-adapter"). The M5
row (line 619) and the M6 P3 note (line 667) identify the four classes:
compute (computrons), inference (cogitrons), storage, network. The
per-class measurement surfaces (what counts as a computron, how cogitrons
map to upstream provider tokens) are described as needing "per-class spec
text."

Verdict: **partially covered** (class names and abstract metering surfaces
named in the ledger narrative; no design file; likely to fold into
gateway-stripe-adapter).

### Marketplace packaging and listing

The brief asks about AWS Marketplace requirements for an AMI/container
product and what they constrain in Phase 11.

Coverage found:
- `daemon-docker-selfhost.md` (Not Started): covers Docker image shape,
  state persistence, compose pattern, external TLS via reverse proxy. Does
  not address AWS Marketplace listing, AMI, Packer, or marketplace
  certification requirements.
- `gateway-aws-deployment` (Proposed, named in M5 table, line 614): described
  as covering "EC2 + ALB + Packer AMI + Terraform" and the AWS-attuned variant.
  This design IS referenced in the ledger but the file does NOT exist in
  `designs/`. The ledger cites it as part of PR #356 (a stacked-PR design
  that is "in review"), but the design file is on that PR's branch, not
  merged to `llm` yet.
- `gateway-packaging-ci` (Proposed, named in M5 table, line 613): CI workflow
  that builds and signs OS package artifacts. Same situation: file not present
  on `llm`; lives on PR #356's branch.

**Discrepancy (per brief §6):** The README's Summary table (lines 612–613)
and M5 milestone table list `gateway-package`, `gateway-packaging-ci`,
`gateway-aws-deployment`, and `gateway-aws-attuned` as Proposed designs.
None of these files exist in the `designs/` directory at `llm` tip.
The README refers to them as existing on PR #356 stacked on PR #343;
neither PR has been merged to `llm` as of tip `72d1c764c`.
The ledger claims these designs exist (with Proposed status) but they are
not in the tree.

TLS and domain provisioning: covered in principle by the reverse-proxy
pattern in `daemon-docker-selfhost.md` and `endo-gateway.md` (both say
"TLS is the reverse proxy's job"), but neither designs the first-boot
domain-binding flow for a marketplace-launched node.

Verdict: **partially covered** (Docker/container shape in
`daemon-docker-selfhost.md`; AWS-specific designs referenced but not present
on `llm`; marketplace listing requirements, AMI certification, domain
provisioning not addressed in any extant design file).

### First-boot ceremony

The brief asks how an operator receives their bearer token and bonds OAuth
identity on a fresh node, before any other channel of trust exists.

Coverage found:
- `endo-gateway-mcp.md` Chat-side UI section covers affordance 2 ("retrieve
  the MCP configuration block") and affordance 1 ("+ Add agent" button) for
  an operator who already has a running node and an authenticated Chat UI.
  It does NOT cover the bootstrap problem: how does the operator authenticate
  to Chat before they have a bearer token?
- `gateway-bearer-token-auth.md` (Implemented) establishes that the agent's
  256-bit formula identifier IS the bearer; it does not address how the operator
  first retrieves that identifier on a fresh headless deployment.
- `daemon-docker-selfhost.md` mentions Chat hosting at a URL with anchor
  (`#agent=<id>`) but does not design the first-boot flow.
- No design covers: secure out-of-band delivery of the initial bearer,
  operator authentication before any bearer exists, the trust bootstrapping
  problem for a headless server.

Verdict: **uncovered** (the credential retrieval is implicit — the formula
identifier is in the daemon's state directory — but no design specifies
how an operator securely retrieves it from a fresh cloud-deployed node
before establishing any other trust channel; this is a genuine undesigned gap).

### State custody / backup / restore / migration

The brief asks for design of backup, restore, and cloud-to-cloud migration
of node state (framed as the "self-custody and anti-lock-in" brand promise).

Coverage found:
- `daemon-docker-selfhost.md` covers Docker volume for state persistence
  (section "State persistence") and mentions bind-mount for direct backup
  access. Does not design backup procedures, restore verification, or migration.
- `daemon-cas-management.md` (In Progress): covers the content-addressed store
  management and pruning; relevant substrate for any backup design.
- `daemon-checkin-checkout.md` (Complete): `endo ci`/`endo co` for local
  serialization of readable trees; a substrate but not a backup design.
- No design addresses: cloud-to-cloud migration, backup integrity verification,
  restore ceremonies, export formats for node state, or data portability
  guarantees.

Verdict: **uncovered** (substrate exists in CAS management and checkin-checkout,
but no design addresses the full backup/restore/migration lifecycle as a
product-facing feature).

### Upgrade channel

The brief asks for signed updates for an always-online node.

Coverage found:
- `familiar-release.md` (Proposed, on PR #231 branch, not on `llm`): referenced
  in `app-sharing-milestone.md` as covering G1–G16 gaps including auto-update
  posture (G-item mention in app-sharing-milestone lines 64–65: "auto-update
  posture" listed as an open question). The actual design file is not on `llm`.
- No design on `llm` addresses signed OTA updates for a headless gateway node.
  `familiar-release.md` targets the Familiar Electron app (desktop), not the
  gateway service.

Verdict: **uncovered** (Familiar release design partially addresses the
desktop case but is not on `llm` and does not cover the headless gateway
node upgrade problem; no design addresses signed gateway updates).

### Operator observability

The brief asks for logs and metrics adequate to run a production node, without
building surveillance.

Coverage found:
- `endo-gateway-mcp.md` Design Decision 9 ("Logging today: a structured-logger-
  shaped `node:console`"): covers diagnostic forwarding to MCP clients via
  `notifications/message`; notes anylogger as the future bridge; does not
  address operational metrics (uptime, request rates, error rates, resource
  consumption).
- `daemon-xs-worker-metering.md` (Complete): covers computron metering at the
  XS worker level; relevant substrate for resource billing, not operator
  dashboards.
- `daemon-rust-xs-performance.md` (Active): benchmarking and performance metrics
  for the Rust/XS side.
- No design covers: structured logging for the gateway service, metrics
  endpoints (Prometheus-style), alerting posture, or the observability-vs-
  surveillance design tension the brief names.

Verdict: **uncovered** (relevant substrate in XS metering and MCP logging;
no design addresses operational observability as a production concern, and
no design engages with the surveillance-refusal framing the brief requires).

### O2 multi-tenancy

The brief asks for isolation between members on one hub, hub economics,
abuse handling, and a survey of operator liability questions.

Coverage found:
- `endo-gateway.md` Open Question 2 ("Daemon-hosting service mode, deferred"):
  names the shape — "a variant of the Gateway where it manages virtual users
  rather than addressing system-level User Daemons" — but explicitly defers it.
- `daemon-capability-persona.md` (Not Started, M10): "epithets and delegation"
  for per-agent persona management; relevant substrate for member isolation
  but not multi-tenancy per se.
- `daemon-capability-bank.md` (Not Started, M10): integrates all capability
  categories; relevant for per-member capability scoping.
- `endo-gateway.md` registration protocol distinguishes `local` vs `remote`
  registrations and describes per-host policy for who may host at the local
  virtual-host hierarchy; a substrate for multi-tenancy.
- No design addresses: member billing vs operator billing, abuse handling
  posture, moderation tools, operator liability (the "Mastodon-instance-
  operator problem" the brief names), member invitation flows beyond
  `familiar-deep-link-invitations` (which covers peer peering, not hub
  membership).

Verdict: **uncovered** (gateway architecture supports multi-user at the
OS-process level; virtual-user multi-tenancy is explicitly deferred in
endo-gateway.md; no design addresses hub economics, member billing, abuse
handling, or operator liability at the community-hub scale).

---

## Part 3: O2 Entrainment Map

For each design that the O2 community-hub objective entrains, status and
the specific O2 function it serves.

| Design slug | Status | O2 function |
|-------------|--------|-------------|
| `daemon-agent-network-identity` | Not Started (ledger) / In Progress (file; items 1-2 done) | Per-agent keypairs are the identity model for member accounts on a hub. Each member gets their own Ed25519 identity; the keypair is the routing key for OCapN sessions between member nodes and the hub operator. |
| `ocapn-noise-network` | Complete (PR #137) | Secure peer transport; the cryptographic substrate for member-to-hub and hub-to-hub sessions. Without Noise-IK, the hub cannot authenticate remote members. |
| `ocapn-noise-session-reconnect` | Proposed | Session reconnect for always-online hub members who experience transient disconnections; important for the "always-online capabilities" part of O2. |
| `endo-gateway` | Proposed | The host-level service that O2 sits on. The gateway's multi-user registration model (one gateway, N user daemons) is the substrate for one-operator-many-members. Open Question 2 in this design names the "daemon-hosting service mode" variant (virtual users rather than OS-level users) as the direct O2 shape. |
| `daemon-capability-persona` | Not Started (M10) | Persona system: members as distinct personas with separate identity contexts, epithets, and delegation chains. Foundational for community isolation. |
| `daemon-capability-bank` | Not Started (M10) | Full capability taxonomy; needed for per-member capability scoping (what can each member's agents do?) and per-member resource limits. |
| `familiar-deep-link-invitations` | Proposed (M8) | Member onboarding by invitation: the `endo://` deep-link scheme and confirmation screen. Covers the Familiar-to-Familiar peer connection flow. The hub onboarding variant (operator invites member to hub service, not just peer) would extend this design. |
| `endo-app-sharing` | Proposed (M8) | App sharing between hub members; the "curation" O2 function. A hub operator curating apps for members is the multi-user extension of peer app sharing. |
| `gateway-oauth-bonding` (gap) | — (M5) | OAuth identity bonding so hub members can sign in with external accounts rather than managing raw bearer tokens. Without this, member onboarding requires out-of-band key delivery. |
| `gateway-key-recovery` (gap) | — (M5) | Bearer re-issue on OAuth proof; critical for member account recovery when members lose their bearer on a hub they do not administer. |
| `endoclaw-webhooks` | Not Started (M7) | Event-driven automation for hub members; enables the "proactive" and "mail delivery" O2 capabilities by allowing agents to receive external events. |
| `endoclaw-network-fetch` | Not Started (M3, Strategic Early) | Outbound HTTP for hub-hosted agents; the substrate for mail delivery and external service integrations that O2's ISP-like services require. |
| `daemon-agent-tools` | Not Started (M3) | The tool surface that hub-hosted agents use; needed for the "always-online capabilities" O2 promises. |
| `ocapn-network-transport-separation` | In Progress (M4) | Transport abstraction layer; needed for the relaying/NAT-traversal O2 function (relay nodes require abstract transport pluggability). |
| `daemon-capability-filesystem` | Reference | Referenced by `daemon-agent-tools`; the `Dir`/`File` substrate for per-member workspace isolation. |
| `namehub-interface-unification` | Proposed (M9) | Gateway `AppsNameHub` is the O2 hub-level name registry for apps and agents; interface unification makes it composable with per-member `EndoMount` namespaces. |

**Designs the brief names as candidates, verified:**

- `daemon-agent-network-identity`: confirmed entrained; the Ed25519 keypair
  side that gateway identity bonding builds on (M4 → M5 dependency correctly
  stated in brief).
- M4 networking designs (`ocapn-network-transport-separation`,
  `ocapn-noise-session-reconnect`): confirmed entrained; relay/NAT-traversal
  and always-online session reliability both depend on these.
- `familiar-deep-link-invitations`: confirmed entrained as the member
  onboarding substrate; the hub-invitation variant is a natural extension
  of the peer-invitation shape.
- M8 app-sharing cut (`endo-app-sharing`, `familiar-app-ui-hosting`):
  confirmed entrained; curation and app distribution to members are O2 functions
  the sharing cut directly serves.

**Additional entrained designs not in brief's candidates:**

- `endo-gateway` Open Question 2 (daemon-hosting service mode): the brief does
  not cite this but it is the most precise ledger description of what O2
  requires at the gateway layer — the virtual-users variant where the hub
  operator manages member accounts without requiring per-member OS accounts.
- `gateway-oauth-bonding` and `gateway-key-recovery` (both M5 gaps): member
  sign-in and recovery are O2 requirements, not just O1; OAuth bonding is
  arguably more important for a community hub than for a self-custodial node
  because hub members are not expected to manage raw keypairs.
- `daemon-capability-persona` (M10): persona system for member identity
  isolation; not in brief's O2 candidates.

**O2 slot relative to M7–M11:**

The ledger does not explicitly place O2 in the milestone sequence; the brief
asks the designer to do this. Based on entrainment, O2's minimum prerequisites
are: M3 (gateway substrate), M4 (network identity and OCapN), M5 (OAuth
bonding, key recovery, AWS deployment), M6 (MCP for always-online agent
tools), M7 (webhooks, OAuth capabilities for member agents). The virtual-user
multi-tenancy work (endo-gateway.md Open Question 2) and `daemon-capability-
persona` (M10) are likely the long poles; M8 (app sharing) provides the
curation and distribution substrate. A conservative placement: O2 can begin
design work in parallel with M7 but requires M5 to be complete before
it can ship. The "operator liability survey" component is not blocked on
any technical milestone — it is a design/legal analysis task.

---

## Discrepancies Found (brief §6 — do not resolve, record verbatim)

1. `daemon-agent-network-identity` status conflict: README summary table
   lists status as "Not Started"; M4 milestone table lists "Not Started";
   design file metadata says `Status: In Progress, Updated: 2026-03-18`
   and items 1 ("Locator construction with agent keys") and 2 ("LOCAL_NODE
   for formula storage") are marked Done with `~~strikethrough~~`. The
   summary table has not been reconciled with the file.

2. M5 designs missing from `llm`: README lists `gateway-package`,
   `gateway-packaging-ci`, `gateway-aws-deployment`, and `gateway-aws-attuned`
   as Proposed designs in both the Summary table and the M5 milestone table.
   None of these files exist in `designs/` at `llm` tip `72d1c764c`. The
   README text explains they live on PR #356 (stacked on PR #343), neither
   of which has been merged to `llm`. The ledger presents them as if they
   were extant design docs; they are not.

3. `familiar-release.md` referenced but not on `llm`: the M8 milestone
   table (line 795) references `familiar-release.md` as a Proposed design
   with specific PR numbers (#231, #318, #321, #319, #316, #320, #323, #324,
   #322, #317, #360). The file does not exist in `designs/` at `llm` tip.
   The `app-sharing-milestone.md` design file (which IS on `llm`) references
   it by name and links to its raw GitHub URL on the `design/familiar-release`
   branch. The ledger treats it as a Proposed design in the milestone table
   despite it not being merged.

4. M6 P4 sequencing conflict: the brief (§2, "co-prioritization") directs
   that OAuth bonding and key recovery are prioritized "together" with MCP
   termination, "not sequentially." The ledger's M6 slice table (lines 671–676)
   recommends "sequencing [P4] last keeps the rest of the milestone from being
   held by its design cycle." These two directives conflict. The ledger predates
   the brief's strategic decision; the designer will need to reconcile them.

---

Self-improvement: nothing this time. The role-stretch (reconnaissance rather
than benchmarking) worked cleanly with the scout role's evidence-discipline
spirit; no structural lesson warrants a role file change.
