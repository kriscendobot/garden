---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
---

# One `package.json` keyword, one install command, multiple resource kinds with per-kind confinement

> *The gap is not the daemon-side substrate (which is already
> strong) but the *packaging convention* that lets one author ship
> a coordinated set of resources.*
>
> — `designs/endopi-extension-package-manifest.md` §Motivation

`endopi-extension-package-manifest.md` (149 lines, *Proposed*
status, created 2026-05-15) is the eighth endopi-* design ingested
and the sixth spinout from cycle 121's family keystone. Parent:
`endopi.md`. The design closes the §Extension model gap surfaced
by cycle 121's keystone: *Pi extensions can ship both code and
resources (skills, prompts, themes) under one keyword in
`package.json`, and a single `pi install` command resolves them
all. Endo's `endo install` is single-purpose.*

This design is the *cross-referenced family unifier* — it
consumes four prior endopi-* designs through its `endo`
manifest key: `guests` (Endo native), `skills` (cycle 112),
`prompts` (cycle 129 - prompt-templates, still unindexed), and
`providers` (cycle 128).

## The §packaging-convention frame — *substrate is strong; the
convention is missing*

The §Motivation paragraph names the asymmetry:

> *The gap is not the daemon-side substrate (which is already
> strong) but the *packaging convention* that lets one author
> ship a coordinated set of resources.*

