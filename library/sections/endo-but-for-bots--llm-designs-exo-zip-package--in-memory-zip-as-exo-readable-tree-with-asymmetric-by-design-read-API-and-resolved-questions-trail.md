---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
---

# In-memory ZIP as exo `readable-tree` with asymmetric-by-design read API and resolved-questions trail

> *Consider creating an `@endo/exo-zip` package that exposes an
> in-memory ZIP as an Exo directory/file tree for consumption
> over CapTP.*
>
> — maintainer review comment, PR #128
> [discussion_r3205653903](https://github.com/endojs/endo-but-for-bots/pull/128#discussion_r3205653903)

`exo-zip-package.md` (429 lines, *Proposed* status, created
2026-05-08) is a **design-as-formalized-review-comment** by
Kris Kowal *(prompted)*. The metadata block names the source
explicitly: *PR #128 inline review comment*. The maintainer's
comment on `packages/cli/src/commands/checkin.js:36` became
the design seed; this document formalizes it into a package
spec.

Last touch commit `11d04c95` 2026-05-08 by Kriscendo Bot:
*design(exo-zip): in-memory ZIP as exo readable-tree*.

## The §load-bearing-context — PR #128's anti-pattern

PR #128 (`endo checkin` / `endo checkout`) implements the
`-z` flag by *extracting the zip into a temporary directory*
and then walking that directory with `makeLocalTree`. The
maintainer flagged three costs:

1. **Temp directory + try/finally cleanup + partial-extraction
   recovery** — significant ceremony.
2. **Doubled I/O** — every byte written to disk and
   immediately re-read.
3. **Conflated concerns** — `checkin.js` carries zip-decoding
   *and* tree-walking *fused together*; neither is reusable
   alone.

The §enumerate-the-costs methodology: rather than "this is
suboptimal," the design *names three concrete costs*. Each is
independently defensible; the union *justifies* the new
package.

The §desired-shape preview shows the result-of-fix in one
snippet:

```js
const exoTree = makeExoZip(zipBytes);
await E(agent).storeTree(exoTree, parsedName);
```

The §show-the-collapse pattern: a *before* (try/finally with
extractZipToTemp) and *after* (single-call) demonstration
makes the design's value visible *before* the implementation
details.

## The §single most structurally interesting move — §asymmetric-by-design read/write API

The most distinctive structural move is the *deliberately
asymmetric* API. §Symmetric-write-path section opens:

> *There is a symmetry argument for a sibling
> `makeExoWritableZip()` that exposes a `WritableTree`-
> flavoured exo backed by an in-memory `ZipWriter`, but the
> asymmetry is real and load-bearing.*

The §asymmetry-is-real-and-load-bearing observation. Why?

**Read side** (`checkin -z`):
- Daemon's `storeTree` consumes a `ReadableTree` over CapTP.
- The CLI must hand it a *remotable*.
- An exo adapter is the *only way* to bridge in-memory bytes
  to `storeTree`.

**Write side** (`checkout -z`):
- The CLI has direct access to the daemon's `readable-tree`
  exo and *can walk it* with `list` / `lookup` /
  `streamBase64` against the daemon over CapTP.
- *No `WritableTree` interface exists* in
  `platform/src/fs/interfaces.js`.
- The natural shape is: walk the remote tree client-side,
  accumulate into a local `ZipWriter`, snapshot, write.

The §don't-invent-WritableTree-just-for-symmetry discipline:
the *interface that would be needed* for symmetry doesn't
exist; *inventing it* would be a separate (and larger) design.

The §write-side-no-WritableTree-interface observation: the
asymmetry is *forced by what exists*, not chosen for taste.

§Design Decision 4 codifies this:

> *Asymmetric read/write API; walker stays inline at the
> consumer. `makeExoZip` (exo) on the read side; the dual
> write-side walker stays inline in `checkout.js` for now.*

## The §inline-is-fine-until-multiple-uses maintainer guidance

The asymmetry rationale concludes:

> *Per the maintainer's guidance on Open Question 3 (review
> [4255618212]), inline is fine until we find multiple uses.*

The §wait-for-second-consumer-before-extracting-a-helper
discipline. Same shape as the standard rule against
premature abstraction: a single consumer doesn't justify a
helper package; a *second* consumer reveals what the
abstraction's *boundary* should be.

