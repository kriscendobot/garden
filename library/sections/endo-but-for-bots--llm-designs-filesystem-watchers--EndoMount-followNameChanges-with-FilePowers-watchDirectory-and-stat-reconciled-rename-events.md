---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
---

# EndoMount `followNameChanges` with `FilePowers.watchDirectory` and stat-reconciled rename events

> *Hub abstractions that pick between a directory and a mount
> based on what the user has bound at a name path break down
> at the subscription edge.*
>
> — `designs/filesystem-watchers.md` §What is the Problem Being Solved

`filesystem-watchers.md` (486 lines, *Not Started* status,
created 2026-05-07) is a §parity-fix design by Kris Kowal
*(prompted)*. Source named in metadata: **Issue #110**.

The §design-from-sourced-issue lifecycle: the metadata cites
`Source: Issue #110`. Cycle 149's unhandled-rejection-display
was sourced from *issue + repro test PR*; cycle 157's
exo-zip-package was sourced from *PR inline review comment*;
this design's source is a *standalone issue*. §three-design-
sources-lifecycle observed across cycles 149 / 157 / 161.

## The §load-bearing-two-fold-problem

The §What-is-the-Problem-Being-Solved section names *two*
distinct problems:

1. **§Surface parity** — Code that consumes a `NameHub` for
   live updates (`chat-spaces-gutter`, the inventory view,
   the `endo log` follower) *cannot be retargeted at an
   EndoMount because the method is absent*. Polymorphic hub
   abstractions *break down at the subscription edge*.
2. **§Mechanism parity** — Even where polling is acceptable,
   every consumer *reinvents debounce, ordering, and
   disposal*. A central adapter from `node:fs` watcher events
   to `pubsub` lets callers share *one code path* with
   EndoDirectory consumers.

The §enumerate-two-problems methodology: rather than "EndoMount
needs follow," the design names *two* independent reasons
either of which would justify the fix. §multiple-independent-
justifications (parallel to cycle 153's CI design which named
*supply-chain + reproducibility + correctness*).

## The §single most structurally interesting move — §stat-reconciled-rename-events

The §Node-side adapter is the most technically interesting
piece. `fs.watch` emits `'rename'` *for both adds and removes*
— the OS-level notification doesn't tell you which. The
handler must reconcile via `stat`:

```js
for await (const event of watcher.events) {
  const childPath = filePowers.joinPath(target, event.name);
  const present = await filePowers.exists(childPath);
  if (present && !snapshotSet.has(event.name)) {
    // discovered: an add
    const isDir = await filePowers.isDirectory(childPath);
    if (await isConfinedPath(...)) {
      snapshotSet.add(event.name);
      yield { add: event.name, type: isDir ? 'directory' : 'file' };
    }
  } else if (!present && snapshotSet.has(event.name)) {
    // discovered: a remove
    snapshotSet.delete(event.name);
    yield { remove: event.name };
  }
}
```

The §stat-reconciled-rename-events discipline: the OS-level
event is *direction-agnostic*; the handler uses *stat* to
discover which direction. The §in-memory-set-as-truth pattern:
`snapshotSet` tracks *what we've already emitted*; comparing
current existence to that set yields the diff.

The §editor-save-dance-coalescing observation: editor patterns
(write-tmp + rename) generate `remove` + `add` pairs that
*shouldn't* be visible as such. The 50ms debounce window
collapses them. The §bookkeeping-over-in-memory-entry-set-not-
timer-per-event approach makes coalescing cheap.

The §rename-events-mean-something-changed observation: the OS
notifies "the directory's name table changed for some entry";
the user wants the *direction* of change. The reconciliation
step bridges the gap.

## The §FilePowers-extension-not-reach-into-Node discipline

The new primitive sits on `FilePowers`:

```ts
watchDirectory: (path: string) => {
  events: AsyncIterable<{ kind: 'add' | 'remove' | 'replace'; name: string }>;
  cancel: () => void;
};
```

The §minimal-platform-seam discipline: `EndoMount`'s body
calls `filePowers.watchDirectory(target)` — it doesn't reach
into Node's `fs.watch` directly. The §platform-agnostic-body
property: the same `EndoMount` body works on any platform
that provides `FilePowers`.

The §polling-fallback-inside-FilePowers observation: where
`fs.watch` is unavailable or unreliable (some network
filesystems on Linux where inotify fires inconsistently), the
`FilePowers` adapter falls back to *polling diff*. The
`EndoMount` body doesn't know or care.

The §interface-shaped-to-allow-future-implementations
discipline: the `events / cancel` return shape is intentionally
generic; a polling implementation can provide the same
contract.

## The §MountNameChange-vs-PetStoreNameChange shape asymmetry

