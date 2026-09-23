---
title: What is the Problem Being Solved?
source: designs/gateway-bearer-token-auth.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 069d5ecbf79d90409069cfe72ed0c54e79c7bc77
source_date: 2026-03-07
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "agent ID as bearer token" pattern reuses the formula identifier (256-bit hex, 64 chars) as the authentication credential — knowing it grants full control. The URL-fragment-not-query-param choice is the load-bearing secrecy detail: HTTP fragments per RFC 3986 are never sent to the server in HTTP requests. CapTP's `GatewayBootstrap.fetch(token)` is the only gate; no JSON auth handshake.
parent: endo-but-for-bots--llm-designs-gbta--problem-and-auth-model
---

The Endo daemon gateway currently accepts connections only from localhost. The gateway checks the remote IP address and rejects any connection that does not originate from `127.0.0.1` or `::1`. This makes the gateway unsuitable for remote access — a self-hosted daemon on a VPS cannot be controlled from a user's local machine.

The specific requirement is: a user self-hosting a daemon with Docker can open `https://my-daemon.example.com/#agent=<root-agent-id>` in their browser, and the Chat UI establishes an authenticated session as that agent's profile.

Source: [designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
