---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/captp/src/finalize.js
source_line_range: 1-133
file_commit: 96b9ea81ddc403944750f2bb64a7eab3de8cd700
file_commit_date: 2026-05-21
file_commit_author: Kris Kowal
comment_subject: Weak-Value-Map via WeakRef + FinalizationRegistry with gc-as-side-channel warning and end-of-turn stability
ingested: 2026-06-03
refreshed: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  **Refreshed 2026-06-27** (library-source-drift-scan): upstream
  advanced `5efcf7dd0` → `96b9ea81d` (Kris Kowal, *refactor:
  Embrace default chaining*, 2026-05-21). The only change to this
  file: `get` collapsed from the verbose deref-guard to optional
  chaining (`get: key => keyToRef.get(key)?.deref()`), deleting
  the `// UNTIL endo#1514` workaround comment block (141 → 133
  lines). The §issue-#1514 TODO is now **resolved**; its section
  is retitled and rewritten to record the resolution. All other
  sections unchanged.

  Thirty-seventh comment-fragment ingest (cycle 156). 133-
  line @endo/captp *Weak-Value-Map* primitive. Mark S. Miller
  authored; last touched 2026-05-21 (commit `96b9ea81d`, Kris
  Kowal, *Embrace default chaining*; original ingest at
  `5efcf7dd0`, refactor pass-style faster isObject). **Second
  @endo/captp source file ingested** (after cycle 154's trap.js).

  Single export `makeFinalizingMap(finalizer, opts)` —
  §weak-on-values-not-on-keys (dual of WeakMap which is weak
  on keys). §multi-map-coordinated-removal: when a value is
  GC'd, the entry vanishes from every weak-value-map holding
  it. §keys-stay-but-entries-disappear semantic.

  Single most structurally interesting move: §gc-as-side-
  channel warning. *Both the ability to create one, as well
  as each created one, must be treated as dangerous
  capabilities that must be closely held*. §timing-
  independent-side-channel observation — unlike most side
  channels needing a clock, gc-side-channel just observes
  whether entries exist. §closely-held-capability discipline.
  §blockchain-replay hazard escalation: *this non-determinism
  also enables code to escape deterministic replay; in a
  blockchain context, this could cause validators to differ
  from each other, preventing consensus*. §nondeterminism-
  breaks-consensus. §gc-as-consensus-blocker. §primitive-
  exists-but-must-not-be-used-in-some-contexts discipline.

  §Two-mode design with §graceful-fallback-via-
  fakeFinalizingMap: when `weakValues=false` or WeakRef
  unavailable or FinalizationRegistry unavailable, falls back
  to plain Map wrapped as Far('fakeFinalizingMap'). §honest-
  tagging-when-degraded ('fake' is in the tag); §tag-tells-
  the-truth property. §opt-in-via-weakValues defaulting false;
  §dangerous-mode-not-default discipline.

  §FinalizationRegistry callback routes through `delete`:
  §unified-finalize-path — gc / explicit delete / set-
  overwrite all converge on finalizingMap.delete which calls
  the user finalizer.

  §Unregister-immediately-suppresses-finalization assumption
  explicit in JSDoc: *TODO If this is not actually
  guaranteed... we will need to revisit this*. §honest-
  acknowledgment-of-spec-uncertainty. §explicit-assumption-
  as-TODO pattern.

  §JS-standards-WeakRef-end-of-turn-stability invariant
  named: operations that deref() keep the WeakRef stable for
  the rest of the turn. has/get/set/delete guarantee deref;
  clearWithoutFinalizing/getSize do not. §method-by-method
  derefing classification. §getSize-may-lie observation.
  §atomicity-within-a-turn-via-deref property.

  §has-must-deref-or-it-lies: `has: key => get(key) !==
  undefined` routes through get to force deref. §define-has-
  via-get-not-via-Map-has pattern.

  §Replace-finalizes-old discipline for set: deletes old
  first (unregister + finalizer), then registers new. §`!
  isPrimitive(ref)` assert (WeakRef requires non-primitive;
  imports isPrimitive from cycle 142's @endo/pass-style).
  §unregister-token-is-the-WeakRef shape.

  §clearWithoutFinalizing-exempt semantics: unregisters all
  WeakRefs then clears map; *Our semantics are to finalize
  upon explicit `delete`, `set` (which calls `delete`) or
  garbage collection (which also calls `delete`).
  `clearWithoutFinalizing` is exempt*. §teardown-bypass
  discipline.

  §TODO-with-issue-link to endo#1514 named the preferred-form
  blocker; the §commented-out-preferred-form pattern kept the
  future cleanup visible at the site, and the §preserve-the-
  undefined-not-the-typeof-deref-result TypeScript-narrowing
  workaround held the verbose form in place. **As of `96b9ea81d`
  this TODO is resolved** — the preferred optional-chaining form
  landed and the workaround is gone.

  §Far-as-the-protective-wrapper for both real and fake maps.
  §RemotableBrand-typing: typed as remotable so it's passable
  via E().

  Cycle 156 was nominally chat-lane (exhausted at 20/20);
  papers-lane blocked 50+ consecutive cycles. **Papers-lane
  blocked 50 cycles — milestone**. Pivoted to comments-lane.
---

> Abstract: `finalize.js` (133 lines) is the @endo/captp
> **Weak-Value-Map primitive**. Mark S. Miller authored.
> Single export `makeFinalizingMap(finalizer, opts)`.
> **Second @endo/captp source file ingested** after cycle
> 154's trap.js.
>
> §Weak-on-values-not-on-keys distinction (dual of WeakMap).
> §multi-map-coordinated-removal via FinalizationRegistry.
>
> **Single most structurally interesting move**: §gc-as-side-
> channel warning. *Dangerous capabilities that must be
> closely held* — §timing-independent-side-channel (no clock
> needed). §Blockchain-replay hazard: *could cause validators
> to differ from each other, preventing consensus*.
> §Primitive-exists-but-must-not-be-used-in-some-contexts.
>
> §Two-mode design with §graceful-fallback-via-fake. §honest-
> tagging-when-degraded ('fake' in Far tag); §dangerous-mode-
> not-default.
>
> §Unified-finalize-path: gc / delete / set-overwrite all
> converge through `delete` + user finalizer.
>
> §JS-standards-WeakRef-end-of-turn-stability invariant.
> §has/get/set/delete deref; §clearWithoutFinalizing/getSize
> don't. §getSize-may-lie.
>
> §has-must-deref-or-it-lies (defines `has` via `get`).
> §Replace-finalizes-old (set deletes first).
> §clearWithoutFinalizing-exempt §teardown-bypass.
>
> §TODO-with-issue-link to endo#1514 (**resolved** at
> `96b9ea81d` — `get` now optional-chains). §Far-wrapping for
> remotability.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability](../sections/endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability.md) | captp, hardened-javascript, capability-security | current |

