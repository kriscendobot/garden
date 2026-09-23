---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
title: The §composition — templates reference skills
parent: endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
---

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
