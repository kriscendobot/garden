---
ts: 2026-05-22T20:50:01Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
---

# Dispatch: designer authors a coherent narrative on confinement-stacked guests with `@fs`, `@main`, `@primer`, `@journal`, `@agent` capabilities and CLI/Chat verbs for attenuation

Dispatch root: `dispatches/designer--3f1ae3/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

## Maintainer directive (verbatim)

> Please dispatch a designer to peruse the existing design space for confined and unconfined plugins, plus the Posix sandbox and 9p filesystem, to build a coherent narrative for creating guests with specialized @fs and @main worker capabilities that stand on each of the various kinds of confinement. Consider creating a convention that guests can be created with each kind of filesystem slice, as well as a @primer and @journal as immutable and mutable filesystems for instructions, logging, and message passing in the same way we use the Garden. Consider creating a convention inherent to the daemon where a guest is spawned with a bot controller (albeit an inference engine) as well, to hold its @agent facet and communicate with other parties. A guest should be able to partition its own filesystems to create their own guests with attenuated capability. Host agents should be born with an unattenuated @fs mounted at the filesystem root. We may need CLI and Chat verbs for attenuating a filesystem capability: snapshotting, partitioning, controller faceting, or simply attenuating write privileges generally.

## Existing design space the new narrative integrates

The designer reads these first, in roughly this order, and lets the narrative emerge from what's already there:

| Design | What it carries forward |
|---|---|
| `designs/endo-posix-sandbox.md` (In Progress, Phase 3) | The POSIX sandbox plugin — "a slice of a POSIX-like system as a CapTP capability surface": confined process namespace + writable filesystem view + optional private network, GC-pinned by handle. This is one of the "kinds of confinement" the narrative stacks on. The PLAN at `PLAN/endo_posix_sandbox.md` is the authoritative phase log. |
| `designs/daemon-os-sandbox-plugin.md` (Superseded by `endo-posix-sandbox`) | Historical predecessor; read for the original framing of cross-platform OS-sandbox plugins. |
| `designs/daemon-make-archive.md` (In Progress, Phases 1-5 complete, 6-8 open) | The JS-side confined/unconfined dichotomy: `makeFromTree` (confined), `makeUnconfinedFromTree` (unconfined, with `@node` as a required host-scoped capability since Phase 6). The `@node` precedent is the load-bearing analogue for the new `@primer`, `@journal`, `@fs`, `@main`, `@agent` conventions. |
| `designs/daemon-worker-import-from-mount.md` (Proposed, just landed PR #358) | `makeFromPackage(workerPetName, mountName, options)` — the third rung above `makeFromTree`. `@registry` joins `@node` as a host-scoped required field on `HostFormula`. Same convention shape the new design extends. |
| `designs/daemon-mount.md` (In Progress) + `designs/daemon-mount-capabilities.md` (In Progress) + `designs/filesystem-watchers.md` (Proposed) | `EndoMount` formula + capability completion plan + live-watcher affordance. The `@fs` capability the new narrative names is plausibly an `EndoMount`. |
| `designs/daemon-capability-filesystem.md` (Proposed) | Filesystem capability ideas and directions; the proto-narrative the new design completes. |
| `designs/daemon-capability-persona.md` | Delegates and epithets — the agent-faceting precedent for `@agent`. |
| `designs/daemon-capability-bus.md` + `designs/daemon-capability-bank.md` | Capability bus + bank: the registration / grant / revoke shape the new conventions plug into. |
| `designs/daemon-agent-tools.md` (Claw-like Capabilities) | Agent-facing capability surface; cross-references the mount work. |
| `designs/endoclaw.md` + family | The endoclaw capability family establishes the grant/revoke + UI conventions. The new `@agent` facet for guests sits adjacent to these. |
| `designs/daemon-cas-management.md`, `designs/daemon-content-store-gc.md`, `designs/daemon-cross-peer-gc.md` | The content-addressed store layer the immutable `@primer` likely sits atop. |
| `designs/cli-edit-verb.md`, `designs/cli-store-verb-text-modes.md`, `designs/cli-http-client.md`, `designs/chat-command-bar.md`, `designs/chat-slot-slash-commands.md`, `designs/chat-view-edit-commands.md` | CLI + Chat verb-shape precedents — the new "attenuate / snapshot / partition / controller-facet" verbs follow these conventions. |
| `designs/daemon-guest-eval-simplification.md` | Guest evaluation simplification — adjacent. |
| `designs/formula-inspector.md` | Formula inspection — adjacent to the formula-graph the new conventions write into. |

### About "9p filesystem"

The maintainer named "9p filesystem" in the directive but **no design currently uses 9p as a term**. The Plan 9 / 9P protocol is plausibly being cited as a **modeling abstraction** for what the user is describing — the unified-filesystem-namespace-with-attenuation model 9P pioneered, where every resource is a file and every authority is a namespace mount. The designer should:

- Treat 9p as an **inspirational reference** for namespace-as-capability and uniform mount semantics, not as a literal wire protocol the daemon must speak.
- Cite it once or twice in the design's *Background* section to acknowledge the framing.
- If the design later requires speaking 9P (e.g., for interop with Plan-9-style tools or for exposing the EndoMount to FUSE-9P), surface it as a future-variant or open question, not as a Phase 1 deliverable.
- WebSearch / WebFetch authorized to refresh on 9P's namespace + bind / mount / clone-walk semantics if the designer needs the framing crisp.

### The Garden as a precedent for `@primer` / `@journal`

The maintainer named the *Garden* (this repo: `kriskowal/garden`) as the precedent for the `@primer` / `@journal` convention. The Garden uses:

- `journal/` — a separate git worktree on the orphan `journal` branch, where every action is recorded as a markdown entry (immutable in practice; entries are appended, rarely edited).
- `roles/` and `skills/` — the *primer*-shaped instructions the agents read on dispatch start; these come from `main`-branch worktrees and are read-only from the subagent's perspective.

The narrative's `@primer` likely models the read-only-instruction surface (Garden's `roles/` + `skills/`); the `@journal` likely models the append-only-log + message-bus surface (Garden's `journal/entries/` + `inboxes/` + `jobs/`). The designer cites this analogy concretely.

## Task

Produce a coherent **narrative** design across the conventions the maintainer named. Designer decides 1 vs. 2-3 documents per the *1-to-3-screens* rule in `garden/roles/designer/AGENT.md`. The substance is large; the maintainer's framing is one continuous arc, so **lean toward one overarching narrative with named subsections** rather than a fragmented stack, but split if any one section grows past 3 screens.

Suggested slug: **`guest-fs-confinement-narrative.md`** (one document) — designer picks final name. If splitting: `guest-confinement-stack.md` (the confinement layering + `@fs`/`@main` per layer) + `guest-special-names.md` (the `@primer`/`@journal`/`@agent` conventions + sub-guest partitioning) + `cli-chat-attenuation-verbs.md` (the verb surface).

### What the narrative covers

1. **Metadata table.** Status `Proposed`.
2. **What is the problem being solved?** Capture the maintainer directive verbatim (in the `## Prompt` section at the bottom) and frame the gap: the current corpus has confinement modes (POSIX sandbox, makeFromTree, makeUnconfinedFromTree, makeFromPackage) and filesystem primitives (EndoMount), but no coherent story about how a guest is *spawned* with the right `@fs` + `@main` for the chosen confinement level, no convention for `@primer` / `@journal` (in the Garden's sense), no daemon-inherent convention for spawning with a bot controller (inference engine), no story for sub-guest creation with attenuated capability, no CLI/Chat verbs for the attenuation operations.
3. **The confinement stack.** Lay out the kinds of confinement available today and how they compose:
   - **Compartment** (SES hardened JS — pure-capability JS confinement; no filesystem authority by default).
   - **`makeFromTree` confined worker** (XS worker reading from a precomposed tree; the tree is the only filesystem).
   - **`makeFromPackage` confined worker** (just-landed: package.json-rooted, npm-registry-proxy-resolved, EndoMount-backed source).
   - **`makeUnconfinedFromTree` Node worker** (unconfined `@node` access; for plugins that need real Node — see `daemon-make-archive` § Phase 8).
   - **`endo-posix-sandbox` POSIX slice** (process namespace + writable fs view + private network; for native subprocess work).
   - **Bare unconfined daemon** (the daemon itself — full host authority; reserved for special operators).
   - Each level has a different `@fs` shape (what the guest can read), a different `@main` shape (where its primary worker runs and what authorities it carries), and different `@primer` / `@journal` semantics (which storage backs them).
