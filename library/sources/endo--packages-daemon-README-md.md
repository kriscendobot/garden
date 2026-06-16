---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/daemon/README.md
source_line_range: 1-14
ingested: 2026-06-16
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 369 designs-lane ingest. 14-line README for @endo/
  daemon, the persistent-process host for managing guest
  programs in hardened JavaScript worker processes.
  **TWENTY-SIXTH package** added to pivot cluster.
  Seventeenth AUTHORED conformant single-body section doc in
  post-refactor era. Fifty-nine consecutive non-garden sources
  after the pivot (310-369). §fifty-nine-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  persistent-process-as-package — the daemon is a long-running
  process, not a library. Every prior cluster member is a
  library (functions and classes imported by other code). The
  daemon SHIPS A PROCESS that runs continuously and accepts
  connections. §the-named-process-not-library as tier-3 meta-
  pattern. NEW SHAPE: §the-named-persistent-daemon-process-as-
  package — the FIFTH new shape introduced post-pivot, joining
  discipline-as-package (cycle 359) + testing-substrate-bridge-
  as-package (cycle 361) + private-package-as-internal-tooling
  (cycle 363) + meta-template-package-as-skeleton (cycle 365).

  §The-named-controller-manages-daemon-lifecycle — line 3-4:
  "This package provides the Endo daemon and controller. The
  controller manages the Endo daemon lifecycle." TWO-PART
  package: the daemon (the running process) AND the controller
  (the lifecycle manager). §the-named-two-part-package-daemon-
  and-controller as tier-3 meta-pattern; sibling shape to cycle
  365's skel where README and package.json had dual nature.

  §The-named-CapTP-over-netstring-message-envelopes — lines
  11-12: "Over that channel, the daemon communicates in CapTP
  over netstring message envelopes." CapTP is Mark Miller's
  Capability-Transport Protocol (public knowledge in
  capability-style systems literature). Netstring is the
  cycle 318 wire format. The daemon STACK is: Unix socket +
  netstring framing + CapTP protocol + user-agent capabilities.
  §the-named-four-layer-protocol-stack as tier-3 meta-pattern.
  Closes the netstring citation arc forward into its production
  use.

  §The-named-Unix-domain-socket-or-named-pipe-channel — line 9:
  "The daemon communicates through a Unix domain socket or
  named pipe associated with the user." Two transport
  alternatives named (Unix-socket for Unix-like; named-pipe for
  Windows). §the-named-platform-specific-transport-as-named-
  pair as tier-3 meta-pattern.

  §The-named-per-user-storage-and-compute-access — line 9-10:
  "manages per-user storage and compute access." Isolation
  boundary at the user level; the daemon runs per-user. §the-
  named-user-as-isolation-boundary as tier-3 meta-pattern.

  §The-named-hardened-JavaScript-worker-processes — line 6-7:
  each guest program runs in a hardened JavaScript worker
  process. Double isolation: lockdown (per-vat) AND process
  boundary (per-guest). §the-named-double-isolation-lockdown-
  plus-process-boundary as tier-3 meta-pattern.

  §The-named-bootstrap-provides-user-agent-API — line 13-14:
  "The bootstrap provides the user agent API from which one can
  derive facets for other agents." Bootstrap is the root
  capability handed to the connecting client; the user agent is
  the entry point; facets are sub-capabilities derived from the
  user agent and delegated to other agents. This is the §the-
  named-least-authority-via-facets discipline from cycle 367
  exo realized at the daemon level. §the-named-user-agent-as-
  root-bootstrap-capability as tier-3 meta-pattern.

  §The-named-guest-programs-vocabulary — line 6: "guest
  programs" (not "applications", not "modules"). The vocabulary
  treats hosted code as guests in the daemon's house. §the-
  named-host-guest-relationship-as-vocabulary as tier-3 meta-
  pattern.

  §The-named-vat-vocabulary-implicit-not-named — interesting
  absence: the README does NOT use the word "vat" even though
  the Endo ecosystem uses vat as the canonical term for a
  message-passing isolation boundary. The README says "hardened
  JavaScript worker processes" instead. Possible reason: vat is
  Agoric-specific vocabulary; daemon README aims at a broader
  audience who don't know vat. §the-named-vocabulary-choice-
  for-broader-audience as tier-3 meta-pattern.

  §The-named-fourteen-line-README-for-substantial-system — the
  daemon is a complex multi-package subsystem (daemon process +
  controller + worker process management + CapTP + storage),
  but the README is 14 lines. Pairs with cycle 363's benchmark
  (8-line README, substantial cross-engine system) and cycle
  365's skel (3-line README, blueprint package.json). §the-
  named-minimal-README-for-substantial-system as tier-3 meta-
  pattern; the package's design content lives elsewhere
  (source, package.json, examples).

  Closes nine citation arcs: cycle 368 (1, adjacent forward
  pair exo taxonomy → daemon README; both deal with vat/process
  boundaries but at different shapes) + cycle 367 (1, exo's
  least-authority-via-facets composes with daemon's facets-for-
  other-agents at process boundary; carry the OCAP discipline
  across library/process boundary) + cycle 365 (1, both minimal-
  README-for-substantial-system shape; skel is template-with-
  blueprint, daemon is process-with-controller) + cycle 363 (1,
  benchmark minimal-README shape sibling) + cycle 339 (51,
  Hardened JS worker processes use lockdown; §the-named-double-
  isolation-lockdown-plus-process-boundary) + cycle 337 (50,
  harden's defended interfaces compose with process isolation)
  + cycle 321 (7, eventual-send's vat vocabulary referenced
  implicitly via worker-processes naming) + cycle 318 netstring
  (1, netstring is the wire-format for CapTP messages here;
  closes netstring forward into production use) + cycle 326
  (42, pure-naming-as-discipline sibling). Pushes citation-arc-
  closures-in-pivot to TWO-HUNDRED-FIFTY-THREE (244 + 9 net new).
---

14-line README for @endo/daemon (twenty-sixth package in pivot cluster). Persistent-process host for guest programs in hardened JS worker processes. §the-named-persistent-process-as-package (single most structurally interesting move — NEW SHAPE; FIFTH new shape introduced post-pivot). §the-named-controller-manages-daemon-lifecycle (two-part package). §the-named-CapTP-over-netstring-message-envelopes (closes netstring arc forward; four-layer protocol stack: Unix socket + netstring framing + CapTP + user-agent capabilities). §the-named-Unix-domain-socket-or-named-pipe-channel. §the-named-per-user-storage-and-compute-access. §the-named-hardened-JavaScript-worker-processes (double isolation: lockdown + process boundary). §the-named-bootstrap-provides-user-agent-API (least-authority-via-facets at daemon level). §the-named-guest-programs-vocabulary. §the-named-vat-vocabulary-implicit-not-named (interesting absence). §the-named-fourteen-line-README-for-substantial-system. Nine citation arcs closed.
