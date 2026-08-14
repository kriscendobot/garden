---
title: Nested bubblewrap execution boundary
source: docs/guides/isolation-sessions.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 95333d6bfeea9d848c181aef03e58f3773b5c271
source_date: 2026-08-11
source_authors: [epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms]
status: current
---

> Abstract: An isolation session is a long-lived shell inside bubblewrap namespaces nested within one OpenSandbox sandbox. Each session receives PID, mount, tmpfs, environment, and optionally network namespaces. A sandbox can therefore amortize container creation across many mutually isolated task runs, while each session reuses shell state and serializes its own runs.

`execd` forks a bubblewrap child, establishes the namespace, and executes a persistent shell. The default overlay workspace gives each session a copy-on-write upper directory that vanishes on deletion; read-write and read-only bind modes are also available. A filesystem proxy outside the namespace reads and writes the merged workspace view without spawning another shell.

This is a nested task boundary, not the tenant's outer boundary. The source places a session at roughly 100 ms creation with near-zero subsequent run overhead, a sandbox at container/pod startup scale, and a secure runtime at the kernel or VM boundary. RL rollouts, batch grading, and multi-tool agent runs are the intended workloads.

Source: [docs/guides/isolation-sessions.md](https://github.com/opensandbox-group/OpenSandbox/blob/95333d6bfeea9d848c181aef03e58f3773b5c271/docs/guides/isolation-sessions.md) at commit `95333d6b`.
