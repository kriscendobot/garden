All work complete and durable. Inbox clean. Writing the completion report.

---

## Completion report — `design-gateway-authenticated-peer-identity`

**Deliverable:** `designs/gateway-authenticated-peer-identity.md` (309 lines), written for `endojs/endo-but-for-bots`. It addresses all four required deliverables, every code claim grounded in `file:line` (confirmed against `llm` HEAD `12a9aa4a6`).

**Where it landed (embargo-respecting):** committed on branch `design/gateway-authenticated-peer-identity` and pushed to the **bot fork** `kriscendobot/endo-but-for-bots` (commit `845f5ac9b`). **No PR was opened** and `designs/README.md` was **not** touched — per this job's directive not to open a public PR or publish without further authorization. This is "normal design flow minus the publish/PR step." Because no draft design PR is named here, the auto-gauntlet machinery is not (and should not be) triggered.

**What the design says:**
1. *Gap, per transport* — `greeter.hello(remoteNodeId, ...)` takes the peer's NodeNumber as a **self-asserted argument** on every transport (`manager.js` `hello`, only `assertNodeNumber` shape-check); `Gateway.provide` and `followRetentionSet` gate on argument shape, never caller identity. Transport table: loopback (n/a), tcp-netstring (no crypto), ws-relay (authenticates only daemon↔relay; discards the relay-attested `fromNodeId`), iroh (QUIC key **derived from the public NodeNumber**, so authentication is void for identity), ocapn (real agent-binding proof, but **only the dialer verifies the responder**; the inbound side runs no reciprocal check).
2. *Link to cross-peer following* — concrete sequence (mermaid): a peer claims `remoteNodeId = victim`, receives a victim-bound gateway, `followRetentionSet(victim)` leaks the victim's retained formula numbers, then `provide` turns those bearer tokens into the victim's capabilities.
3. *Mechanism* — a reciprocal agent-binding proof generalizing OCapN's, so the transport vouches for the peer's NodeNumber before `hello` scopes a gateway (`followRetentionSet` then takes no argument). Explicitly **non-uniform** where it must be: tcp-netstring and iroh-until-its-key-is-fixed get a degraded gateway with no cross-peer retention surface rather than a spoofable identity.
4. *Compatibility/migration* — staged path (land #978/#979 → additive permissive proof → iroh key re-derivation → mandatory flip); retention persistence is already NodeNumber-keyed, so no schema migration.

Two mermaid diagrams validated by parse (`OK sequence`, `OK flowchart-v2`). Design carries five maintainer-facing open questions.

**Maintainer notified** (`message-user`): design location, the deliberately-withheld review surface, and a request for the disclosure/landing decision plus confirmation of the #978/#979-first ordering.

**Follow-ups:**
- Maintainer disclosure decision needed before the review PR (draft against `llm`) and `designs/README.md` plan-sync happen. Tracked in `journal/jobs/plan/endo-retention-set-disclosure-hold.md`.
- Self-improvement lessons sent to the liaison: (a) add the semicolon-as-statement-separator gotcha to `skills/mermaid-validation`; (b) add an embargoed-design carve-out to `roles/designer`.

**Not verified:** the design is an argument from code reading, not an executed exploit — I did not run a live cross-peer following attack (nor should I under embargo). Mermaid parse-validation is the only real-execution evidence claimed.

Self-improvement: two lessons routed to the liaison (mermaid `;` gotcha; embargoed-design landing pattern).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-gateway-authenticated-peer-identity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (6779613 cached reads)
- Output: 62350 tokens
- Cost: $7.885659749999998
- Wall-clock: 958s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
