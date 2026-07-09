---
role: designer
---

designer job (minion.town — `kriscendobot/minion.town`). Revise the existing
design `designs/mcp-endo-guest.md` (delivered commit `c92a66c` on `main` by the
`minion-town-mcp-endo-guest-design` job) to fold in a maintainer directive of
record. Design-only; direct-to-`main` per the repo convention (no PR).

## Maintainer directive (2026-07-09)

**Do not lean on OAuth permission scopes for real access control.** Put the
access control in **object capabilities behind the tool calls** — the Endo guest
model, where a per-identity Pet Daemon guest holds *attenuated capabilities*
(payment-attenuated `@main` worker, `@fs`, formula creation) and a tool call
*exercises the caps it was granted* rather than checking a scope. Permission
scopes (`mcp/tools`, `mcp/minions:*`, the design's proposed `mcp/guest`) collapse
to a **thin outer authentication layer only**; per-action authorization is the
guest's ocaps, not a scope or a `policy.json` grant keyed on `iss+sub`.

Context: validated live 2026-07-09 that Claude authenticates to `minion.town/mcp`
and a fresh baseline identity is correctly limited to `minion_status`. That
scope+policy gating works and is fine as the *placeholder* auth layer, but it is
NOT the intended long-term control surface. See memory
`minion-town-access-control-ocap` and [[endo-gateway-mcp-direction]].

## What to revise

1. Reframe the design's access-control model: the current `mcp/guest`-scope +
   static-policy gating on the `guest_*` tools should be described as the thin
   auth layer, with the **authoritative per-action control being the capabilities
   the guest holds** (granted/attenuated at provisioning), exercised by the tool
   implementation. Reconcile explicitly: what stays scope/policy (coarse "is this
   a known, authenticated caller") vs what moves to ocap (fine "may this caller do
   THIS action on THIS object").
2. Reconsider the § 9 open question on `mcp/guest` scope naming/baseline in this
   light — the directive largely answers it (scopes are not the control), so state
   the resolved position and what, if anything, still needs a scope.
3. Make the provisioning site (gate 3) the place where a guest's capability set is
   composed and attenuated, and show how a later payment-attenuation layer
   (already the deferred `authorize()`/`debit()` seam) rides the SAME cap-grant
   path — not a scope check. Keep it deferred, but make the seam ocap-shaped.
4. Keep the rest of the design intact (daemon unit, CapTP-over-UDS control path,
   `iss+sub` guest keying, impedance exercises); this is a targeted access-control
   reframing, net design invariant elsewhere.

## Definition of done

Revised `designs/mcp-endo-guest.md` committed to `main` with the access-control
model reframed around object capabilities behind the tool calls (scopes as thin
auth), the `mcp/guest` open question resolved accordingly, and the deferred
metering seam shown as ocap-shaped. Spec only; no live change.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  claimed_at: 2026-07-09T23:29:56Z
