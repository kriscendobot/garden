---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
title: The §editor-expansion-not-agent-invocation distinction
parent: endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
---

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
