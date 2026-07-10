---
role: builder
---

builder job (minion.town — `kriscendobot/minion.town`, deployed on AWS at
https://minion.town, box `i-0380cd68b90020fad`, us-west-1, SSM-only). Implements
a gap the maintainer identified (kriskowal, 2026-07-10) in the accepted design
`designs/mcp-endo-guest.md` (the per-user Endo Pet Daemon guest system behind the
MCP; design reviewed and accepted). Build → **validate in production** → **post a
PR** (builds delivered via PR per the 2026-07-10 minion.town convention).

## The gap

The design provisions per-user **guests** keyed on `iss+sub` under a single Endo
daemon host, but **the root host does not exist** — no bootstrapped root-host
authority over the daemon, and no way to establish or rotate it. Build an
**out-of-band mechanism** (out of band from the normal MCP guest-provisioning
path) for admin/bootstrap control that does one or both:

- **Create or repoint an email address to the root facet** — bind, and later
  re-bind, which maintainer identity holds the daemon's **root-host** authority.
  Email is the Cognito username attribute; the identity spine is `iss+sub`.
- **Promote certain guests to their own hosts** — elevate a designated guest from
  a guest facet to a full host (its own root authority), no longer merely a guest
  under the single daemon host.

## Requirements

1. Implement in the minion.town repo, shaped for later transplant into
   `@endo/gateway` / `@endo/mcp` (standing Endo direction; Endo-side changes
   target `endojs/endo-but-for-bots` @ `llm`, not the old kriscendobot/endo fork).
2. **Validate in production** — deploy to the live box under the SSM /
   presigned-S3 discipline (`deploy/aws/scripts/*`, secrets only in Secrets
   Manager), then exercise the mechanism end-to-end with recorded evidence
   (create a root binding, repoint it, and/or promote a guest), failing loudly and
   stopping on any gap, per the design's Gate acceptance discipline. It is a toy;
   validating in production is authorized.
3. **Post a PR** against `main` with the change plus a summary of the live
   validation (what was created/repointed/promoted and the observed result).

## Sequencing / decomposition

This presupposes the Endo daemon (design Gate 2: `endo-daemon.service`,
CapTP-over-UDS control path), which may not be stood up yet. Stand up the minimum
needed to implement and validate this mechanism, or sequence it explicitly and say
so. Access control is object-capability-based (caps behind the tool calls), not
OAuth scopes — the root facet is the ultimate such capability, so guard how it is
minted and repointed. **If this is larger than one PR, decompose it into an
orchestration job and escalate rather than silently truncating** (standing
multi-part-job decomposition rule).

## Definition of done

The out-of-band root-facet mechanism implemented, **validated live with recorded
evidence**, and delivered as a PR against `kriscendobot/minion.town` `main`. If
implementation reveals the design needs adjustment, note the delta back into
`designs/mcp-endo-guest.md` (same or a companion PR).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  claimed_at: 2026-07-10T06:55:43Z
