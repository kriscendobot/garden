---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: Why this is a *messages-as-the-substrate* design
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

The design's deepest claim isn't "let's move the supervisor out of
Node.js." It's that *the right unit of subprocess communication is
the handle-tagged envelope, not the netstring-framed CapTP stream
that happens to be carrying CapTP today*. The daemon doesn't speak
CapTP; it speaks envelopes. CapTP rides inside `"deliver"` payloads.
Other things can ride inside other verbs:
`"spawn"`/`"spawned"`/`"init"`/`"ready"`/`"log"` are non-CapTP
control-plane verbs. The syscall migration is *just more verbs* —
new control-plane operations that workers can address to handle 0.

The phrase *the daemon **is** the capability bus* is the design's
thesis. It pairs with cycle 105's
[[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
worldview shift (capabilities-as-shared-resources rather than
per-agent-attached) — but at a lower layer. The capability-bus
design says: *the daemon's job is to route handle-tagged messages
between subprocesses, and capabilities are addressed by handle*. The
capability-bank design says: *given that capabilities are first-class
shared resources, how should agents reach them?* Both designs treat
capabilities as routable, addressable objects rather than
JavaScript-stack-attached values.
