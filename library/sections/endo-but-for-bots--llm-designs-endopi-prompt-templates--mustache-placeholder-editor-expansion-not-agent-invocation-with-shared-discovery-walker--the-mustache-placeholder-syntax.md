---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
title: The §Mustache placeholder syntax
parent: endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
---

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
