# Completion report — endo-npm-cas-registry-press-20260719-040510

**Headline: Phase 4 of the npm-via-CAS registry proxy is now complete on the current base.** `endor run <entry.js>` resolves, fetches, and executes real npm dependencies — no npm CLI, no `node_modules`, no lockfile — via draft PR **[#800](https://github.com/endojs/endo-but-for-bots/pull/800)**, stacked on #799.

## Assessment (step 1 of the press brief)

- **#276 (Phase 2 HTTP fetch) merged** since the last tick and is the `llm` HEAD.
- The arc had **forked into two generations**: an old stack built pre-merge (#772 resolver → #782 offline → #785 assembly → two competing execution forks: #787→#791→#795 vs #798), ~208 files stale, and a new post-merge reland (#799, resolver only). #798 had already proven end-to-end execution, but #799's body wrongly claimed the loader half was blocked on the xsnap worker-bundle gap — #798's `execute.rs` path needs no xsnap changes at all (which also avoids colliding with the live xs2rust arc that owns `rust/endo/xsnap/`).

## What I pressed: consolidation onto one canonical stack

Ported #785's assembly + #798's execution onto the #799 resolver API as one commit on new branch `feat/endor-npm-run` (base `feat/endor-npm-resolve`): new `assemble.rs` (entry-root discovery, CAS ingestion of the entry package, deterministic compartment map with `cas:sha256:` locations; `Resolution`/edge-binding rebuilt over `npm_resolve::ResolvedPackage` by reading each package's `package.json` from its CAS tree), `execute.rs` (map → runnable archive → `xsnap::run_xs_archive_loaded`, ESM normalization), `endor run <entry.js> [--registry <url>]` CLI wiring, and the design-doc status update. Canonical stack is now **#276 (merged) ← #799 ← #800**; supersession/reference notes posted on all seven old-generation PRs and a correction on #799.

## Real-execution evidence

- `cargo test -p endo --lib`: **119/119**, including `executes_assembled_esm_graph_in_xs` (mock-registry graph executed in an XS machine through two compartment links).
- Live, cold CAS + empty registry table: `endor run main.js` (deps: `p-limit@^4.0.0`) fetched **p-limit@4.0.0** and transitive **yocto-queue@1.2.2** (never named by the entry) from registry.npmjs.org, assembled compartment map `90803817…`, executed in XS printing `p-limit over CAS: squares=1,4,9,16`, exit 0. Replay with `--registry https://registry.invalid.example/`: **byte-identical hashes, identical output, zero network** — the registry table + CAS as implicit lock file. No `node_modules` directory ever created.

## Follow-ups for future ticks

- Reland #791's error-surface hardening and #795's Node-`exports`-map resolution on top of #800.
- Phase 5 (`--offline` hard-fail, `.npmrc`, scoped registries) — port #782's substance to the new stack rather than rebase it.
- The seven old-generation drafts are commented as superseded/reference but left open for the maintainer to close.
