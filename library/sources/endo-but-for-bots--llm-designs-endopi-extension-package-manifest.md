---
source: designs/endopi-extension-package-manifest.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f4a9dc6d13234bc5a8b6c8642b3082d5d8a488d8
source_date: 2026-05-15
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Eighth endopi-* design ingest (after cycles 112 + 117 + 121 +
  122 + 124 + 126 + 128). 149-line *Proposed* design (Parent:
  endopi.md) closes the §Extension model gap from cycle 121's
  family keystone. **The family unifier** — consumes four prior
  endopi-* designs through its `endo` manifest key (`guests` /
  `skills` (cycle 112) / `prompts` (cycle 129's
  prompt-templates, still unindexed) / `providers` (cycle 128)).

  §Packaging-convention frame: *the gap is not the daemon-side
  substrate (which is already strong) but the packaging
  convention that lets one author ship a coordinated set of
  resources*. Pi solves this with a `pi` keyword in package.json
  + `pi install` resolving four resource kinds. Endo gets the
  same shape: one keyword (`endo:` in package.json), one install
  command (`endo install npm:@foo/bar`), four resource
  directories (guests / skills / prompts / providers).

  §Auto-discovery-defaults discipline: if the `endo` key is
  absent, the installer scans for directories named `guests/`,
  `skills/`, `prompts/`, `providers/`. *Convention over
  configuration*. §Forward-compatibility discipline: *unknown
  keys ignored*; *we never need a v2 manifest*.

  Three §Install source schemes: `npm:`, `git:`, local path,
  with optional version pinning and `--project` flag for
  project-local installs. The §dispatch mechanism walks four
  resource directories: `guests/` → daemon's guest-plugin store
  (existing `endo install` path); `skills/` →
  `~/.agents/skills/` per cycle 112; `prompts/` → per cycle 129;
  `providers/` → cycle 128's registry.

  **Single most structurally interesting move**: the §Security
  posture *per-kind-confinement* table. Pi packages run with
  full system authority on first run; Pi's response is *review
  the source before installing*. Endo's response: *each resource
  kind has its own confinement*.
    - **Guests** run under SES with only the capabilities the
      user grants at provisioning time. *Package authors do not
      get to ask for new capabilities silently.*
    - **Skills** are markdown files. Power is *to instruct the
      agent, not to do anything directly*; the agent's own
      capabilities bound what skill instructions can effect.
    - **Prompts** are pure text expansion. *No capability surface
      at all.*
    - **Providers** ship code that talks to an LLM endpoint;
      *runs confined*; network gated by the daemon's outbound
      HTTP capability per `endoclaw-network-fetch`.

  §Safer-than-today conclusion: *a package install is therefore
  safer than `endo install` is today because the new resource
  kinds (skill, prompt) carry no execution authority, and the
  existing one (guest) is unchanged*. The
  *expanding-the-surface-without-expanding-the-attack-surface*
  discipline.

  Cycle 121's §Extensibility architectural contrast directly
  named this design as the *right move*: *make Endo's guest
  model as ergonomic as Pi's plug-in model for the cases where
  the user actually wants the broad authority*. This design *is
  the cited solution*. The §title encodes the four-part promise:
  *one package.json keyword, one install command, multiple
  resource kinds, with per-kind confinement* — first three are
  Pi's promise; fourth is Endo's addition.

  §Pi-mirrored lifecycle: `endo list packages` + `endo remove
  npm:@foo/bar` + `endo config` for enable/disable *mirroring
  Pi's pi config*. The §temporary-deactivation feature lets
  packages be disabled without uninstalling.

  Five-phase implementation plan: (1) manifest read + skill
  installs; (2) prompt + provider kinds; (3) lifecycle commands;
  (4) enable/disable; (5) pinning + updates.

  Two §Out of scope decisions:
    - **Centralized registry** declined — *Pi browses npm with a
      keyword search; Endo follows the same npm convention*;
      *a registry is unnecessary and would add a moderation
      surface Endo does not want to operate*. The
      §no-moderation-surface discipline.
    - **Backwards-incompatible manifest changes** declined — the
      manifest is forward-compatible by design.

  Two Pi citations file-level: `coding-agent/docs/packages.md` +
  `coding-agent/src/core/package-manager.ts`.

  Cycle 129 was nominally chat-lane (cycle 128 was designs).
  Chat-lane exhausted at 20/20. Cycle 129 pivoted to designs-lane.
  Papers-lane has been blocked for 23+ consecutive cycles.
  Endopi-* family now at 8/9 ingested. One spinout remains:
  endopi-prompt-templates.
---

> Abstract: `endopi-extension-package-manifest.md` (149 lines,
> *Proposed* status; Parent: endopi.md) is the *endopi family
> unifier* — the design that consumes four prior endopi-*
> designs through its `endo` manifest key in `package.json`
> (`guests` / `skills` / `prompts` / `providers`). Closes the
> §Extension model gap from cycle 121's family keystone — the
> *ergonomics gap* between Pi's plug-in-installable everything
> and Endo's single-purpose `endo install`.
>
> Pi: *bundles four resource kinds under one `pi` keyword in
> `package.json`; a single `pi install npm:@foo/bar` resolves
> them all*. This design imports the same packaging convention:
> one keyword, one install command, four resource directories,
> §forward-compatibility-by-ignoring-unknown-keys (no v2
> manifest needed). §Auto-discovery-defaults discipline:
> directories named `guests/` / `skills/` / `prompts/` /
> `providers/` are picked up if the `endo` key is absent.
>
> **Single most structurally interesting move**: the §Security
> posture *per-kind-confinement* table. Pi: full system authority
> on first run. Endo: *each resource kind has its own
> confinement* — guests under SES with only granted capabilities;
> skills are markdown (instruct only, no direct action); prompts
> are pure text (no capability surface); providers run confined
> with daemon-gated network. §Safer-than-today: *a package
> install is therefore safer than `endo install` is today*
> because the new resource kinds carry no execution authority.
>
> Cycle 121's family keystone §Extensibility architectural
> contrast directly named this design as the *right move*. The
> §title encodes the four-part promise: *one keyword, one install
> command, multiple resource kinds, with per-kind confinement* —
> first three are Pi's promise; fourth is Endo's addition.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement](../sections/endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement.md) | agent-conventions | current |

Tight 149-line design. The whole argument hangs off one
structural claim: *import Pi's packaging convention; add
per-kind-confinement that Pi doesn't provide*. One cohesion-
honest section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots@f4a9dc6d`
  (the branch `origin/llm`) via the local bare-clone. Same
  commit as cycle 122's `endopi-edit-tool` and cycle 126's
  `endopi-stdio-rpc-bridge`.
- Last touched 2026-05-15 by endolinbot in commit `f4a9dc6d`.
- Status: *Proposed*. Parent: `endopi.md` (cycle 121's family
  keystone).
- **Twenty-sixth-comment-style design ingest.** Pairs with
  cycles 112 + 117 + 121 + 122 + 124 + 126 + 128 to advance the
  endopi-* family to 8/9 ingested.
- Cycle 129 was nominally **chat-lane** (cycle 128 was designs).
  Chat-lane is exhausted (20/20 upstream designs ingested).
  Papers-lane has been blocked for **23+ consecutive cycles**
  due to lack of PDF-fetching infrastructure. Cycle 129 pivoted
  to designs-lane.
- One cohesion-honest section.
