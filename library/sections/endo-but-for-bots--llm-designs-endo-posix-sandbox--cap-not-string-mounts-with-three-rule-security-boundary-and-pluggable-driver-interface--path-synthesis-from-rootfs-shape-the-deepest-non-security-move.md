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
title: §$PATH-synthesis-from-rootfs-shape (the deepest non-security move)
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

§Four-rootfs-modes — each has its own §$PATH-synthesis-rule:

| Mode | $PATH source |
|------|--------------|
| `host-bind` | Canonical Debian/Ubuntu order + survivors mined from daemon's $PATH |
| `mount` | Probe rootfs for canonical bin dirs that exist |
| `minimal` | Canonical default only |
| `oci` (podman) | Image's `Config.Env` PATH from `podman image inspect`, cached per image ref |

§Survivor-rules for `host-bind` mode:

- §Must-be-absolute-paths.
- §Must-not-contain-`..`-segment.
- §Must-not-begin-with `/home`, `/Users`, `/root`, `/tmp`,
  `/var/tmp`, or `/run/user`.

§The-five-forbidden-prefixes are §user-controlled-paths +
§temp-paths. §The-survivor-mining respects §absence-is-
structural-not-policy (cycle 170's discipline): if the
daemon's $PATH contains `/opt/special-tool/bin`, that gets
bind-mounted into the slice; if it contains `/home/user/
.local/bin`, it doesn't.

§Anti-shadowing-rule for caller-granted mounts: "Caller-
granted mounts whose `innerPath` ends in `/bin` or `/sbin`
are promoted to the synthesised `$PATH`, but land **after**
the rootfs-derived entries so a hostile mount cannot shadow
`/usr/bin` with a bin dir of its own."

§Order-matters: rootfs-derived bins first; caller-granted
bins last. §A-hostile-caller-can-extend-$PATH-but-cannot-
override-it.

§Compare-to-cycle-183-init's §shim-assembly-order (lockdown →
base64 → promise-kit → eventual-send). §Both-are-§ordered-
binding-pipelines where the order is §load-bearing-for-
correctness.

§Caller-supplied-env.PATH-always-wins. §The-synthesis-only-
fires-when-`PATH`-is-absent. §Explicit-caller-action overrides
the heuristic. §Compare-to-cycle-186-break-dev-deps' §don't-
pretend-the-platform-is-correct-just-because-it's-default —
§both-prefer-explicit-action-over-default-heuristic.
