---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 713
created_at: 2026-07-28T21:20:00Z
last_appended_at: 2026-07-28T21:20:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#713

Deferred findings from the backfilled panel round of 2026-07-28 (the full 28-seat
code panel; the PR had been opened non-draft and never received a panel). The
must-fix and summary-fix findings went to the fixer job
`endojs-endo-but-for-bots-pr713-panel-fixes`; these are the out-of-scope items,
revisited automatically at merge time. Panel verdict:
https://github.com/endojs/endo-but-for-bots/pull/713#pullrequestreview-4801900438

## Items

- [ ] Genie's mount stand-ins do not gain `glob`/`grep`/`glorp`.
  `packages/genie/src/sandbox/local-powers.js:106` (`LocalMountInterface`) and
  `packages/genie/src/tools/vfs-mount.js:77` document themselves as mirroring
  `MountInterface`, so after #713 an agent's search surface depends on which
  route vended the mount. Nothing breaks (both are declared subsets).
  **Source seat(s)**: migrator
  **Round**: 1
  **Recommended action**: open a follow-up PR adding the three methods to the
  genie stand-ins, or amend their "mirrors MountInterface" comments to state the
  deliberate subset.

- [ ] `readOnly()`'s `ReadableTree` view (`packages/daemon/src/mount.js:1335`,
  `types.d.ts:1135`) carries no search, though search is pure-read and the
  attenuated face is where it is most wanted — an attenuated caller must retain
  the un-attenuated mount to search.
  **Source seat(s)**: curator, surfacer
  **Round**: 1
  **Recommended action**: design note or follow-up PR deciding whether the
  read-only face gains the three methods.

- [ ] The result cap bounds neither memory nor work. `globPaths` collects and
  sorts the *entire* tree before yielding its first batch
  (`packages/platform/src/fs/search.js:229-233,397`), so breaking at
  `GLOB_MAX_RESULTS` saves nothing already spent; `grepFiles` reads whole files
  and splits (`:495-503`), peaking at ~2x file size plus one string per line. On
  XS heap budgets the retention, not the cap, is the failure mode. Relatedly
  `glorp` materializes the glob array instead of piping `globPaths`' generator
  into `grepFiles`' `pathBatches`, which already accepts an
  `AsyncIterable<string[]>` annotated "the future glob->grep pipeline".
  **Source seat(s)**: engine-realist, breaker
  **Round**: 1
  **Recommended action**: follow-up PR in `packages/platform` — bounded top-k
  insert preserving the deterministic first-N UTF-16 prefix, a size pre-check or
  chunked read for grep, and generator piping for `glorp`.

- [ ] The native-fusion performance claim is asserted five times (PR body, commit
  `d117f74f12`, `.changeset/daemon-mount-glorp.md`,
  `packages/daemon/src/interfaces.js:653-657`, `mount.js:855-865`) and closed
  nowhere. No native powers layer exists, so the win is unmeasurable today; the
  `.changeset` text is the copy that ships to a public CHANGELOG. `glorp`'s
  guarded self-dispatch also re-enters the exo guard to shape-check up to 10,000
  paths and constructs `provideSearch` twice, unmeasured.
  **Source seat(s)**: benchmarker
  **Round**: 1
  **Recommended action**: adopt `packages/chacha12/BENCH.md`'s report shape for
  `packages/platform` and measure once a native layer exists; until then the
  one-line "unmeasured / deferred" note is the summary-fix already routed.

- [ ] The grep regex dialect is unpinned across the cross-language seam.
  "An ECMAScript RegExp source (no flags)" is the **Annex B** grammar —
  normative-optional, required only of browsers. `\p{L}` flagless matches the
  literal `p{L}` and not `A`; under `/u` it matches `A`; a Rust `regex`-crate
  port gives it the Unicode-property meaning. `a{`, `[a-\d]`, `\01` parse
  flagless and are SyntaxErrors under `u`; XS/QuickJS may omit Annex B. There is
  also no `mount-grep-contract.json` at all, so `GREP_MAX_RESULTS`, CRLF
  normalization, the silent-skip envelope and `maxResults`' domain are unpinned
  for a port.
  **Source seat(s)**: spec-keeper, assessor, integrator
  **Round**: 1
  **Recommended action**: add `packages/daemon/test/mount-grep-contract.json`
  pinning the dialect (flagless Annex B, or require `u`), the cap constant, and
  the skip envelope, asserted the way `mount-glob-contract.json` is.

