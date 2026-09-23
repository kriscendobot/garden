---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §CapTP-connections-broken acceptance
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

§Design Decision 4:

> *CapTP connections are broken. This is inherent to suspend/
> resume. The alternative — keeping connections alive during
> a machine restart — would require a proxy layer that does
> not exist. The cost is acceptable: debug sessions are
> developer tools, not production operations.*

The §accept-the-cost-because-developer-tool discipline. Three
parts:

1. **Acknowledge the cost** explicitly (live CapTP refs to
   the worker will break).
2. **Name the alternative** (a proxy layer keeping refs
   alive).
3. **Defer the alternative** (not worth the complexity for a
   developer tool).

The §don't-build-the-proxy-layer-for-now choice. Compare
cycle 154's §lifted-from-E.js / §no-this-receiver-check — *we
copy the proxy machinery, we don't extend it*.

The §returned-Debugger-is-itself-a-CapTP-capability
compensation: the *new* connection (the debug session) is a
fresh capability, transferable like any other. The lost
*old* connections are replaced by *new* ones if needed.