4. **Filesystem slices per confinement level.**
   - **Slice 1 — `@fs` itself.** What is mounted at the guest's filesystem root? For an unconfined host: the full machine filesystem (or whatever the daemon's user can see). For a `makeFromTree` confined worker: the tree itself. For a `makeFromPackage` confined worker: the EndoMount the package lives in, plus the registry-fetched module slices. For a POSIX-sandbox slice: the writable fs view the sandbox configured. For Compartment-only: no `@fs` at all (the guest cannot reach any filesystem).
   - **Slice 2 — `@primer`** (immutable). Read-only instructions, agent skill / role files, prompt content. Backed by content-addressed storage (the CAS — see `daemon-cas-management.md`); guaranteed never to change underfoot.
   - **Slice 3 — `@journal`** (mutable). Append-only log + inbox + outbox. Backed by EndoMount or a daemon-managed sqlite analogue (per `daemon-endo-rust-sqlite.md` if relevant); the guest appends, the daemon and other parties read.
   - **Slice 4+ — other named mounts.** `@apps` (already in `endo-gateway.md`), `@node` (already in `daemon-make-archive`), `@registry` (already in `daemon-worker-import-from-mount.md`). The new `@fs` / `@primer` / `@journal` / `@agent` fit cleanly into the same special-name convention.
