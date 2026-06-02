---
section: comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
---

# Comparative Pi mapping with eight spinout gaps and architectural contrasts

> *The fundamental difference echoes endoclaw's: Pi takes the
> *ambient authority + ergonomics* path; Endo takes the *least
> authority + auditable structure* path. The interesting question
> is not which architecture wins, but which of Pi's design moves
> Endo should adopt verbatim, which it should refract through
> capabilities, and which it should decline.*
>
> — `designs/endopi.md` §Architecture Comparison

`endopi.md` (583 lines, *Reference* status, created + updated
2026-05-15) is the *family keystone* the prior two endopi-* ingests
(cycle 112's `endopi-skills-markdown-format.md` + cycle 117's
`endopi-jsonl-transcript-format.md`) both named as their Parent.
The design maps Pi's surface (Mario Zechner's *badlogic/pi-mono*
terminal coding-agent harness, ~49.5k stars, MIT) onto Endo's
surface (daemon + chat + familiar + cli + lal + fae + genie) and
inventories the gaps worth closing as sibling designs.

Same author + companion to `endoclaw.md`: OpenClaw frames Endo's
*assistant* shape; Pi frames Endo's *coding-agent* shape.

## The *ambient authority + ergonomics* vs *least authority +
auditable structure* worldview

The §Architecture Comparison table is the design's load-bearing
frame. Twelve rows contrast Pi and Endo on Runtime / Embedding /
Agent shape / Tool model / Capability model / Provider model /
Persistence / Branching / Compaction / Extensions / Skills /
Distribution / Security. The single most structurally interesting
row is the *Capability model* contrast:

- **Pi**: *Ambient authority + opt-in container/sandbox*
- **Endo**: *Object-capability (agent holds only granted caps)*

The §Architectural Contrasts section near the end (§Capability
model, §Persistence, §Extensibility, §Security, §Agent-orchestration
shape) makes the contrast explicit: Pi takes the *ergonomic path*
(the agent's process *is* the user's process; safety is *review
extensions before installing*, *run pi in a container*, or *write a
permission-gate extension*); Endo *inverts the default* — the agent
receives a `Dir(/path/to/project)` and a `Shell({allowed: [...]})`
and **cannot name** anything outside.

The bet of Endo: *capability confinement will pay off when agents
act on behalf of users who cannot evaluate the agent's source code*.

## *Endo-side surfaces covered* — three surfaces, not two

The §Endo-side surfaces covered preamble names *three* Endo packages
on the agent-shape axis:

1. `packages/lal` + `packages/fae` (the agent-loop and tool surfaces
   that predate this analysis) — the *reimplement Pi's shape in
   Endo's idioms* tack.
2. `packages/genie` (introduced 2026 Q2, version 0.0.1) — the
   *embed Pi inside Endo directly* tack, depending on
   `@mariozechner/pi-agent-core` and `pi-ai` as runtime dependencies.

The comparative-mapping tables in this section answer the questions
for Lal/Fae. The §*Genie: Pi inside Endo* section (covered in the
sister section
[[endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts]])
answers them for Genie, often differently.

## Target disambiguation — *which Pi?*

The §Target disambiguation block rejects four alternatives:

- **Inflection AI's Pi** (consumer chatbot — no capability surface)
- **Forks/ports** (`tibormester/pi-harness`, `werg/pi-harness`,
  `davidondrej/pi-agent`, `Dicklesworthstone/pi_agent_rust` — covered
  by mapping the canonical upstream)
- **`can1357/oh-my-pi`** (downstream skin; out of scope but a
  packaging precedent if Endo ever ships pi-style extensions)
