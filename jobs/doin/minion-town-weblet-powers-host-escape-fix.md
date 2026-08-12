---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
repo: kriscendobot/minion.town

Security fix. A confirmed privilege escalation in the deployed system, traced by
the peer job `ebfb-guest-unconfined-from-tree`. Read that job's findings first
and do not re-derive them.

## The defect

At deployed minion.town main 37252bcdeb200f1088429337c9151b642fe43091:

- the authenticated MCP `weblet_publish` tool accepts **any nonempty powers
  string** and stores it on the vhost record;
- the **public, unauthenticated** `*.ocap.site` WebSocket gateway reads that
  string back and performs `E(daemonHost).lookup(record.powers)`, presenting the
  resolved object as the CapTP bootstrap;
- `@self` passes validation and resolves to the gateway's **daemon top Host**.

So any admitted guest can publish a vhost whose public, unauthenticated
bootstrap is a Host, which is arbitrary code execution on the daemon's host for
anyone who can reach the URL. The daemon's Guest facet is correct; the escape is
entirely in the gateway's trust of a caller-supplied name.

## The fix

The shape of the bug is that a caller-supplied string is resolved in the
**gateway's own** authority instead of the caller's. Fix it at that seam rather
than by blocklisting `@self`, which would leave every other name that reaches a
Host. Approaches worth weighing, in rough order of preference:

1. Resolve the powers name in the **publisher's own guest scope**, never in the
   gateway's daemon Host, so a guest can only ever publish what it already
   holds. This makes the vulnerability structurally impossible rather than
   filtered.
2. Have `weblet_publish` capture the resolved capability at publish time, under
   the publisher's authority, and store a reference to that rather than a name
   the gateway later re-resolves.
3. If neither is reachable without a larger redesign, validate at publish time
   against an explicit allowlist of guest-scoped forms and reject anything that
   resolves host-shaped, at BOTH publish and serve time. Say plainly in the PR
   that this is the weaker containment and why the stronger one was not taken.

Whatever you choose, the gateway must not be able to serve a Host-shaped
bootstrap even if a hostile or stale record is already in the store, since
records published before the fix will still be there after it.

## Tests

- A regression test that a guest cannot publish a vhost resolving to a Host,
  covering `@self` and at least one other host-reaching name.
- A test that the gateway refuses to serve a host-shaped bootstrap from a
  pre-existing record, so the fix covers already-published records.
- A test pinning the intended positive case, so the fix does not silently break
  legitimate weblet publishing.

## Notes

- Security-sensitive: no exploit details in any public tracker or public commit
  message. PR on the fork.
- Do **not** touch production from this job, and do not deploy. Containment of
  the live exposure and the deploy are the maintainer's calls, tracked
  separately.
- Note in the PR that existing vhost records may already carry host-shaped
  powers strings, and state whether the fix neutralizes them or whether a
  cleanup of stored records is also needed. If cleanup is needed, put it under
  Follow-ups; do not perform it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T22:33:37Z