5. **`@main` worker and the controller convention.**
   - `@main` is the guest's primary execution capability (the worker that runs its entry-point program). On each confinement level, `@main` is the corresponding worker invocation (XS for confined, Node for unconfined, sandbox-init for posix-sandbox, etc.).
   - **The bot-controller convention**: when a guest is spawned, the daemon attaches a *controller* (an inference engine) to the guest's `@agent` facet. The controller is responsible for: receiving the guest's outbound messages and routing them to its model (Anthropic API, local LLM, etc.); receiving model-generated tool calls and forwarding them as CapTP messages on the guest's behalf; appending observations to `@journal`; reading instructions from `@primer`. The controller is a daemon-managed capability the guest does not need to instantiate — it just *has* one. This mirrors how the Garden runs subagents under Claude Code: the agent (the LLM) is the controller; the dispatch root + role files are `@primer`; the journal entries + dispatch journal are `@journal`.
   - State whether the controller is *required* (every guest has one) or *optional* (only "agent-style" guests have one; "weblet-style" guests skip). Recommend optional but with a sensible default per guest-formula-kind.
6. **Sub-guest partitioning.** A guest can carve out a portion of its own `@fs` (a subdirectory, a snapshot, a read-only view) and a portion of its own `@journal` (a sub-stream, a subordinate inbox), then `makeGuest({ fs: subFs, journal: subJournal, primer: subPrimer, controller: subController? })` to create a sub-guest with attenuated authority. The sub-guest inherits the parent's confinement level (or lower); it cannot escalate. State the formula-graph implication: sub-guests appear as new formulas under the parent's namespace; the formula-inspector design (`designs/formula-inspector.md`) sees them through.
7. **Host agents are unattenuated.** "Host agents should be born with an unattenuated `@fs` mounted at the filesystem root." Make this explicit: the *host* (the top-level daemon-owned agent) carries the full machine `@fs`; the host's first act in creating any guest is to *attenuate* — never the reverse. There is no "promote my fs to root" operation; only "carve and grant a subordinate slice."
8. **CLI and Chat attenuation verbs.** Per the maintainer's list:
   - `endo fs snapshot <name>` / `:fs snapshot <name>` — freeze the current mutable `@fs` (or a sub-slice) into an immutable view. Snapshotting promotes a mutable mount to an immutable one (or produces a sibling immutable view; designer picks).
   - `endo fs partition <name> <subpath>` / `:fs partition` — carve a sub-slice for handoff. The partition is a name in the namespace; the sub-slice is bound to it.
   - `endo agent facet <name> <controller>` / `:agent facet` — bind a controller capability to a guest's `@agent`. Useful for swapping inference engines, revoking a controller, or initially granting one.
   - `endo fs write-attenuate <name>` / `:fs write-attenuate` — strip write authority from a capability, leaving read-only. Equivalent to "give me the same fs but read-only."
   - Other verbs the designer surfaces.
   - State whether these are *new* CLI/Chat verbs or refinements to existing `endo store`, `endo edit`, `endo view` verbs (per `cli-store-verb-text-modes.md`, `cli-edit-verb.md`, `chat-view-edit-commands.md`).
