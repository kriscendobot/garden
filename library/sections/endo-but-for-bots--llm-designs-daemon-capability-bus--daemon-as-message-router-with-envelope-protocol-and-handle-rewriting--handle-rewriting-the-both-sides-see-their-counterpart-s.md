---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: Handle-rewriting — the *both sides see their counterpart's
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

identity* trick

The most structurally interesting mechanism is in §Worker spawning.
When the manager (handle 1) sends to worker N, the daemon delivers
the message to worker N with the handle field *rewritten to 1* (the
manager's handle). When worker N sends to handle 1, the daemon
delivers to the manager with the handle field *rewritten to N*. This
trick means *both sides can identify their counterpart without an
explicit sender field*:

```
manager ──[N, "deliver", payload, 0]──► daemon ──[1, "deliver", payload, 0]──► worker(N)
worker(N) ──[1, "deliver", payload, 0]──► daemon ──[N, "deliver", payload, 0]──► manager
```

This is a *symmetric handle rewriting* discipline: the handle field
always denotes the local-side identity of *the peer*. Worker N sees
incoming messages stamped with handle 1 ("from the manager"); the
manager sees incoming messages stamped with handle N ("from worker
N"). No header field is needed.
