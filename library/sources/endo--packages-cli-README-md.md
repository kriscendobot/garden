---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/cli/README.md
source_line_range: 1-5
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 373 designs-lane ingest. 5-line README for @endo/cli,
  the user-facing command-line interface to the @endo/daemon.
  **TWENTY-SEVENTH package** added to pivot cluster. Twenty-
  first AUTHORED conformant single-body section doc in post-
  refactor era. Sixty-three consecutive non-garden sources
  after the pivot (310-373). §sixty-three-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-user-
  interface-as-thin-controller-to-process — the CLI is the
  USER-FACING surface to an INTERNAL persistent process. NEW
  SHAPE: §the-named-user-interface-as-thin-controller-package.
  SIXTH new shape introduced post-pivot, joining discipline-
  as-package (cycle 359) + testing-substrate-bridge (cycle 361)
  + private-package-as-internal-tooling (cycle 363) + meta-
  template-package-as-skeleton (cycle 365) + persistent-
  daemon-process (cycle 369).

  §The-named-cli-daemon-pair-as-two-package-architecture —
  cycle 369's @endo/daemon README named the "controller
  manages daemon lifecycle" as a TWO-PART package shape (the
  daemon and the controller). Cycle 373 reveals that the
  controller's USER-FACING form lives in a SEPARATE package
  (@endo/cli). The two-part package becomes a three-part
  architecture: the daemon (long-running process) + the
  controller (lifecycle management programmatic API; in
  daemon) + the CLI (user-facing command surface; in cli).
  §the-named-three-part-architecture-daemon-controller-CLI as
  tier-3 meta-pattern.

  §The-named-application-runner-as-daemon-synonym — line 3-4:
  "The Endo command line is a user interface for managing the
  Endo application runner (daemon)." The README calls the
  daemon "the Endo application runner" with the daemon as
  parenthetical alias. Vocabulary choice: "application
  runner" emphasizes the running-of-apps function over the
  daemon-process function. §the-named-vocabulary-choice-for-
  broader-audience-recurs (cycle 369's §the-named-vat-
  vocabulary-implicit-not-named was the first instance; cycle
  373's "application runner over daemon" is the second; the
  Endo project consistently picks broader-audience vocabulary
  in user-facing surfaces).

  §The-named-five-line-README-for-substantial-CLI — the CLI
  has many subcommands (mkdir, store, spawn, mail, install,
  bundle, etc.) — substantial command surface, 5-line README.
  Pairs with cycle 369's @endo/daemon (14-line README, vast
  implementation) and cycle 365's @endo/skel (3-line README,
  full blueprint package.json) and cycle 363's @endo/
  benchmark (8-line README, private cross-engine tool). §the-
  named-minimal-README-for-substantial-system as recurring
  tier-3 meta-pattern; THIRD instance after daemon and skel
  (or FOURTH counting benchmark).

  §The-named-lifecycle-management-as-named-CLI-purpose — line
  5: "This includes managing the lifecycle of the daemon
  process." The CLI's primary job is named explicitly: start,
  stop, restart, status. The READING confirms cycle 369
  daemon README's framing that the controller is the
  lifecycle manager; cycle 373 reveals the CLI is the
  user-facing form of that controller.

  §The-named-Endo-as-application-platform — the README's
  vocabulary positions Endo as an "application" platform
  (the daemon runs "applications"; the CLI manages the
  "application runner"). This is a higher-level framing than
  the substrate/library framing of most other Endo packages.
  §the-named-package-positions-the-project-as-platform as
  tier-3 meta-pattern; the CLI README does meta-positioning
  work for the project as a whole.

  Closes seven citation arcs: cycle 372 (1, adjacent forward
  pair compartment-mapper utility → cli README; both are
  small surfaces of larger systems) + cycle 369 (1, daemon
  README's two-part architecture extended to three-part with
  CLI as user-facing controller) + cycle 365 (1, skel's
  minimal-README-for-substantial-system pattern recurs) +
  cycle 363 (1, benchmark's minimal-README pattern recurs) +
  cycle 339 (53, lockdown is part of what the daemon runs) +
  cycle 326 (46, pure-naming-as-discipline sibling) + cycle
  322 (47, @endo/errors not used; CLI is too thin to need
  error decoration in its README). Pushes citation-arc-
  closures-in-pivot to TWO-HUNDRED-EIGHTY-THREE (276 + 7
  net new).
---

5-line README for @endo/cli (twenty-seventh package in pivot cluster). User-facing CLI to the @endo/daemon. §the-named-user-interface-as-thin-controller-to-process (single most structurally interesting move; SIXTH new shape introduced post-pivot). §the-named-cli-daemon-pair-as-two-package-architecture (extends cycle 369 two-part architecture to three-part: daemon + controller + CLI). §the-named-application-runner-as-daemon-synonym (vocabulary choice for broader audience; second instance after cycle 369). §the-named-three-part-architecture-daemon-controller-CLI. §the-named-five-line-README-for-substantial-CLI. §the-named-minimal-README-for-substantial-system (recurring; fourth instance). §the-named-lifecycle-management-as-named-CLI-purpose. §the-named-Endo-as-application-platform (CLI README does meta-positioning work for the project). Seven citation arcs closed.
