---
section: genie-pi-inside-endo-and-the-four-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
---

# Genie: Pi inside Endo, and the four architectural contrasts

> *Genie is the existence proof that *embedding* Pi inside Endo is
> viable: a single package can depend on `pi-ai` for the
> provider/model registry, wrap `pi-agent-core` for the agent loop,
> and project the result into Endo's event vocabulary without
> rewriting either Pi surface.*
>
> — `designs/endopi.md` §What Genie's existence tells us

The §Genie: Pi inside Endo section + the §Architectural Contrasts
section together cover *the third Endo-side surface* (the one that
embeds Pi directly) and *the four worldview-level disagreements*
the comparative-mapping frame stops short of. This section
documents both.

The two halves are tightly coupled: Genie is the *concrete
existence proof* that the comparative-mapping mode is not the only
move; the architectural-contrasts section is the *abstract
codification* of why each move (mapping vs embedding) might be
right depending on what the user is willing to live with.

## What Genie is

`packages/genie` (introduced 2026 Q2, version 0.0.1, pre-release) is
the *third Endo-side surface* the comparative analysis covers. It
takes the opposite tack to Lal/Fae:

- **Lal/Fae**: *re-implement* the agent shape in Endo's idioms (own
  agent loop, own tool registration, own provider modules).
- **Genie**: *depend* on `@mariozechner/pi-agent-core` and
  `@mariozechner/pi-ai` directly and wrap them in an Endo-flavoured
  framing.

The genie API surface: `makePiAgent` (factory), `runAgentRound`
(event translation), a Claw-like SOUL.md / HEARTBEAT.md workspace
template, an observer / reflector subagent pair. Genie depends on
upstream Pi packages and translates Pi events into Endo's
`ChatEvent` stream — *without rewriting either Pi surface*.

## The §Mapping table — *the same questions, different answers*

The §Genie Mapping table re-asks the umbrella questions of the
comparative-analysis frame, this time of Genie. The most
structurally interesting rows:

- **LLM API**: Lal has 5 providers; Genie inherits *`pi-ai`'s full
  registry verbatim* — **available** by transitive dependency.

- **Ollama provider**: Genie ships a custom `buildOllamaModel`
  adaptor in `src/agent/index.js` that *masquerades ollama as the
  `openai-completions` API style at `http://127.0.0.1:11434/v1`*,
  bypassing `pi-ai`'s absent native ollama entry. Concrete example
  of the *fill-the-Pi-gap-from-the-Endo-side* idiom.

- **Subscription OAuth**: Gap for both Lal/Fae and Genie. Genie
  *inherits whatever `pi-ai` ships*; OAuth providers are not
  enabled out of the box, but the registry shape supports them.

- **Agent loop**: Lal/Fae has its own loop; Genie uses `PiAgent`
  from `pi-agent-core`, subscribed via `runAgentRound` which
  *translates pi-agent-core events into Genie's ChatEvent stream*.
  Event translation at the boundary is the embedding-friendly
  pattern.

- **Tool model**: Genie's `ToolSpec` converted at boundary into
  `AgentTool` for `pi-agent-core` (`toAgentTool`); tools live in
  `src/tools/` (`vfs`, `command`, `web-fetch`, `web-search`,
  `memory`). The same boundary-translation discipline as for events.

- **Capability confinement**: This is *the row Genie loses the
  confinement story on*. Per-tool gating via `tool-gate.js` over an
  ambient-Node tool surface; tool execution is *gated on expected
  tool/arg pairs but is not capability-confined by SES grants*. The
  intent (per jcorbin) is to confine via `packages/sandbox` (whose
  primary driver today is podman; bwrap is also present;
  macOS/Windows drivers are anticipated) for `command` and
  `vfs-node`; that wiring is **not yet present in main**.

- **System prompt constitution**: `buildSystemPrompt` in
  `src/system/index.js`: composes runtime info, policy / strict-
  policy / security-notes sections, tool list, and a Claw-style
  workspace section. *Builds a flexible library of prompt parts.*

- **Persistence shape**: A Claw-compatible workspace dir (default
  `workspace_template/`): `SOUL.md` (persona), `HEARTBEAT.md`
  (tasks), `memory/` (observations.md, reflections.md, profile.md).
  *Markdown-on-disk; the agent reads its own past sessions through
  the memory tools.* The same Claw idiom cycle 117's
  `endopi-jsonl-transcript-format` documents.

- **Compaction**: **In progress** via the observer + reflector
  subagent pair. Observer compresses chat into prioritised
  `observations.md` entries (token-threshold + idle-timer trigger;
  30k-token default); reflector consolidates observations into
  long-term `reflections.md` and `profile.md` (40k-token threshold
  + daily heartbeat). *Both run as separate `PiAgent` instances
  with focused tool sets, gated by `tool-gate.js`.* Shipped
  substrate.

