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
---

# Cap-not-string mounts with three-rule security boundary, pluggable backend driver interface, capability-blind drivers, and design as mirror of authoritative PLAN

> §Designs-lane after cycle 189's chat-lane. §The-twenty-
> fourth-consecutive designs/chat alternation cycle (166-190).
> §Status: **In Progress (Phase 3)** — Phases 0, 1, and 1.5
> shipped (bwrap driver); Phase 2 (podman driver) shipped;
> Phases 3 (nested slices) in progress; Phases 4 (macOS via
> lima), 6 (Windows via WSL), and 7 (focused tools)
> remaining.
> §Supersedes the cycle-NaN-`daemon-os-sandbox-plugin` open
> proposal that was superseded 2026-05-07 when this design
> landed.

`endo-posix-sandbox.md` (572 lines, Created 2026-05-07,
Updated 2026-05-07) designs an Endo plugin that exposes a
"slice of a POSIX-like system" as a CapTP capability surface.
A slice is a §confined-process-namespace + §writable-filesystem-
view + §optionally-private-network, GC-pinned by its handle.

§The-key-consumer: `@endo/genie` — the plan runs a genie's
entire workspace and `bash`/`exec`/`git` tools inside a slice
so an off-the-rails model cannot exfiltrate via host shell
access. §This-is-additional-defense; the daemon, workers, and
CapTP graph remain the authoritative capability boundary.

§The-single-most-structurally-interesting-move is §cap-not-
string-mounts + §three-rule-security-boundary-clarity +
§pluggable-backend-driver-with-capability-blind-drivers.
§Three-disciplines composed.

## §The-three-rules-of-security-boundary-clarity

The design names §three-rules-restated-explicitly:

```
1. The plugin never accepts string host paths from the caller.
   Mounts are `Mount` capabilities or nothing.
2. The plugin does not receive the daemon's host-paths power
   transitively, even though it could nominally use it.
3. Network profiles are explicit and named.
   `'private'` does not accidentally upgrade to `'host-net'` on
   misconfiguration; misconfig is an error, not a relaxation.
```

§Rule-1: §cap-not-string-mounts. §`SandboxHandle.mount(cap,
innerPath, mode)` is the only way to bind host state into a
slice. §String-host-paths-are-not-accepted.

§Rule-2: §plugin-does-not-receive-daemon's-host-paths-power.
§Even-though-it-could-nominally-use-it (cycle 170 daemon-
capability-filesystem's §Bazel-style-selective-dependency-
mounting parallel). §The-cap-resolution happens inside the
plugin's `prepareSlice` step; the plugin itself doesn't have
ambient host-paths access.

§Rule-3: §misconfig-is-error-not-relaxation. §Network-profiles
fail-loud-on-unknown-value. §Compare-to-cycle-178-daemon-xs-
worker-snapshot's §suspend-only-when-idle (§avoid-the-problem-
by-design); §rule-3-here-is §avoid-silent-degradation-by-
making-misconfig-an-error.

§Compare-to-cycle-170-daemon-capability-filesystem's §five-
named-disciplines and cycle 174-gateway-package's §eight-
Design-Decisions. §Three-rules is the §security-discipline-
shape; not all designs reach §eight.

## §Cap-not-string-mounts (the load-bearing constraint)

```
`SandboxHandle.mount(cap, innerPath, mode)` is the only way to
bind host state into a slice.  String host paths are not
accepted.  The factory does not receive the daemon's host-paths
power; `Mount` capabilities are resolved to host paths inside
the factory's `prepareSlice` step, where the cap-to-path
resolution is the only privileged operation.

This rule keeps the capability boundary in one place and
prevents the sandbox from becoming a confused-deputy escape
hatch.
```

§Why-strings-are-dangerous: a caller that can pass a string
"/etc/passwd" or "/home/user/.ssh" as a mount-source is just
exercising ambient host-paths authority laundered through the
sandbox. §The-cap-discipline ensures the caller already had
authority to that path before the sandbox could mount it.

