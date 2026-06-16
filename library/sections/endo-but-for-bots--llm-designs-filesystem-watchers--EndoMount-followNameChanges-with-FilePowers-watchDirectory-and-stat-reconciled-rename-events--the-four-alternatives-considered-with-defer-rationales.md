---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §four-alternatives-considered with §defer-rationales
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

| Alternative | Outcome |
|-------------|---------|
| **Polling diff** | Use as fallback inside FilePowers |
| **chokidar** library | Defer (50KB dependency for thin daemon; most value is glob matching not needed) |
| **inotify/kqueue direct bindings** | Defer to future Rust port |
| **fs.watchFile** | Use as per-entry fallback inside polling implementation |

The §three-of-four-deferred observation: most alternatives
are *legitimately useful* but *currently deferred*. The
§defer-with-named-trigger discipline:

- chokidar: *revisit if the hand-rolled wrapper accumulates
  platform-specific bug fixes*.
- inotify/kqueue: *track on the Rust-port roadmap*.

Each deferral names *what would trigger reconsideration*.
§deferred-not-rejected-distinction.

The §punt-platform-bindings-to-rust-port observation: the
*future Rust daemon implementation* is the natural home for
native OS-binding watchers. The §wait-for-the-natural-home
discipline.
