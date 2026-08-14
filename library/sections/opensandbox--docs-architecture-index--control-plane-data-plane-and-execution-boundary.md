---
title: Control plane, data plane, and execution boundary
source: docs/architecture/index.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 02617e27f82409a0293012fe4c9acc2f6a67e262
source_date: 2026-08-14
source_authors: [lihaopeng]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, networking]
status: current
---

> Abstract: OpenSandbox places a language-neutral lifecycle server in front of Docker or Kubernetes providers, then places `execd` inside each sandbox workload. Clients create and inspect sandboxes through the control plane, resolve a port endpoint, and cross into the data plane over HTTP, Server-Sent Events, or WebSocket to run commands, manipulate files, open PTYs, or execute code through Jupyter. The security boundary is therefore not a language evaluator: it is a remotely managed container or pod with an injected service endpoint.

OpenSandbox separates six surfaces: client SDK/CLI/MCP tools, OpenAPI protocols, a FastAPI lifecycle control plane, Docker or Kubernetes runtime backends, an in-sandbox data plane, and a network/security plane. The server validates lifecycle requests and selects exactly one runtime service. That service creates the workload, stages `execd`, volumes, and optional egress configuration, and reports lifecycle state.

Execution crosses a second boundary after creation. A client resolves the `execd` endpoint from sandbox metadata, an ingress gateway, or the server proxy, then invokes command, file, session, PTY, metrics, or Jupyter-backed code APIs. Optional `X-EXECD-ACCESS-TOKEN` authentication protects this endpoint. The sandbox image and entrypoint remain ordinary operating-system workload material, so the platform can run Python, Java, JavaScript, Go, browsers, desktop servers, and coding-agent CLIs without requiring a language-specific evaluator.

Source: [docs/architecture/index.md](https://github.com/opensandbox-group/OpenSandbox/blob/02617e27f82409a0293012fe4c9acc2f6a67e262/docs/architecture/index.md) at commit `02617e27`.
