---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_path: packages/where/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
  - getting-started
genre: §endo-source-comment-fragment
cycle: 167
lane: chat
status: current
title: §Four-state-domains-as-distinct-paths
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

The file distinguishes **four** state domains, each with
its own resolver:

| Function | Domain | Loss-on-restart? | Loss-on-cache-purge? |
|----------|--------|------------------|---------------------|
| `whereEndoState` | Durable state (apps, capabilities, pet names) | No | No |
| `whereEndoEphemeralState` | Ephemeral state (PID files) | Yes (sometimes) | No |
| `whereEndoSock` | UNIX socket / named pipe path | Yes | No |
| `whereEndoCache` | Re-creatable cache (bundle compilation) | No | **Yes** |

§Four-domains-not-one-because-each-has-different-loss-and-
visibility-requirements. §Cache-vs-state-split-honors-XDG-
canon: §XDG_STATE_HOME survives `rm -rf ~/.cache`; §XDG_
CACHE_HOME doesn't.

§Why-PID-files-are-ephemeral-but-sockets-too: PIDs are
meaningless after reboot (the process is gone). UNIX socket
files are §inode-paths-that-need-to-be-removable on daemon
restart. Putting both in `XDG_RUNTIME_DIR` (which is purged
on reboot) means §the-OS-cleans-up-after-us.

§Why-state-survives-but-ephemeral-doesn't: durable state
encodes user choices (pet names, capabilities); ephemeral
state encodes only §current-session-coordinates. Conflating
them would §lose-user-state-on-reboot.