The §maintainer-guidance-as-design-constraint pattern: the
design *cites* the maintainer's pull-request review
[#4255618212] as the authority for this decision. The
§authority-trail discipline.

## The §design-as-formalized-review-comment lifecycle

The metadata table includes a `Source:` field naming the
review comment. The §design-as-formalized-review-comment
lifecycle:

- A maintainer reviews a PR and *names a desired shape*
  inline.
- The reviewer's comment gets formalized into a *design
  document* with full context.
- The design is referenced by *the original PR* and *future
  PRs*.

The §inline-comment-becomes-traceable-design discipline. The
comment that would otherwise disappear into PR review
archaeology becomes a *cited authority* for the package's
shape.

## The §three-component package skeleton

§Package layout:

```
packages/exo-zip/
  package.json
  README.md
  index.js
  src/
    exo-zip.js          // makeExoZip(zipBytes)
    exo-zip-tree.js     // internal ReadableTree exo
    exo-zip-blob.js     // internal ReadableBlob exo
  test/
    exo-zip.test.js
  tsconfig.json
  tsconfig.build.json
```

§Dependency list: `@endo/exo`, `@endo/far`, `@endo/harden`,
`@endo/zip`, `@endo/stream`, `@endo/platform`. The §explicit-
dependency-list discipline names what comes in.

The §pure-ECMAScript-no-Node-builtins discipline:

> *The package is pure ECMAScript with no Node built-ins, so
> it is loadable in XS, browsers, and SES realms.*

§Portability-as-constraint: the package must run in *every
realm @endo supports*. This drives Design Decision 6 (use
`Uint8Array` + `TextDecoder`, not Node's `Buffer`).

## The §lazy-materialisation discipline

§Design Decision 3:

> *A 10 000-entry archive should not allocate 10 000 exos at
> `makeExoZip` time. The grouping pass produces child
> factories; `lookup` invokes them.*

The §grouping-pass-produces-child-factories pattern: at
construction time, walk the zip's `Map<string, ZFile>` once;
group entries by first path segment; *each group becomes a
factory function*, not an exo. Sub-exos materialise *on
demand* when `lookup` is called.

The §amortize-allocation-over-lookups discipline:

- **Construction cost**: O(entries) string operations to
  group.
- **Materialization cost**: O(1) per `lookup` call.
- **Total cost** for a daemon's checkin walk that calls each
  `lookup` exactly once: O(entries).
- **Total cost** for a partial walk (e.g. shallow inspection
  of a large archive): O(touched entries) — *vastly* less
  than O(all entries).

The §lazy-evaluation-as-correctness-not-optimization
observation: §lookup `'a/b/c'` *could* materialize 3 exos for
intermediates *or* memoize them. The design doesn't say
which; the *cost of repeated `lookup` calls* is *one extra
exo creation* — acceptable since the daemon's checkin walk
only calls each `lookup` once.

## The §hostile-input-rejection-at-construction discipline

> *Empty path components and `.` / `..` segments are rejected
> at construction time so the resulting tree cannot escape
> the archive's namespace.*

The §fail-fast-at-construction discipline:

- Reject at `makeExoZip(zipBytes)` — the caller learns
  *immediately* that the archive is malformed.
- Not at `lookup` — caller might *never* look up the bad
  path; the rejection would be silently bypassed.

The §security-check-at-the-entry-point pattern. A path-
traversal vector (`'../../etc/passwd'` in a zip entry) is
caught *before* the tree exists, not buried in lookup logic.

## The §reuse-platform-interface-not-daemon-interface discipline

§Design Decision 2:

> *The package reuses the canonical interfaces from
> `packages/platform/src/fs/interfaces.js`:
> `ReadableTreeInterface` for tree nodes (`has`, `list`,
> `lookup`). `ReadableBlobInterface` for blob leaves
> (`streamBase64`, `text`, `json`).*

The §minimal-interface-conformance-keeps-dependencies-narrow
observation. The daemon-side `EndoReadableTree` guard adds
`sha256` and `help`; the exo-zip output sits on the *client
side* of CapTP and doesn't have a content hash to report.
Conforming to the *smaller interface* keeps the package free
of daemon dependencies.

The §which-side-of-CapTP-determines-the-interface discipline:
the client-side adapter speaks the *client-side interface*,
not the daemon-side interface. §interface-asymmetry-tracks-
ownership-asymmetry.

## The §single-chunk-streamBase64 acceptable

§Design Decision 5:

> *`@endo/zip`'s reader buffers each entry's decompressed
> bytes in memory. `streamBase64()` therefore yields a single
> chunk. Chunking at, say, 64 KiB is straightforward to add
> later without changing the API.*

The §no-API-change-needed-for-future-chunking observation.
The async iterator returned by `streamBase64()` is *defined
to yield one or more chunks*; yielding one is a valid
implementation. A future implementation yielding multiple
chunks works *without breaking callers*.

The §forward-compatible-by-iterator-shape discipline: an
async iterator's contract is "you'll get *some chunks*";
*how many* is the implementation's choice. Changing from one
to many doesn't change the contract.

## The §Uint8Array-not-stream input rationale

§Design Decision 7 is the most substantively reasoned:

> *Accepting a stream would let very large archives skip the
> buffering step in principle, but `@endo/zip` requires the
> full bytes to parse the central directory anyway, and a
> stream alone is not enough: lazy zip access needs a
> *seekable* stream concept, which the project does not yet
> define. Streaming zip support is deferred until that
> concept exists.*

The §defer-streaming-zip-until-seekable-stream-exists
discipline. Three constraints converge:

1. **`@endo/zip` needs central-directory bytes** — at the
   end of the file, with random-access reads.
2. **No seekable-stream concept exists in @endo** — current
   `ReaderRef` is one-shot forward-only.
3. **Inventing seekable-stream is out of scope** — a separate
   (large) design.

The §three-constraint-combination locks in `Uint8Array`. The
§future-compatibility-via-overload note: *`makeExoZip` can
grow an overload without breaking the `Uint8Array` callers*.

## The §separate-package-not-sibling-export discipline

§Design Decision 8:

> *`@endo/zip` is deliberately dependency-free. Folding the
> adapter in (even as a sibling entry point) would entrain
> Passable / exo machinery into `@endo/zip`'s core library.
> A separate package keeps `@endo/zip` minimal and isolates
> the exo / `@endo/platform` dependency chain to the
> adapter.*

The §package-cleanliness-as-design-constraint observation.
Adding a sibling export to `@endo/zip` would *transitively*
add `@endo/passable`, `@endo/exo`, `@endo/platform`, etc., to
*every* consumer of `@endo/zip`. The separate package
*isolates* the dependency surface.

The §don't-pollute-a-clean-package discipline. Where cycle
142's passStyle-helpers.js avoids depending on SES (and
duplicates `isTypedArray`), this design avoids forcing exo
machinery into `@endo/zip`.

## The §eight Design Decisions + §three Resolved Questions

The design ends with **eight Design Decisions** + **three
Resolved Questions**. The §resolved-questions-not-open-
questions distinction:

> *The original design carried three Open Questions that were
> resolved inline by the maintainer in review
> [4255618212]. Their resolutions are folded into the design
> body above.*

The §captured-resolution-trail discipline: the design *was*
open-questions-bearing; the maintainer *resolved* them in
review; the design *captures* the resolutions but also
preserves *what they were*. Future readers see *the trail of
decisions*, not just the decisions themselves.

The three resolved questions:

1. **`Uint8Array` vs `ReaderRef` input** → `Uint8Array`
   (Decision 7).
2. **`@endo/exo-zip` vs sibling export from `@endo/zip`** →
   separate package (Decision 8).
3. **Walker location** → walker stays inline at the consumer
   (Decision 4 + the §asymmetric-by-design narrative).

The §three-step-design-lifecycle observation: open question →
review resolution → folded into design body. The *trail* is
preserved.

## The §reshape-blocker-for-PR-128 explicit dependency

> *Reshape blocker for: PR #128 (`checkin.js`). The PR's
> current `checkin.js` extracts to a temp directory; reshape
> merges this design's `makeExoZip` adapter and deletes
> `extractZipToTemp`.*

The §explicit-blockers-section discipline: the design *names
what's downstream of it*. PR #128 cannot land cleanly until
this design ships; the design knows that. The §design-
documents-its-downstream-impact pattern.

## The §three-phase-implementation with §S-sized-phases

§Implementation Phases:

1. **Package skeleton (S)** — minimal scaffold + stub.
2. **`makeExoZip` read path (S)** — full implementation +
   tests.
3. **PR #128 `checkin.js` reshape (S)** — drop
   `extractZipToTemp` + try/finally.

All three are **size S** (small). Phases 1+2 land in a single
*feat* PR; phase 3 is a follow-on retargeting PR #128. The
§small-S-phases-can-bundle observation: when all phases are
small, the natural-PR-boundary follows code-locality, not
phase-boundary.

## How this design fits the broader cluster

- **Cycle 151's app-sharing-milestone** Pillar 3 explicitly
  cites `exo-zip / exo-unzip` (PR #160) as substrate for the
  cross-daemon clone tree-archive shape. This design *is*
  that substrate.
- **`daemon-checkin-checkout`** (referenced as Depends-on) —
  the primary consumer of `makeExoZip`.
- **`daemon-weblet-application`** (referenced as Depends-on)
  — defines the `ReadableTreeInterface` shape this design
  conforms to.

The §design-cluster-graph observation: this design is *one
node* in a graph; its citations and citers locate it in the
ecosystem.

## Related sections

- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — the exo-construction surface this design produces with
  (`makeExoZip` returns a remotable exo built via these
  factories).
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — defines what makes the returned object a remotable for
  CapTP transit.
- cycle 151
  [[endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline]]
  — Pillar 3 cites this design's exo-zip/exo-unzip family as
  the §streaming-clone-substrate.
- cycle 142
  [[endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records]]
  — sibling §don't-pollute-a-clean-package discipline
  (passStyle-helpers avoids depending on SES; exo-zip-package
  avoids polluting @endo/zip).
- cycle 149
  [[endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback]]
  — sibling §design-as-formalized-review-comment lifecycle
  (cycle 149's design sourced from issue #171 + repro test PR
  #174; this design sourced from PR #128 inline comment).
