---
ts: 2026-06-03T22:54:37Z
kind: result
role: researcher
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/researcher--25745d
short_id: 25745d
to: "*"
refs:
  - entries/2026/06/03/222030Z-result-researcher-895d06.md
  - entries/2026/06/03/223900Z-result-builder-a5da82.md
---

# result: researcher — daemon-side `UserDaemon.fetchContentTree` builder prompt refinement

The proposed builder dispatch builds the daemon-side adapter the
gateway's Phase 11b `serveWeblet` power calls into: a composite
`fetchContentTree({webletFormulaId, pathSuffix})` that resolves
the weblet formula on the user-daemon's formula graph, walks the
`contentRoot` readable-tree by the path-suffix, and streams the
matching readable-blob bytes from the daemon's CAS. The refinement
below grounds the prompt's load-bearing terms in the journal
library and the existing builder-result trail, and resolves the
prompt's three Open questions from the journal as far as the
journal can resolve them: the *branch choice* is the most
structurally interesting answer (master is the wrong choice;
the daemon-side substrate the prompt assumes lives only on the
`garden` branch, with `llm` as a partial-overlap intermediate).
The dispatch needs to know that before opening a PR.

```markdown
## Library and project references

**Library concepts and sections**

- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md`](../../library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md) — the canonical CAS verb table (`cas-store` / `cas-fetch` / `cas-has` / `cas-retain` / `cas-release` / `cas-store-tree` / `cas-gc`) and the §streaming-variants `cas-store-stream` / `cas-content-stream`. The §four content types (`blob` / `snapshot` / `tree` / `archive`) frame `contentRoot` as a `tree`. §Phases 1-4 implemented in `rust/endo/src/cas.rs`; §Phase 5 (the JS manager integration replacing `makeContentStore()` in `daemon_bootstrap.js` with these verbs) is *Remaining*. This is load-bearing for the dispatch: the JS shim does not exist yet.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md`](../../library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md) — the `readable-tree` / `readable-blob` formula-type definitions and the sweep-time reference count covering their `content` hash references. The §flat-entries-map representation `{path/to/file → {type, hash, size?}}` is what the path-suffix walk keys on. *Note: this design is "Complete" per the journal but the **JS code that defines the `readable-tree` formula type lives only on the `garden` branch**, not on `master` or `llm` — see Open questions below.*
- [`journal/library/sections/endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision.md`](../../library/sections/endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision.md) — the parent design naming the daemon-side gaps the `fetchContentTree` adapter chips away at. The §*Not implemented* enumeration explicitly lists: *Daemon-side unified web server*, *`makeWeblet` function*, *Virtual host routing*, *Per-weblet CapTP sessions*. The dispatch fills the *daemon-side unified web server's per-weblet content-tree serve* gap.
- [`journal/library/sections/endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule.md`](../../library/sections/endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule.md) — the `ui: {entry, assets, sandbox, bridge}` manifest shape; `assets` is the `readable-tree` the dispatch's adapter walks; `entry` is the bare-root default (`index.html`) the gateway already normalizes per Phase 11b's `normalizeWebletPath`. The §three-sandbox-tiers (`isolated` / `connected` / `trusted`) frame the §default-Content-Type policy: the bare CAS-fetch path matches the `isolated` baseline.
- [`journal/library/sections/endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail.md`](../../library/sections/endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail.md) — names the `ReadableTree` exo's existing read shape: `list` / `lookup` / `streamBase64` are the methods the daemon walks today. The dispatch's `fetchContentTree` consumes a `ReadableTree` over CapTP rather than reaching into the CAS directly; this is the exo surface to call.
- [`journal/library/topics/daemon.md`](../../library/topics/daemon.md) — the table-of-contents for daemon-side designs. Rows of immediate interest for cross-referencing during the build: `daemon-cas-management`, `daemon-content-store-gc`, `familiar-unified-weblet-server`, `familiar-app-ui-hosting`, `exo-zip-package`, `daemon-mount`, `daemon-checkin-checkout`.

**Project context** (project: endo-but-for-bots)

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Rules of engagement — *Default branch for active development: `llm`* for designs; *implementations of those designs are separate builder dispatches that land on `master`*. The gateway stack (PR #420 and siblings) follows this rule: implementation PRs are stacked on `master`. The dispatch must reconcile this convention with the substrate gap below; see Open questions.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Standing authorizations — repo-scoped relaxation: posting comments, reviews, reactjis, cross-references is allowed without per-action authorization in the dispatch prompt for this repo. Destructive actions (force-push to protected branches) still require explicit per-action authorization.
- [`journal/entries/2026/06/03/223900Z-result-builder-a5da82.md`](../223900Z-result-builder-a5da82.md) — Phase 11b result (gateway side): explicitly names the daemon-side adapter as *the named remaining gap*; *Daemon-side adapter is a separate stacked PR*. The gateway-side `serveWeblet` power is a single composite call by design (per `packages/gateway/src/types.d.ts` § *The embedder-supplied adapter*); the daemon-side decomposition is the daemon's choice.
- [`journal/entries/2026/06/03/222030Z-result-researcher-895d06.md`](../222030Z-result-researcher-895d06.md) — the prior researcher refinement that produced the Phase 11b gateway-side dispatch. Its *Open questions* section explicitly flags: `UserDaemon.fetchContentTree` is named in the Phase 11a result entry's "what's next" but the exo itself has no library coverage; *The dispatch should either (a) confirm `fetchContentTree` exists on the daemon today, or (b) explicitly scope Phase 11b to the gateway-side*. Phase 11b chose (b); this dispatch is the daemon-side follow-up.
- [`journal/entries/2026/06/02/051648Z-result-builder-c592cb.md`](../../02/051648Z-result-builder-c592cb.md) — Phase 7 result: the canonical `WebletFormula` typedef shape `{type: 'weblet', contentRoot, mimeTypes?, ssrHandler?, virtualHosts?}` and `validateWebletFormula` in `packages/gateway/src/apps-formula.js`. The daemon-side adapter's formula-graph walk produces a `WebletFormula`-shaped object; the validator that confirms the shape is gateway-side, so the daemon-side adapter only needs to *produce* the right shape, not validate it.
- Project design (read from the project worktree): `designs/gateway-package.md` on the gateway-package-phase-N branches — the canonical design driving the gateway stack; not yet a library source page. The Feature 2 *content-tree resolution path* section is what the dispatch's daemon-side adapter implements.
- Project design (read from the project worktree): `designs/daemon-cas-management.md` on the `llm` branch — Phases 1-4 are implemented in `rust/endo/src/cas.rs`; the worker side calls the supervisor via the envelope bus on those phases; Phase 5 (JS-side `makeContentStore()` replacement) is *Remaining*. The dispatch is in Phase-5 territory.

**Why each reference is relevant**

- *daemon-cas-management section* — the dispatch's adapter routes through these verbs. The JS-side shim that exposes them as a JS API is the Phase-5 work the dispatch may need to do alongside the `fetchContentTree` exo, depending on the chosen branch (see below).
- *daemon-content-store-gc section* — the `readable-tree` / `readable-blob` formula types are the contentRoot substrate. Knowing they live on `garden` and not on `master`/`llm` is the critical branch-question input.
- *familiar-unified-weblet-server section* — explicitly enumerates the daemon-side gaps; the dispatch fills the content-serve gap.
- *familiar-app-ui-hosting section* — names the manifest shape and the default-Content-Type policy the dispatch implements when `mimeTypes` is absent.
- *exo-zip-package section* — the `ReadableTree` exo's existing read methods (`list` / `lookup` / `streamBase64`) are the surface the dispatch walks; not new-API work.
- *daemon topic page* — quick-jump to sibling designs during the build.
- *project README rules of engagement* — the convention says implementations land on `master`; the substrate gap (see Open questions) complicates this, requires a decision before the dispatch opens a PR.
- *project README standing authorizations* — confirms commenting authorization is implicit on this repo.
- *Phase 11b gateway-side builder result* — the contract the daemon-side adapter is the inverse of; the `ServeWeblet` typedef in `packages/gateway/src/types.d.ts` is the gateway-side type the daemon-side adapter satisfies.
- *Phase 11b's researcher refinement* — explicitly flagged this very dispatch as the next-step.
- *Phase 7 builder result* — the `WebletFormula` typedef shape the adapter must produce.
- *designs/gateway-package.md* and *designs/daemon-cas-management.md* — the canonical designs the dispatch implements; reading them from the project worktree is unavoidable.

**Open questions** (load-bearing for the dispatch, resolved as far as the journal can resolve them)

- **The branch choice — `master` is the wrong base.** The prompt asks: *Right base branch: master, llm, or stacked on the gateway-package-phase-N chain?* The journal-resolved answer: the dispatch's substrate does **not exist on `master`** and does **not exist on `llm`**. `readable-tree` (the formula type the gateway's `contentRoot` references) is defined in `packages/daemon/src/formula-type.js` only on the `garden` branch (confirmed: `master`'s `formula-type.js` carries `readable-blob` but not `readable-tree`; `llm`'s `formula-type.js` matches `master`'s on this point; `garden` carries both). The `makeReadableTree` factory and the `readable-tree`-case branch in `daemon.js`'s `formulate` switch are likewise garden-only. Confirmed by `git grep readable-tree master -- packages/daemon/` returning no matches; same for `llm`; `garden` returns 7+ files including `packages/daemon/src/daemon.js`, `packages/daemon/src/formula-type.js`, `packages/daemon/src/types.d.ts`, `packages/daemon/src/host.js`. **Implication: the dispatch cannot land on `master` as-is; the prompt's "implementations land on master" convention from the project README is in tension with the substrate the prompt depends on**. The dispatch should resolve this with the orchestrator before opening a PR — either (a) target `garden` directly (breaking the convention), (b) stack the daemon-side adapter on a precursor PR that ports `readable-tree` from `garden` to `master`, or (c) scope the dispatch tighter to a `readable-blob`-only mode (the gateway's bare CAS-fetch path on a single blob, no tree walk; loses the path-suffix → file mapping). Option (b) is the cleanest fit for the gateway stack's master-based discipline but adds substantial upstream work.

- **The CAS JS shim — does not exist.** The prompt asks: *The cas-fetch / cas-content-stream verbs: do they have JS shims callable from packages/daemon/, or only Rust-side?* Confirmed by `git grep cas-fetch\|cas-content-stream\|makeContentStore master/llm/garden 2>&1` returning no matches in any branch's `packages/daemon/`. The verbs exist in `rust/endo/src/cas.rs` (per the cas-management section's §Implementation phases). The JS shim (Phase 5 of the cas-management design) is *Remaining*. The dispatch's adapter walks `contentRoot` via the `ReadableTree` exo's existing `list` / `lookup` / `streamBase64` methods (which already reach the CAS through the current JS-side `makeContentStore()` in `daemon-node-powers.js`), not via the new envelope-bus verbs. *The dispatch does not block on Phase 5*; the `ReadableTree` exo's existing read surface is what `fetchContentTree` walks.

- **The readable-tree formula and tree-walk helper — exist on garden, not on master/llm.** The prompt asks: *Whether the readable-tree formula type and its tree-walk helper already exist (the daemon-content-store-gc design describes them; whether the implementation is in place is the question).* The journal-resolved answer: implementation exists on `garden` (`packages/daemon/src/daemon.js` lines 601, 1273, 2444 reference `readable-tree`; `host.js` line 236 names *Check in a remote readable-tree Exo, storing it content-addressed*; the tree-walk-and-store logic is in `host.js` around lines 591-680). No tree-walk helper for *path-suffix → entry lookup* is named separately; the dispatch will likely implement that lookup as part of `fetchContentTree`.

- **The UserDaemon exo's natural insertion point.** The prompt asks: *what's the natural place to add `fetchContentTree`?* Journal-resolved partial answer: on `garden`, the existing host-exo surface (`packages/daemon/src/host.js`'s `HostInterface` from `interfaces.js`) carries methods like `storeTree`, `checkout`, `cat`. The natural insertion point for `fetchContentTree` is alongside `storeTree` on the same exo (the host or a future user-daemon exo); the design's §UI-manifest-shape on `familiar-app-ui-hosting` already names the binding the gateway needs ("the originating user daemon"). The library does not carry a separate `UserDaemon` exo concept page; the term in the prompt may be aspirational (a future split of host into a per-user-daemon exo) rather than a name for an existing exo. The dispatch should confirm with the orchestrator whether `UserDaemon` is shorthand for "the host exo as seen from the gateway" or a planned new exo type.

- **Library writeback gaps** (signals for librarian/scholar, not blockers): no concept page for `WebletFormula`; no concept page for `UserDaemon`; no concept page for `fetchContentTree`; no keyword shortcut for `content-tree walk` or `path-suffix lookup`. The Phase 11b researcher entry already surfaced these; no new gaps this engagement.
```