Tight 133-line file. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `5efcf7dd03c9caff1592c146a1a506320bddf9db`) via the local
  bare-clone.
- **Refreshed 2026-06-27** (library-source-drift-scan) from the
  local bare-clone at commit
  `96b9ea81ddc403944750f2bb64a7eab3de8cd700`. The path had
  advanced one commit since the original ingest.
- Last substantive touch 2026-05-21 by Kris Kowal (commit
  `96b9ea81d`, *refactor: Embrace default chaining*) — resolved
  the §issue-#1514 TODO, collapsing `get` to optional chaining
  (141 → 133 lines). Prior touch 2025-06-23 by Mark S. Miller
  (commit `5efcf7dd0`, *refactor(pass-style): faster `isObject`
  (#2860)*), the original-ingest commit. Not in cycle 108's
  coordinated-update commit `e56bf00f` cluster (this file
  predates the @endo/harden migration).
- **Thirty-seventh comment-fragment ingest.** **Second
  @endo/captp source file ingested** after cycle 154's
  trap.js.
- Cycle 156 was nominally **chat-lane** (exhausted at 20/20);
  papers-lane has been blocked for **50+ consecutive cycles**
  due to lack of PDF-fetching infrastructure. **Papers-lane
  blocked 50 cycles — milestone**. Cycle 156 pivoted to
  comments-lane.
- One cohesion-honest section.
