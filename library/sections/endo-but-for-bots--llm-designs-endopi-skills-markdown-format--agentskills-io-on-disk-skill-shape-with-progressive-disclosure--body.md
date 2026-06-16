---
title: Body
source: designs/endopi-skills-markdown-format.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-15
source_authors: [Kris Kowal (prompted)]
source_lines: "1-173 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-eighth endo-but-for-bots design ingest. **First endopi-*
  design ingest in the library**. *Status: Proposed*. *Parent:
  endopi*. The 172-line design adopts the *agentskills.io
  specification* for on-disk skill format (Pi, Claude Code,
  Codex all already adopted it) so that skills authored for any
  harness can be consumed by any other. Three structurally
  interesting moves: (1) the *cross-harness-standardization*
  argument — *Pi, Claude Code, and Codex have all adopted the
  [agentskills.io specification]. The result is that a skill
  written for any of those harnesses can be loaded into the
  others. Endo joining this format means* — the canonical
  *adopt-the-existing-standard rather than fragment* discipline;
  (2) the *progressive-disclosure* context-budget pattern — *the
  system prompt receives a compact descriptor list (name +
  description) per skill. When the agent decides it needs the
  skill, it uses `read` to load the full SKILL.md* — reduces
  per-skill context cost from full-body-inline to descriptor-only;
  (3) the *authoring-surface-vs-granting-surface* split — on-disk
  shape (this design) is for *authoring*; the sibling
  `endoclaw-skill-registry` EndoDirectory is the *granting*
  surface; a guest module bridges them.
  
  Cycle 112 first endopi-* ingest, similar to how cycle 109 was
  first familiar-* ingest. Single-section cohesion-honest ingest.
  Pairs structurally with the cycle 105+107 daemon-agent-capability
  layer cycles — skills are *another shape of capability* (an
  invokable instruction-bundle rather than a function-call surface).
parent: endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure
---

### §The on-disk-vs-daemon-side split

The §canonical structural distinction (lines 109-113):

> The on-disk shape is the *authoring* surface. The [endoclaw-skill-registry](endoclaw-skill-registry.md) EndoDirectory is the *granting* surface. The bridge: a guest module that, given a filesystem path to a skill directory, registers the skill as a daemon formula and adds it to the agent's `skills/` EndoDirectory.

The §two-surface split:

- **Authoring surface** (`SKILL.md` on disk) — a user with shell access creates a directory + frontmatter + body. Standard text-editor workflow; standard version-control workflow; standard file-permission discipline.
- **Granting surface** (`endoclaw-skill-registry` EndoDirectory) — the daemon's pet-name-keyed directory of skill formulas. Skills are *granted* (via the daemon's capability-discipline) and *consumed* (by agents that look them up via the pet-name).

The §bridge is *a guest module* that takes a filesystem path, registers the skill as a daemon formula, and adds it to the agent's directory.

The §two consumption modes (lines 116-120):

> - A user authoring a skill at the command line creates files in their project's `.agents/skills/<name>/`. The agent loads them at startup.
> - A user receiving a skill via the daemon's `request` mechanism receives a formula in their `skills/` directory, no filesystem write needed.

The §design intent: *both surfaces are first-class*. A skill can be on-disk-authored (developer ergonomics) OR daemon-granted (no filesystem write needed; capability-discipline preserved). The two surfaces compose via the guest-module bridge.

### §The cross-harness-standardization argument

The §motivation lines 21-32 name the *adopt-the-existing-standard rather than fragment* discipline:

> Pi, Claude Code, and Codex have all adopted the [agentskills.io specification] for this shape. The result is that a skill written for any of those harnesses can be loaded into the others. Endo joining this format means:
>
> 1. The Endo agent can consume skills written for other harnesses without translation (`~/.claude/skills`, `~/.codex/skills`).
> 2. A skill authored for Endo can be shared with users of other harnesses.
> 3. Progressive disclosure (descriptions in the system prompt; bodies read on demand by the agent) reduces context cost compared to inlining every skill.

The §three benefits:

- **Cross-harness consumption** — Endo's agent can load Pi/Claude/Codex skills *without translation*. The directory layout and frontmatter are the same.
- **Cross-harness sharing** — a skill written for Endo works in Pi/Claude/Codex.
- **Progressive disclosure** — the system prompt holds *descriptors* (name + description) per skill; the *body* is loaded on demand. Bounds context cost regardless of skill count.