```ts
type MountNameChange =
  | { add: string; type: MountEntryType }
  | { remove: string };

type MountEntryType = 'file' | 'directory';
```

vs `PetStoreNameChange`:

```ts
type PetStoreNameChange =
  | { add: string; value: IdRecord }
  | { remove: string };
```

The §interface-asymmetry-tracks-ownership-asymmetry observation
(echoed from cycle 157's exo-zip-package):

> *An `EndoMount` does not have formula identifiers to publish
> (file contents are not capabilities), so the second field
> carries the `stat`-derived kind instead, which is the
> information a consumer needs to decide whether to recurse.*

The §minimum-shape-difference discipline: keep the `add` /
`remove` *discriminant* identical so consumers' switch-cases
work; differ only in what *additional info* each variant
carries. The §discriminant-stable-additional-fields-vary
pattern lets polymorphic code mostly work, while typed-
consumers can branch on the extra data.

## The §subscription-bound-to-path-not-name property

> *A subscriber to `mount/foo` who calls `await
> E(mount).move('foo', 'bar')` keeps watching the moved-out
> directory; the receiver of the new name path opens its own
> watcher. This matches `EndoDirectory` semantics, where a
> subscription to `petName` survives the rename of `petName`.*

The §subscription-bound-to-path-not-name discipline. The
watcher holds an *OS-level handle to the directory*, not a
*name-table entry*. Moving the name binding doesn't move the
handle.

The §matches-EndoDirectory-semantics observation: the parity
applies *to invariants*, not just to the *method signature*.
A consumer's *temporal expectations* (what happens across
renames) work the same way.

## The §try-finally-is-load-bearing discipline

```js
async function* followNameChanges(...pathSegments) {
  const watcher = filePowers.watchDirectory(target);
  try {
    // snapshot loop
    // live event loop
  } finally {
    watcher.cancel();
  }
}
```

The §iterator-return-as-cleanup-trigger observation:

> *The `try / finally` is load-bearing: when the consumer
> calls `return()` on the iterator (the standard `for await
> … of` cleanup path, and what `makeIteratorRef` triggers
> when the remote subscription is dropped), `finally`
> releases the OS-level watcher handle.*

The §async-generator-finally-is-the-cleanup-hook idiom:
async generators *do* run their `finally` blocks when
`return()` is called on them — the JS spec guarantees it.
This makes `try / finally` *the* mechanism for releasing
resources.

The §remote-cleanup-via-CapTP-propagates-to-finally chain:
remote subscriber drops → `makeIteratorRef` releases →
iterator `return()` fires → `finally` runs → `watcher.cancel()`
releases the OS handle.

## The §confinement-flows-through-unchanged discipline

The §security-discipline-flows-through observation: the
`EndoMount` confinement model applies to both the subscription
*setup* (assertConfined before opening the watcher) and to
each *emitted event* (isConfinedPath filter per entry).

> *Symlinks added at runtime that point outside the root are
> silently dropped from the stream.*

The §silent-drop-not-error discipline: a symlink-outside is
*not* a violation worth raising. It's a *normal* filesystem
state that simply *isn't* visible through the confined view.
§silent-omission-vs-loud-error choice.

## The §four-alternatives-considered with §defer-rationales

| Alternative | Outcome |
|-------------|---------|
| **Polling diff** | Use as fallback inside FilePowers |
| **chokidar** library | Defer (50KB dependency for thin daemon; most value is glob matching not needed) |
| **inotify/kqueue direct bindings** | Defer to future Rust port |
| **fs.watchFile** | Use as per-entry fallback inside polling implementation |

The §three-of-four-deferred observation: most alternatives
are *legitimately useful* but *currently deferred*. The
§defer-with-named-trigger discipline:

- chokidar: *revisit if the hand-rolled wrapper accumulates
  platform-specific bug fixes*.
- inotify/kqueue: *track on the Rust-port roadmap*.

Each deferral names *what would trigger reconsideration*.
§deferred-not-rejected-distinction.

The §punt-platform-bindings-to-rust-port observation: the
*future Rust daemon implementation* is the natural home for
native OS-binding watchers. The §wait-for-the-natural-home
discipline.

## The §captured-resolution-trail (echoing cycle 157)

§Design Decisions opening note:

> *The following questions were raised during initial drafting
> and resolved in maintainer review on 2026-05-07. They are
> captured here for traceability rather than relitigation.*

The §captured-resolution-trail discipline (cycle 157's
exo-zip-package named the same pattern). Five questions
*were* open during drafting; each was *resolved* in same-day
review; resolutions folded into the body but the *trail
preserved* for future readers.

The §three-design-sources-lifecycle observation across recent
cycles:

- **Cycle 149** (unhandled-rejection-display) — sourced from
  *Issue #171 + repro test PR #174*.
