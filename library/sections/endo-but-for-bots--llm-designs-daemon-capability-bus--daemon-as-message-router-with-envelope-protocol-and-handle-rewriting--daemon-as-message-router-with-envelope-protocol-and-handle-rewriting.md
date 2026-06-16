---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: Daemon-as-message-router with envelope-protocol and handle-rewriting
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

> *The **daemon** is the long-running top-level process that owns
> the PID file and Unix socket, routes envelopes between its
> children, and enforces the sync-call spawn tree — the daemon
> ***is*** the capability bus. It runs no JavaScript itself.*
>
> — `designs/daemon-capability-bus.md` §Terminology

`daemon-capability-bus.md` is *In Progress*, dated 2026-02-25 (created)
/ 2026-04-11 (updated), authored by Kris Kowal. The 526-line design
records a **worldview shift**: the Endo daemon stops being a Node.js
process supervising Node.js workers, and becomes a *language-agnostic
message router* — a standalone Go or Rust binary that speaks one wire
protocol to every subprocess, JavaScript or otherwise. Phases 0-3
already shipped; phases 4-5 (syscall migration) are unbounded
follow-on work.