The §discipline: *don't invent a new format when an existing standard works*. The §canonical lesson — same shape as cycle 105's *Capabilities are objects, not configurations* discipline but at the file-format level: adopt-the-standard-not-fragment.

The §three-harness adoption (Pi + Claude Code + Codex) means agentskills.io is *the* de-facto cross-harness standard. Joining it is a low-cost-high-benefit move.

### §The on-disk shape

The §lines 38-47:

```
my-skill/
├── SKILL.md              # required: frontmatter + body
├── scripts/              # optional: helper scripts the body references
│   └── process.sh
├── references/           # optional: details loaded on demand
│   └── api.md
└── assets/               # optional: templates, data
    └── template.json
```

The §four-element layout:

- **`SKILL.md`** — required. Frontmatter + free-form markdown body.
- **`scripts/`** (optional) — helper scripts the body invokes.
- **`references/`** (optional) — additional documentation files the body references via markdown links; loaded on demand.
- **`assets/`** (optional) — non-code resources (templates, data files).

The §discipline: *the directory name IS the skill name*. The frontmatter's `name` field must match the parent directory name; this gives the filesystem a canonical lookup path.

The §progressive-disclosure design is encoded in the structure: `SKILL.md` is loaded eagerly (its frontmatter generates the descriptor); `references/*.md` and `scripts/*` are loaded *on demand* when the agent decides to use the skill.

### §The SKILL.md frontmatter and validation

The §frontmatter shape (lines 51-66):

```markdown
---
name: my-skill
description: What this skill does and when to use it.
license: MIT
compatibility: Requires git, bash.
allowed-tools: read bash
disable-model-invocation: false
---

# My Skill

## Usage

Run `./scripts/process.sh <input>`. See [API reference](references/api.md).
```

The §five-field frontmatter:

- **`name`** (required) — max 64 chars, lowercase a-z / 0-9 / hyphens, must match the parent directory name.
- **`description`** (required) — max 1024 chars. Goes into the system-prompt descriptor.
- **`license`** (optional) — SPDX-style license identifier.
- **`compatibility`** (optional) — free-form prose describing prerequisites.
- **`allowed-tools`** (optional) — space-separated tool names. *Today Pi treats it experimentally* per the open questions section.
- **`disable-model-invocation`** (optional) — boolean. Likely controls whether the model can auto-invoke the skill.

The §validation discipline (lines 68-76):

> - `name`: required, max 64 chars, lowercase a-z / 0-9 / hyphens, must match the parent directory name.
> - `description`: required, max 1024 chars.
> - All other fields optional.
>
> Endo follows Pi's posture: warn on violations, but remain lenient so foreign skills load.

