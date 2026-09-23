---
title: Abstract
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
parent: endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration
---

The §opening Problem block (lines 10-29) names *Claw-like* (Claude-Code-like, after the lal "Claw" framing) AI coding agents and their *ambient-authority tool set*: read files, write files, execute shell, run git, search codebases. The §gap-and-solution framing: Endo's capability model can provide *the same tools with principled confinement* — `Dir` capability scoped to a project directory, `Shell` capability with command allowlist, `Git` capability scoped to a repository. The agent can do useful coding work *without ambient access to `~/.ssh`, `~/.aws`, or arbitrary network commands*. The §design bridges cycle 105's `daemon-capability-bank` (meta-framework) with the *concrete tools an AI agent uses for coding assistance*. The §explicit **Revision note (2026-05-18)** names three later designs that *refine this sketch*: `daemon-mount-capabilities` (local git authority should derive from `EndoMount`); `daemon-git-capability` (path authority should flow through mount-scoped descriptors); `daemon-git-remotes` (remote git should be granted separately through bounded `GitRemote` capabilities rather than omitted). The §Design (lines 40-273) decomposes into seven subsections. The §Tool categories table (lines 42-52) names four tool groups: Filesystem (via `Dir`: `readFile`/`writeFile`/`listDir`/`glob`/`stat`); Shell (via `Shell`: `exec`/`execInteractive`); Git (via `Git`: `status`/`diff`/`log`/`add`/`commit`/`checkout`/`branch`); Search (reuses `Dir`: `grep`/`glob`). The §filesystem tools section (lines 53-93) shows `registerFsTools(tools, dir)` registering five tool callbacks that delegate to the Dir's `openDir`/`openFile`/`subDir`/`list`/`glob` methods. The §structural-confinement claim: *the agent cannot navigate above the project root, cannot access `~/.ssh` or `~/.aws`, and cannot follow symlinks that escape the mount boundary*. The §Shell capability section (lines 94-143) defines a `makeShell({cwd, allowedCommands, env: filteredEnv, timeout, maxOutputBytes})` factory with the canonical 14-command allowlist (`node`/`npm`/`npx`/`yarn`/`python`/`python3`/`pip`/`make`/`cargo`/`go`/`grep`/`find`/`sed`/`awk`/`curl`), the `Shell.exec(command, args[])` interface with `M.interface('Shell', ...)` guard, and the array-based-execution + no-shell-expansion + allowlist-validation discipline. The §Git capability section (lines 145-181) defines a `Git` interface with `status`/`diff`/`log`/`add`/`commit`/`checkout`/`branch` + `M.interface('Git', ...)` guard, and *explicitly excludes* `git push`/`git pull` (network is separate capability), `git config` (no hook-setting), `git hook` (no persistence attack), and raw `git` command execution (all operations are method calls with validated arguments). The §Capability granting section (lines 183-211) shows both CLI grants (`endo grant fae fs /home/user/project` + `endo grant fae shell /home/user/project` + `endo grant fae git /home/user/project`) and programmatic grants via `E(powers).makeDir`/`.makeShell`/`.makeGit` + `E(powers).grant('fae', '<name>', <cap>)`. The §Agent tool discovery section (lines 213-254) shows the dynamic-registration pattern — agent looks up known capability names in its namespace at startup, registers tools per-capability, gracefully `catch`-and-skips when capability absent. *This means an agent's tool set is determined by the capabilities granted to it. An agent with only `fs` can read and write files but cannot execute commands. An agent with `fs` + `git` but no `shell` can do file operations and git operations but cannot run arbitrary processes.* The §Form-based capability provisioning section (lines 256-273) builds on `lal-fae-form-provisioning` — manager agent's setup form includes a `capabilities` field listing the cap-names to grant. The §Dependencies table (lines 275-282) names four sister designs: `daemon-capability-filesystem`, `daemon-capability-bank`, `lal-fae-form-provisioning`, `daemon-os-sandbox-plugin`. The §Phased implementation (lines 284-307) sketches four phases in dependency order: Filesystem → Shell → Git → Integration. The §Design Decisions (lines 309-333) name five rationale points: *Capabilities, not configurations*; *Dynamic tool registration*; *Git split by authority* (local Git excludes network); *Shell is array-based* (commands as `(command, args[])` tuples never shell strings); *Phased approach* (filesystem first because structural confinement is strongest). The §Related Designs (lines 335-350) cross-references seven sister designs including the three §Revision-note successors.
