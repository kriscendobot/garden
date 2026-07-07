---
created: 2026-07-07
updated: 2026-07-07
author: scholar
---

# EndpointSecurity as a named macOS backend path for the OS-sandbox plugin

> Abstract: The endo-but-for-bots OS-sandbox design lineage
> (`daemon-os-sandbox-plugin` → `endo-posix-sandbox`) confines and observes the
> process subtrees the daemon spawns for native-program tools (bash/exec/git via
> `@endo/genie`). Its superseded parent design *explicitly named Apple's
> EndpointSecurity (ES) framework* — alongside user-space FUSE — as a future
> replacement for the deprecated `sandbox-exec`/SBPL macOS backend. Apple's
> `es_new_descendants_client` (ingested 2026-07-07) is precisely that primitive:
> an ES client scoped to a process **and its recursively-spawned descendant
> tree**, delivering auth (allow/deny) + notify events for descendants and
> needing only the client entitlement (no root, no TCC). This note records the
> concrete fit and, honestly, its limits: ES is a *named-but-not-chosen* path,
> the current design picked lima + Apple Containerization for macOS, and OS
> sandboxing is framed throughout as defense-in-depth, not the primary boundary
> (CapTP/ocap discipline remains authoritative).

## The design surface this maps onto

The daemon's OS-sandbox plugin exposes a "slice of a POSIX-like system" as a
CapTP capability surface and runs native tool processes inside it. The plugin
layer resolves capability-mounts to host paths and hands *capability-blind*
per-platform drivers a set of resolved-path/rule triples to enforce. The
superseded `daemon-os-sandbox-plugin.md` design carried **two platform backends**
— macOS via SBPL (`sandbox-exec`) and Linux via bwrap+seccomp — with a table
mapping each endowment (`fs[].mode`, `net.allowOutbound`, …) to that backend's
concrete rules. See
[`../../library/sections/endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--two-platform-backends-macos-sb.md`](../../library/sections/endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--two-platform-backends-macos-sb.md).

The same design flagged the macOS backend's platform risk and named its exits:

> Should Apple remove [`sandbox-exec`] in a future release, the macOS backend can
> be updated to use the **Endpoint Security framework** or a user-space
> FUSE-based approach.

(from
[`../../library/sections/endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--apple-deprecation-acknowledgme.md`](../../library/sections/endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--apple-deprecation-acknowledgme.md)).

That is the concrete hook: the project has already, in writing, identified the ES
framework as a candidate macOS backend. It just never spelled out *which* ES
primitive.

## Why `es_new_descendants_client` is the matching primitive

`es_new_descendants_client` fills in that named-but-unspecified ES path almost
exactly (ingested source:
[`../../library/sources/web--apple-es-new-descendants-client.md`](../../library/sources/web--apple-es-new-descendants-client.md)):

- **Descendant-tree scoping is the sandbox's shape.** The client sees the calling
  process (notify only) and every process it forks/exec's, recursively
  (auth+notify), and *nothing else*. A sandbox backend that launches a native
  tool and must supervise whatever it spawns wants exactly this subtree-scoped
  field of view — not a system-wide ES client.
- **Auth events give enforcement, not just observation.** For descendants the
  client receives synchronous *auth* events and returns an allow/deny verdict
  before the operation proceeds. That is a genuine enforcement point — the kind
  of allow/deny gate the SBPL/bwrap backends express declaratively, here
  expressed imperatively in the handler. (See
  [`../../library/concepts/auth-vs-notify-events.md`](../../library/concepts/auth-vs-notify-events.md).)
- **Deployment friction is low.** It needs the
  `com.apple.developer.endpoint-security.client` entitlement but **no root and no
  TCC prompt** — a far better fit for a developer-tool daemon than a
  root-requiring, consent-gated full-system ES client.

## Honest limits — this is analysis, not advocacy

- **Named ≠ chosen.** The live successor design, `endo-posix-sandbox`, did *not*
  route macOS through ES. Its Phase 4 macOS backend is **lima + Apple
  Containerization** (a process-*namespace/VM* confinement driver), matching its
  Linux bwrap/podman drivers. ES is monitoring/authorization; the chosen drivers
  are namespace isolation. They are different enforcement models, and the project
  bet on the namespace model. See
  [`../../library/sources/endo-but-for-bots--llm-designs-endo-posix-sandbox.md`](../../library/sources/endo-but-for-bots--llm-designs-endo-posix-sandbox.md).
- **OS sandboxing is defense-in-depth, not the boundary.** The design states
  plainly that "the daemon, workers, and CapTP graph remain the authoritative
  capability boundary; the plugin does not replace Endo's own confinement model."
  So even a future ES backend would be a *secondary* enforcement layer around a
  process the ocap graph already confines — valuable, but not architecture-
  changing.
- **A descendants client cannot gate its own creator.** The caller gets notify
  only; a backend built on this API supervises what it *spawns*, and would need
  to be the process that launches the confined tool (which is the natural shape
  anyway).
- **Per-process muting is unavailable** (`ES_RETURN_ERROR`); a backend would lean
  on path / target-path muting to trim event volume.

## Where this could go (not proposed, just noted)

If Apple ever retires the SBPL private interface, or if the project wants an
enforcement layer that *observes* (audit trail of what a tool actually did) in
addition to *confining*, `es_new_descendants_client` is the concrete API to
prototype a macOS ES driver against, slotting into the existing
capability-blind driver interface. Nothing in the current roadmap asks for it;
this note exists so the next reader who reaches the "Endpoint Security framework"
line in the sandbox design finds the specific primitive already ingested and
assessed.

## Relevance to the garden's other process-supervision surfaces (assessed, weak)

- **The garden's own gardener fleet** is supervised by systemd `--user` units in
  a Linux container; ES is macOS-only, so no fit.
- **endo / ocapn / cosgov / agoric-sdk** projects carry no OS-level
  process-monitoring surface; their confinement is ocap/SES or chain-level. No
  fit.

The single genuine fit is the endo-but-for-bots OS-sandbox backend surface above.

Sources: the ingested Apple ES reference (`web--apple-es-new-descendants-client`,
library `sources/` + `sections/`) and the existing design sections cited inline.
