---
title: Cap'n Web RPC discipline
source: AGENTS.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Cloudflare OS contributors]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-conventions, capability-security, eventual-send]
status: current
---

Cap'n Web RPC is used as a capability protocol across frontend, backend, and Workers, with promise pipelining preferred to unnecessary awaits and runtime validation generated from every RPC interface.

An RPC promise may stand in for a future stub or argument, so unawaited pipelined promises are intentional. Every `RpcStub` must be disposed to release server resources. React state cannot store a stub directly because stubs are callable and a state setter would invoke one as an updater; the stub must be wrapped in an object. All interfaces use `@validateRpc()` rather than duplicating generated runtime checks by hand.

Source: [AGENTS.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/AGENTS.md) at commit `1ef6020a`.
