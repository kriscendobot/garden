---
section: genie-pi-inside-endo-and-the-four-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: The four §Architectural Contrasts — the design's worldview
parent: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts
---

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
