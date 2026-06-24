---
host: endolin
role: liaison
dispatch_id: 5afd98
date: 2026-06-02
kind: result
---

# result(librarian, cycle 107): daemon-agent-tools — Dir/Shell/Git capabilities + dynamic tool registration (1 section); **daemon AI-agent-capability layer triangle complete**

**Cycle**: 107 (pivoted from chat-lane (exhausted) to daemon-design-lane).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/daemon-agent-tools.md` (350 lines), last touched 2026-05-18 by Kris Kowal (prompted).

## What

Ingested the **Not Started** `daemon-agent-tools` design — the *concrete-tool-shapes* design that bridges cycle 105's `daemon-capability-bank` meta-framework with the Claw-like (Claude-Code-like) AI-coding-agent tool set. The 350-line design unifies four-tool-group taxonomy (Filesystem/Shell/Git/Search), three capability shapes (Dir/Shell/Git), capability-granting via pet-name, dynamic tool discovery, form-based provisioning, five Design Decisions, and four-phase implementation plan. Single-section cohesion-honest ingest.

### Section drafted

1. **Dir/Shell/Git capabilities + dynamic tool registration** (full file, lines 1-350) — single cohesive ingest. The §opening Problem names *Claw* (Claude Code), Cursor, Devin as the target AI agents with *ambient authority*. The §explicit **Revision note (2026-05-18)** names three later refining designs: `daemon-mount-capabilities` (local git authority derives from `EndoMount`), `daemon-git-capability` (path authority flows through mount-scoped descriptors), `daemon-git-remotes` (remote git granted separately through bounded `GitRemote` capabilities rather than omitted). The §four-tool-group taxonomy (Filesystem via Dir / Shell via Shell / Git via Git / Search reuses Dir). The §Dir capability provides structural confinement (no above-root navigation; no `~/.ssh` access; no escaping symlinks). The §Shell capability with 14-command allowlist + array-based execution (no shell expansion) + filtered-env + timeout + max-output-bytes. The §Git capability is local-only with explicit exclusions of `push`/`pull` (network is separate), `git config` (no hook-setting), `git hook` (no persistence attack), raw `git` command exec. The §pet-name capability granting (`endo grant fae fs /home/user/project`) + programmatic grants via `E(powers).makeDir`/`.makeShell`/`.makeGit` + `E(powers).grant(...)`. The §dynamic tool-discovery pattern — agent looks up known cap-names at startup, gracefully skips when absent. The §form-based capability provisioning extends `lal-fae-form-provisioning`. The §five Design Decisions: *Capabilities, not configurations* / *Dynamic tool registration* / *Git split by authority* (local-only excludes network) / *Shell is array-based* / *Phased approach*. The §four-phase implementation: Filesystem → Shell → Git → Integration.

### Library state after this cycle

- **608 sections** (was 607) / **152 sources** (was 151) / **44 concepts** (unchanged).
- Topic pages updated: `daemon.md` (+1 row), `capability-security.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~35 daemon-agent-tools keywords (Claw / Dir/Shell/Git capability shapes / 14-command allowlist / array-based execution / Git split by authority / dynamic tool registration / try-lookup-catch-skip pattern / Revision-note refining lifecycle / EndoMount / GitRemote bounded capability).

## Daemon AI-agent-capability layer triangle complete

This cycle **completes** the daemon's AI-agent-capability layer documented in the library. The four-cycle triangle:

- **Cycle 101** `daemon-commands-as-messages` (Not Started) — *audit-trail* primitive; agent tool invocations become commands too via the same self-addressed-message mechanism.
- **Cycle 103** `daemon-value-message` (Complete) — *foundational reply-primitive*; the reply-primitive that agent-tool results flow through.
- **Cycle 105** `daemon-capability-bank` (Not Started) — *meta-framework*; family of nine sibling per-category designs with six Design Principles.
- **Cycle 107** `daemon-agent-tools` (Not Started, this ingest) — *concrete-tool-shapes*; bridges meta-framework with Claw-like AI agents.

Together the four cycles describe the *daemon's AI-agent-capability layer*: state primitives (value-message + commands-as-messages) + meta-framework (capability-bank) + concrete tool shapes (agent-tools).

## Notes

- The §*Revision note (2026-05-18)* lifecycle pattern is *honestly forward-referencing* and structurally distinct from cycle 99's chat-reply-chain (fully-deprecated with successor pointer in Status). Both are partly-superseded but: chat-reply-chain → fully superseded; agent-tools → refined-but-not-deprecated. The §design lifecycle vocabulary now has two named shapes in the library.
- The §*Git split by authority* design decision (local Git excludes push/pull; remote Git via separate `daemon-git-remotes` capability) is a worked example of the *one-capability-one-authority-domain* invariant. Conflating local + remote git would *smuggle network and credential authority into local repository access*.
- The §*capability-driven dynamic tool registration* pattern (`try { lookup('fs') ... } catch { skip }`) encodes capability-driven configuration without agent-code modification. *The same agent code works with or without coding capabilities; it simply has fewer tools available.* Reusable for any *runtime-configurable-via-capability-grants* shape.
- The §*Shell is array-based* design decision (commands as `(command, args[])` tuples, never shell strings) is the canonical *injection-prevention-via-no-shell-expansion* pattern. The OS-level exec primitive accepts the tuple directly; shell metacharacters in arguments are passed as literal characters.
- The §*Claw* parenthetical naming (*Claude-Code-like Capabilities*) reflects the lal-on-Claude-Code variant. The lal framework is the local-agent-library; Claw is its Claude-Code variant. Naming the target concrete makes the design's audience explicit.

## Next

- Cycle 108 (papers-lane): the persistent six-cycle papers-lane block (97/100/102/104/106) suggests structural pivot to comments-lane or designs-lane continues. Consider trying Saltzer-Schroeder 1975 or fresh URL search for Stiegler-Miller HPL-2006-116 if fresh PDF access becomes available.
- Cycle 109 (chat-lane): chat-cluster exhausted. Continue with broader endo-but-for-bots designs. Candidates: daemon-form-request (Implemented; 435 lines — likely 2 sections); daemon-mount (In Progress; 718 lines — 3+ sections); daemon-capability-bus (In Progress; 526 lines — 2 sections); daemon-capability-filesystem (Draft per cycle 105's table); familiar-* (10 designs); endopi-* (12 designs); ocapn-* (7 designs).
- Cycle 110 (comments-lane): `packages/exo/src/exo-makers.js` (242 lines); `packages/marshal/src/marshal-justin.js` (510 lines); `packages/patterns/src/keys/copySet.js` (109 lines); `packages/exo/src/exo-tools.js` (513 lines).

ScheduleWakeup 1500s for cycle 108.
