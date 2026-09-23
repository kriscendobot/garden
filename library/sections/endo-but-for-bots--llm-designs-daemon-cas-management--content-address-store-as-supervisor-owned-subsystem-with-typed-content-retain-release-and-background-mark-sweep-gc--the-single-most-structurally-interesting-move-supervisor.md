---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The single most structurally interesting move — §supervisor-
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

owned vs worker-owned

The §Supervisor-owned vs. worker-owned subsection is the
design's *load-bearing architectural choice*. The §four reasons
the supervisor wins:

1. *The CAS is a shared resource accessed by all workers. A
   dedicated worker would require every CAS operation to cross
   the envelope bus twice (request + response), adding latency to
   module loading and snapshot operations.*

2. *The supervisor already owns the filesystem paths and creates
   the CAS directory.*

3. *GC requires knowledge of which handles are alive — the
   supervisor has this information; a worker would need to
   query for it.*

4. *The supervisor can run GC on a background thread without
   blocking the routing loop.*

The §future-worker-option discipline:

> *The worker-role option is preserved as a future alternative
> for deployments where the supervisor should remain minimal
> (e.g., embedded systems). The envelope verbs are identical in
> either case — only the handler location differs.*

The §verbs-are-the-same-interface discipline: the wire protocol
doesn't change based on who handles the verbs. The supervisor-
ownership decision is *operational*, not *architectural*; the
verbs would work either way.