The discipline: Endo already has all the resource-kind
substrates (guests = SES + capabilities; skills = cycle 112's
markdown format; prompts = cycle 129's prompt templates;
providers = cycle 128's registry). What's missing is the
*authoring + distribution surface* that lets one npm package
ship a *coordinated set*.

Pi solves this with a `pi` keyword in `package.json` + `pi
install` resolving all four resource kinds. The author manages
one distribution channel; the consumer runs one install command.

## The §`endo` manifest key — four resource directories with
auto-discovery defaults

The §Manifest subsection shows the shape:

```json
{
  "name": "my-endo-package",
  "keywords": ["endo-package", "endo-skill"],
  "endo": {
    "guests": ["./guests"],
    "skills": ["./skills"],
    "prompts": ["./prompts"],
    "providers": ["./providers"]
  }
}
```

The §auto-discovery-defaults discipline: if the `endo` key is
absent, the installer scans for directories named `guests/`,
`skills/`, `prompts/`, `providers/`. *Convention over
configuration* — packages that follow the default layout don't
need the manifest at all.

The §forward-compatibility discipline: *`themes` and other
resource kinds are added as new types emerge; the manifest is
extensible without breaking older readers* — unknown keys are
ignored. The §Out of scope reinforces: *backwards-incompatible
manifest changes... we never need a v2 manifest*.

## The §Install command — three source schemes + project-local
mode

The §Install subsection shows the source-resolution shape:

```sh
endo install npm:@foo/bar
endo install npm:@foo/bar@1.2.3
endo install git:github.com/user/repo
endo install git:github.com/user/repo@v1
endo install --project npm:@foo/bar     # project-local
```

Three source schemes (`npm:`, `git:`, local path) with optional
version pinning. The `--project` flag installs to a project-local
location rather than the user's global store. The §dispatch
mechanism walks the four resource directories:

1. **`guests/`** → daemon's guest-plugin store (existing `endo
   install` path).
2. **`skills/`** → `~/.agents/skills/` global OR `.agents/skills/`
   project-local — cycle 112's
   `endopi-skills-markdown-format` discovery walker picks them up.
3. **`prompts/`** → cycle 129's `endopi-prompt-templates`
   discovery path.
4. **`providers/`** → cycle 128's `endopi-provider-registry-
   and-oauth` registry registration.

The four-step dispatch directly cross-references the four
sibling designs. This design is *the unifier* — the file that
makes the prior endopi-* designs distributable as a coordinated
set.

## The §Security posture — *sharpest contrast with Pi*

The §Security posture subsection is the design's *most
structurally interesting paragraph*:

> *This is the sharpest contrast with Pi. Pi packages run with
> full system authority on first run; Pi's response is "review the
> source before installing". Endo's response: each resource kind
> has its own confinement.*

The §per-kind-confinement table:

- **Guests** run under SES with only the capabilities the user
  grants at provisioning time. *Package authors do not get to ask
  for new capabilities silently.*
- **Skills** are markdown files. *Their power is to *instruct*
  the agent, not to *do* anything directly; the agent's own
  capabilities bound what skill instructions can effect.*
- **Prompts** are pure text expansion. *No capability surface at
  all.*
- **Providers** ship code that talks to an LLM endpoint. The
  provider module *runs confined*; its network access is gated by
  the daemon's outbound HTTP capability per
  `endoclaw-network-fetch`.

The §conclusion:

> *A package install is therefore *safer than `endo install` is
> today* because the new resource kinds (skill, prompt) carry no
> execution authority, and the existing one (guest) is unchanged.*

The §safer-than-today claim is the design's bottom line. The
*expanding-the-surface-without-expanding-the-attack-surface*
discipline: by adding resource kinds with strictly *less*
authority than existing guest plugins, the design *strictly
improves* the install posture. Each new resource kind is *more
confined* than the existing one.

## How this design contrasts with Pi's plug-in model

Cycle 121's family keystone §Extensibility paragraph already
laid out the contrast:

- **Pi**: extensions are TS modules with *full system access*.
  The shape is *plug-in*. *The same module can register a tool,
  replace a built-in UI component, hook compaction, and emit a
  status-line widget — all with no security boundary.*
- **Endo**: guest plugins are guest modules with *bounded
  authority*. The shape is *guest*. *The plugin author cannot
  escalate by "just adding another import"; the import resolution
  itself is mediated by Endo's compartment mapper.*

Cycle 121's §right move:

> *not to copy Pi's plug-in model, but to make its guest model
> *as ergonomic as Pi's plug-in model* for the cases where the
> user actually wants the broad authority (developer-on-their-
> own-box). That is what
> [endopi-extension-package-manifest](endopi-extension-package-manifest.md)
> is for: one `package.json` keyword, one install command,
> multiple resource kinds.*

This design *is the cited solution* to the §right-move
identification. The §title encodes the four-part promise:
*one `package.json` keyword, one install command, multiple
resource kinds, with per-kind confinement*. The first three are
Pi's promise; the fourth is Endo's addition.

## §Listing + removal + config — Pi-mirrored lifecycle

The §Listing and removal subsection adds three commands:

```sh
endo list packages
endo remove npm:@foo/bar
endo config           # Plus enable/disable mirroring Pi's pi config
```

The §pi-mirrored discipline: *mirroring Pi's `pi config`* names
the existing-tool-pattern this design follows. The §enable/disable
without uninstalling is the *temporary-deactivation* feature that
makes opt-in/out cheap.

## Five-phase implementation plan

The §Phased implementation lists five phases:

1. **Manifest read + skill installs.** `endo install` recognizes
   `endo.skills`, drops content into the discovery path.
2. **Prompt + provider kinds.** Same shape, more directories.
3. **`endo list packages` + `endo remove`.** Lifecycle.
4. **`endo config` for enable/disable.** Disable a package
   without uninstalling.
5. **Pinning + updates.** `endo install npm:@foo/bar@1.2.3`
   semantics, `endo update`.

Phase 1 is *skills-only* because cycle 112's skills format is
already designed; the rest of the family follows. The
§incremental-adds-one-kind-at-a-time discipline lets each phase
ship independently.

## §Out of scope — *centralized registry* declined

The §Out of scope paragraph names two declines:

- **Centralized registry.** *Pi browses npm with a keyword
  search. Endo follows the same npm convention (`keywords:
  ["endo-package"]`); a registry is unnecessary and would add a
  moderation surface Endo does not want to operate.* The
  §no-moderation-surface discipline: maintaining a moderation
  surface is a non-trivial operational commitment; *unnecessary*
  here because the npm keyword convention already gives the
  searchability.

- **Backwards-incompatible manifest changes.** The manifest is
  forward-compatible by design (unknown keys ignored), so *we
  never need a v2 manifest*. The §forever-v1 discipline keeps
  the convention stable across future additions.

## Endopi-* family arc progress

The endopi-* family is now at **8/9 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md` (consumer
  for `skills/`)
- cycle 117 — `endopi-jsonl-transcript-format.md`
- cycle 121 — `endopi.md` (family keystone; named this design
  as the *right move*)
- cycle 122 — `endopi-edit-tool.md`
- cycle 124 — `endopi-iterative-compaction.md`
- cycle 126 — `endopi-stdio-rpc-bridge.md`
- cycle 128 — `endopi-provider-registry-and-oauth.md`
  (consumer for `providers/`)
- **cycle 129 (this cycle)** —
  `endopi-extension-package-manifest.md` (*the unifier*)

One spinout remains: `endopi-prompt-templates`.

## Related sections

- cycle 121 family keystone Genie path
  [[endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts]]
  — the §Extensibility architectural contrast that names this
  design as the *right move* (*as ergonomic as Pi's plug-in
  model* + per-kind confinement).
- cycle 112
  [[endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure]]
  — the *consumer* design for the `skills/` directory.
- cycle 128
  [[endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question]]
  — the *consumer* design for the `providers/` directory; the
  ProviderInterface that new providers register into.
- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — the canonical *capabilities are objects, not configurations*
  worldview that the §Security posture per-kind-confinement
  table embodies for the install path.
