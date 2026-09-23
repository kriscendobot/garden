---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §user-facing-one-method surface
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

```js
const debugSession = await E(host).debugWorker('my-worker');
```

The §user-facing-one-method discipline: one Endo-host method,
one argument (pet name or path). The whole mechanism is
invisible behind it. §everything-else-is-implementation.

The §returned-Debugger-already-paused property:

> *The returned `Debugger` is attached and paused at the XS
> `<login>` break — the machine has been restored from the
> snapshot but has not executed any code.*

The §caller-must-issue-go-before-anything contract: the
worker is *frozen* from the user's perspective until the
returned `Debugger`'s `go()` / `step()` / `setBreakpoint()`
is exercised. §pause-by-default-explicit-resume.
