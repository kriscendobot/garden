---
ts: 2026-06-11T04:59:31Z
kind: result
role: researcher
project: endo
refs:
  - entries/2026/06/11/045450Z-dispatch-liaison-e41daf.md
---

The proposed designer prompt covers Workstream A of the Endo strategy brief: a resequencing proposal for the `designs/README.md` ledger that realigns milestones M3–M11 to the two-stage commercial objective (O1 self-custodial node, O2 community hub), inventories design gaps, and derives the O1 critical path. The refinement section below grounds the designer in the existing gateway, network-identity, OAuth, metering, app-sharing, and deployment designs already in the library, so the designer does not have to rediscover them from the raw `designs/` tree.

```markdown
## Library and project references

### Library concepts and sections

**Gateway stack (critical path for O1)**

- `journal/library/sections/endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations.md`
  The overarching `@endo/gateway` design (1157 lines, Proposed) driving Phases 1–11+ stacked PRs against master. Names the ten gateway features, their four-phase strategic rollout (Phase 4 = HTTPS proxy compat + OS packaging + relay + payment adapter), the resource ledger living in the gateway layer, and the seven open questions (including payment-processor identity and abuse-prevention for the public relay). Load-bearing for understanding what Phases 10 and 11 actually deliver and what they leave open.

- `journal/library/sections/endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay.md`
  Superseded-but-citable predecessor design (Proposed, 997 lines). Establishes the one-binary-two-modes architecture, the five named platform service targets (systemd / launchd / Windows Service / container / AppImage), TLS delegated to a reverse proxy, and the deferred "daemon hosting service" (virtual-users) variant that is structurally the O2 multi-tenant shape.

- `journal/library/sections/endo-but-for-bots--llm-designs-gbta--problem-and-auth-model.md`
  `gateway-bearer-token-auth` design: the existing bearer-token auth model (256-bit hex formula ID as credential, URL fragment not query param, `GatewayBootstrap.fetch(token)`). The O1 "first-boot ceremony" gap starts here — the design solves remote access for an already-configured node but does not address how an operator receives their token on a fresh deploy.

**OAuth bonding and identity (co-prioritized with MCP in brief §2)**

- `journal/library/sections/endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster.md`
  `endoclaw-oauth` design (Not Started): the canonical ocap OAuth pattern — the agent never sees the token; authority-to-use not authority-to-delegate; two-facet OAuth/OAuthControl split; six-step flow with daemon formula store holding the token. This is the endoclaw-cluster OAuth shape for agent-level OAuth; the `gateway-oauth-bonding` gap the brief names is distinct — it binds an OAuth identity to the operator's gateway-level public-key identity. The designer should scope the gap to the operator/node layer and cite this design as the agent-layer precedent.

- `journal/library/sections/endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth.md`
  `endoclaw-network-fetch` substrate that `endoclaw-oauth` wraps. Relevant because OAuth bonding at the gateway layer will likely need network-fetch primitives for the OAuth redirect or token exchange.

**Metering and resource classes**

- `journal/library/sections/endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter.md`
  `daemon-xs-worker-metering` design (Complete): XS-worker computron metering with admission control, three modes (Measurement / Quota / Rate-limited), budget-as-pre-payment, and burst ceiling. This is the existing metering layer the gateway's resource-ledger design (`gateway-resource-classes`) will need to expose through the billing interface. The keyword `computrons` (XS computation steps) is the existing metering unit; the brief's `cogitrons` (inference steps) is a named gap.

- Library keyword `resource-ledger-in-gateway-not-daemon` — the gateway-package design's Decision 8 establishing that per-account resource counters (compute seconds, storage bytes, network bytes) live in the gateway layer, not the daemon. Relevant to where `gateway-resource-classes` plugs in.

**Network identity and O2 foundations**

- `journal/library/sections/endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets.md`
  `daemon-agent-network-identity` design: every agent gets its own `NETS` special name pointing to its own networks directory, controlling which network addresses appear in locators. Foundation for per-agent anonymizing personas and for the multi-tenant network isolation O2 requires. The brief names this design explicitly as an O2 candidate.

**App sharing and deep-link invitations (O2 member onboarding substrate)**

- `journal/library/sections/endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline.md`
  `app-sharing-milestone` design (Proposed, Aaron-authored 2026-06-01): the milestone coordination document for peer app sharing. Three pillars: (1) signed installer, (2) `endo://` deep-link peer connect, (3) runnable and shareable apps. Pillar 2 owns `familiar-deep-link-invitations.md` (a named gap design not yet authored). The brief's "M8 app-sharing cut as the member-onboarding substrate" maps directly here; the designer should scope the O2 gap to what `app-sharing-milestone` does not yet cover for the hub/community context.

