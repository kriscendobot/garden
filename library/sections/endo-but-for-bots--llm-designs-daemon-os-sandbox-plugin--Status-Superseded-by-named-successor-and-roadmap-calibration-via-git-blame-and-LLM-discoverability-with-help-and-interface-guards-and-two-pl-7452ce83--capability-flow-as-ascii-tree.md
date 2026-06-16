---
title: §Capability-flow as ASCII tree
source-slug: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin
section-id: Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-os-sandbox-plugin.md
authors: [Kris Kowal (prompted), Joshua T Corbin (revised)]
repo: endojs/endo-but-for-bots
path: designs/daemon-os-sandbox-plugin.md
total-lines: 544
status: Superseded by endo-posix-sandbox (2026-05-07)
ingest-cycle: 228
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
---

```
HOST
 └─ makeUnconfined("sandbox-worker", "./sandbox-plugin.js")
     └─ SandboxMaker                        (held by host or granted to guests)
         │
         ├─ describe({ fs, net, exec, env })
         │   └─ Sandbox                     (scoped to declared endowments)
         │       ├─ run(command, args, opts)
         │       │   └─ { stdout, stderr, exitCode }
         │       ├─ help()
         │       └─ getEndowments()
         │
         └─ help()
```

§ASCII-tree-of-capability-flow with §nested-indentation-showing-creation-hierarchy. §Borrowable-pattern: §when-a-design-has-a-multi-level-capability-graph, §an-ASCII-tree-with-method-arrow-return-values-shows-the-full-call-shape-at-a-glance.

§Fourth-cycle-with-ASCII-illustration in 2026-06: cycles 214 (tree) / 218 (UI mockup) / 220 (flow diagram) / 228 (capability tree).
