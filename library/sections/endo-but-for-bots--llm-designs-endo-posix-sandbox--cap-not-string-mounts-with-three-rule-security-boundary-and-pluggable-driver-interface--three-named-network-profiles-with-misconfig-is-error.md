---
source: designs/endo-posix-sandbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endo-posix-sandbox.md
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Joshua T Corbin (PLAN)
  - kriscendobot (prompted by kriskowal)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress (Phase 3)
genre: §endo-but-for-bots-design §supersedes-prior-with-relationship-section
cycle: 190
lane: designs
status: current
title: §Three-named-network-profiles with §misconfig-is-error
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
1. `none` (default) — no network namespace usage of host net;
   loopback unreachable.
2. `private` (recommended) — private network namespace via
   `pasta` / `slirp4netns`, NAT'd outbound, with an explicit
   blocklist of RFC 1918 (`10/8`, `172.16/12`, `192.168/16`),
   `100.64/10` (CGNAT), `169.254/16`, `fc00::/7`, and the
   host's loopback.
3. `host-loopback` / `host-lan` / `host-net` — explicit opt-
   ins, each strictly less confined than the prior step.
```

§Three-named-profiles + §three-explicit-opt-ins (the host-*
trio). §A-six-position-ladder of network-confinement.

§The-§misconfig-is-error discipline (Rule 3): "an unknown
profile is a hard error, not a fall-through." §No-auto-
upgrade-if-private-fails.

§Compare-to-cycle-184-metering's §three-modes-as-discriminated-
union (Measurement / Quota / Rate-limited) — both are §named-
mode-with-explicit-discrimination patterns. §Cycle-184-modes-
are-orthogonal-progressions; §cycle-190-profiles are §strictly-
ordered-from-most-confined-to-least.

§The-private-profile blocklist names §six-categories of LAN
ranges (RFC 1918 trio + CGNAT + link-local + IPv6 ULA + host
loopback). §Defense-in-depth-via-explicit-enumeration.