- **Autonomous execution**: A heartbeat subagent loads
  `HEARTBEAT.md`, executes pending tasks, and records
  `.heartbeats.log` per tick. *Claw's autonomous-task shape.*

- **Skill format**: A `skillsPrompt` option on `buildSystemPrompt`
  accepts a pre-rendered skills section. The on-disk format and
  discovery walker are not in Genie; the open spinout
  [endopi-skills-markdown-format](endopi-skills-markdown-format.md)
  still applies.

- **Interval scheduler**: `makeIntervalScheduler` runs *periodic
  agent prompts (cron-style) under the agent loop*. Substrate for
  scheduled-action agents.

## *What Genie's existence tells us* — three implications

The §What Genie's existence tells us subsection names three
shifts in the gap-closing roadmap:

1. **The provider-registry gap is partially closed today.** Genie
   ships `pi-ai`'s full registry by transitive dependency. M1 of
   `endopi-provider-registry-and-oauth` reduces to (a) consolidating
   onto one registry surface (Genie's vs Lal's) and (b) the OAuth
   and cross-provider-handoff work that `pi-ai` does not provide.

2. **The compaction gap has a working implementation.** Genie's
   observer + reflector pair is *closer to a shipped iterative
   compactor than `endopi-iterative-compaction`'s design
   anticipated*. The substrate now exists; the design's role
   *shifts from "specify the algorithm" to "harmonise with the
   observer/reflector pair and route Lal/Fae transcripts through
   them"*.

3. **The confinement story is the open question.** Genie's tool
   surface runs with ambient Node authority (the `command` tool
   spawns subprocesses; the `vfs-node` tool reaches the filesystem
   directly). The tool-gate's role is *to constrain which tools and
   which arguments a sub-agent may invoke, not to confine what
   those tools can reach*. The maintainer's direction is
   `packages/sandbox` as the confinement layer for ambient tools.
   `packages/sandbox` ships a multi-driver shape: podman is its
   primary driver today, bwrap is also present, and additional
   drivers are anticipated for macOS and Windows. *Wiring
   `packages/sandbox` underneath `command` and `vfs-node` is the
   natural follow-on design once `endo-posix-sandbox` Phase 1.5
   lands.*

