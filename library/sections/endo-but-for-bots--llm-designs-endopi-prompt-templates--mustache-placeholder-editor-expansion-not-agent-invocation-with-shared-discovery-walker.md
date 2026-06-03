---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
---

# Mustache placeholder editor expansion (not agent invocation) with shared discovery walker

> *Templates expand the user's editor; they do not run
> autonomously. Autonomous prompts are endoclaw's proactive-
> messages territory.*
>
> — `designs/endopi-prompt-templates.md` §Out of scope

`endopi-prompt-templates.md` (104 lines, *Proposed* status,
created 2026-05-15) is the **ninth and final endopi-* design
ingested**. With this cycle, the endopi-* family is at **9/9
complete**. Parent: `endopi.md`. The design closes the §Prompt
templates gap from cycle 121's family keystone: *Self-contained,
low-risk feature.*

## The §editor-expansion-not-agent-invocation distinction

The §Slash-command integration paragraph names the load-bearing
behavior:

> *Templates appear in the autocomplete list under `/`. Selecting
> one expands the template body into the editor; the agent loop
> does not run until the user presses Enter. This matches Pi's
> UX: a template is *editor expansion*, not *agent invocation*.*

The §Out of scope reinforces:

> *Template execution as agent prompts. Templates expand the
> user's editor; they do not run autonomously. Autonomous prompts
> are endoclaw's proactive-messages territory.*

This is the *template-is-text-not-trigger* discipline. The
expansion produces editor content; *the user must press Enter to
actually invoke the agent*. The user keeps control of when the
agent runs; the template is an *input convenience*, not an
*automation trigger*. The discipline is part of the §security
posture cycle 129's `endopi-extension-package-manifest` codifies:
prompts are *pure text expansion. No capability surface at all*.

## The §Mustache placeholder syntax

The §On-disk shape shows a template file:

```markdown
<!-- ~/.pi/agent/prompts/review.md -->
Review this code for bugs, security issues, and performance problems.
Focus on: {{focus}}
```

Mustache-style `{{name}}` variables. Two argument-passing
mechanisms:

1. **Form-field prompts** — *when the template is invoked with no
   arguments, the Chat UI surfaces variable-prompts as form
   fields*. The §variable-prompt UI *reuses the Chat UI's
   existing form-rendering surface from
   [lal-fae-form-provisioning](lal-fae-form-provisioning.md)*.
2. **Bash-style positional arguments** — *fill them in when the
   user provides them on the slash command line*.

The §two-modes-for-one-knob shape lets the user choose: leave
arguments off → form UI prompts for them; provide arguments
inline → no UI prompts. The same template works in both modes.

The §reuse-of-form-provisioning observation: cycle 116's
`daemon-form-request` provided the foundational form message
shape; cycle 129's `endopi-extension-package-manifest` distributes
prompt templates via the `prompts/` directory; *this* design's
variable-prompt UI rides on that same form-rendering infrastructure
already in place for capability requests. *One UI surface, two
use cases* — the form-field shape is the substrate.

## The §shared-discovery-walker discipline

The §Discovery paragraph names the *same walker that handles
[endopi-skills-markdown-format](endopi-skills-markdown-format.md)
scans a parallel set of paths for `*.md` files*:

- `~/.pi/agent/prompts/*.md`
- `~/.agents/prompts/*.md` (cross-harness)
- `.pi/prompts/*.md`
- `.agents/prompts/*.md` (walk up from cwd)

The §parallel-paths-with-cross-harness-aliasing discipline
mirrors cycle 112's skills-format design exactly. Two
canonical-name paths (`.pi/` for Pi, `.agents/` for cross-harness)
× two scopes (global at `~/`, project at `cwd/`). The walk-up-from-
cwd shape lets a project override global templates.

The §same-walker-as-skills note: cycle 112's skills format design
already implemented the discovery walker; this design *just adds
a parallel set of paths*. No new traversal machinery. The
*one-walker-many-resource-kinds* substrate-reuse discipline visible
across cycles 112 + 129 + this cycle.

## The §composition — templates reference skills

The §Composition paragraph names a subtle composability:

