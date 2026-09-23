---
title: Component map and AI workload shapes
source: README.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 7166129aa7a00c49021fcf8409019ace2b6d1c30
source_date: 2026-08-12
source_authors: [贾岛, 高然, epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, tooling]
status: current
---

> Abstract: The repository is partitioned into protocol specs, lifecycle server, client SDKs, CLI, Kubernetes runtime, injected execution daemon, ingress and egress proxies, sandbox images, and examples. Example workloads range from coding agents and code interpreters to browsers, desktops, evaluation trials, and reinforcement-learning training.

The component map makes the control/data split concrete. `server/` implements lifecycle management; `specs/` defines interoperable APIs; `components/execd/` supplies in-sandbox execution; ingress and egress components mediate network edges; `sandboxes/` and `kubernetes/` supply workload implementations and deployment; and SDKs, CLI, and MCP adapt those facilities for clients.

Examples show that a sandbox is not limited to a language evaluator. It can host vendor coding CLIs, LangGraph or Google ADK agents, Chromium and Playwright, VNC desktops, VS Code, and one evaluation sandbox per trial. This breadth explains why OpenSandbox's primary abstraction is an operating-system workload and why finer authority discipline must be layered inside it when untrusted code shares selected application powers.

Source: [README.md](https://github.com/opensandbox-group/OpenSandbox/blob/7166129aa7a00c49021fcf8409019ace2b6d1c30/README.md) at commit `7166129a`.