§Confused-deputy-named-explicitly. §The-sandbox-must-not-
become-a-confused-deputy-escape-hatch.

§Compare-to-cycle-170-daemon-capability-filesystem's §realpath-
at-operation-time-confinement + §caretaker-facet-separation.
§Both-are-§capability-discipline-in-the-filesystem-layer;
cycle 170 is the wider design, cycle 190 is the concrete
slice-bounded slice.

## §Pluggable backend driver with capability-blind drivers

§Drivers-do-not-receive-Endo-capabilities-directly. §The-
plugin-layer-is-the-single-mediator: it resolves each granted
`Mount` to a host path on the daemon side, then hands the
driver a §plain-{hostPath,innerPath,mode}-triple. §The-driver-
does-the-bind-mount/volume-mapping.

```ts
interface SandboxDriver {
  name: string
  probe(): Promise<{ available, reason?, version? }>
  prepareSlice(spec: SliceSpec): Promise<DriverSliceContext>
  spawn(slice, argv, opts): Promise<DriverProcess>
  teardown(slice): Promise<void>
}
```

§Five-method-driver-interface. §Compare-to-cycle-187-shim-
cluster's §Indenter-trait-with-two-implementations (5 methods:
open / line / next / close / done). §Both-are-§polymorphic-
interface-with-named-shapes; cycle 190's driver-interface is
the §runtime-pluggable-implementation pattern.

§Five-drivers-in-scope:

| Driver | OS | Phase |
|--------|-----|-------|
| `bwrap` | Linux | 1 (Complete) |
| `podman` | Linux | 2 (Complete) |
| `lima` | macOS | 4 (Not Started) |
| `containerization` | macOS 15+ | 4 (Not Started) |
| `wsl` | Windows | 6 (Not Started) |

§Capability-blind-drivers = §drivers-see-only-resolved-paths.
§This-keeps-drivers-simple-and-keeps-the-capability-boundary-
in-one-place. §A-driver-that-doesn't-handle-capabilities-
correctly cannot escape the slice via cap-abuse.

§Compare-to-cycle-176-daemon-endor-architecture's §three-
worker-platforms-with-byte-identical-CBOR-envelopes. §Both-
are-§platform-blind-substrate patterns where the layer above
provides the common interface and the layer below provides
the platform-specific machinery.

## §Three-named-network-profiles with §misconfig-is-error

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

## §$PATH-synthesis-from-rootfs-shape (the deepest non-security move)

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

## §Phase-progression with §living-phase-list-records-its-own-renumbering

```
| Phase | Description                                  | Status       |
| 0     | Driver interface design                      | Complete     |
| 1     | bwrap driver on Linux                        | Complete     |
| 1.5   | bwrap hardening (Landlock, seccomp, cgroups) | Not Started  |
| 2     | podman driver                                | In Progress  |
| 3     | Nested slices (fork())                       | In Progress  |
| 4     | macOS via lima and Apple Containerization    | Not Started  |
| 6     | Windows via WSL2                             | Not Started  |
| 7     | Focused tools and renderer integration       | Deferred     |
```

§Phase-5-intentionally-absent. §The-design-records-its-own-
renumbering:

> the original Phase 5 (Apple Containerization) has been
> folded into Phase 4, and the original Phase 4 (Windows /
> WSL2) was renumbered to Phase 6 so macOS lands before
> Windows.

§Each-phase-with-renumbering-context is named in its
description: "Phase 3 (Was Phase 5; promoted ahead of multi-
platform work)", "Phase 4 (Was Phase 3; combined with...)",
"Phase 6 (Was Phase 4; deferred until after macOS lands)".