- **`earendil-works/pi`** (the public mirror; same content as
  `badlogic/pi-mono`; both cited interchangeably in pi's own docs)

The chosen reference is `badlogic/pi-mono`: 4100+ commits, ~49.5k
stars, MIT, shipping at v0.74.x as of 2026-05-15. The maintainer's
prior reference [`endoclaw`](endoclaw.md) already cites *Pi-compatible
jsonl files* as the desired session-persistence shape (see
endoclaw §Persistence and Memory), consistent with pi-mono being the
intended target.

## The eight spinout-gap tables

The §Feature-by-Feature Mapping section runs eight tables, each
covering one feature category. Each table inventories the cross-
product (Pi feature × Endo equivalent × Status), and each spins out
a sibling design naming the gap. The eight categories + their
sibling-design spinouts:

| Category | Sibling design | Status as of 2026-06-02 |
|----------|----------------|--------------------------|
| **Built-in tool core** (read/write/edit/bash) | [endopi-edit-tool](endopi-edit-tool.md) | Pi's *edit* (unique-match oldText/newText replacement on normalized line endings, structured diff preview) is the interesting one — Endo has no edit-by-replacement primitive; `cli-edit-verb` covers hashline patches for human-on-CLI editing, not the primitive a tool-calling LLM uses. |
| **Session model** (JSONL tree, id/parentId, /tree, /fork, /clone, /export) | [endopi-jsonl-transcript-format](endopi-jsonl-transcript-format.md) (cycle 117) | Pi's session-on-disk format is *the part worth porting verbatim* — *the session-export feature also doubles as the agent's own form of long-term memory inside its workspace*. |
| **Multi-provider LLM API** (30+ providers, subscription auth, cross-provider handoff, token tracking, tool-call streaming, image input) | [endopi-provider-registry-and-oauth](endopi-provider-registry-and-oauth.md) | Pi's `pi-ai` package is a focused dependency Endo could vendor or take inspiration from; the *subscription auth* piece (Claude Pro / ChatGPT Plus / Copilot instead of API key) is *its highest-leverage feature for end users*. |
| **Extension model** (TS modules + full system access; tools / commands / shortcuts / hot-reload / pi install) | [endopi-extension-package-manifest](endopi-extension-package-manifest.md) | *Endo's existing guest-plugin model is *more* secure than Pi's. The gap is not the architecture but the ergonomics: Pi extensions can ship both code and resources (skills, prompts, themes) under one keyword in `package.json`, and a single `pi install` command resolves them all.* |
| **Skills system** (SKILL.md frontmatter, progressive disclosure, /skill:name slash command, cross-harness skill paths) | [endopi-skills-markdown-format](endopi-skills-markdown-format.md) (cycle 112) | The daemon side is `endoclaw-skill-registry`; the on-disk side is this sibling — a markdown-frontmatter skill format compatible with the agentskills.io specification used by Pi, Claude Code, and Codex. |
| **Prompt templates** (markdown `{{var}}` interpolation, `/templatename` expansion, global+project+package locations) | [endopi-prompt-templates](endopi-prompt-templates.md) | Self-contained, low-risk feature. |
| **Context files** (AGENTS.md / CLAUDE.md, parent-walking from cwd, append vs replace via SYSTEM.md) | Tracked under [endopi-skills-markdown-format](endopi-skills-markdown-format.md); same discovery rule. | The discovery rule composes with the skills format. |
| **Operating modes** (interactive TUI, print, RPC stdio JSONL, SDK) | [endopi-stdio-rpc-bridge](endopi-stdio-rpc-bridge.md) | Pi's RPC mode is *the part Endo does not have* — a strict line-delimited JSON protocol for embedding the agent in another process (an IDE, a CI harness, a Familiar pane) without WebSocket overhead. The maintainer's `endor-bus-tui` direction may eventually subsume this; the short-term gap is real. |

A ninth table covers **compaction** (auto + manual `/compact`,
structured summary format, iterative compaction, `keepRecentTokens`
/ `reserveTokens` knobs, branch summarization on `/tree`) — spinning
out [endopi-iterative-compaction](endopi-iterative-compaction.md);
the sister §Genie section reports this design's *substrate now
exists* in genie's observer/reflector pair, so the design's role
shifts from *specify the algorithm* to *harmonise with the
observer/reflector pair and route Lal/Fae transcripts through them*.

A tenth table covers **session sharing** (Hugging Face publish /
HTML export / GitHub gist) — HTML export is *the only piece worth
carrying forward*; the rest is philosophical (sharing transcripts
is a workflow choice).

## *Designs the Pi-Endo mapping does not need*

The §Pi-specific moves Endo declines list:

- **Ambient extension authority** — Endo keeps SES + capability
  confinement.
- **No MCP** — Pi's stance (*build CLI tools with READMEs; an
  extension can add MCP if wanted*) is compatible with Endo;
  nothing to do.