- **Cycle 157** (exo-zip-package) — sourced from *PR #128
  inline review comment*.
- **Cycle 161** (this) — sourced from *Issue #110*.

Three different *seed* shapes; all three carry §captured-
resolution-trail through review.

## The §five Design Decisions form §coherent-discipline

§Design Decisions:

1. **Fan-out multiplexing**: one watcher per subscriber first;
   add fan-out when profiling shows pressure.
2. **Recursive subscriptions**: shallow only (matches
   EndoDirectory).
3. **File-content changes**: parity-first; defer `replace` arm
   until it lands uniformly across name hubs.
4. **Coalescing window**: hard-coded 50ms; *tuning is
   premature; promote to an option only if a real consumer
   needs it*.
5. **Polling fallback default**: silent fallback with a
   `console.error` diagnostic on activation.

The §parity-first-then-extend discipline: each decision
defaults to *match the existing thing* (EndoDirectory) rather
than *innovate*. The §don't-design-for-yet-unseen-needs
discipline.

The §revisit-only-when-profiling-shows-pressure pattern in
Decision 1: explicit *trigger* for revisiting. §profiling-not-
guessing.

## The §eight-test-plan items with §test-by-absence-of-events

§Test Plan:

1. Snapshot
2. Live add
3. Live remove
4. Subdirectory
5. External-mount parity (the parity assertion)
6. Confinement
7. Disposal
8. Daemon restart

The §test-by-absence-of-events trick for Disposal (test 7):

> *A regression for this is hard to assert directly without
> inspecting OS handles; use `t.timeout(2000)` and a bounded
> "expect zero events" probe.*

The §absence-test-via-bounded-timeout idiom. Where direct
inspection is hard, test the *consequence* (no events arrive
after disposal). Bounded timeout + "expect zero events"
catches the regression even if a watcher leaks; the timeout
makes the test deterministic.

## The §one-open-question — §NameHub-interface-unification

§Open Questions has *only one* genuinely open question (rare
for designs this size): should `EndoMount` adopt the broader
`NameHubInterface`?

> *This is a larger refactor than the watcher addition and
> crosses into mount identity semantics. This design stays
> focused on parity for `followNameChanges`. A sibling design
> has been dispatched to address hub-interface unification on
> its own; cross-link here once that design lands.*

The §sibling-design-already-dispatched observation: the
related question already has *another design* handling it.
§don't-let-this-design-grow.

The §cross-link-here-once-that-design-lands placeholder: the
design *names where future cross-references will live*. The
§future-cross-reference-as-TODO-anchor pattern.

## How this design fits the broader cluster

§Three Dependencies:

| Design | Relationship |
|--------|--------------|
| `daemon-mount` | Defines `EndoMount`; this design adds one method |
| `platform-fs` | Owns `FilePowers`; adds `watchDirectory` |
| `daemon-content-store-gc` | Cleans up scratch mount backing directories at GC time; the watcher's `finally` release is the runtime-side cleanup |

The §dependency-typology observation (parallel to cycle 159):
each Dependency names its *kind of relationship*. Adding-a-
method / owning-a-primitive / runtime-cleanup-counterpart are
*different* kinds.

§Runtime-cleanup-pairs-with-GC observation: the watcher
release in `finally` happens *at iterator drop time*; the GC
cleanup of the mount happens *at directory garbage-collection
time*. The two work together to ensure no leaked OS handles.

## The §parity-first design-philosophy

The whole design is an exercise in **§parity-first**:

- `MountNameChange` matches `PetStoreNameChange`'s shape
  (with §interface-asymmetry-tracks-ownership-asymmetry).
- Snapshot-then-diff pattern *lifted from* `pet-store.js`.
- Subscription-bound-to-path-not-name matches EndoDirectory.
- Shallow-only matches EndoDirectory.
- AsyncIterator-as-CapTP-surface via `makeIteratorRef` matches
  EndoDirectory.

The §parity-as-design-axiom: the design's *primary value* is
*sameness with the existing thing*. Innovation is *minimized
to what the new substrate strictly requires* (the watcher
adapter + the type field).

## Related sections

- cycle 149
  [[endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback]]
  — sister §sourced-from-issue lifecycle (Issue #171 + repro
  PR #174).
- cycle 157
  [[endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail]]
  — sister §captured-resolution-trail discipline + §sourced-
  from-review-comment lifecycle.
- cycle 153
  [[endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint]]
  — sister §multiple-independent-justifications discipline
  (CI: supply-chain + reproducibility + correctness; this:
  surface parity + mechanism parity).
- cycle 141
  [[endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc]]
  — the daemon-content-store-gc dependency this design
  references for §runtime-cleanup-pairs-with-GC.