**Deployment and self-hosting**

- `journal/library/sections/endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline.md`
  `daemon-docker-selfhost` design (Not Started): Docker image with external TLS via reverse proxy (Caddy/nginx), state persistence, remote auth via bearer token. This is the closest existing design to the "marketplace packaging" gap; the designer should scope the gap to the remainder — AMI/container marketplace listing requirements, TLS and domain provisioning for a self-custodial node, and what Phase 11 (OS packaging) must satisfy beyond the Docker image already designed here.

**MCP protocol context**

- `journal/library/sections/mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum.md`
  MCP 2026-07-28 release candidate: stateless protocol core, Extensions framework, OAuth/OIDC alignment, 12-month deprecation floor. Relevant because the brief co-prioritizes MCP termination (`endo-gateway-mcp`, not yet in the library) alongside OAuth bonding. The MCP protocol is evolving toward OAuth alignment; the designer should note this as a dependency constraint on the `gateway-oauth-bonding` design.

**Capability theory and attenuation (brief §2 positioning)**

- `journal/library/concepts/object-capability.md`
  Object-capability model (Miller-Yee-Shapiro 2003): ambient authority, no ambient authority, the seven named properties. Load-bearing for the brief's "capability discipline" differentiator framing — the designer should ground gap problem statements in ocap vocabulary (attenuation, endowment, revocation, per-agent grants) rather than generic auth vocabulary.

### Project context

- `journal/projects/endo-but-for-bots/README.md` — rules of engagement, default branch (`llm` for designs, `master` for implementations), standing authorizations (post freely), authority structure (every commenter is maintainer-equivalent), identity conventions (`kriscendobot` for fork work).

- `journal/projects/endo/README.md` — upstream identity and credentials, authority structure (erights senior on ocap/ses topics), boatman handoff shape. Relevant if the designer encounters designs that touch `pass-style`, `ses`, or capability-security and needs to route erights-sensitive technical questions.

- `designs/README.md` on the `llm` branch of `endojs/endo-but-for-bots` — the live design ledger; the designer's worktree at `project/` carries it. Note the 2026-06-03 M1–M11 renumbering and M6 slice plan P0–P4. The library's ingested snapshot (`endo-but-for-bots--llm-designs-readme--overview.md`) is from 2026-05-11 and predates the renumbering; treat the live ledger in `project/` as authoritative over any library citation about milestone numbers.

- `designs/gateway-package.md` on `llm` — the canonical Phase 10/11 source; read from `project/` for current status.
- `designs/endo-gateway.md` on `llm` — the superseded predecessor; still citable for the virtual-users deferral (the O2 multi-tenant shape).
- `designs/daemon-docker-selfhost.md` on `llm` — the closest existing design to the marketplace-packaging gap.
- `designs/daemon-agent-network-identity.md` on `llm` — the O2 network-identity foundation.
- `designs/app-sharing-milestone.md` on `llm` — the app-sharing + deep-link-invitations coordination document.
- `designs/daemon-xs-worker-metering.md` on `llm` — the computron metering layer.

### Why each reference is relevant