A second viable angle for the filesystem half of the confinement
problem (per jcorbin's follow-up on PR #265): *rather than
implementing a `vfs-endo` backend for genie's vfs-holding tools,
implement a 9p filesystem server that exports endo's filesystem
space*. A 9p server is reachable from both genie's existing
`vfs-node` implementation (as a mounted 9p export) and from normal
system command tools running inside the sandbox (as a mounted 9p
export inside the sandbox), so *one interface covers both
consumers instead of two parallel backends*. The trade-off (vfs-
endo backend vs 9p server) is named as an *open question that the
follow-on design captures*.

## *Genie is closer to pi-agent than to pi-coding-agent*

The §Upstream-Pi cross-reference subsection makes the pi-mono
package-split visible:

- `pi-mono/packages/agent` (`@mariozechner/pi-agent-core`) — the
  *embeddable* agent-loop core. Genie depends on this.
- `pi-mono/packages/ai` (`@mariozechner/pi-ai`) — the
  provider/model abstraction. Genie inherits the registry from this.
- `pi-mono/packages/coding-agent` — the pi-cli surface. *Not what
  Genie depends on.* The §Feature-by-Feature Mapping section maps
  Endo against this pi-cli, but Genie reuses the *embedding-shaped
  agent core, not the cli-shaped one*.

The two pi packages mapped here are different shapes: `coding-agent`
is *Pi the cli*, the one most of the comparative-mapping section
addresses; `agent` is *Pi the SDK*, the one Genie embeds.

## The four §Architectural Contrasts — the design's worldview
codification

The §Architectural Contrasts section near the end of the design
makes the *worldview-level disagreements* explicit. Four contrast
rows:

### Capability model

Pi: *the agent's process is the user's process*. Tools run with
user permissions; safety is *review extensions before installing*,
*run pi in a container*, or *write a permission-gate extension*.

Endo: *the agent receives a `Dir(/path/to/project)` and a
`Shell({allowed: [...]})` and cannot name anything outside*. The
user does not have to remember to review the agent's actions
because the agent's authority is *bounded by what was granted at
provisioning time*.

The §bet:

> *capability confinement will pay off when agents act on behalf
> of users who cannot evaluate the agent's source code.*

### Persistence

Pi: *a JSONL file in `~/.pi/agent/sessions/`*. Reading the file
with `jq` or `cat` recovers everything; *the agent can read its
own past sessions as files*. The agent's *memory* is the same file
the operator inspects.

Endo: *the formula store* — a typed graph indexed by 256-bit
formula identifiers, durable but *opaque to the operator without
going through the daemon*. The Lal reply-chain transcripts are
in-memory only.

> *Pi's shape is simpler and more debuggable for the operator.
> Endo's shape is more structurally sound and survives
> malicious-formula crashes without losing history.*

The §gap-closing move: cycle 117's
[`endopi-jsonl-transcript-format`](endopi-jsonl-transcript-format.md)
imports Pi's file shape as a *projection of Endo's transcript
graph — not a replacement*.

### Extensibility

Pi: extensions are TS modules with *full system access*. The shape
is *plug-in*: pi loads them, calls their factory, lets them
register tools and listen to events. *The same module can register
a tool, replace a built-in UI component, hook compaction, and emit
a status-line widget — all with no security boundary.*

Endo: guest plugins are guest modules with *bounded authority*.
The shape is *guest*: the daemon hands the module a `powers`
argument with the capabilities the host approved. The plugin
author *cannot escalate by "just adding another import"; the
import resolution itself is mediated by Endo's compartment mapper*.

The §right move:

> *not to copy Pi's plug-in model, but to make its guest model
> *as ergonomic as Pi's plug-in model* for the cases where the
> user actually wants the broad authority (developer-on-their-
> own-box). That is what
> [endopi-extension-package-manifest](endopi-extension-package-manifest.md)
> is for: one `package.json` keyword, one install command, multiple
> resource kinds.*

### Security

Pi: *the user reviews the code, or runs pi in a container*. Fine
for one developer auditing their own environment, *weak for any
other deployment posture*.

Endo: SES baseline plus capabilities. *Even malicious extensions
cannot read `~/.ssh/id_rsa` because they were not granted a `Dir`
containing it.* The canonical ocap-vs-ACL distinction. (This
contrast is endoclaw's headline as well; carried forward without
repeating it.)

### Agent-orchestration shape

This is the section's *most consequential* contrast. Pi: *one
agent, one session, one cwd*. Sub-agents are a deliberate non-
feature, pushed to extensions (*there's many ways to do this; tmux
is one*). *The harness assumes the human stays in the loop.*

Endo: *many guests, many spaces, many capabilities*. The multi-
guest formula model is the orchestration layer; the human can
delegate one guest to another (`send`, `request`, `form`) *without
the human being on the message path*. This is *the shape that
matters for the Endo bot fleet's eventual self-organization*.

The §closing thesis:

> *Pi and Endo are pointed at different problems. Pi optimizes for
> a single developer's coding velocity; Endo optimizes for a
> multi-agent system in which the human is one of N participants.
> The gap-closing designs in this document are about adopting Pi's
> developer-velocity moves (edit tool, JSONL transcripts, OAuth
> providers, skills format, RPC) without giving up Endo's
> multi-agent-system shape.*

## *Why this section pairs with section 1 but stays distinct*

Section 1 (the comparative-mapping frame + the eight spinout-gap
tables + the architectural-contrasts list) treats Endo as
*Lal/Fae* — the *re-implement Pi's shape in Endo's idioms* path.
Section 2 (this section) treats Endo as *Genie* — the *embed Pi
inside Endo directly* path. The same questions get different
answers depending on which Endo-side surface the question is asked
of. Genie's surface is structurally novel enough — and its
implications for the gap-closing roadmap concrete enough — that it
needs its own argument cluster, not a subsection inside the
comparative-mapping frame.

The §Architectural Contrasts subsection (capability model /
persistence / extensibility / security / agent-orchestration shape)
lives in this section rather than section 1 because *that's where
the worldview difference becomes the load-bearing claim*. Section
1's spinout-gap tables describe *what to adopt*; the architectural
contrasts describe *what makes Pi and Endo not the same thing in
the first place*. Without that frame, the spinout gaps look like
acquisitions; with it, they look like *focused borrowings* against
a different worldview.

## Related sections

- the sister section
  [[endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts]]
  — the comparative-mapping frame + the eight spinout-gap tables.
- cycle 112
  [[endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure]]
  — the markdown-frontmatter skill format spinout.
- cycle 117
  [[endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions]]
  — the JSONL transcript format spinout that imports Pi's file
  shape as *a projection of Endo's transcript graph, not a
  replacement*.
- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — the *capabilities as objects, not configurations* worldview
  that the §Capability model contrast names as *the bet of Endo*.
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the OS-level sandboxing primitives that `packages/sandbox`
  inherits to confine Genie's ambient `command`/`vfs-node` tools.
