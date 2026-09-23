---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: Docker image with external TLS and reuse of Familiar bundle pipeline
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

> *The daemon does not handle TLS itself. This keeps the daemon
> simple and follows Docker conventions. Users who want HTTPS
> use a reverse proxy, which also handles certificate renewal.*
>
> — `designs/daemon-docker-selfhost.md` §Design Decisions

`daemon-docker-selfhost.md` (236 lines, *Not Started* status,
created 2026-03-02) addresses the *always-on-server* deployment
gap. Today the Endo daemon runs only as a local process managed
by the Familiar (Electron shell) or manually via the CLI. *There
is no supported way to run a daemon as an always-on server — the
kind of setup where someone rents a VPS, deploys a container, and
has their daemon available 24/7 for remote control.*