- [ ] `fast-check` is not a `packages/daemon` devDependency, though five sibling
  packages already ship it. The properties worth landing: `maxResults` domain
  (shrinks to `NaN`/`-1` on the first run), the grep record round-trip
  (`readFileText(file).split('\n')[line-1].replace(/\r$/,'') === text`), glob
  output invariants (sorted UTF-16, duplicate-free, capped, no denied segment,
  no `..`), `**` idempotence over k, and the grep silent-skip envelope. The
  `glorp(g,p) === grep(p, glob(g))` equivalence test is tautological against
  today's composed implementation and earns its keep only as the differential
  harness a native fused override must pass.
  **Source seat(s)**: fast-checker
  **Round**: 1
  **Recommended action**: follow-up PR adding the devDependency and the five
  properties.

- [ ] The #127 stack map is now wrong and uncorrected.
  `#127#issuecomment-4951663983`'s closing reply asserts "every concern has its
  own reviewable PR" and lists **#679** (B') and **#680** (C') as live. Since
  2026-07-17 that is false: #679 closed unmerged, #680 landed only into #679's
  dead branch, and #713 absorbed both. A reader following the map from the
  closed origin issue lands on two dead PRs.
  **Source seat(s)**: scribe
  **Round**: 1
  **Recommended action**: post a one-paragraph correction comment on
  endojs/endo-but-for-bots#127 pointing glob/grep/glorp at #713.

- [ ] Per-call engine construction and an unhardened deny-set copy.
  `provideSearch(filePowers)` re-runs `makeSearch` on every method call (twice
  per `glorp`), and `[...deniedSegments]` (`mount.js:815,851`) copies the deny
  set each time and hands an **unhardened** array to a possibly-foreign engine.
  Harmless today (`toDenySet` copies immediately); a native engine that retained
  it would hold a mutable alias to the deny list.
  **Source seat(s)**: warden, engine-realist, assessor
  **Round**: 1
  **Recommended action**: hoist engine provision into the `makeMountExo` ctx and
  `harden([...deniedSegments])`.

- [ ] No conformance case asserts escape/deny behavior for a *substituted*
  engine. `provideSearch` returns `filePowers.search` verbatim, so
  `confinementRoot`/`deniedSegments` travel as data a foreign engine is trusted
  to honor, while every other mount method enforces locally via
  `assertConfined`/`isConfinedPath`. `mount-platform-fs-conformance.test.js`
  adds the three names to `ENDOMOUNT_EXTENSIONS` but asserts nothing about their
  confinement behavior.
  **Source seat(s)**: warden
  **Round**: 1
  **Recommended action**: add conformance cases exercising escape and deny
  against a substituted search engine.

- [ ] `GrepMatch` is not nameable from `@endo/daemon`, and the guard/type
  conformance test gains no case. `types.d.ts:1206,1217` reach the type through
  an inline `import('@endo/platform/fs/search.types')` and
  `packages/daemon/types.d.ts` (the types index) omits it, so a consumer cannot
  name the record type it receives. `test/mount-types.test.ts` — the standing
  guard-vs-type conformance mechanism — gains no assertion for the three
  methods, though `grep`'s `M.callWhen(...).optional(M.await(...))` against the
  declared `paths?: string[] | Promise<string[]>` is exactly the divergence it
  exists to catch.
  **Source seat(s)**: surfacer, curator, typist
  **Round**: 1
  **Recommended action**: re-export `GrepMatch` from the package types index and
  add the three `mount-types.test.ts` assertions.

- [ ] Coverage of the new lines was never verified. The `coverage-auditor` seat
  found no c8 report in the review worktree and explicitly did **not** assume the
  new lines are covered.
  **Source seat(s)**: coverage-auditor
  **Round**: 1
  **Recommended action**: run `c8 --all --reporter=json` over
  `packages/daemon` at merge time and check the new-line coverage, or record that
  the package is intentionally outside coverage.
