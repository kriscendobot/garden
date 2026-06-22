---
title: CLI as execution-plus-daemon surface and per-command identity switch
source: packages/lal/primer/cli-reference.md
source_kind: primer
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/cli-reference.md
source_line_range: 1-85
source_commit: 81f1d64b8c28470e44014cf23e7f24805fbda7f3
source_date: 2026-04-09
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
topics: [cli, daemon, operator]
status: current
---

85-line `packages/lal/primer/cli-reference.md` — the Endo CLI reference for operators. Covers five command groups: Daemon Management, Inventory, Messaging, Execution, and Agents/Profiles/Personas. The CLI is the full administration+execution surface; it shares the inventory+messaging vocabulary with the Chat UI but diverges on both ends: it adds daemon lifecycle and code execution while Chat adds interaction-first extensions.

## CLI as execution-plus-daemon surface (no Chat equivalent)

The CLI exposes two categories wholly absent from the Chat UI:

**Daemon Management** (nine verbs): `endo start`, `endo stop`, `endo restart`, `endo status`, `endo ping`, `endo log` (with `-f` to follow), `endo where` (show state/cache/socket/log paths), `endo clean` (erase ephemeral state), `endo purge` (erase all persistent state). The daemon is an operator-managed process; the Chat UI assumes a running daemon and provides no lifecycle controls.

**Execution** (five verbs): `endo eval <source> [name:petname...] -n <result>` (evaluate JavaScript with named endowments), `endo run [--UNCONFINED] <file> [--powers <name>]` (run a program), `endo make <specifier> [--UNCONFINED]` (make a plugin/caplet), `endo spawn [names...]` (create a worker), `endo bundle <file> [-n <name>]` (bundle a program). The Chat UI has no equivalent execution commands; code execution is a developer+operator concern surfaced only through the CLI.

The shared vocabulary is inventory management (list, show, store, checkin, checkout, mount, locate, remove, move, copy) and messaging (inbox, send, reply, dismiss, clear, request, resolve, reject, adopt). Both surfaces reach the same daemon through the same operations; the differences reflect what each audience needs beyond the common core.

This closes the Chat/CLI asymmetry arc opened in cycle 445: Chat adds `/view`, `/edit`, `/dm`, `/network*`, `/share`, `/adopt-locator`, `/enter`, `/exit` for interactive navigation; CLI adds daemon lifecycle and execution for administration. Neither is a strict subset of the other; they are two audience-shaped projections of the same underlying capability model.

## Per-command identity switch via `-a`/`--as`

The `-a`/`--as` flag applies to any CLI command: it means "pose as named agent" (operate as another persona) for that one invocation. This is transient and per-command.

In contrast, the Chat UI's `/enter <host>` and `/exit` perform stateful profile navigation: entering a host switches the active identity context persistently until exit. The same underlying capability (operating as a different identity) appears in two UX models:

- **CLI**: `endo <command> --as <persona>` — per-command, returns to caller's identity immediately after.
- **Chat**: `/enter <host>` ... `/exit` — persistent context, spans multiple interactions.

The `-n`/`--name` flag, also universal, names the result of any command that produces a value.

## Define/endow as CLI attenuation commands

`endo define <source> --slots <name=label>...` proposes code with named capability slots for the host to fill. `endo endow <msgnum> <slot=name>...` binds capabilities to a pending definition and evaluates it. Together they implement the operator-side attenuated code injection pattern:

1. Agent proposes code with named holes (define with slots).
2. Operator reviews the proposal in their inbox as a message.
3. Operator binds real capabilities to the named slots (endow).
4. The code evaluates with exactly those capabilities — no others.

This is the CLI surface for the define/endow attenuation flow that `howto-code.md` (cycle 423) named as the preferred pattern for code that requires specific capabilities.

## Guest onboarding: invite/accept pair

`endo invite <guest>` creates an invitation for a guest identity. `endo accept <guest-name>` accepts an invitation from another Endo node. The Agents/Profiles/Personas section groups these alongside `endo mkhost <handle-name>` (create a host with separate mailbox and storage) and `endo mkguest <handle-name>` (create a guest). The invite/accept pair is the peering bootstrapping step: before two Endo nodes can share capabilities, they exchange invitations through this operator-mediated flow.

## Locate vs. share: surface-specific locator access

`endo locate <name>` retrieves the locator URL for a named value as a raw result. The Chat UI's `/share <name>` generates a shareable locator with connection hints (network-aware, peer-connection-ready). The underlying operation is the same — serializing a capability reference as a URL — but the CLI returns the raw locator while the Chat surface wraps it with the network hints needed for sharing across peer connections. The `/adopt-locator <locator> <name>` Chat command has no direct CLI equivalent; the CLI operator would use the locator output from `locate` directly.

## Additional vocabulary

`endo checkin <dir> -n <name>` / `endo ci` — check in a local directory as a readable tree; `endo checkout <name> <dir>` / `endo co` — check out a readable tree to a local directory. The `ci`/`co` shorthands transplant version-control vocabulary.

`endo cancel <name>` cancels a formula (terminates the formula's lifecycle). Distinguished from `endo remove <name>` / `endo rm` (removes the name from inventory without necessarily terminating a running formula). Two distinct operations: canceling a computation vs. removing a reference.

Source: [packages/lal/primer/cli-reference.md](https://github.com/endojs/endo-but-for-bots/blob/81f1d64b8c28470e44014cf23e7f24805fbda7f3/packages/lal/primer/cli-reference.md) at commit `81f1d64`.