| Reference | Connection to proposed prompt |
|-----------|-------------------------------|
| `gateway-package` section | Defines the Phase 10/11 scope, four-phase strategic rollout, and seven open questions the resequencing must resolve |
| `endo-gateway` section | Establishes the virtual-users deferral that maps to O2 multi-tenancy; names the five platform service targets Phase 11 must cover |
| `gbta` (bearer-token-auth) section | Existing first-boot auth shape; scopes the `first-boot ceremony` gap to what GBTA does not address (initial token delivery on a fresh node) |
| `endoclaw-oauth` section | Agent-level OAuth precedent; scopes `gateway-oauth-bonding` gap to the operator/node layer distinction |
| `endoclaw-network-fetch` section | Substrate for OAuth flows; relevant to `gateway-oauth-bonding` implementation path |
| `daemon-xs-worker-metering` section | Existing computron metering layer; `gateway-resource-classes` builds on it; defines the vocabulary gap (`cogitrons` as inference metering unit is new) |
| `resource-ledger-in-gateway-not-daemon` keyword | Establishes where per-account counters live; load-bearing for dependency ordering of `gateway-stripe-adapter` and `gateway-resource-classes` |
| `dani` (daemon-agent-network-identity) sections | O2 foundation: per-agent NETS, multi-key registration, anonymizing personas |
| `app-sharing-milestone` section | M8 substrate for O2 member onboarding; defines `familiar-deep-link-invitations` gap scope |
| `daemon-docker-selfhost` section | Closest existing design to marketplace packaging; scopes the remaining gap (AMI/container listing requirements, TLS provisioning, Phase 11 constraints) |
| MCP 2026-07-28 RC section | Protocol evolution context for MCP termination co-prioritization; OAuth/OIDC alignment constraint |
| `object-capability` concept | Vocabulary foundation for capability attenuation framing in gap problem statements |
| `journal/projects/endo-but-for-bots/README.md` | Design branch (`llm`), posting authorization, authority structure |

### Open questions

The following terms appear in the proposed prompt but have no concept page or indexed section in the library. The designer will encounter them as uncharted territory:

- **`endo-gateway-mcp`** (the MCP termination design slug named in the brief): no design file was ingested under this slug; the designer must read `project/designs/` to determine whether this design exists on the `llm` branch or is itself a gap to invent.
- **`gateway-oauth-bonding`**, **`gateway-key-recovery`**, **`gateway-stripe-adapter`**, **`gateway-resource-classes`**: the four ledger-named design gaps. None are ingested; each is either a stub or absent in `project/designs/`. The designer reads the live ledger to confirm.
- **`cogitrons`**: the brief's term for inference metering units. Not in the library; the metering vocabulary currently covers `computrons` (XS computation steps) only. A `gateway-resource-classes` concept page is a scholar candidate after the design is authored.
- **`endor`**: the Rust-hosted worker runtime. Mentioned in the brief's synthesis section. The library has `endo-but-for-bots--llm-designs-daemon-endor-architecture` section but no concept page indexing `endor` as a named runtime.
- **AWS Marketplace AMI/container listing requirements**: external reference; the library has no AWS Marketplace material. The brief notes the scholar may shelve external references; if a sibling scholar dispatch has done so, the designer should check `journal/library/sources/` for any newly added source under an `aws-marketplace-*` slug.
- **`familiar-deep-link-invitations`**: referenced in `app-sharing-milestone` as a gap design not yet authored. No ingested section for it exists in the library.
```

Library writeback: added 17 keyword shortcuts to `journal/library/keywords.md` for terms reached via flat-grep during this engagement. Terms added: `endo-gateway design`, `gateway-package design`, `gateway-bearer-token-auth design`, `bearer token gateway auth`, `daemon-agent-network-identity design`, `DANI design`, `app-sharing-milestone design`, `app sharing milestone`, `familiar-deep-link-invitations`, `deep-link invitation`, `endoclaw-oauth design`, `OAuth capability ocap`, `daemon-docker-selfhost design`, `docker self-hosting endo`, `MCP protocol stateless`, `MCP release candidate 2026`, `endoclaw-network-fetch design`. No concept pages drafted (existing sections were sufficient). No distractions pruned.

Open questions from this engagement:
- `endo-gateway-mcp` (MCP termination design): does it exist on the `llm` branch? The library has no ingested section for it.
- `gateway-oauth-bonding`, `gateway-key-recovery`, `gateway-stripe-adapter`, `gateway-resource-classes`: four ledger-named gaps with no library entries.
- `cogitrons` as inference metering unit: library gap; `computrons` is indexed but inference metering is not.
- AWS Marketplace listing requirements: no library source; requires scholar shelving if referenced in the final design.
- `familiar-deep-link-invitations`: gap design not yet authored; not in library.

Self-improvement: the researcher AGENT.md's Open questions guidance (§ Output shape step 4) correctly covers these unindexed terms, but a note-from-the-field could observe that for workstreams where the proposed prompt names multiple design *gaps* (not just existing designs), the Open questions section is the primary deliverable — the designer cannot be grounded in material that does not yet exist, only warned that it is absent. Consider adding a sentence to § Output shape noting that gap-heavy prompts will have proportionally larger Open questions sections than library-heavy ones.
