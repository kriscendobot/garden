---
title: notify-server — a durable notification proxy with persist-then-dispatch and Markdown routing
source: notify_server/DESIGN.md
source_repo: jcorbin.tngl.sh/unum
source_commit: 7c0a32ce453a7e48f87b4669557004753c879186
source_date: 2026-04-16
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
notes: |
  unum's standalone notify-server: a lightweight HTTP proxy that absorbs
  notification boilerplate (auth, retry, formatting) behind a durable
  persist-then-dispatch queue, configured by a Markdown "Routedown" dialect.
  Compare to the garden's bulletin/notify path.
---

## Abstract

**notify-server** is a small standalone Go HTTP proxy that decouples notification *senders* from
*receivers*. Callers POST simple JSON; the server absorbs the boilerplate every CI job / cron task /
agent otherwise re-implements — auth headers, retry logic, formatting, downstream-service quirks — and,
crucially, **writes each request to disk before returning the HTTP response**, then dispatches with
exponential-backoff retry so **nothing is silently dropped**. Endpoints are declared in a single
Markdown config file (a dialect called **Routedown**). It is unum's answer to the same need the garden
serves with its bulletin/notify path; the transferable core is the **persist-then-dispatch-with-retry**
durability shape and the config-as-Markdown routing.

## Persist-then-dispatch: the durability contract

The server is two-directional: an **outgoing proxy** (an agent POSTs a simple notice; the server
encapsulates upstream API details — secrets, retries, formatting — so the caller needs no knowledge of
Telegram/etc.) and an **incoming webhook** (external services POST *in*, mapped to configured actions like
scheduling a timer or filing a task prompt). The durability guarantee is the point:

- A request is **written to the persistent on-disk queue before the HTTP response is sent** — an
  acknowledged request is already durable.
- Transient downstream failures are **retried with exponential backoff**; nothing is silently dropped.
- The server **shuts down gracefully on SIGINT/SIGTERM, draining in-flight requests** before exiting.

This is the "persist before you promise" discipline: never acknowledge a notification you haven't durably
recorded, and never let a downstream flake lose an already-acknowledged one. (It is the inbound sibling of
the LORE `notification_layer_ownership_single_emitter` rule — one emitter per user-visible event.)

## Routedown: routing config as Markdown

"**Routedown**" is Markdown with route semantics — each `H1` declares an endpoint, `H2` sections declare
its parameters, actions, and response:

- `# Endpoint: POST /path` (or `# Config.<KEY>` for inline config) heads an endpoint; prose after it is the
  description.
- `## Param: <name> <type>` declares a parameter, optionally with `(json_path: .a.b.c)` to extract from
  nested JSON, `(default: VALUE)`, or `(optional)`.
- `## Action: <spec>` declares an ordered, sequentially-executed action whose body is a Go `text/template`
  code block. Three action kinds by spec: **command** (prose spec, `bash` code block), **file** (`file://
  PATH append|write`, with `$VAR`/`${VAR}` expansion), and **http** (`https://HOST`, the code block being the
  request template).
- `## Response` optionally overrides the default `200 OK text/plain`.

Config values can be literal or **lazy loaders** (`func() (string, error)`) — a secret is resolved on demand
rather than baked into the file. The parser (`internal/routedown`), the action executors (`internal/action`),
the HTTP handler (`internal/server`), and the persistent queue (`internal/queue`) are cleanly separated
packages, and the config endpoint / status dashboard sit behind a control-plane auth layer. Path variables in
file targets expand from the environment, and the server exports its own data dir as `NOTIFY_SERVER_DATA_DIR`
for action templates.

The design lesson worth carrying: **a notification hand-off is a durability problem, not a formatting one.**
Putting the persist-then-dispatch queue and the retry/backoff in *one* proxy — behind a declarative,
secret-aware routing config — keeps every caller (agent, hook, cron) from re-implementing (and re-bugging) the
same auth-and-retry boilerplate.

Source: [notify_server/DESIGN.md](https://tangled.org/jcorbin.tngl.sh/unum) at commit `7c0a32c`.
