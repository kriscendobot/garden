---
title: §Three-named-future-stronger-isolation-mechanisms (Landlock + container runtimes + Lightweight VMs)
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

§The-Problem-section names §three-future-paths-for-stronger-isolation:

1. **§Landlock** — Layered on top of bubblewrap for filesystem-scope and network-scope restrictions.
2. **§Container-runtimes** (Podman, LXC/Incus, systemd-nspawn, Docker) — Full namespace isolation including network namespace.
3. **§Lightweight-VMs** (Firecracker, Incus VMs) — Hardware-assisted isolation; strongest confinement; higher startup latency.

§Borrowable-pattern: §name-the-future-stronger-isolation-mechanisms with §per-mechanism-trade-offs-named (Landlock layers + container provides namespace + VM provides hardware-assisted at higher cost).

§Sibling to cycle 218 familiar-chat-weblet-hosting's §two-CapTP-transports + §primary-transport-and-stretch-goal-transport — both designs §enumerate-future-paths-with-trade-offs-named.
