---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: The §evaluate-is-a-tool-of-tools observation
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

The §Design Decisions section restates the thesis as a structural
claim:

> *With eval, an agent can compose capabilities programmatically,
> drastically reducing the need for special-purpose tools.
> Withholding eval forces building bespoke tools for each
> composition pattern.*

The §tool-of-tools framing: a single `evaluate` capability
*subsumes* most special-purpose tools. Want to chain a `read` →
`transform` → `write` operation? Eval `({Dir}) => Dir.read('foo')
.then(transform).then(d => Dir.write('foo', d))` once instead of
inventing a *read-transform-write* tool. The agent's reach is
bounded by the capabilities passed in; the *composition pattern*
is free.

The §retreat-to-bespoke-tools observation is the cost: withhold
eval, and every composition becomes a *new tool design*. The
agent-tools surface grows linearly with use cases. With eval, *one
capability covers them all*.
