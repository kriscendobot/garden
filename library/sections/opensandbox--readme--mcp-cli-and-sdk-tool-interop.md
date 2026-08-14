---
title: MCP, CLI, and SDK tool interoperation
source: README.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 7166129aa7a00c49021fcf8409019ace2b6d1c30
source_date: 2026-08-12
source_authors: [贾岛, 高然, epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, tooling, capability-security]
status: current
---

> Abstract: OpenSandbox offers the same coarse sandbox powers through language SDKs, the `osb` CLI, and an MCP stdio server. MCP clients such as Claude Code and Cursor can create sandboxes, execute commands, and read or write text files, so the MCP server is an authority-bearing adapter whose configuration and server credentials determine the ambient workload powers available to the agent.

The SDK family covers Python, Java/Kotlin, JavaScript/TypeScript, C#/.NET, and Go. The `osb` CLI packages the common workflow: configure a lifecycle-server connection, create a sandbox, run commands, transfer files, inspect diagnostics, and manage egress policy. The MCP package exposes sandbox creation, command execution, and text-file operations over stdio to MCP-capable clients.

This interoperation is not an object-capability boundary by itself. An MCP tool name designates an operation, but the server connection and API key may authorize a broad platform account. Endo-style confinement instead makes each reference carry only the authority intentionally endowed to the recipient. A confining integration therefore needs an attenuated adapter or per-tenant credentials, narrow network and mount policy, and careful validation of returned files and command output. Running the MCP server outside the sandbox also makes it part of the trusted control plane.

Source: [README.md](https://github.com/opensandbox-group/OpenSandbox/blob/7166129aa7a00c49021fcf8409019ace2b6d1c30/README.md) at commit `7166129a`.
