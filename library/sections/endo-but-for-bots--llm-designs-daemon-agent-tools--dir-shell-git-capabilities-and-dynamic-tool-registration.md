---
title: The §problem framing that names *Claw-like* (Claude-Code-like) AI coding agents and their *ambient-authority tool set* (read files / write files / execute shell / run git operations / search) as the gap the design fills with *capability-confined equivalents* (Dir-rooted at project / Shell with allowlist / Git scoped to repo); the §four-tool-group taxonomy (Filesystem via Dir / Shell via Shell / Git via Git / Search reuses Dir); the §filesystem tools (`readFile`/`writeFile`/`listDir`/`glob`/`stat`) backed by the Dir capability from `daemon-capability-filesystem`, with §structural confinement preventing navigation above project root + `~/.ssh`/`~/.aws` access + escaping symlinks; the §Shell capability with allowlist (`node`/`npm`/`npx`/`yarn`/`python`/`python3`/`pip`/`make`/`cargo`/`go`/`grep`/`find`/`sed`/`awk`/`curl`) + `cwd` + `filteredEnv` (no secrets) + `timeout` + `maxOutputBytes`; the §Shell interface uses `(command, args[])` tuples *never shell strings* to prevent injection + array-based execution + allowlist validation; the §Git capability that *deliberately excludes* `push`/`pull` (network is separate capability), `git config` (no hook-setting), `git hook` (no persistence attack), raw `git` command exec; the §pet-name capability granting via `endo grant fae <name> <path>` CLI + programmatic `E(powers).makeDir`/`.makeShell`/`.makeGit` + `E(powers).grant(...)`; the §dynamic tool-discovery pattern — agent looks up known capability names in its namespace at startup, registers tools per-capability, gracefully skips when capability absent (same agent code works with or without coding capabilities); the §form-based capability provisioning building on `lal-fae-form-provisioning` — manager agent includes capability grants in worker-agent setup form; the §five Design Decisions (capabilities-not-configurations / dynamic-tool-registration / git-split-by-authority / shell-array-based / phased-approach); the §explicit *Revision note (2026-05-18)* that names three later designs (`daemon-mount-capabilities` + `daemon-git-capability` + `daemon-git-remotes`) as *refining this sketch* — local git authority should derive from `EndoMount`, path authority should flow through mount-scoped descriptors, and remote git should be granted separately through bounded `GitRemote` capabilities; the §four-phase implementation plan (Filesystem → Shell → Git → Integration-and-discovery)
source: designs/daemon-agent-tools.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-18
source_authors: [Kris Kowal (prompted)]
source_lines: "1-350 (full file)"
topics: [daemon, capability-security]
status: current
notes: |
  Twenty-fifth endo-but-for-bots design ingest. **Status: Not
  Started**, with a §Revision note (2026-05-18) that *names three
  later designs as refining this sketch*: `daemon-mount-capabilities`,
  `daemon-git-capability`, `daemon-git-remotes`. The 350-line
  design is the *concrete-tool-shapes* design that bridges cycle
  105's daemon-capability-bank (meta-framework) with the *Claw-like*
  AI-coding-agent tool set (read / write / shell / git / search).
  Three structurally interesting moves: (1) the *Claw* naming —
  the title parenthetical *Claude-Code-like Capabilities* surfaces
  the user-facing-tool that motivates the design; (2) the
  *capability-granting via pet-name* mechanism connects the
  abstract capability model to concrete daemon operations
  (`endo grant fae fs /home/user/project`); (3) the §dynamic
  tool-discovery pattern — *the same agent code works with or
  without coding capabilities; it simply has fewer tools
  available* — encodes capability-driven configuration without
  agent-code modification.
  
  Pairs structurally with:
  - cycle 101's `daemon-commands-as-messages` (which names this
    design as a *parallel consumer* — agent tool invocations
    become commands too via the same self-addressed-message
    mechanism, giving daemon-capability-bank a built-in
    observability surface).
  - cycle 103's `daemon-value-message` (which names *future
    capability-grant-delivery* — value messages could carry the
    grants this design's capability-granting CLI uses).
  - cycle 105's `daemon-capability-bank` (the meta-framework
    this design implements concrete tool shapes for).
  - cycle 105's six Design Principles — applied directly here
    (capabilities-not-configurations, recursive attenuation,
    LLM discoverability via help() and M.interface() guards).
  
  The §Revision note pointing to three successor designs makes
  this a *partly-superseded sketch* — not deprecated like the
  cycle 99 chat-reply-chain-visualization, but explicitly
  identified as a sketch whose details are *refined* by later
  designs. Single-section cohesion-honest ingest reflects the
  design's unified Problem → Design → Granting → Discovery →
  Implementation argument.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--abstract.md)
- [Body](endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration--common-confusions.md)