> *A template body can reference a skill ("then use
> `/skill:gh-cli`"). The agent loop processes the skill reference
> on submit, the same way it processes any slash command in a
> user message.*

The §template-references-skill discipline: the template *expands
to text containing slash commands*; the agent loop sees those
slash commands *in the user message* and processes them on submit.
The template doesn't *invoke* the skill; it *names* the skill.
Once the editor expansion lands and the user presses Enter, the
agent picks up `/skill:gh-cli` as part of the user message and
loads the named skill.

The §natural-composition-via-text-not-API observation: there's no
template-to-skill *programmatic* invocation. Both are text; both
are routed through the same agent-loop dispatch on user-message
submission. The cleanest cross-feature composition is *just text*.

## Three-phase implementation

The §Phased implementation lists three phases:

1. **Loader + discovery.** Scan paths, parse, return
   `PromptTemplate[]`.
2. **Slash-command registration.** Templates appear in
   autocomplete.
3. **Variable substitution + argument prompts.** Form UI for
   missing variables.

The §three-phase-shape is *minimal-then-add-features*. Phase 1 is
*infrastructure* (load files); phase 2 is *UI integration*
(autocomplete); phase 3 is *substitution + form UI*. Each phase
ships independently.

## Two §Out of scope declines

The §Out of scope paragraph names two:

1. **Template execution as agent prompts** — *templates expand
   the user's editor; they do not run autonomously*. The
   §editor-expansion-not-agent-invocation discipline (above).
2. **Variable types beyond strings** — *Pi keeps variables as
   plain string substitution; Endo follows*. The
   §follow-Pi-for-simplicity discipline. Richer types (numbers,
   booleans, lists) would require a richer UI; the design
   accepts Pi's simplification.

Both declines are *minimal-surface* decisions. The first is
*structural* (security-shape); the second is *convention-following*
(don't-invent-new-syntax).

## How this design closes the endopi-* family arc

With this cycle, the endopi-* family is at **9/9 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md`
- cycle 117 — `endopi-jsonl-transcript-format.md`
- cycle 121 — `endopi.md` (family keystone)
- cycle 122 — `endopi-edit-tool.md`
- cycle 124 — `endopi-iterative-compaction.md`
- cycle 126 — `endopi-stdio-rpc-bridge.md`
- cycle 128 — `endopi-provider-registry-and-oauth.md`
- cycle 129 — `endopi-extension-package-manifest.md` (the
  unifier)
- **cycle 131 (this cycle)** — `endopi-prompt-templates.md`

The family arc:

- **Keystone** (cycle 121, 583 lines) — *Reference* status,
  comparative analysis frame
- **Two-already-ingested-spinouts** (cycles 112 + 117) — *Proposed*
  status, both named keystone as Parent
- **Five-more-spinouts** (cycles 122 + 124 + 126 + 128 + 129 +
  131) — *Proposed* status (one *partially satisfied*), all
  named keystone as Parent
- **Unifier** (cycle 129) — the `endo` manifest key in
  package.json that consumes guests + skills + prompts +
  providers in one install

The family covers nine endopi-* design files (one keystone +
eight spinouts) ingested across nineteen cycles (112 → 131). Each
ingest *traced back to the keystone* and built on the prior
ingest's vocabulary.

## How this design serves the unifier

Cycle 129's `endopi-extension-package-manifest` named this design
as *consumer for `prompts/`* — packages with a `prompts/`
directory drop their `.md` files into the discovery path this
design defines. Cycle 129's §per-kind-confinement table named
prompts as *pure text expansion; no capability surface at all*.
This design's §Out of scope confirms: *templates expand the
user's editor; they do not run autonomously*. The two designs
*lock together*: 129 distributes; this cycle defines what's
distributed.

## §The smallest endopi-* design

At 104 lines, this is the *smallest endopi-* design in the
family. By contrast:

- cycle 121's keystone: 583 lines
- cycle 119's daemon-capability-bus: 526 lines
- cycle 116's daemon-form-request: 435 lines
- cycle 107's daemon-agent-tools: 350 lines
- cycle 103's daemon-value-message: 331 lines

The *smallest-feature-bullet-self-contained-low-risk* shape that
the §Prompt cell of the design names: *useful before larger
workflow features land*. The design is what cycle 121's family
keystone called *self-contained, low-risk feature* — the easiest
of the eight spinouts to ship.

## Related sections

- cycle 121 family keystone
  [[endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts]]
  — the §Prompt templates table that named this design as the
  *self-contained, low-risk* gap-closer.
- cycle 112
  [[endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure]]
  — the design that defined the discovery walker this file's
  *parallel set of paths* reuses; *one-walker-many-resource-kinds*
  substrate-reuse.
- cycle 116
  [[endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation]]
  — the form message infrastructure the §variable-prompt UI
  reuses via cycle 116's *form-rendering surface from
  lal-fae-form-provisioning*.
- cycle 129
  [[endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement]]
  — the unifier that *consumes prompts via `prompts/` directory*;
  §per-kind-confinement table named prompts as *pure text
  expansion; no capability surface at all* — this design
  confirms the discipline.