- **No built-in sub-agents** — Endo's multi-guest formula model
  already provides confined sub-agents.
- **No permission popups in core** — Endo enforces structurally
  (caretaker revocation, interface guards) rather than runtime-
  prompt.
- **No background bash** — Pi prefers `tmux`; Endo is symmetric.
- **Hugging Face transcript publishing** — out of scope for Endo's
  local-first posture.

The §Endo-specific advantages list (no Pi equivalent):

- Object-capability confinement at the JS module boundary
- Caretaker revocation of any granted capability
- Multi-guest isolation with per-guest network identity
- Formula-store persistence outliving daemon restarts
- Hardened JavaScript (SES) defeating prototype pollution attacks
- OCapN peer-to-peer message-passing primitives

The pair of lists is what makes this design *comparative* rather
than *acquisitive*: it's not *adopt Pi*, it's *adopt Pi's
developer-velocity moves without giving up Endo's multi-agent-
system shape*.

## *Adopting Pi's developer-velocity moves without giving up Endo's
multi-agent-system shape*

The §Agent-orchestration shape architectural contrast is the
clearest summary of *what each project optimizes for*:

> *Pi's default is *one agent, one session, one cwd*. Sub-agents
> are a deliberate non-feature, pushed to extensions ("there's many
> ways to do this; tmux is one"). The harness assumes the human
> stays in the loop.*
>
> *Endo's default is *many guests, many spaces, many capabilities*.
> The multi-guest formula model is the orchestration layer; the
> human can delegate one guest to another (`send`, `request`,
> `form`) without the human being on the message path. This is the
> shape that matters for the Endo bot fleet's eventual
> self-organization.*
>
> *Pi and Endo are pointed at different problems. Pi optimizes for
> a single developer's coding velocity; Endo optimizes for a
> multi-agent system in which the human is one of N participants.
> The gap-closing designs in this document are about adopting Pi's
> developer-velocity moves (edit tool, JSONL transcripts, OAuth
> providers, skills format, RPC) without giving up Endo's
> multi-agent-system shape.*

## *Pi-compatible JSONL files* is the maintainer's pre-existing
directive

Two prior ingests (cycle 112 + cycle 117) both quoted the maintainer's
endoclaw directive *Pi-compatible jsonl files (openclaw and localgpt
at least both do this)*. The endopi root makes that directive a
*ratified architecture decision*: the endopi family is now the
formal sibling-spinout machinery for closing the eight (or nine)
*adopt this from Pi* gaps, each with its own dated design page and
each tracked against Pi source files at the file level (§Pi
source-file citation index has 33 file-level citations).

## Related sections

- cycle 112
  [[endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure]]
  — first endopi-* ingest; the markdown-frontmatter skill format
  spinout (one of the eight gaps tabulated here).
- cycle 117
  [[endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions]]
  — second endopi-* ingest; the JSONL transcript format spinout
  (one of the eight gaps tabulated here).
- the sister section
  [[endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts]]
  — the third Endo-side surface (`packages/genie`) that embeds Pi
  directly + the architectural-contrasts portion of this design.
- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — the *capabilities as objects, not configurations* worldview
  that this design contrasts with Pi's *ambient authority*.
- cycle 107
  [[endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-and-git-as-claw-like-agent-capabilities]]
  — `daemon-agent-tools.md` (Claw-like coding tools) cited as
  *Designed* in the *Built-in tool core* gap table.