§Living-phase-list-records-its-own-renumbering is a §design-
evolution-discipline. §Compare-to-cycle-178-snapshot's
§revised-scope-discussion-2026-04-15 and cycle 188-perf's
§working-copy-inventory. §All-three-record-how-the-design-
state-arrived-at-its-current-shape.

§The-§Phase-7-Deferred status appears for §scoped-only-after-
production-use items (genie-side spawn tool surface; Familiar
renderer access; OCI-pull rootfs via skopeo; sandbox-exec
defense-in-depth around macOS native worker). §Defer-with-
condition-named (production-use).

## §The-§Relationship-to-daemon-os-sandbox-plugin section (the supersedes record)

§The-design-names-three-ways-it-supersedes-the-prior:

```
1. The capability surface is split across `SandboxFactory` /
   `SandboxHandle` / `ProcessHandle` / `MountHandle` so a
   slice's lifetime, mounts, and processes are individually
   addressable (and individually GC-pinnable).
2. Mounts are `Mount` capabilities, never string host paths;
   the plugin does not receive the daemon's host-paths power.
3. The phase plan stages bwrap → podman → fork() → macOS →
   Windows, with macOS and Windows using the in-guest backend
   + host-side proxy pattern that lima establishes, rather
   than maintaining a parallel SBPL backend.
```

§Three-improvements-named-explicitly. §This-is-§the-§supersedes-
record-pattern (sibling to cycle 174-gateway-package's
§supersedes-with-named-prior-as-citable-reference).

§The-older-design "remains in the index as the historical
proposal" — §preserve-the-prior-as-citable-reference, even
though new implementation tracks against the successor.

§Compare-to-cycle-174-gateway-package's §three-design-
lifecycle-statuses-now-distinguished (Supersedes / Deprecates
/ Replaces). §Cycle-190-shows-the-§Supersedes-record-shape in
detail.

## §Source-mirror-to-PLAN (the §authoritative-source pattern)

```
This design mirrors and tracks
PLAN/endo_posix_sandbox.md on the packages/sandbox working
branch.
The PLAN is the authoritative phase-by-phase implementation
log; this design is the roadmap-aligned mirror for milestone-
tracking purposes (project velocity, ETD per milestone) per
review comment 3203724907 on PR #119.

When the PLAN advances a phase, this design's Status row and
the Phase Progression table below should be updated to match.
```

§Two-documents-with-named-authoritative-source. §The-PLAN-is-
the-source-of-truth; §this-design-is-the-mirror-for-roadmap-
tracking.

§The-§update-protocol named: "When the PLAN advances a phase,
this design's Status row and the Phase Progression table below
should be updated to match."

§Compare-to-cycle-186-break-dev-deps' §review-iteration-
archived-in-design (PR #206 discussion links per Resolved
Decision). §Both-are-§designs-archive-process patterns, but
cycle 190 archives a §parallel-document while cycle 186
archives §review-conversation.

§The-PR-#119-review-comment-3203724907 is cited as the source
of the mirror discipline. §Provenance-of-the-mirror-decision-
named.

## §The §four-handle-capability-surface (split lifecycle)

```
make-unconfined entry → SandboxFactory ──┐
                                         │ make({...})
                                         ▼
                                   SandboxHandle ──┐
                                         │         │ spawn(argv, opts)
                                         │         ▼
                                         │   ProcessHandle
                                         │
                                         │ mount(mountCap, innerPath, opts)
                                         ▼
                                   MountHandle
```

§Four-handle-types. §Each-individually-addressable + §each-
individually-GC-pinnable. §The-split makes "release just the
process" or "release just one mount" possible without
affecting the rest of the slice.

§Compare-to-cycle-170-daemon-capability-filesystem's §three-
layer-architecture (Guest / VFS-Namespace / Backends). §Both-
are-§deliberately-decomposed-capability-surfaces; cycle 190's
four-handle split is §lifecycle-decomposition rather than
architectural-decomposition.

