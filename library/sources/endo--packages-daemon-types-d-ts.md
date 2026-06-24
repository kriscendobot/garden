---
source_kind: source
source_repo: endojs/endo
source_path: packages/daemon/types.d.ts
source_line_range: 1-21
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 396 chat-lane ingest paired to cycle 395 designs-
  lane TypeScript precision changeset. 21-line packages/
  daemon/types.d.ts, the daemon package's top-level public
  TypeScript declarations. Forty-fourth AUTHORED conformant
  single-body section doc in post-refactor era. Eighty-
  sixth consecutive non-garden source after the pivot
  (310-396). §eighty-six-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  ref-X-and-X-ref-as-paired-name-inversions — lines 3-4
  export FOUR functions in two paired inversions:
  `makeRefReader` + `makeReaderRef` and `makeRefIterator`
  + `makeIteratorRef`. The NAME INVERSION encodes the
  FUNCTIONAL INVERSION: `makeRefReader(ref)` takes a ref
  and gives you a reader; `makeReaderRef(reader)` takes a
  reader and gives you a ref. The two are dual operations
  across the local/remote boundary. §the-named-name-
  inversion-encodes-function-inversion as tier-3 meta-
  pattern; the naming convention is self-documenting about
  which direction of the boundary the function operates.

  §The-named-six-lifecycle-verbs — lines 7-12 declare SIX
  lifecycle functions on the daemon: start + stop +
  restart + terminate + clean + purge. Each takes an
  optional Config and returns `Promise<void>`. The verbs
  cover the full lifecycle from cold-start to cleanup.
  §the-named-six-named-lifecycle-operations as tier-3
  meta-pattern; six is a complete-enough vocabulary for
  daemon lifecycle (start to run; stop to halt gracefully;
  restart to stop+start; terminate to halt forcefully;
  clean to remove transient state; purge to remove all
  state).

  §The-named-terminate-vs-stop-distinction — both stop and
  terminate exist. The distinction is presumably graceful
  vs forceful halt. §the-named-graceful-vs-forceful-halt-
  distinct-verbs as tier-3 meta-pattern.

  §The-named-clean-vs-purge-distinction — both clean and
  purge exist. The distinction is presumably partial vs
  full state removal. §the-named-partial-vs-full-cleanup-
  distinct-verbs as tier-3 meta-pattern; the daemon API
  has two pairs of distinct-by-degree verbs (stop/
  terminate, clean/purge).

  §The-named-makeEndoClient-as-generic-bootstrap-factory —
  lines 13-21: `makeEndoClient<TBootstrap>(name, sockPath,
  cancelled, bootstrap?)`. Four parameters with a generic
  type parameter for the bootstrap. The function returns
  `Promise<{ getBootstrap, closed }>`. §the-named-generic-
  client-factory-with-bootstrap-type as tier-3 meta-
  pattern.

  §The-named-cancelled-promise-as-deadline-parameter —
  line 16: `cancelled: Promise<void>`. The third parameter
  is a Promise that resolves when the operation should
  abort. Cancellation-via-promise-resolution is the
  pattern. §the-named-cancellation-via-promise-resolution
  as tier-3 meta-pattern; cancellation is signaled by
  fulfillment, not by an explicit cancel() call.

  §The-named-closed-promise-as-shutdown-signal — line 20:
  the return value has `closed: Promise<void>` which
  resolves when the connection closes. The connection's
  shutdown is itself a promise the caller can await. §the-
  named-shutdown-via-promise-resolution as tier-3 meta-
  pattern; sibling shape to cancelled-as-input — both use
  promise-resolution to signal lifecycle transitions.

  §The-named-getBootstrap-as-named-thunk — line 19:
  `getBootstrap: () => Promise<EndoBootstrap>`. The
  bootstrap is accessed via a function call, not a property
  access. §the-named-getX-as-named-thunk-pattern as tier-3
  meta-pattern; the function-call shape signals that the
  result might require work (network call, decryption,
  etc.) rather than being a stored value.

  §The-named-Config-as-shared-config-shape — lines 1-12:
  Config is imported from src/types.js then re-exported,
  and used as the optional parameter type for all six
  lifecycle functions. One Config type, six users. §the-
  named-shared-config-type-across-lifecycle as tier-3
  meta-pattern.

  §The-named-types-d-ts-as-package-public-API — the file
  sits at the package root (not under src/) and IS the
  daemon package's public TypeScript declarations as seen
  by consumers. §the-named-package-root-types-d-ts-as-
  consumer-surface as tier-3 meta-pattern.

  §The-named-twenty-one-line-public-API-surface — 21 lines
  of declarations summarize the daemon's entire public
  API. Sibling shape to cycle 363/365/369/380's minimal-
  but-rich documents; this is the type-declarations-as-
  API-surface version.

  Closes seven citation arcs: cycle 395 (1, adjacent
  forward; cycle 395 changeset modified types.d.ts; cycle
  396 shows the surface) + cycle 369 (6, daemon README
  named lifecycle management as CLI's primary job; cycle
  396 reveals the six lifecycle verbs in the type
  signature) + cycle 387 (4, AGENTS.md TypeScript
  conventions; types.d.ts pure-re-export discipline
  partially applied here — this file has function
  declarations, not pure re-exports, but it's the
  package-root file not the types-index pair) + cycle 367
  (14, exo's ERef used elsewhere in daemon types) + cycle
  321 (14, eventual-send substrate) + cycle 326 (70,
  pure-naming-as-discipline; the ref-X / X-ref name
  inversions are pure naming applied to encode direction)
  + cycle 322 (70). Pushes citation-arc-closures-in-pivot
  to FOUR-HUNDRED-FIFTY-ONE (444 + 7 net new).
---

21-line daemon/types.d.ts, the daemon package's top-level public TypeScript declarations. §the-named-ref-X-and-X-ref-as-paired-name-inversions (single most structurally interesting move; makeRefReader/makeReaderRef and makeRefIterator/makeIteratorRef encode functional inversion via name inversion); §the-named-name-inversion-encodes-function-inversion. §the-named-six-lifecycle-verbs (start + stop + restart + terminate + clean + purge); §the-named-six-named-lifecycle-operations. §the-named-terminate-vs-stop-distinction (graceful vs forceful); §the-named-graceful-vs-forceful-halt-distinct-verbs. §the-named-clean-vs-purge-distinction (partial vs full state removal); §the-named-partial-vs-full-cleanup-distinct-verbs. §the-named-makeEndoClient-as-generic-bootstrap-factory; §the-named-generic-client-factory-with-bootstrap-type. §the-named-cancelled-promise-as-deadline-parameter; §the-named-cancellation-via-promise-resolution (cancellation is signaled by fulfillment not by explicit cancel call). §the-named-closed-promise-as-shutdown-signal; §the-named-shutdown-via-promise-resolution. §the-named-getBootstrap-as-named-thunk; §the-named-getX-as-named-thunk-pattern (function-call shape signals work might be required). §the-named-Config-as-shared-config-shape; §the-named-shared-config-type-across-lifecycle. §the-named-types-d-ts-as-package-public-API; §the-named-package-root-types-d-ts-as-consumer-surface. §the-named-twenty-one-line-public-API-surface. Seven citation arcs closed.