The §lenient-validation discipline: *warn but accept*. A skill that violates the validation rules (e.g., name doesn't match dir, description exceeds 1024 chars) gets a warning logged but is still loaded. The §rationale: *foreign skills* (from Claude / Codex / Pi) might evolve their own conventions; refusing them would defeat cross-harness consumption.

The §discipline reusable: *adopt-the-standard + warn-not-reject for non-conformance*. The standard is the lingua franca; lenient acceptance keeps the cross-harness compatibility.

### §The progressive-disclosure pattern

The §loader and prompt-injection (lines 78-105):

```js
const skills = await discoverSkills({
  paths: [
    '~/.pi/agent/skills',
    '~/.agents/skills',
    '~/.claude/skills',
    '.agents/skills', // walk up from cwd to repo root
    '.pi/skills',
  ],
});

const systemPrompt = buildSystemPrompt({
  ...,
  skills,
});
```

The §pattern:

1. **Discovery**: scan the configured paths, parse each `SKILL.md`, return a list of `Skill` objects.
2. **Descriptor injection**: the system prompt receives a *compact descriptor list* (name + description per skill) — NOT the full body of each skill.
3. **On-demand body load**: the agent uses `read` to load the full `SKILL.md` of a skill when it decides to use it.
4. **Slash-command forced load**: `/skill:my-skill` forces immediate load even when the model wouldn't have on its own.

The §context-cost trade-off:

- **Naïve approach**: inline every skill body in the system prompt → context cost scales with total skill bytes.
- **Progressive disclosure**: inline only descriptors (name + description) → context cost scales with skill count, not bodies. The agent picks which body to read at runtime.

The §observation: *the description IS the load decision*. A well-written description tells the LLM *what the skill does and when to use it*; the LLM uses the description to decide whether to read the body. Bad descriptions waste skill-discoverability; the validation cap (1024 chars) prevents description-bloat.

The §slash-command `/skill:my-skill` forced-load is a *user-override* — if the user knows they want a specific skill, they invoke it directly rather than relying on LLM decision-making.

### §The cross-harness path scanning

The §lines 122-126:

> Pi documents adding `~/.claude/skills` to its settings. Endo does the same in reverse: a setting (or default) instructs the agent to scan `~/.claude/skills`, `~/.codex/skills`, and the Pi paths.

The §default-scan-all-paths discipline: *Endo's agent reads skills from every known harness's path*. The §discipline:

- Pi scans `~/.claude/skills` (and Claude scans nothing else?).
- Endo scans Pi's paths + Claude's path + Codex's path.

The §design intent: *be the most-inclusive harness*. Users with multiple agents (Claude + Pi + Endo) want skills to work in all of them; scanning all paths means a skill written anywhere works everywhere.

### §The five-phase implementation plan

The §lines 130-138:

1. **Frontmatter parser + discovery walker** — parse `SKILL.md`, validate, return `Skill[]`. No agent integration yet.
2. **System-prompt injection** — compact descriptor list appears in the system prompt. The agent can `read` a skill by path on demand.
3. **Slash command (`/skill:name`)** — forces immediate load.
4. **Daemon-formula bridge** — a skill on disk can be granted as a daemon formula per `endoclaw-skill-registry`.
5. **Cross-harness paths** — default-enable scanning of Claude / Codex / Pi skill directories.

The §phased plan: *each phase shippable independently*. Phase 1 is the parser-only baseline; Phase 2 adds the agent-side rendering; Phase 3 adds user-override; Phase 4 bridges to the daemon; Phase 5 expands the source paths.

The §rationale for ordering: *correctness before ergonomics*. The parser comes first (without it nothing works); the cross-harness scan is last (it's a nice-to-have on top of the local-skill baseline).

### §The three Open questions

The §lines 150-159:

> - Where do project-local skills live? Pi uses `.pi/skills/` and `.agents/skills/`; Claude Code uses `.claude/skills/`. Endo can either pick one and document it, or scan all three.
> - Does `allowed-tools` map onto capability grants? Today Pi treats it experimentally; in Endo, this could be a structural grant ("this skill only sees these capabilities"). The Endo answer is more rigorous than Pi's; the alignment is worth doing.
> - Is the in-memory skill cache invalidated on file change? Pi hot-reloads via `/reload`. Endo can use the existing `filesystem-watchers` design once it lands.

The §three honest open questions:

- **Project-local skill location convention** — pick one or scan all three? The design defers the decision. The §loader sketch above scans `.agents/skills` and `.pi/skills`, hinting at the *scan-multiple* preference.
- **`allowed-tools` → capability grants** — Pi treats `allowed-tools` *experimentally*; Endo could make it a *structural capability grant* (the skill literally only sees the named capabilities). The §observation: *the Endo answer is more rigorous than Pi's; the alignment is worth doing*. Connects to cycle 105's *Capabilities are objects, not configurations* — `allowed-tools` could become a structural capability filter, not an advisory configuration.
- **Cache invalidation on file change** — uses the `filesystem-watchers` sister design (not yet landed).

The §discipline: *name open questions explicitly*. The design isn't pretending to have closed all decisions; it documents the three remaining knobs.

### §The Pi-citation discipline

The §Citation (lines 161-166):

- `packages/coding-agent/docs/skills.md` (Pi's docs).
- `packages/coding-agent/src/core/skills.ts` (Pi's implementation).
- `packages/coding-agent/src/core/system-prompt.ts` (Pi's skill formatting block).
- The external `agentskills.io` specification.

The §discipline: *cite the implementation we're following*. The §design isn't reinventing the wheel; it's *adopting Pi's implementation pattern* with explicit references to the specific files. A future Endo implementer can read Pi's code to understand the canonical shape.

The §`badlogic/pi-mono` GitHub URL pattern names the upstream repository. The §design is *cross-project standardization* via citation to the de-facto-reference implementation.