§Compare-to-cycle-182-daemon-xs-worker-debugger's §natural-
debugger-trio-attenuation (DebuggerView / DebuggerControl /
DebuggerAdmin). §Cycle-190's four-handle split is §similar-
attenuation but at the §sandbox-layer instead of §debugger-
layer.

## §GC-pinning-with-pre-defined-disposal

```
A SandboxHandle formula pins, by reference:
- the rootfs source (Mount capability or marker for host-bind),
- every granted Mount cap,
- a ScratchMount for the writable upper layer.

When the handle is unpinned, dispose() runs.
Every live ProcessHandle is killed (SIGTERM, then SIGKILL
after a grace).
Every MountHandle unmounts.
The driver's teardown cleans up the namespace / container.
ScratchMount removal piggy-backs on the daemon's existing
scratch GC.
```

§GC-pinning-and-disposal-protocol-explicit. §Three-things-
pinned: rootfs + granted-mounts + scratch-mount.

§On-unpin: dispose runs § SIGTERM-grace-SIGKILL on processes +
unmount + driver teardown + scratch GC.

§Piggy-backs-on-existing-scratch-GC = §reuse-existing-
discipline-not-build-parallel. §Compare-to-cycle-167-where/
index.js' §reuse-@endo/where-rather-than-reinventing pattern.

## §The §five-cross-phase-invariants (the test discipline)

```
- The plugin layer never accepts a string host path from a
  caller.
- A SandboxHandle released by GC results in inner processes
  receiving SIGTERM and then SIGKILL after the grace period.
- A slice with network: 'private' cannot reach host loopback,
  RFC 1918, CGNAT, link-local, or fc00::/7.
- An unknown network profile is a hard error at slice
  construction.
- A caller-granted mount cannot shadow rootfs-derived $PATH
  entries.
```

§Five-invariants the test suite preserves across phases.
§Each-invariant maps to a §rule-named-elsewhere in the design.

§Compare-to-cycle-180-hex-package's §audit-drives-scope (32-
row exhaustive table). §This-design's §five-cross-phase-
invariants are the §test-side-equivalent: enumerate what the
test suite guards.

## §Plugin-shape-in-Endo

```
A make-unconfined formula loaded from the daemon, mirroring
the shape of lal, jaine, and the existing networks plugins.

Powers needed:
- child_process.spawn of an allow-listed binary set (bwrap,
  pasta, podman, lima, wsl.exe — plus the rootfs caller's
  chosen interpreter).
- Read access to a config dir.
- Writable scratch path via the daemon's provideScratchMount.
- Not the host-paths power.
```

