---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
---

# Pop the bonnet on pet-named capabilities with edit-toggle and retention-path reveal

> *Power users and developers need to inspect — and
> potentially edit — the formula graph to understand and debug
> the system.*
>
> — `designs/formula-inspector.md` §What is the Problem Being Solved

`formula-inspector.md` (110 lines, *Not Started* status,
created 2026-02-14 / updated 2026-02-24) is a small,
structurally clear "popping-the-bonnet" debug-tool design
sitting between daemon internals and the chat UI. Surfaces
the daemon's 26-formula-type structure to the user so they
can *see* what's behind each pet-named capability — and,
optionally, edit it.

## The §load-bearing-metaphor — *popping the bonnet*

> *There is no way for a user to "pop the bonnet" and see the
> underlying formula for a pet-named capability.*

The §pet-name-hides-the-formula observation: the chat UI shows
the *rendered value* of each capability (its pet name, its
display), but the daemon's storage holds a *richer formula
structure* — 26 types with fields like `worker`, `source`,
`endowments`, `hub`, `path`. Each pet name resolves to a
formula; the formula resolves to a value. The user normally
sees only the second layer.

The §popping-the-bonnet metaphor (from car mechanics) names
the move: *open the hood; see the engine*. The design surfaces
the formula layer to advanced users.

## The §26 formula types with type-specific metadata

The §Key-Interfaces subsection names the existing API the
design extends:

```js
export const InspectorHubInterface = M.interface(
  'EndoInspectorHub', {
  lookup: M.call(NameOrPathShape).returns(M.promise()),
  list: M.call().returns(M.array()),
});
```

The §`InspectorHub.lookup(petName)` API *already* returns
formula-type-specific metadata. The design lists six type-
specific shapes:

| Formula type | Metadata fields |
|--------------|-----------------|
| `eval` | `endowments`, `source`, `worker` |
| `lookup` | `hub`, `path` |
| `guest` | `hostAgent`, `hostHandle` |
| `make-bundle` | `bundle`, `powers`, `worker` |
| `make-unconfined` | `powers`, `specifier`, `worker` |
| `peer` | `NODE`, `ADDRESSES` |
| Other types | empty metadata object |

The §type-specific-metadata discipline lets the UI render
each formula type in a *type-appropriate* way: `eval` shows
syntax-highlighted source, `lookup` shows the hub+path chain,
`peer` shows the network identity.

The §`makePetStoreInspector` reference at
`packages/daemon/src/daemon.js` lines 3210-3319 points to the
existing implementation that *already* surfaces this
metadata — the design's add is mostly UI.

## The §formula-references-as-clickable-links discipline

> *Render formula identifier references as clickable links
> that navigate to the referenced formula's inspector view.*

The §formula-graph-as-hypertext idiom: when a formula's
`worker` field references *another* formula, the UI surfaces
that as a clickable link. Clicking navigates to the referenced
formula's inspector. The §navigation-via-formula-identifiers
discipline means the user can *walk the formula graph* node by
node.

The §formula-graph-is-a-DAG observation: formula identifiers
reference *other* formulas; chasing references lets the user
*see the dependency structure* of any capability. Combined
with the §retention-path-reveal subsection below, this gives
a complete *navigability story* over the daemon's persistent
state.

## The §edit-toggle-with-revise-API discipline

The §read-only-default-edit-toggle-opt-in discipline:

> *Read-only by default, with an "edit" toggle for advanced
> users that allows modifying mutable formula fields (e.g.,
> re-pointing a lookup path). Editing requires a new daemon
> API method — `E(agent).revise(petName, patch)` or similar —
> that validates and persists formula changes.*

The §`E(agent).revise(petName, patch)` API shape:

- **`agent`**: the agent under whose authority the revision
  runs (host-level required per §security).
- **`petName`**: which capability to revise.
- **`patch`**: the partial formula update (re-point a lookup
  path, change endowments, etc.).
- Returns a promise of the revised formula identifier (or an
  error if validation fails).

