---
role: designer
---

designer job (minion.town — `kriscendobot/minion.town`, deployed on AWS at
https://minion.town behind the oauth2-proxy → Caddy login gate). Design-only:
produce a `designs/*.md` in the minion.town repo (spec, no live change), per the
designer definition of done.

## Goal

Design the next step for minion.town: turn the authenticated web surface into a
**control surface for a per-user Endo "Pet Daemon" guest**, driven through the
minion.town MCP, with Claude as the first-class client.

Work the objectives in this ORDER — each is a validation gate before the next:

1. **Validate the MCP works with Claude (first, before anything else).** Confirm
   that the MCP already served by minion.town (`handle /mcp*` → app on :3000,
   plus `/.well-known/oauth-protected-resource*`) is reachable and usable by
   **Claude specifically** as an authenticated client: Claude authenticates to
   the minion.town MCP and exercises it as a control surface. Design what
   "validated" means concretely — the auth handshake Claude uses (OAuth /
   protected-resource metadata), a minimal tool surface to prove round-trips, and
   the acceptance test. This gate must pass before daemon work begins.

2. **Stand up an Endo daemon as a systemd user/system unit on the box** such that
   the MCP controls an **Endo Guest**. Design the unit (lifecycle, ownership,
   restart, where it binds, how the app/MCP reaches it), and the control path from
   an MCP tool call → the daemon → a guest capability. Mirror the existing deploy
   discipline (`deploy/aws/scripts/*`, SSM-driven, secrets via Secrets Manager +
   presigned S3, config shipped from the repo). Reference the Endo direction the
   maintainer has set: grow `@endo/gateway` + `@endo/mcp` organically with the AWS
   deployment; Endo work targets `endojs/endo-but-for-bots` @ `llm` (not the old
   kriscendobot/endo fork). The prior Docker-selfhost route (PR #134) was declined.

3. **Auto-provision one guest per OAuth credential.** Every authenticated
   identity gets its own Endo Guest ("Pet Daemon") provisioned automatically on
   first sign-in. Key the guest on the **same `iss+sub` identity the billing
   router already uses** (`X-Auth-Request-Sub`, the subject we just made resolve;
   see PR #3 / oauth2-proxy `additionalClaims: [sub]`) and the account store's
   provisioning hook. Design the provisioning trigger, idempotency, the
   guest↔identity mapping, and teardown.

4. **Prove the end-to-end loop: Claude ↔ minion.town MCP ↔ that user's Pet
   Daemon guest.** The headline acceptance criterion: Claude authenticates as a
   real minion.town user and drives that user's corresponding guest through the
   MCP as its control surface.

5. **Keep an eye open for impedance.** Design a set of *interesting design
   exercises* that rigorously test interacting with **remote** capabilities
   through the MCP, and surface impedance/mismatch (latency, capability
   granularity, error/lifecycle semantics, promise-pipelining across the wire,
   revocation) between the local Endo capability model and the remote MCP
   control surface. The deliverable should name concrete exercises and what each
   is meant to reveal.

## Mention but DEFER (do not design in depth now)

- **Metering + payment attenuation.** Future provisioning will connect the
  guest's **storage and compute metering** to the credits system already deployed
  (Stripe TEST-mode credits keyed on `iss+sub`), with **payment-attenuated**
  costs for the `@main` worker, `@fs`, and **formula creation**. Sketch where the
  seams are so today's design doesn't foreclose it, but leave the mechanism for a
  later design.
- **Storage/compute decoupling.** The above implies later decoupling the daemon's
  **storage** from its **compute** so they can be distributed across **S3** (state)
  and **EC2** (execution). Note this as a tentative future direction and defer;
  today's daemon may be single-box.

## Definition of done

A design doc under `designs/` that: (a) specifies the MCP-with-Claude validation
gate and its acceptance test; (b) specifies the Endo daemon systemd unit and the
MCP→daemon→guest control path; (c) specifies per-OAuth-credential guest
auto-provisioning keyed on `iss+sub`; (d) names the impedance-hunting design
exercises; (e) records the deferred metering/attenuation and storage/compute
decoupling as explicit future work with the seams identified. Spec only — no live
changes, no daemon stood up in this job.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  claimed_at: 2026-07-09T20:06:29Z
