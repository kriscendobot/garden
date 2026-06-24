---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
title: Two §Out of scope declines
parent: endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
---

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