The §validation-on-revise discipline: the daemon *validates
formula invariants* before persisting (e.g., a `worker` field
must reference a valid worker formula). Editing a formula
isn't free-form JSON manipulation — it goes through the
daemon's invariant checks.

## The §retention-path-reveal facility

> *Provide a facility for revealing every retention path in
> the formula graph for identified formulas.*

The §retention-path-reveal subsection ties this design to the
cycle 49's retention-path-notation cluster
(`endo-but-for-bots--llm-designs-retention-path-notation`).
Each pet-named capability has *one or more retention paths* —
the chains of named references from a persistent root that
keep it alive in the persistent store.

The §why-retention-paths-matter discipline: removing the
*last* retention path GCs the formula. Showing retention
paths in the inspector tells the user *exactly which removals
will lose the capability*. Cycle 49's retention-path-notation
gives the *textual encoding* for paths; this design surfaces
the *visual rendering* in the inspector UI.

## The §CLI-mirror command

> *The CLI should gain an `endo inspect <name>` command that
> prints the formula JSON.*

The §two-surfaces-one-API discipline: the same
`InspectorHub.lookup()` data backs both the chat UI panel
*and* the CLI command. The §additive-CLI shape preserves
backwards compatibility — `endo` command grows by one verb;
nothing existing breaks.

## The §security-gated-edit discipline

§Security Considerations:

> *Formula editing is a highly privileged operation. It must
> be gated behind host-level authority and should log an audit
> trail.*

The §host-level-authority-required discipline: revising a
formula isn't *guest-accessible*. Only the host can call
`revise()` directly; guests must request host approval.

The §audit-trail-on-revise discipline: every `revise()` call
*logs* the before/after formula. Recovery from a mistaken
revise depends on having a record of what was there before.

The §inspection-vs-editing-security-asymmetry: *inspection*
exposes formula structure to the *owning user/host* (not
guests without explicit policy); *editing* is host-level only.
Two different authority gates for two different operations.

## The §three-affected-packages partition

§Affected Packages:

> - **`packages/daemon`** — surface inspector data, add
>   `revise` API for editing
> - **`packages/chat`** — new inspector panel UI
> - **`packages/cli`** — new `endo inspect <name>` command

The §three-layer-symmetry: daemon (data + revise API) → chat
UI (visual inspection) + CLI (JSON output). The split honors
the §thin-API-thick-UI principle — the daemon adds *one*
method (`revise`); the UI carries most of the work.

## The §Not-Started status — design-as-roadmap

§Status: **Not Started**. The §Not-Started-design-as-roadmap
shape: this file *specifies* the feature but doesn't yet
*implement* it. The §existing-API-leverage observation (most
of the data is *already* available via `InspectorHub.lookup`)
suggests the implementation path is *additive* on existing
infrastructure rather than new substrate.

The §test-plan-Maybe-subsection is honest about uncertainty:

> *Maybe:*
> *- Unit test: InspectorHub.lookup() returns correct metadata
>   for each formula type.*
> *- UI test: Formula inspector panel renders and navigates
>   formula references.*

The §Maybe-prefix discipline names tests as *uncertain
candidates* rather than *required additions*. Honest about
what the test scope might be at design time.

## Related sections

- cycle 49
  [[endo-but-for-bots--llm-designs-retention-path-notation--retention-path-notation]]
  — the retention-path notation this inspector visualizes.
- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — *capabilities-are-objects-not-configurations*: the formula
  inspector surfaces the *object structure* that backs each
  pet-named capability.
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--shared-capabilities-as-system-wide-bus]]
  — the capability-bus that holds the formula graph this
  inspector traverses.
- cycle 122
  [[endo-but-for-bots--llm-designs-endopi-edit-tool--single-tool-for-edit-with-explicit-replace-or-patch-modes]]
  — *edit-toggle* discipline parallel: the endopi edit tool
  also defaults safe-read-only with explicit opt-in for write.
