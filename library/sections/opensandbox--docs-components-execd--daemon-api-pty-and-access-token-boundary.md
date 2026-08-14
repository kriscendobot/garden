---
title: Daemon API, PTY, and access-token boundary
source: docs/components/execd.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 7b969bd64935682895e077342b42007b68490585
source_date: 2026-08-11
source_authors: [ruirui6946, yutian.taoyt, epha, Baichao He]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, tooling, capability-security]
status: current
---

> Abstract: `execd` exposes code execution, command sessions, filesystem operations, isolated sessions, PTY WebSockets, and metrics over one in-sandbox HTTP service. `--access-token` or `EXECD_ACCESS_TOKEN` can place a shared bearer check in front of that API, separate from ingress Secure Access.

The daemon connects to an optional Jupyter service for code execution and selects Bash or `sh` for shell-backed APIs. Its PTY protocol gives one WebSocket the mutable holder role; a takeover flag can replace that holder, while any number of viewers receive bounded replay and live output but cannot send input, signals, or resize commands. Repeated viewer mutations close the connection.

The access token is an optional, service-wide authentication boundary. It does not partition command, file, PTY, and isolation powers into independently delegable references. A client holding it should be treated as able to reach the daemon's full configured API surface.

Source: [docs/components/execd.md](https://github.com/opensandbox-group/OpenSandbox/blob/7b969bd64935682895e077342b42007b68490585/docs/components/execd.md) at commit `7b969bd6`.