## Library writeback

No keyword shortcuts added this engagement. The four open
questions above are signals for librarian/scholar growth, not
items the researcher can answer by indexing alone (the
`readable-tree` / `garden`-branch / Phase-5-JS-shim gaps are
implementation-state facts, not library-structure facts). All
referenced keyword-index entries hit existing rows
(`readable-tree`, `cas-content-stream`, `formula-graph`, `weblet`,
`familiar-app-ui-hosting`, `daemon-cas-management`). The prior
researcher engagement (895d06) already surfaced the
`WebletFormula` / `UserDaemon.fetchContentTree` / content-tree-
walk-semantics gaps; this engagement's open questions overlap
with those rather than adding new keyword-index work.

No distractions pruned, no concept pages drafted.

## Open questions

See the fenced refinement above. The four entries are:

1. **The branch choice — `master` is the wrong base.** The
   `readable-tree` formula type lives only on `garden`, not on
   `master` or `llm`. Substantive decision the orchestrator must
   resolve before the dispatch opens a PR.
2. **The CAS JS shim does not exist.** Phase 5 of the cas-
   management design is *Remaining*. The dispatch does not block
   on it; the existing `ReadableTree` exo's read surface is what
   `fetchContentTree` walks.
3. **The readable-tree formula and tree-walk helper exist on
   `garden`, not on `master`/`llm`.** Implementation in
   `packages/daemon/src/daemon.js` + `host.js`. No separate path-
   suffix → entry lookup helper; the dispatch implements it.
4. **The UserDaemon exo's natural insertion point.** Library
   has no `UserDaemon` concept page; the term may be aspirational
   (planned exo split) rather than naming an existing exo. The
   dispatch should clarify with the orchestrator.

The branch-choice question (1) is the load-bearing one. The
journal trail does not contain a prior decision; the gateway-
stack discipline (master-based) is in tension with the
`readable-tree` substrate location (garden-only); the
orchestrator must call.

Self-improvement: nothing this time. The researcher role's
*budget: 1-3 minutes* held; the *Open questions* shape carried
the load for absent-but-load-bearing terms; the
*don't-invent-citations* norm was honored (every cited path
verified at `journal/` HEAD or in the project worktree at
`/home/kris/worktrees/endojs-endo-but-for-bots/watch-endo-but-for-bots--monitor--20260512-233307/`).