§Four-powers-needed and §one-power-explicitly-not-needed.
§The-§not-the-host-paths-power explicit refusal reinforces
Rule 2 ("plugin does not receive the daemon's host-paths
power transitively").

§Compare-to-cycle-170-daemon-capability-filesystem's §absence-
is-structural-not-policy. §Both-encode-the-§deny-by-omission
discipline.

§Allow-listed-binary-set: bwrap + pasta + podman + lima +
wsl.exe + caller's-chosen-interpreter. §Six-binaries the
plugin can spawn. §Other-binaries-must-go-through-a-slice's-
SandboxHandle.spawn-not-direct-child_process.

## §Non-goals (the §scope-limiting discipline)

```
- Replacing Endo's own confinement model.
- Shipping a rootfs with Endo.  Consumers BYO their userland.
- Pulling OCI images directly.
- Cross-platform parity in v1.
- Familiar / Electron renderer access.
- Replacing the existing bash/exec/git genie tools with new
  sandbox.spawn tools.
```

§Six-non-goals-explicitly-named. §Each-disclaims-a-tempting-
scope-creep.

§The-§non-goals discipline is §scope-clarification-via-
negation. §What-this-design-does-not-do is as important as
what it does.

§Compare-to-cycle-180-hex-package's §five-known-gaps and
cycle 184-metering's §six-known-gaps. §Non-goals are §scope-
boundary; known-gaps are §future-work. §Both-are-§honest-
disclosure-discipline patterns.

## §Cohesion notes

- §Cap-not-string-mounts is §the-load-bearing-constraint.
  Mounts are `Mount` capabilities or nothing.
- §Three-rules-of-security-boundary-clarity: §never-string-
  host-paths + §plugin-does-not-receive-daemon's-host-paths-
  power + §misconfig-is-error-not-relaxation.
- §Pluggable-backend-driver-interface with §capability-blind-
  drivers (drivers see only resolved-path triples; the plugin
  is the single cap-to-path mediator).
- §Three-named-network-profiles + §three-explicit-host-opt-
  ins = six-position-confinement-ladder.
- §Four-rootfs-modes (host-bind / mount / minimal / oci) with
  §five-forbidden-PATH-prefixes for survivor mining.
- §Anti-shadowing-rule: caller-granted mounts land after
  rootfs-derived $PATH so they extend but can't override.
- §Caller-supplied-env.PATH-always-wins over synthesis
  heuristic.
- §Living-phase-list-records-its-own-renumbering (Phase 5
  intentionally absent; Phase 3/4/6 each note their prior
  numbering).
- §Supersedes-record-pattern (§three-improvements over the
  prior daemon-os-sandbox-plugin).
- §Source-mirror-to-PLAN with §named-update-protocol. The
  PLAN is authoritative; this design is the roadmap-aligned
  mirror for milestone-tracking.
- §Four-handle-capability-surface (SandboxFactory /
  SandboxHandle / ProcessHandle / MountHandle) with §each-
  individually-GC-pinnable.
- §GC-pinning-and-disposal-protocol with §SIGTERM-grace-
  SIGKILL on processes + driver teardown + scratch-GC
  piggy-back.
- §Five-cross-phase-invariants as the §test-side-discipline.
- §Plugin-needs-four-powers + §explicitly-refuses-host-paths-
  power.
- §Six-non-goals-explicitly-named.
- §Genie-integration-as-workspace-not-tool-surface: existing
  tools unchanged externally; spawn channel swapped daemon-
  side.

## §Tier-1 borrowing

- §cap-not-string-mounts (the load-bearing-constraint for any
  capability-boundary-around-syscalls)
- §three-rules-of-security-boundary-clarity (never-string-
  inputs + don't-receive-the-power-you-could-have + misconfig-
  is-error)
- §pluggable-backend-driver-interface with §capability-blind-
  drivers (cap-resolution in the mediator only)
- §three-named-profiles + §explicit-opt-ins (no auto-upgrade)
- §anti-shadowing-rule: extend-but-can't-override (caller-
  mounts land after rootfs-derived)
- §living-phase-list-records-its-own-renumbering
- §supersedes-record-pattern with §three-improvements-named-
  explicitly
- §source-mirror-to-PLAN with §named-update-protocol (two
  documents with named authoritative-source)
- §four-handle-capability-surface for §lifecycle-decomposition
- §GC-pinning-and-disposal-protocol with §SIGTERM-grace-
  SIGKILL
- §five-cross-phase-invariants as test-side-discipline
- §plugin-explicitly-refuses-power-it-could-have
- §non-goals-discipline (six explicit scope-limits)

## §Synthesis-target

The §slot-machine-library's external-process-spawning
mechanism (if any) can §borrow-cap-not-string-mounts directly.
§The-three-rules-of-security-boundary-clarity form a
borrowable §security-discipline-template.

§The-§supersedes-record-pattern with §three-improvements-
named-explicitly is borrowable for any design that replaces
a prior — name what got better, not just that the prior was
"superseded."

§The-§source-mirror-to-PLAN pattern is borrowable for any
§authoritative-implementation-log + §roadmap-aligned-mirror
split. §The-update-protocol-named-explicitly avoids the §two-
documents-drift problem.
