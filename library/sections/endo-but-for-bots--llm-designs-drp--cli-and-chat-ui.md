---
title: CLI (endo paths) + Chat UI (Paths panel + disincarnate/reincarnate)
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, tooling]
status: current
notes: Compare CLI notation to the sibling RPN design (cycle 42): RPN uses the 5-prefix system (`@`/`*`/`/`/`:`/`~peer:`) for one-line-per-path rendering; this design uses indented multi-line rendering with bold/italic styling. Both consume the same typed RetentionPath. **Disincarnate** maps to `cancelValue(targetId, reason)` at `daemon.js:2858` (drops in-memory exo + aborts ongoing work, but keeps formula JSON; next access reincarnates from disk). **Reincarnate** maps to `provide(targetId)` followed by re-attaching subscriptions. Both host-only. The deny-list for disincarnation suppresses the button for `endo`, `host-agent`, the user's own agent.
---

> Abstract: **CLI**: `endo paths <name-or-locator> [--locator] [--json]`. Default: accepts a pet name (or `petname/path`) and resolves via host's `identify`. `--locator`: argument is already-encoded locator. `--json`: raw `RetentionPath[]`. Default human-readable output: one path per block, segments newline-separated, `pet:<name>` rendered as `<name>` in bold, field labels rendered as `→<field>` in italics, group's primary type shown per segment line. **Chat UI**: every rendered value gains a "paths" affordance (chain-link icon); clicking opens the **Paths panel**, a floating panel anchored to the value listing every path. Each pet-name segment is a clickable chip; field-edge segments are small grey `→<field>` arrows; the leaf is highlighted. Per-path **"Delete pet name on this path"** button (enabled if path has ≥1 `pet:<name>` edge in a host-writable store; confirmation lists all names that would be removed). Single **"Disincarnate"**/**"Reincarnate"** toggle for the target itself. The panel subscribes via `followRetentionPaths(locator)`; closing drops the far ref → subscription released. **"Delete pet name" semantics**: calls `host.remove(...namePath)` once per `pet:<name>` segment on the selected path, in path order root-to-leaf. Subscription emits a delta as each removal becomes visible; the panel shows the path crossing out and disappearing reactively. **Disincarnate/Reincarnate** are existing daemon affordances; disincarnate = `cancelValue(targetId, reason)` (drops in-memory exo + aborts work; next access reincarnates from disk); reincarnate = `provide(targetId)` + re-attach subs. Host-only; deny-list suppresses for critical formulas (`endo`, `host-agent`, user's own agent).

### CLI: `endo paths`

```
endo paths <name-or-locator> [--locator] [--json]
```

- Without flags, accepts a pet name (or `petname/path`) and resolves it via the host's `identify` to a locator before calling `listRetentionPaths`.
- `--locator` interprets the argument as an already-encoded locator.
- Default output is human-readable, one path per block, segments newline-separated, with `pet:<name>` rendered as `<name>` in *bold* and field labels rendered as `→<field>` in italics. Each segment line shows the group's primary type (e.g. `pet-store`, `eval`, `handle`).
- `--json` emits the raw `RetentionPath[]` for scripting.

Example output (without `--json`):

```
$ endo paths shared-file
Path 1 (rooted at endo):
  endo (root)
    →pins
  pins (pet-store)
    "shared-file"
  shared-file (eval)

Path 2 (rooted at known-peers-store):
  known-peers-store (root)
    →peer
  bob (peer)
    retention
  shared-file (eval)
```

The first path is human-named (the user's own pin). The second is a cross-peer retention edge from Bob's agent. The user can see at a glance that *if I unpin "shared-file" but disconnect from Bob, the value still survives via Bob's retention*.

### Chat UI

#### Reveal button on every value

Each rendered value (in inbox, inventory, transcript, value modal) gains a "paths" affordance — a small chain-link icon next to the existing value chip. Clicking it opens the **Paths panel**.

#### Paths panel

A floating panel anchored to the value, listing every path with the same notation as the CLI:

- Pet-name segments render as a clickable chip with the bold pet name and the parent store's label.
- Field-edge segments render as a small grey arrow `→<field>` between segment chips.
- The leaf segment (the target value) is highlighted.
- Above each path: a per-path **"Delete pet name on this path"** button, enabled only if the path contains at least one `pet:<name>` edge in a store the host can write. Clicking it shows a confirmation listing the names that would be removed (one per `pet:` edge along the path).
- Below the path list: a single **"Disincarnate"** / **"Reincarnate"** toggle for the target value itself (see below).

The panel subscribes via `followRetentionPaths(locator)` and updates in place. Closing the panel drops the far reference, releasing the subscription.

#### Disincarnate / reincarnate

These are existing daemon affordances, surfaced in the panel:

- **Disincarnate**: equivalent to `cancelValue(targetId, reason)` (`daemon.js:2858`), which drops the in-memory exo and aborts ongoing work for that ID without removing the formula JSON. The next access reincarnates from disk. Useful for clearing a stuck eval or making a worker rehydrate its agent.
- **Reincarnate**: equivalent to `provide(targetId)` followed by re-attaching to any existing subscriptions. Surfaced as a button only when the target is currently in a not-incarnated state (the panel polls or watches an incarnation-state event for this).

Both operations are gated to the **host** facet — not exposed to guests. The panel's `Disincarnate` button is hidden if the targeted formula is not host-owned (e.g., when the target is the host's own agent — disincarnating that would lock the user out).

#### "Delete pet name" semantics

The existing `host.remove(...namePath)` removes a single pet name from a single pet store. The Chat UI's per-path delete button calls `host.remove(...)` once per `pet:<name>` segment on the selected path, in path order from root to leaf. The subscription will emit a delta as soon as each removal is visible to the GC graph; the panel shows the path crossing out and disappearing reactively.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
