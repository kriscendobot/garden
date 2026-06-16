---
source: designs/daemon-engo-supervisor.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-engo-supervisor.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Not Started
genre: §endo-but-for-bots-design §unrealized-predecessor-of-cycle-176
cycle: 192
lane: designs
status: current
title: §Engo-does-not-modify-the-endo-CLI (the §scope-boundary)
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
Engo does not modify the `endo` CLI.  Users can run
`engo start` instead of `endo start` to use the Go
supervisor.  The daemon's Unix socket is at the same path, so
all `endo` commands work against an engo-managed daemon.

In the future, the CLI could detect engo's presence and
delegate to it, or engo could subsume the CLI's daemon
management commands.
```

§The-§scope-boundary-with-named-future-direction. §Initial-
scope: engo is a separate command (`engo start`); §future-
direction: CLI could detect engo or engo could subsume CLI.

§The-§initial-scope-preserves-the-`endo`-CLI-surface. §All-
existing-tooling-keeps-working. §Compare-to-cycle-190-endo-
posix-sandbox's §existing-tools-unchanged-externally (genie
tools unchanged; daemon-side spawn-channel-swapped). §Same-
discipline-different-layer.

§The-§Unix-socket-at-the-same-path makes engo-managed-daemon
indistinguishable-from-Node.js-daemon-managed daemon for the
`endo` CLI. §The-supervisor-is-transparent-to-the-client.
