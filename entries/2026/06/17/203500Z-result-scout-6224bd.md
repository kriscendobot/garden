---
ts: 2026-06-17T20:35:00Z
kind: result
role: scout
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo
short_id: 6224bd
refs:
  - entries/2026/06/17/195115Z-dispatch-scout-4ed554.md
  - entries/2026/06/11/045739Z-result-scout-8f5fb7.md
  - entries/2026/06/03/041100Z-result-builder-0fa673.md
  - entries/2026/06/03/050000Z-result-builder-bc8cef.md
  - entries/2026/06/03/053500Z-result-builder-57e6ca.md
  - projects/endo/drafts/resequencing-2026-06.md
  - library/topics/cloud-marketplace.md
  - library/topics/tls-provisioning.md
  - library/topics/signed-updates.md
  - library/topics/node-packaging.md
prs:
  - { repo: endojs/endo-but-for-bots, pr: 410, role: cited }
  - { repo: endojs/endo-but-for-bots, pr: 412, role: cited }
  - { repo: endojs/endo-but-for-bots, pr: 413, role: cited }
---

# Reconnaissance: Cloud-marketplace artifact strategy for the Capability Bridge (AWS-first, with Azure / GCP comparison)

Scout dispatch for the workstream the maintainer named in the v11 strategy document
(`Limited Scope Product Strategy: The Capability Bridge and the Capability Hub`,
9 Jun 2026) as the **MVP cloud-marketplace deployment**. The strategy is explicit
that the MVP is "a turnkey Capability Bridge deployable from cloud marketplaces:
AWS Marketplace, GCP Marketplace, Azure Marketplace, and receives a running Endo
agent sandbox in their own cloud account. Marketplace billing handles the
commercial layer. We are the publisher; the user is the operator." This report
maps that strategic ask onto the technical and commercial reality of each
marketplace, anchors against the gateway-package design and the in-flight
gateway stack (PRs #410, #412, #413), and recommends a sequencing.

The companion scholar (`scholar--302d34`, dispatched the same minute) is
shelving the canonical AWS / Azure / GCP marketplace documentation but had not
returned at the time this report was written. AWS library coverage is rich
(see refs); Azure / GCP coverage is from this scout's own web sources noted
inline. See *Open Questions* for the gap.

---

## 1. AWS Marketplace artifact shapes

AWS Marketplace offers four product types that the Capability Bridge could in
principle be sold under. Each has distinct technical build requirements, a
distinct review pipeline, a distinct metering and identity model, and a
distinct fit to the gateway-package architecture.

### 1.1 Single AMI (AMI-based product)

The simplest shape and the one the strategy implicitly assumes when it says
"deploy from a cloud marketplace and receive a running Endo agent sandbox in
their own cloud account."

**Technical build requirements** (`web--aws-marketplace-ami-requirements--technical-security`):

- HVM virtualization, x86-64 or ARM64, EBS-backed (no S3-backed AMIs), unencrypted
  EBS snapshots, region-agnostic (no per-region variants), source AMI in
  `us-east-1`.
- No hardcoded secrets, no pre-seeded SSH keys, no system / service passwords
  (even hashed), no private keys, no credentials.
- No password-based SSH authentication; password-based remote logins disabled
  for superuser accounts. `sshd_config` must set `PasswordAuthentication no`.
- No AWS-credential requests in the image; products needing AWS service access
  use a minimally-privileged IAM role assigned to the instance.
- Sellers may not have access to customer instances; customers may explicitly
  enable support access.
- AMI passes the marketplace scanning tool with no vulnerabilities; no
  end-of-life OS or software; AMI is not older than two years from creation date.

**Listing review pipeline** (`web--aws-marketplace-ami-requirements--pricing-and-listing--listing-and-review-process`):

1. Seller registration (tax + banking for paid products).
2. AMI preparation per the requirements above.
3. Self-service scan via "Test Add Version" in the Marketplace Management Portal
   (typically under one hour).
4. Submission via Build tab (or Assets tab for complex configurations).
5. Limited state: visible only to seller and an optional allow-listed test set.
   Test thoroughly here.
6. Public publication: Request Update Visibility; AWS Seller Operations reviews.
7. AMI cloning: AWS creates region-specific clones and attaches a product code.

**Timing:** initial publication is 7-10 business days if no errors; total
calendar time is 2-4 weeks for new products; planned releases need 45 days
lead; price changes require 90-day notice. **This is a calendar tax on O1's
ship date and must be budgeted into the milestone timeline, not the effort
estimate.**

**Metering / billing integration** (`web--aws-marketplace-ami-requirements--pricing-and-listing--pricing-models`):

Six pricing models: Free, BYOL, Paid Hourly, Paid Hourly with Annual, Paid
Monthly, Paid Usage (Custom Metering), Contract Pricing. **Custom Metering
binds the Capability Bridge tightly** because:

- Seller software calls `MeterUsage` once per hour per dimension per customer.
- The FCP Dimension Name is **15 characters, alphanumeric + underscore only**.
- **Dimensions are locked after publication.** New dimensions may be added up
  to the 24-dimension cap, but existing ones cannot be renamed or removed.
- Products on Custom Metering **cannot be converted** to hourly / monthly / BYOL
  after publication. The choice is irreversible.
- Free trial and annual pricing are not compatible with Custom Metering.

**Identity model:** the buyer subscribes via their AWS account; the AMI runs
under their IAM role; the operator IS the AWS-account holder. The product code
attached to the cloned AMI is what `MeterUsage` calls against. There is no
SSO; OAuth / OIDC for the *operator-into-the-node* trust handshake is
orthogonal to the marketplace's account-level identity.

**Cost-to-list:** essentially zero in fees beyond AWS Marketplace Seller
registration (free), but the calendar tax (2-4 weeks per submission, 45 days
for planned releases, 90 days for price changes) is real and compounding.

**Fit to the Capability Bridge:** **the natural starting shape.** Maps
directly onto v11's "click 'deploy' in AWS Marketplace and receive a running
Endo agent sandbox in their own cloud account." The operator runs the sandbox
in their own account; we ship a binary image; AWS handles the billing
plumbing. The only friction is the dimension-lock + 15-char limit, which the
G-resource-classes gap (per the resequencing draft §3.1) must encode.

### 1.2 AMI with CloudFormation template (AMI+CFT)

A single AMI optionally augmented with a CloudFormation template that
provisions surrounding AWS resources (VPC, ALB, security groups, IAM roles,
S3, DynamoDB, an ACM certificate, Route 53 record sets) so the buyer gets a
**cluster or distributed architecture** rather than a bare EC2 instance.

AWS launched self-service listing for AMI+CFT in January 2025, replacing the
prior manual spreadsheet process for this product type. Self-service is now
available for single-AMI, AMI+CFT, SaaS, and container products.

**Why it matters for the Bridge:** the architecture described in the absent
`gateway-aws-deployment` design (per the resequencing draft and the prior
scout `8f5fb7`) is exactly this shape: "EC2 + ALB + Packer AMI + Terraform."
An AMI+CFT listing replaces the Terraform with a CFT and lets the buyer get
the architecturally-correct deployment in one click.

**Constraints carried from §1.1** apply (same security policies and
architecture requirements on the underlying AMI). The CFT adds its own
review surface but does not relax any AMI requirement.

**Fit to the Bridge:** **the right shape once `gateway-aws-deployment` lands.**
For O1 (the marketplace MVP), single-AMI suffices and is cheaper to maintain.
AMI+CFT becomes attractive when the Bridge needs the surrounding AWS
infrastructure (ALB for TLS termination, IAM role for S3 CAS, DynamoDB for
state) to be provisioned consistently. **G-marketplace and G-aws-deployment
(the two M5 gaps) carry the AMI+CFT decision; the resequencing's M5 critical
path should treat the upgrade from single-AMI to AMI+CFT as a graduation step,
not a launch requirement.**

### 1.3 Container product

For ECS, EKS, and AWS Fargate deployments. Container images push to an
AWS Marketplace-managed Amazon ECR repository; buyers pull from that ECR.

**Technical build requirements** (`web--aws-marketplace-container-requirements--technical-security`):

- Linux-based images only. Paid products deploy on ECS, EKS, or Fargate.
- No known vulnerabilities, malware, or end-of-life packages.
- No AWS credentials in the image (use IAM roles for service accounts on EKS,
  IAM roles for tasks on ECS; AWS credentials are obtained at runtime).
- Run with non-root privileges by default; least-privilege only.
- No hardcoded secrets; no password-based authentication for any service in
  the container.
- For EKS add-on products: must support both AMD64 and ARM64, must ship as a
  Helm chart; all image references defined exclusively in `values.yaml` (so
  AWS can replace them for cross-region replication); chart self-contained,
  all dependencies pushed to Marketplace ECR (no Docker Hub / GitHub external
  refs).

**Metering / billing integration:**

| Model | Integration |
|---|---|
| Hourly / fixed monthly | `RegisterUsage` API; AWS meters by task/pod count. |
| Custom metering | `MeterUsage` API; seller defines up to 24 dimensions. |
| Contract pricing | AWS License Manager; software checks entitlement via License Manager APIs. |

Both `MeterUsage` and `RegisterUsage` serve dual purpose: entitlement check
(is the buyer subscribed?) and usage reporting. Unentitled buyers see
`CustomerNotEntitledException`.

Notes specific to container products:

- Do not configure the AWS SDK to use a specific region; obtain it dynamically.
- Integrate metering directly into the software (not via CMD / ENTRYPOINT);
  otherwise buyers can override it by inserting new image layers.
- Manage product codes in a way buyers cannot modify (maintain a trusted
  product-code list to prevent free-code substitution for paid-code).

**Fit to the Bridge:** **the natural second listing.** The gateway-package
design's "one factory, many configurations" shape and PR #412's
`packaging/docker/` recipe already produce a runnable container. The gating
constraint for a Marketplace container listing is **Linux-only** (already
true) and **non-root by default** (PR #410's systemd unit ships with
`User=endo`, so the daemon is already non-root-ready; the Dockerfile inherits
the same expectation). Per the strategy's "self-custodial" framing, container
products on Marketplace are still operator-run; the operator pulls the image
into their own ECS / EKS cluster. AWS does not host containers for sellers.

**Trade-off vs single-AMI:** the AMI is simpler to ship and review (single
binary, no orchestrator dependency) but locks the operator into an EC2
instance. The container is more portable across the operator's compute estate
(ECS, EKS, Fargate, even local Docker) but the operator must own a runtime.
**For the MVP, single-AMI minimizes the buyer's pre-existing-infrastructure
requirement, which v11 §3.2 names as part of the "click deploy" promise.**

### 1.4 SaaS product

The seller hosts the software; the buyer subscribes through Marketplace and
hits an endpoint the seller operates. Two integration shapes: subscription
(hourly / fixed monthly via `RegisterUsage`) and contract / pay-as-you-go
(custom metering via `MeterUsage`).

**Technical requirements:**

- Implement the AWS Marketplace **Fulfillment API** to provision new customers
  and resolve their entitlement when they first land at the seller's URL after
  subscribing.
- Implement webhook handling for entitlement lifecycle events (subscribe,
  unsubscribe, plan change).
- For metered billing, call `MeterUsage` per hour per dimension per customer.
- Starting **June 1, 2026**, all new SaaS products must support **Concurrent
  Agreements** (a buyer holding overlapping entitlements from multiple
  agreements).

**Identity model:** the buyer authenticates to the seller's hosted endpoint;
the marketplace passes a one-time token via Fulfillment API to bond the
marketplace subscription to the seller's user record. **The seller operates
the service**; this is the opposite of the v11 strategy's self-custodial
posture.

**Fit to the Bridge:** **explicitly not the MVP shape.** v11 §2.2 names the
distinction directly: "The Bridge is forkable: open-source software, runnable
anywhere, with cloud-marketplace deployment a first-class commitment. The Hub
is forkable in code but not in position." The SaaS product type IS the Hub's
listing shape, not the Bridge's. **For O2 (the Capability Hub), SaaS becomes
the canonical listing.** For O1, SaaS contradicts the self-custody promise.

### 1.5 CloudFormation Quick Start

Not a Marketplace product type. CloudFormation Quick Starts are reference
architectures Amazon publishes for popular open-source projects; they are
**community / partner artifacts**, not commercial listings. They cannot be
metered or sold through them. The Bridge could publish a Quick Start as a
no-cost on-ramp ahead of (or alongside) a Marketplace AMI listing, but it
does not substitute for any of §1.1-§1.4. Mentioning here for completeness
because the dispatch prompt named it; the answer is "not a marketplace shape,
treat as supplementary marketing material."

### 1.6 AWS product-shape summary

| Shape | When | Fit for Bridge | Why |
|---|---|---|---|
| Single AMI | O1 launch | **Primary** | Simplest review pipeline, directly maps to v11's "click deploy and run in own account," lowest buyer-side prerequisites. |
| AMI+CFT | O1 graduation | Secondary | Right shape once the Bridge wants ALB / IAM / S3 / DynamoDB provisioned alongside. Carries the `gateway-aws-deployment` design that the resequencing draft pulls into M5. |
| Container | O1 second listing | Useful | Already produced by PR #412's `packaging/docker/` recipe; appeals to operators with existing ECS / EKS estates. Non-root-ready via PR #410's `User=endo`. |
| SaaS | O2 only | **Wrong shape for O1** | Contradicts self-custody. The right shape for the Hub. |
| CloudFormation Quick Start | Marketing supplement | Adjacent | Not a marketplace product type; community-architecture publication. |

---

## 2. Gateway integration: what PR #410 + PR #412 compose into, and what's missing

### 2.1 What is already landed (DRAFT) toward a marketplace-ready artifact

Per the in-flight gateway stack (status as of 2026-06-03; verify current state
before submission):

- **PR #410** (`feat/endo-gateway-cli-systemd`, DRAFT): CLI wrapper
  (`endo gateway start/stop/log/run/where/install-systemd`), per-platform
  state locations resolver (Linux / macOS / XDG with per-dir env overrides),
  systemd unit (`packages/gateway/systemd/endo-gateway.service`, hardened
  directives, `User=endo`), launchd plist
  (`packages/gateway/systemd/com.endojs.endo-gateway.plist`),
  `docs/system-service.md`. 416 gateway tests + 23 CLI tests pass.
- **PR #412** (`feat/endo-gateway-distribution`, DRAFT): five OS packaging
  recipes: `packaging/debian/` (.deb), `packaging/rpm/` (.rpm),
  `packaging/arch/` (PKGBUILD), `packaging/docker/` (Dockerfile),
  `packaging/brew/` (Homebrew formula), `docs/packaging.md`. Six commits,
  +1446 lines. Sibling to PR #410, not stacked.
- **PR #413** (`design/gateway-package-phase-11`, DRAFT): HTTP listener
  wire-up. `src/http-listener.js` (portable Node HTTP listener exo;
  X-Forwarded threaded; Host-header AppsNameHub lookup), `src/node-ws-upgrade.js`
  (Node WS adapter wrapping `ws.WebSocketServer({noServer: true})`). 471
  gateway tests pass. `httpListener` defaults OFF during rollout.

These compose: the handler library (#343 + the phase 2-10 stack) becomes a
runnable service via #413's listener; #410's CLI wrapper composes with #413's
listener so the operator runs `endo gateway start` and a real HTTP server
binds; #412's distribution recipes deploy the resulting binary as a .deb,
.rpm, PKGBUILD, Dockerfile, or Homebrew formula.

### 2.2 What composes into a Marketplace AMI

A single-AMI Marketplace listing builds, in principle, on the .deb (Debian /
Ubuntu) recipe from PR #412 plus the systemd unit from PR #410. The Packer
build would (a) start from an approved base AMI (Amazon Linux 2023 or Ubuntu
LTS), (b) install the .deb (or equivalent .rpm), (c) enable the systemd
service, (d) apply the AMI-requirements hardening (sshd config, no password
auth, no pre-seeded keys, no embedded credentials), (e) run the AWS
Marketplace scanner, (f) submit.

**This is the path of least resistance.** The .deb / .rpm artifacts the
resequencing draft hangs the "marketplace appliance" story on already exist
on `feat/endo-gateway-distribution` (PR #412). The systemd / launchd / Windows
gaps live on PR #410 (Windows Service is documented as deferred per the PR
#410 result entry).

### 2.3 What is missing for an AWS submission

Cross-referencing the resequencing draft's gap inventory (§3) against what is
not yet on `llm` or `master`:

- **G-tls-firstboot (`gateway-bundled-tls`)**: **missing and load-bearing.**
  The gateway refuses TLS by design (gateway-package Feature 9 is proxy
  *compatibility* with `X-Forwarded` headers, not TLS termination). A
  marketplace AMI must terminate TLS somewhere inside the image, which means
  bundling a reverse proxy (Caddy or nginx) + ACME client and obtaining a
  certificate autonomously at first boot. The resequencing draft recommends
  **Pattern 1: vendor-delegated subdomain with pre-provisioned CNAME**
  (`<node-id>.nodes.example.com`, vendor-controlled DNS, DNS-01 challenge,
  no operator DNS configuration at first boot). This requires the vendor
  (the publisher: us) to run a DNS provisioning service for all issued
  nodes; the 90-day Let's Encrypt renewal requires the provisioning API to
  stay reachable. **This is the largest undesigned seam between the
  packaging track and the listing track.**

- **G-firstboot (`gateway-first-boot-ceremony`)**: **missing and
  load-bearing.** AWS Marketplace AMI requirements explicitly prohibit
  hardcoded secrets, pre-seeded SSH keys, and system / service passwords.
  This means the operator's initial bearer cannot be baked into the image.
  The node must *generate* its root bearer at first boot and deliver it
  via a channel the cloud operator can read but the network cannot (AWS
  instance user-data response, serial console, or a one-time token in the
  cloud console via instance tags). The resequencing draft scopes this as
  "the out-of-band bootstrap" and grounds it in ocap terms (first boot is
  the genesis endowment of root authority to the operator).

- **G-observability (`gateway-operator-observability`)**: **missing,
  required for production-readiness but not strictly for first listing.**
  Operator-facing logs and metrics, structurally incapable of being member
  surveillance. The resequencing draft scopes this with the surveillance-vs-
  observability tension named explicitly.

- **G-upgrade (`gateway-upgrade-channel`)**: **missing, required for
  listing maintenance.** Marketplace continuous-compliance scan (per
  `web--aws-marketplace-ami-requirements--technical-security--continuous-compliance`)
  means products falling out of compliance are pulled from new subscribers
  until issues are resolved; AMIs older than two years are disallowed. A
  working signed-update channel is a **listing-maintenance requirement**,
  not a launch nicety. The resequencing draft proposes TUF-shaped
  Root / Targets / Snapshot / Timestamp role hierarchy with offline keys
  for Root / Snapshot / Targets and an online Timestamp key on vendor
  build infra.

- **G-state-custody (`gateway-state-custody`)**: **missing, brand-promise
  weight.** v11 §3.2 names "self-custodial" as the credibility story at
  launch. Backup, restore, and cloud-to-cloud migration of node state must
  be designed because the brand promise of credible exit (v11 §4.3) requires
  it; without it "you can leave" is not concretely true.

- **G-resource-classes (`gateway-resource-classes`)**: **partial, must
  resolve before Custom Metering publication.** The AMI's MeterUsage
  dimensions are locked at publication; the 15-character alphanumeric
  dimension-name limit binds the class names. The resequencing draft
  §3.1 calls out that `computrons` exists, `cogitrons` is new vocabulary,
  and the design must choose names that survive the AWS lock. **The
  decision flows directly into the marketplace listing form.**

- **`gateway-aws-deployment`** (referenced as Proposed but absent from
  `llm`, per scout `8f5fb7` discrepancy 2): **missing.** The
  CloudFormation-template content for an AMI+CFT listing lives in a
  design that is not yet on the roadmap branch.

**Net gap to ship an AWS single-AMI listing of the Capability Bridge:**

1. Bundle a reverse proxy (Caddy recommended for built-in ACME) into the
   .deb / .rpm produced by PR #412, and the AMI built from it. Implement
   the vendor-delegated DNS-01 first-boot pattern. (G-tls-firstboot)
2. Implement the first-boot ceremony: node generates root bearer on first
   start, writes it where the operator can retrieve it (AWS user-data or
   serial console); operator authenticates over the
   self-signed-or-vendor-cert setup endpoint. (G-firstboot)
3. Decide and lock the Custom Metering dimensions; pick names that fit the
   15-char limit; ship Custom Metering integration in the gateway's
   ResourceLedger Phase 8 output. (G-resource-classes + G-marketplace)
4. Land the AMI-builder pipeline (Packer or equivalent) and the
   `gateway-packaging-ci` design (referenced as Proposed, absent from
   `llm`). The CI must produce an AMI in `us-east-1` that passes the
   Marketplace scanner.
5. Open Marketplace seller registration (tax + banking) and submit the
   first AMI version through the self-service Build flow. Budget 2-4
   calendar weeks from first submission to public publication.

**Items deferred safely past first listing** (can be follow-ups after the
AMI is live and selling, but **before** continuous-compliance starts
flagging compliance drift): G-upgrade (the TUF channel; until it ships,
plan to re-submit a new AMI version every 12 months at most), G-state-custody
(critical for brand promise; can ship in the second AMI version).

---

## 3. MCP-first staging: the minimum-viable artifact

The dispatch asks for the smallest shippable cut that terminates MCP for a
single buyer with attenuated capability grants per `designs/endo-gateway-mcp.md`
on the `llm` branch.

### 3.1 What the MCP design actually requires (per the resequencing §1.2 and the prior scout's Part 2)

The MCP-bridge milestone M6 P1 ("MCP termination") is gated on
gateway-package phases 2 (UDS bootstrap), 7 (admin / AppsNameHub), and 8
(ResourceLedger). **But not on phases 10 or 11**. M6 P1 implements:

- Extract `@endo/agent-tools` (the tool surface the MCP adapter publishes).
- Bearer-token table + `publishAgent` (per-agent bearer that the MCP client
  authenticates with).
- `/mcp` adapter + SSE (Server-Sent Events transport, current MCP convention).
- Chat-side affordances (the "Add agent" button and the "retrieve the MCP
  configuration block" affordance from `endo-gateway-mcp.md` § Chat-side UI).

### 3.2 The smallest shippable MVP that satisfies v11's MCP+OAuth promise

The strategy doc's MVP is more demanding than M6 P1 alone:

- v11 §3.2 names OAuth authentication for the MCP bridge.
- v11 §3.2 names "constructible and revocable capabilities" via subagent
  spawning.
- v11 §3.2 names service adapters (Gmail, Slack, generic OAuth-2, GitHub)
  chosen for demo clarity.

These are larger than M6 P1's MCP termination. The minimum cut that ships
v11's MVP is:

1. **M6 P1 (MCP termination):** the resequencing-derived O1 critical path
   Track A; everything in the prior bullet list.
2. **G-firstboot:** without it, the operator cannot retrieve their first
   bearer on a fresh marketplace AMI. M5 work; absolute prerequisite.
3. **G-oauth-bonding (M5 P4 design slice):** OAuth identity bonding so the
   MCP bridge can authenticate operators with familiar accounts. The
   resequencing draft's "design-forward, implementation can trail" framing
   means the *bearer-token-only* path (already Implemented, per
   `gateway-bearer-token-auth`) can ship the MVP, with OAuth bonding as a
   fast-follow in the first update. **Recommended decision:** ship the MVP
   on bearer-token authentication for MCP and add OAuth bonding in v1.1.
   This collapses MVP scope materially.
4. **At least one service adapter** (Gmail or GitHub) bundled in the AMI as
   a worked example of attenuated capability grant. The strategy names
   GitHub as "attractive because, despite having fine-grained tokens, it
   still lacks sufficiently narrow roles." This work is *on top of* the
   gateway stack; the service adapter lives in `@endo/agent-tools` or a
   sibling. **Scope this as 1 adapter for first listing**, 3 by general
   availability.
5. **G-marketplace + G-tls-firstboot + the AMI build pipeline** (per §2.3).

### 3.3 The smallest shippable cut, as a checklist

If the maintainer wants a single-AMI shipped in three months, the
critical-path cut is:

- Gateway-package phases 2, 7, 8 merged to `master` (already in flight as
  PRs #388-#397).
- Phases 9, 10, 11a (relay, proxy compat, OS packaging) merged
  (PR #410 + PR #412 + PR #413 progression to GA).
- M6 P1 (`@endo/agent-tools` extraction, `publishAgent`, `/mcp` adapter,
  SSE, Chat-side affordances) merged.
- G-firstboot designed and implemented.
- G-tls-firstboot designed and implemented (bundled Caddy + ACME).
- G-resource-classes designed (dimension names locked).
- G-marketplace AMI build pipeline (Packer or similar).
- One service adapter (recommend GitHub for demo clarity per v11 §3.2).
- AMI submitted to AWS Marketplace; 2-4 weeks for review.

Items explicitly excluded from this cut (per v11 §3.3): hosted personal
agent, attached inference, payment metering at the user surface,
federation. All of those are O2 / Hub work.

### 3.4 The "MCP-first staging" framing

Calling this "MCP-first" reflects the strategy's positioning: lead with the
MCP+OAuth bridge story because that is where the AI-tool-connectivity market
is consolidating (v11 §3.1: "MCP is where AI tool connectivity is
consolidating ... We have a brief window. Either a platform vendor builds
capability attenuation into the spec, or a competitor claims the category").

**The MVP listing is single-tenant, single-buyer, single-operator.** That
matches both the gateway-package design's "self-custodial node" framing and
v11's "in their own cloud account ... bring your own inference." Multi-buyer
shapes (one publisher, many operators) come naturally because each
marketplace transaction creates an independent AMI launch in an independent
AWS account; the publisher does not host anything.

---

## 4. Designated-keys relaying: what extends from O1 to O2

The dispatch frames O2 (per the resequencing draft) as "community-hub
relaying ... relaying services on behalf of users with designated keys." The
strategy doc names this as the Capability Hub: hosted, federated,
OCapN-native, with two reach axes ("down" to phones / workstations as ocap
peers, "laterally" to other hubs and peers).

### 4.1 What extends from the O1 artifact

The O1 single-AMI artifact ships:

- A `@endo/gateway` package configured as a self-custodial node.
- Bearer-token (and post-MVP, OAuth-bonded) operator identity.
- ResourceLedger for per-account counters (compute / storage / network).
- `verifyPaymentProof` injection point for billing (Stripe self-host, or
  AWS MeterUsage when sold as a Paid-Usage AMI).
- MCP termination at `/mcp` with per-agent bearer tokens.
- Bundled TLS + first-boot ceremony.

The gateway-package design's "one factory, many configurations" property
(per `library/sources/endo-but-for-bots--llm-designs-gateway-package.md`) is
the critical asset here: the *same `@endo/gateway` code* runs as
developer-install, system-service, Familiar-bundled fallback, **or** public
relay, depending on configuration.

### 4.2 What O2 requires beyond O1

Per the resequencing draft §2 (the proposed M7 Community Hub milestone, with
gaps §3.7-3.8):

- **`endo-gateway` Open Question 2 (the virtual-users mode):** the
  multi-tenant variant where the operator manages member accounts without
  one OS account per member. Currently deferred in `endo-gateway.md`. **This
  is the spine of O2.**
- **G-hub-invitation (`gateway-hub-membership`):** operator invites a
  member to a managed account on the operator's node, not a peer
  relationship between two self-custodial nodes. Distinct from
  `familiar-deep-link-invitations` (peer-to-peer).
- **G-multitenancy (`gateway-multi-tenant-isolation`):** per-member
  isolation of CAS, formula store, capability grants within one
  operator's node.
- **G-hub-economics (`gateway-hub-economics`):** member billing vs operator
  billing. O1 bills one operator; a hub must decide whether members pay
  the operator, the operator pays for all members, or a split.
- **G-abuse-moderation (`gateway-abuse-moderation`):** moderation tools an
  operator has given that end-to-end Noise encryption means the operator
  routes ciphertext and cannot read it.
- **G-operator-liability (`gateway-operator-liability-survey`):** the
  "Mastodon-instance-operator problem" the canon names. Survey-only;
  posture-deciding remains the maintainer's call.

### 4.3 "Designated-keys relaying" framing

The dispatch phrase "relaying services on behalf of users with designated
keys" maps onto:

- **The relay role** in the gateway-package design (Feature 6: frame-relay
  without decryption; the gateway is a frame relay and never decrypts
  member traffic).
- **OCapN-Noise transport** as the cryptographic substrate for
  member-to-hub sessions (`ocapn-noise-network`, Complete, PR #137).
- **`daemon-agent-network-identity`** for per-member Ed25519 identity
  (the keypair side, M4).
- **The Capability Bridge's MCP+OAuth surface relayed forward**: a hub
  member's authority to call upstream services (Gmail, Slack, GitHub via
  OAuth) is delegated through the hub's capability machinery; the hub's
  operator does NOT see the upstream credentials because they live in the
  member's persona's namespace.

### 4.4 The O2 listing shape on the marketplaces

Once O2 is implemented, the *Hub* is what gets listed as a SaaS product (per
§1.4 of this report) on AWS / Azure / GCP marketplaces, because the Hub is
seller-operated, not buyer-operated. The Hub is the SaaS shape; the Bridge
is the AMI / container shape. The two listings coexist; v11 §4.2 calls the
cannibalization "the plan, not the failure mode."

### 4.5 Distance from O1 to O2 expressed as gaps

The resequencing draft makes the distance concrete: **five gap design files**
new in the proposed M7 milestone (the four §3.8 gaps plus G-hub-invitation
in §3.7), plus the virtual-users mode in `endo-gateway` Open Question 2
moving from "deferred" to "implemented." Plus the SaaS Fulfillment API
integration on each cloud marketplace.

**Sequencing note:** the O2 artifact does NOT need to redesign O1's
marketplace listing. It is a *new* listing alongside the AMI listing. The AMI
listing continues to serve self-custodial operators (and continues to
generate marketplace revenue); the SaaS listing serves federation customers
who want hosted convenience. v11 §7 names both tiers in the business model.

---

## 5. Azure + GCP comparison

The companion scholar had not returned at write time; the AWS section is
grounded in the library, while the Azure and GCP sections cite the web sources
the scout fetched directly. **Mark this section as "to be re-verified against
the scholar's shelved material when it lands."**

### 5.1 Azure Marketplace (Microsoft commercial marketplace)

**Artifact shapes:**

- **VM offer** (analogous to AWS single-AMI): the operator deploys a VM image
  to their Azure subscription. Requires HVM-equivalent virtualization; OS
  disks and Data disks must use implicit managed disks; image must be
  deployable from the Azure Portal or PowerShell scripts; the first 1 MB
  (2,048 sectors) of the OS disk must remain empty for Azure metadata.
- **Container offer:** for Kubernetes deployments via the buyer's AKS
  cluster. Helm-chart-based, similar in shape to the AWS EKS add-on path.
- **SaaS offer:** seller-hosted, marketplace handles billing via the
  Fulfillment API + Marketplace metering service.
- **Managed application:** seller-provisioned ARM template deployed into the
  buyer's subscription; closest analog to AWS AMI+CFT but Azure-specific.

**Listing review pipeline:**

- Publisher registration through Microsoft Partner Center; approval for the
  VM billing plan.
- For VM offers: upload VHD (with a SAS URI valid for at least 3 weeks from
  creation); run the Azure Certification Test Tool.
- Azure validates the image is bootable, secure, and compatible with Azure.
- Submission via Partner Center.

**Metering integration (SaaS / metered billing):**

- Implement the Marketplace Fulfillment API + webhook handling.
- For metered billing: define dimensions before publishing; call the
  Marketplace metering service API per dimension per customer per hour.
- Emit usage hourly for the past hour, only if there is usage; max 24-hour
  delay before events are not accepted; the best practice is to emit at the
  end of each hour. Available **only on the flat-rate billing model**; does
  not apply to per-user billing.

**Identity model:** buyer authenticates via Microsoft Entra ID (formerly Azure
AD). SaaS offers can integrate with Entra ID for single sign-on. For VM
offers, identity is the Azure subscription holder (analogous to AWS account).

**Cost-to-list:** Partner Center membership (free for ISVs); no listing fees;
co-sell programs (IP Co-Sell Eligible) require additional commitments and
revenue thresholds that are not relevant to the O1 MVP.

**Review cadence:** Microsoft does not publish a single canonical
business-day count comparable to AWS's 7-10. Practitioners report 1-3 weeks
for VM offers; the Certification Test Tool is the gating step.

### 5.2 Google Cloud Marketplace

**Artifact shapes:**

- **VM solution** (analogous to AWS single-AMI): deploys software to and runs
  on Compute Engine; uses a Cloud-Marketplace-hosted image with an attached
  Compute Engine license.
- **Kubernetes app:** deploys to the buyer's GKE cluster via Helm-equivalent
  manifests.
- **SaaS / integrated SaaS:** seller-hosted; GCP manages metering for
  usage-based pricing via Service Control APIs.

**Listing review pipeline:**

- Submit product through GCP Marketplace partner program.
- GCP Marketplace team verifies the image deploys and uninstalls
  successfully, runs unit tests, scans for vulnerabilities.
- Critical security issues require the publisher to update.

**Metering integration (SaaS):**

- Every SaaS listing implements **Procurement API handlers** for entitlement
  lifecycle events, account association, and usage reporting.
- Usage reporting goes through **Service Control** (Google's metering plane).
  Unique among the three: Google **manages metering and dynamically bills**
  on the publisher's behalf, so the publisher reports metrics but does not
  call a per-hour metering API in the same shape as AWS or Azure.
- Buyers see a single consolidated invoice from Google Cloud that includes
  SaaS purchases AND infrastructure costs.

**Pricing models:** usage-based (per-metric), subscription (flat monthly fee
prorated), combined (subscription + usage above a quota).

**Identity model:** buyer authenticates via Google Cloud Identity; the
publisher can require Google account or federate to the buyer's identity
provider. For VM solutions, the buyer is the GCP project owner.

**Cost-to-list:** Marketplace partner registration is free; certain
commitments (co-sell, partner advantage) layer additional revenue-share or
investment requirements; not relevant to O1 MVP.

**Review cadence:** GCP does not publish a canonical timeline either;
practitioners report 2-4 weeks for VM solutions, somewhat slower than Azure.

### 5.3 The same-image-vs-different-packaging question

**Same artifact, three packagings.** A core observation: the **OS-level**
artifact (the gateway daemon + its dependencies + a bundled reverse proxy +
the first-boot ceremony script + the systemd unit) is the same on all three
clouds. What differs is the **outer wrapper**:

| Cloud | Wrapper | What changes |
|---|---|---|
| AWS | AMI (raw disk image) | Packer build targeting `us-east-1`, SSH config per AMI policy, MeterUsage integration. |
| Azure | VHD (virtual hard disk) | First 1 MB reserved for Azure metadata, managed-disk format, Marketplace metering service integration. |
| GCP | GCE image | Compute Engine license attachment, Service Control metering integration. |

**The .deb / .rpm produced by PR #412 is the common substrate.** Each
cloud's build pipeline installs the .deb (or .rpm) into a base image of the
appropriate kind, applies cloud-specific hardening, and ships. The
gateway-package design's "one factory, many configurations" property
materializes one rung up: one binary substrate, three cloud-specific
packagings.

**The MeterUsage / metering-service code is the only material per-cloud
divergence in the gateway code itself.** Each cloud's billing API has a
different shape:

- AWS: `MeterUsage` over the AWS SDK; dimension names 15-char alphanumeric;
  locked at publication.
- Azure: Marketplace metering service over REST; dimensions defined before
  publishing; available only on flat-rate billing model.
- GCP: Service Control over gRPC; Google manages billing on the publisher's
  behalf; report-metrics shape, not call-meter-per-hour shape.

The gateway-package design's payment-processor abstraction (`PaymentProcessor`
contract, with `verifyPaymentProof(tokens, proof)` injected per cycle 174's
shelved §resource-ledger-in-gateway-not-daemon decision) is the right
abstraction for this divergence: ship three adapters (one per cloud) behind
one interface.

### 5.4 Does any of them admit SaaS only?

None of the three is SaaS-only. All three support a buyer-deploys-to-own-
account shape (AMI / VHD / GCE image) that fits the v11 self-custody
posture. All three support a seller-hosts-and-buyer-subscribes SaaS shape
that fits the v11 Hub posture. The three are commercially symmetric in
shape; they differ in implementation detail and review cadence.

---

## 6. Recommendation

**AWS-first sequencing, with parallel Azure + GCP listing as a deferred
graduation.** Not engage-all-three at MVP; not parallel-MVP. The reasoning,
with the trade-offs surfaced:

### 6.1 Why AWS first

1. **Library coverage and dispatched scholar artifact.** The library already
   carries the canonical AWS Marketplace AMI and container requirements
   (5 sections under `cloud-marketplace`); the in-flight `scholar--302d34`
   is shelving Azure and GCP, but the AWS material is the only set
   currently verified at scholar-quality. Acting on what is grounded is
   cheaper than acting on what is half-grounded.
2. **Customer concentration.** AWS Marketplace is the largest of the three
   by transaction volume; the AI-developer audience the strategy targets
   (v11 §3.1: MCP ecosystem, Anthropic / Cursor / Windsurf users) skews
   AWS-heavy.
3. **MeterUsage's dimension-lock is the most constraining; locking it
   first forces the G-resource-classes design to fully resolve.** Azure
   and GCP are more permissive on metering naming, so an AWS-acceptable
   set of dimensions is automatically acceptable on the other two; the
   reverse is not true.
4. **The gateway-package design's "external TLS via reverse proxy"
   decision (Feature 9) and the bundled-TLS first-boot ceremony are
   identical across the three clouds.** Doing the design once during
   AWS preparation produces an artifact that ships to Azure and GCP with
   only the cloud-specific wrapper changing.
5. **Review-cadence asymmetry.** AWS's 2-4 calendar weeks is the slowest
   of the three; starting AWS first means parallel work on Azure / GCP
   begins inside the AWS review window. (The 45-day lead for planned AWS
   releases and the 90-day price-change lock also argue for an early
   AWS pin.)

### 6.2 Why not engage-all-three at MVP

1. **Three metering integrations triple the per-cloud-specific code
   surface** at the moment the design is least settled. The MeterUsage
   dimension lock is irreversible; getting it wrong on one cloud is
   recoverable, getting it wrong on all three simultaneously is a
   re-launch.
2. **The Fulfillment API integrations** (required for SaaS shapes on all
   three clouds) are per-cloud and additive. Deferring them to O2 (the
   Hub) keeps the O1 surface focused on the cloud-VM-image shape.
3. **Each marketplace's review pipeline has its own quirks.** Submitting
   three listings simultaneously means resolving three independent review
   feedback loops. Sequential submission lets each loop's lessons feed
   the next.

### 6.3 Why not AWS-only forever

1. **v11 §3.2 names "AWS Marketplace, GCP Marketplace, Azure Marketplace"
   as the commitment.** A single-cloud listing makes the self-custody
   message weaker (the user is locked to one cloud's pricing).
2. **The Azure Entra ID / Microsoft 365 OAuth provider mix overlaps the
   GitHub / Gmail adapters the MVP demonstrates** (v11 §3.2); Azure
   buyers' provider preferences argue for Azure listing within 6 months
   of the AWS launch.
3. **GCP's `Service Control`-managed-billing model is meaningfully
   simpler** for the publisher than AWS / Azure's call-per-hour shapes;
   shipping GCP after the AWS / Azure metering work is largely a code-
   subtraction exercise.

### 6.4 The recommended sequencing

```
Phase O1.a (months 0-3): single AWS AMI listing.
  - Gateway phases 2/7/8 to master (in flight: PRs #388-#397).
  - Gateway phases 9/10/11a to master (PRs #410, #412, #413).
  - M6 P1 (MCP termination) to master.
  - G-firstboot, G-tls-firstboot, G-resource-classes designed + implemented.
  - G-marketplace + AMI build pipeline (Packer).
  - GitHub OAuth adapter (one demo adapter).
  - Submit AWS AMI; budget 2-4 weeks for review.

Phase O1.b (months 3-5): Azure VHD listing + GCP GCE listing.
  - Add Azure metering adapter behind PaymentProcessor.
  - Add GCP Service Control adapter behind PaymentProcessor.
  - Add cloud-specific Packer build targets (VHD, GCE image).
  - Add G-state-custody and G-observability designs (now critical for
    multi-cloud "credible exit" claim per v11 §4.3).
  - Submit Azure and GCP listings in parallel (within their respective
    review cadences, both ~1-3 weeks).

Phase O1.c (months 5-8): G-upgrade (TUF signed-update channel) lands.
  - Marketplace continuous-compliance requires a working update channel
    before the 2-year AMI staleness threshold triggers.
  - The vendor publishes signed updates; deployed nodes auto-pull.
  - Same shape across AWS / Azure / GCP because the TUF metadata is
    cloud-agnostic.

Phase O2 (months 8+): Capability Hub.
  - `endo-gateway` Open Question 2 (virtual-users mode) implemented.
  - G-hub-invitation, G-multitenancy, G-hub-economics, G-abuse-moderation,
    G-operator-liability designs landed (per the resequencing draft).
  - Hub listed on each cloud as SaaS (Fulfillment API + metering on each).
  - The AMI / VHD / GCE listings continue to serve self-custodial
    operators in parallel. Cannibalization is the plan (v11 §4.2).
```

### 6.5 The single-most-important sequencing recommendation

**Author G-resource-classes before any marketplace submission, and have it
panel-reviewed.** The AWS MeterUsage dimension-lock is the only irreversible
commercial decision in the O1 phase. Every other choice (TLS pattern,
first-boot delivery channel, OAuth bonding, state-export format, update
channel) admits a graceful v1.1; dimensions do not.

---

## 7. Open Questions for the maintainer

1. **Companion scholar gap.** The `scholar--302d34` dispatch (shelving Azure
   / GCP canonical references) had not returned at the time this report was
   written. The Azure and GCP sections (§5.1, §5.2) are grounded in this
   scout's own web searches, not in scholar-shelved library entries. The
   liaison should re-verify those sections against the scholar's output when
   it lands, and the librarian may need to backfill `library/topics/`
   entries for Azure / GCP equivalents to the existing `cloud-marketplace`
   topic.

2. **SaaS vs AMI as the MVP shape.** v11 §3.2 names self-custody as the
   "credibility story at launch" and the MVP as buyer-deploys-to-own-account.
   This is the AMI shape (or AMI+CFT / container). Confirm the AMI is the
   right MVP product type, not SaaS. The recommendation in this report is
   AMI; the resequencing draft and v11 align on AMI; flagging because the
   dispatch prompt named all four shapes neutrally.

3. **Single-AMI vs AMI+CFT at launch.** Single-AMI is simpler to submit and
   maintain; AMI+CFT delivers an architecturally-correct deployment in one
   click but pulls the absent `gateway-aws-deployment` design into the
   critical path. Recommend single-AMI for launch, graduate to AMI+CFT in
   v1.1 once `gateway-aws-deployment` lands.

4. **MeterUsage dimensions: lock now or defer Custom Metering?** The
   alternative to Custom Metering is Paid Hourly (a flat per-hour price per
   instance type, metered automatically). Paid Hourly is simpler and
   reversible. But it does not let the publisher charge per cogitron or
   per gigabyte of relay traffic, which is the v11 §3.2 inference-aware
   billing posture. The trade-off: ship Paid Hourly first (no dimension
   lock, easier to maintain) and add Custom Metering in a follow-up listing,
   OR ship Custom Metering first (irreversible dimensions, but the right
   commercial shape from day one). Recommend Custom Metering with
   conservative dimensions (the four resequencing-draft classes: compute,
   inference, storage, network) so the dimension lock has been thought
   through.

5. **Vendor-delegated DNS for TLS first-boot: operational commitment.** The
   recommended TLS pattern (DNS-01 with a vendor-delegated CNAME) requires
   *us* (the publisher) to run a DNS provisioning service for every issued
   node, and to keep it reachable for the lifetime of every deployed node
   (90-day Let's Encrypt renewal needs the API). This is a non-trivial
   operational commitment that contradicts the strategy's "we are not the
   custodian" posture in spirit. Confirm the maintainer is willing to run
   this DNS service, or pick an alternative pattern (TOFU self-signed, or
   operator-brings-domain DNS-01) with weaker UX.

6. **Marketplace listing as the "vendor" identity.** AWS / Azure / GCP all
   require a seller registration (tax, banking, an LLC or equivalent). The
   strategy's "kriskowal credentials" model (per the garden CLAUDE.md and
   `journal/projects/endo/README.md` § Identity and credentials) needs an
   adjacent **commercial-entity identity** that is not the maintainer's
   personal identity. Confirm the maintainer has or is creating a vendor
   entity for the marketplace listings.

7. **Service-adapter choice for MVP demo clarity.** v11 §3.2 names Gmail,
   Slack, generic OAuth-2, and GitHub. Recommend GitHub for first MVP
   (because of v11's explicit "GitHub is attractive because, despite having
   fine-grained tokens, it still lacks sufficiently narrow roles" framing),
   adding Gmail and a generic OAuth-2 provider by general availability.
   Confirm.

---

## Self-improvement

The dispatch named this scout in a role-stretch shape (technical
reconnaissance for a strategic decision, not the benchmarking shape the
scout role file describes). Per the prior precedent set by scout `8f5fb7`
on 2026-06-11 ("the role-stretch worked cleanly with the scout role's
evidence-discipline spirit; no structural lesson warrants a role file
change"), the same conclusion holds here: the scout role's
evidence-discipline, library-grounded, gap-naming, recommendation-with-
trade-offs posture transfers cleanly to the reconnaissance shape. No role
file change.

One observation worth surfacing to the gardener if it recurs: when the
maintainer's directive is a strategic-position question that depends on a
companion scholar dispatch's output, the orchestrator's dispatch ordering
matters. Issuing scout and scholar in the same minute means the scout often
writes its result before the scholar returns; the scholar's library
contributions then arrive after the scout's report has already been read.
The shape that absorbs this: dispatch scholar first, let it return, then
dispatch the scout with `refs:` to the scholar's result entries. This is a
one-off observation, not a recurring pattern in this scout's experience.
below the gardener threshold; surfacing here for the next caller to weigh.

Self-improvement: nothing this time.
