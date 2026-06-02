---
source: designs/daemon-agent-tools.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-18
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-fifth endo-but-for-bots design ingest. **Status: Not
  Started**, with a §Revision note (2026-05-18) that names three
  later designs as *refining this sketch*: `daemon-mount-
  capabilities`, `daemon-git-capability`, `daemon-git-remotes`.
  The 350-line design is the *concrete-tool-shapes* design that
  bridges cycle 105's daemon-capability-bank (meta-framework)
  with the Claw-like AI-coding-agent tool set (read / write /
  shell / git / search). Three structurally interesting moves:
  (1) the *Claw* naming — parenthetical *Claude-Code-like
  Capabilities* names the user-facing-tool that motivates the
  design (LAL-on-Claude-Code variant); (2) the *capability-driven
  dynamic tool registration* pattern — *the same agent code works
  with or without coding capabilities; it simply has fewer tools
  available* — encodes capability-driven configuration without
  agent-code modification; (3) the *Git split by authority*
  design decision — local Git capability deliberately excludes
  push/pull (network is separate); fetch/pull/push live in
  daemon-git-remotes — the *one-capability-one-authority-domain*
  invariant.
  
  Pairs structurally with cycle 101's daemon-commands-as-messages
  (which names this design as *parallel consumer* — agent tool
  invocations become commands too via the same self-addressed-
  message mechanism), cycle 103's daemon-value-message (the
  reply-primitive that agent-tool results flow through), and
  cycle 105's daemon-capability-bank (the meta-framework this
  design implements concrete tool shapes for). Together cycles
  101+103+105+107 describe the *daemon's AI-agent-capability
  layer*: state primitives (value/commands) + meta-framework
  (capability-bank) + concrete tool shapes (agent-tools).
  
  The §Revision note pattern (refined-but-not-deprecated) is
  distinct from cycle 99's chat-reply-chain-visualization
  (fully-deprecated). Both are partly-superseded but the design
  lifecycle is different: chat-reply-chain has a *successor
  pointer in Status field*; agent-tools has a *Revision note
  with refinement-direction*. Single-section cohesion-honest
  ingest.
---

> Abstract: `designs/daemon-agent-tools.md` is the *concrete-tool-
> shapes* design that bridges cycle 105's daemon-capability-bank
> meta-framework with the Claw-like (Claude-Code-like) AI-coding-
> agent tool set. Four tool groups (Filesystem via Dir / Shell
> via Shell / Git via Git / Search reuses Dir) with the canonical
> capability-confined-equivalents discipline — agent receives
> Dir rooted at project, Shell with allowlist, Git scoped to
> repo; *no ambient access to `~/.ssh`, `~/.aws`, or arbitrary
> network commands*. The §opening Problem framing names *Claw*
> (Claude Code), Cursor, Devin as the target AI agents. The §Dir
> capability provides structural confinement (no above-root
> navigation; no `~/.ssh` access; no escaping symlinks). The
> §Shell capability has 14-command allowlist (`node`/`npm`/etc.)
> + array-based execution (no shell expansion) + filtered-env +
> timeout + max-output-bytes. The §Git capability is local-only
> with explicit exclusions: no `push`/`pull` (network is separate
> capability), no `git config` (no hook-setting), no `git hook`
> (no persistence attack), no raw `git` command execution. The
> §pet-name capability granting (`endo grant fae fs
> /home/user/project`) bridges CLI to programmatic
> `E(powers).makeDir`/`.makeShell`/`.makeGit` + `.grant(...)`.
> The §dynamic tool-discovery pattern — agent tries to look up
> known cap-names in its namespace at startup, registers tools
> per-capability, gracefully skips when absent — encodes
> capability-driven configuration without agent-code
> modification. The §form-based capability provisioning extends
> lal-fae-form-provisioning: manager agent's worker-setup form
> includes a `capabilities` field. The §five Design Decisions:
> *Capabilities, not configurations*; *Dynamic tool
> registration*; *Git split by authority* (local-only excludes
> network); *Shell is array-based*; *Phased approach*. The
> §four-phase implementation plan: Filesystem → Shell → Git →
> Integration. The §explicit **Revision note (2026-05-18)** names
> three later designs as refining this sketch:
> `daemon-mount-capabilities` (local git authority derives from
> `EndoMount`), `daemon-git-capability` (path authority flows
> through mount-scoped descriptors), `daemon-git-remotes`
> (remote git granted separately through bounded `GitRemote`
> capabilities rather than omitted).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [dir-shell-git-capabilities-and-dynamic-tool-registration](../sections/endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration.md) | daemon, capability-security | current |

The 350-line file is honestly one cohesive argument-cluster — *one unified sketch* of agent-tools-on-capabilities with Problem → per-capability shapes → granting → discovery → phasing → decisions → related designs. Single-section ingest preserves the unified structure; forcing a multi-section split would create artificial divisions within a single design proposal.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-05-18 by Kris Kowal (*prompted* — LLM-collaborated authoring). The 2026-05-18 update added the §Revision note pointing to three later refining designs.
- Verified file existence via bare-clone listing: 350 lines.
- **Twenty-fifth endo-but-for-bots design ingest**. Pairs structurally with cycles 101+103+105 to complete the *daemon's AI-agent-capability layer*:
  - **Cycle 101** `daemon-commands-as-messages` — names *daemon-agent-tools* as *parallel consumer*; agent tool invocations become commands too.
  - **Cycle 103** `daemon-value-message` — the reply-primitive that agent-tool results flow through.
  - **Cycle 105** `daemon-capability-bank` — meta-framework that this design implements concrete tool shapes for.
  - **Cycle 107** `daemon-agent-tools` (this ingest) — the concrete-tool-shapes layer bridging meta-framework and AI-agent tools.
- Cycle 107 was scheduled for chat-lane (exhausted as of cycle 99). Pivoted to daemon-design-lane (continuing the pattern of cycles 101, 103, 105).
- Single-section cohesion-honest count. The 350-line file is *one unified sketch* with per-capability subsections that all serve the same design proposal. Forcing a 2-section split would create an artificial divide between the per-capability shapes (Dir/Shell/Git) and the wiring/discovery/phasing.
- The §Revision note (2026-05-18) is *honestly forward-referencing* — the author updated the doc after writing the three later refining designs and added a note pointing to them. The §lifecycle pattern (refined-but-not-deprecated) is structurally distinct from cycle 99's chat-reply-chain (fully-deprecated with successor pointer in Status field).