9. **Capability discipline.** What capability does the guest actually receive when its `@fs` slice is mounted? Read-handle? Read+write handle? Capability-attenuated NameHub (per `daemon-mount-capabilities.md`)? State the discipline so the builder later knows what the guest's runtime sees in `globalThis` / `powers`.
10. **Open questions.** Anything the maintainer's directive leaves under-specified. Likely candidates: where the controller's inference-engine credentials live (per-guest, per-host, daemon-wide?); how `@journal` persists across daemon restarts (always-on-disk, or backed by the CAS with periodic snapshots?); whether sub-guest creation requires an explicit parent-grants-permission flow or is an inherent guest authority; whether `@primer` is per-guest (each guest has its own primer set) or shared (one primer corpus across many guests); the GC story for sub-guest fs slices when the parent guest is itself garbage-collected.
11. **Phased implementation.** Suggested cuts: Phase 1 — establish the `@fs` / `@main` / `@primer` / `@journal` / `@agent` special-name convention at the formula-graph level; revise `daemon-make-archive` § Phase 6 (`@node`) and `daemon-worker-import-from-mount` (`@registry`) to fit the broader pattern. Phase 2 — implement the host-agent-born-unattenuated initialization. Phase 3 — sub-guest partitioning with the attenuation verbs. Phase 4 — controller convention (bot-controller wiring per guest). Phase 5 — POSIX-sandbox slice + 9p-style namespace mount as the "highest confinement" rung. Designer adjusts.
12. **Dependencies table.** Every design in the table above.
13. **Design decisions** with rationale — the bullet-style picks: controller required vs. optional default; per-confinement-level `@fs` shape; `@primer` backed by CAS vs. dedicated mount; `@journal` mutable mount vs. sqlite-style append-only log; new CLI verbs as `endo fs <verb>` vs. extending `endo store` / `endo edit` verbs.
14. **Prompt** — capture the maintainer's verbatim directive at the bottom per `designs/CLAUDE.md`.

## Procedure

1. Read `garden/roles/COMMON.md`, then `garden/roles/designer/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`. Index domain terms heavily — `@fs`, `@main`, `@primer`, `@journal`, `@agent`, `@node`, `@registry`, `@apps`, *confinement stack*, *POSIX sandbox*, *9p namespace*, *bot controller*, *inference engine*, *guest formula*, *host agent*, *attenuation verb*, *sub-guest*, *snapshot*, *partition*.
3. Read `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md`, `garden/skills/prompt-section-discovery/SKILL.md`.
4. Read `project/designs/CLAUDE.md`, `project/designs/README.md`.
5. Read the existing-corpus designs named in the table above. Take dense notes; they become the new design's *Dependencies* table.
6. Optional: WebSearch / WebFetch on Plan 9 / 9P / FUSE-9P if the framing needs sharpening. The narrative cites 9p once or twice as inspiration; do not deep-dive.
7. Decide on document count (1 narrative vs. 2-3 siblings). Draft.
8. Sync `project/designs/README.md`: new row(s), milestone assignment (likely M1 or M2 since this is foundational), dependency-graph edges from many existing designs into the new one(s), size estimate (L or XL).
9. Open as DRAFT PR against `endojs/endo-but-for-bots@llm`. Branch: `design/guest-fs-confinement-narrative` (or your final slug). Title: `design(daemon): coherent narrative for guest confinement stack with @fs, @main, @primer, @journal, @agent` (or condensed). Body cites the maintainer directive verbatim, lists the designs the narrative integrates, surfaces the open questions, names the design decisions.

## Per-action authorization

Standing on `endojs/endo-but-for-bots`: push to your `design/<slug>` branch, open draft PR against `llm`. WebSearch / WebFetch on Plan 9 / 9P references authorized. No comment authority outside the new PR's body. READ-ONLY on `endojs/endo`.

## Out of scope

- No implementation.
- No edits to `packages/daemon/` source.
- No edits to the existing designs the narrative integrates (the narrative *references* them; revisions to them are follow-up PRs).
- No upstream ferry. No un-draft.

## Report

≤ 800 words. PR URL + head SHA. The design file path(s) on llm. The 1-vs-2-3-design decision with rationale. The five-rung confinement-stack picture (one line per rung naming the `@fs` / `@main` shape). The controller-required-or-optional decision with rationale. The verb table (one row per new CLI/Chat verb). Open questions surfaced rather than answered. The Phase 1 deliverable's footprint (what concretely lands first). The 9p framing (one sentence: as-inspiration vs. as-wire-protocol). One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-designer-3f1ae3.md` and push journal (rebase if non-fast-forward).
