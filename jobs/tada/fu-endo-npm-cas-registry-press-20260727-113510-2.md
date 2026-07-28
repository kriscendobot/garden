Design PR is open and the tree is clean.

## Completion report

**Job:** design note on the npm-CAS registry's handling of nanoid's `node:crypto`/webcrypto need, so the default-condition-set policy question raised across the 2026-07-27/07-28 press reports has a written proposal for the maintainer to rule on.

**Delivered:** draft PR https://github.com/endojs/endo-but-for-bots/pull/879 (branch `design/endor-npm-runtime-identity`, commit `b6cb23f850`, base `llm`, OPEN / draft / MERGEABLE), adding `designs/endor-npm-runtime-identity.md` (438 lines, ~2.9k words, in line with the corpus) plus a `designs/README.md` sync. Design only, no code.

**What the note says.** It reframes the question as: which environment does the endor archive runtime profess to an npm package? The central claim is that the three candidate answers named in the job are not three points on one axis — selecting a build (the `exports` condition set) and providing a module (endowments, exit modules) are independent levers, so shimming `node:crypto` never implies activating the `node` condition. From that: default set becomes flavor + `endo` + `default` (matching `mapNodeModules` in `@endo/compartment-mapper`, which adds `import`/`default`/`endo`); `node` never enters the set; `browser` stays opt-in pending a corpus experiment *and* the top-level `browser`-field redirection; web-standard globals preferred over builtin shims; a powerless-veneer-only `node:` allowlist that excludes `Buffer`; a better diagnostic; and recording the effective condition set with the run. Five open questions are posed in question form for the ruling.

**Grounded in verified facts, not the press summaries alone:**
- Read `EXPORTS_RESOLVER_JS` (`rust/endo/xsnap/src/archive.rs`) and the #876 diff: the active set is one flavor condition per pass plus `default`; `--conditions` lands in the machine global `__archiveExtraConditions`.
- Fetched `nanoid@5.1.16` from the live registry: its `exports` object, and both builds' sources. Its default build needs `node:crypto`'s `webcrypto` **and** the ambient `Buffer.allocUnsafe`, so the builtin-shim route does not fix it without a `Buffer` global — a fact the press reports flagged but did not develop, and the strongest argument against the node-shims default. Its browser build needs only ambient `crypto.getRandomValues`, which #876 already endows.
- nanoid also publishes a top-level `browser` **field** (`{"./index.js": "./index.browser.js"}`), which `@endo/compartment-mapper` honors (`infer-exports.js`, `interpretBrowserField`) and endor does not implement at all — so a `browser`-by-default flip would be a half-implementation. Confirmed no `browser` handling exists in `assemble.rs`/`execute.rs`.
- #859's `process` shim already withholds `versions.node` so packages take their non-Node branch, which makes professing `node` in the condition set incoherent with a decision already in flight.

**Two findings surfaced that were not in the job or the press reports:**
1. Conditions are a **run-time** input in endor and a build-time input everywhere else, so the same CAS map hash can execute two different module graphs depending on a flag. The registry-proxy design's reproducibility claim depends on closing this (proposal item 7).
2. The observed nanoid failure message (`import webcrypto not found`) is XS's binding error, but the load hooks' own path for an unfurnishable specifier throws `Module not found: <comp>/<spec>`. Which stage reports first is unpinned; the note says so plainly rather than guessing, and makes pinning it a prerequisite of the diagnostic item.

**Also posted:** a cross-link comment on https://github.com/endojs/endo-but-for-bots/pull/876#issuecomment-5101080534, the PR that surfaced the question (repo standing authorization covers commenting).

**README sync scope:** recently-added prose entry, summary-table row, and current-totals line (Proposed 31 to 32, 149 to 150). Milestone-bin and dependency-graph placement were deliberately left to the roadmap keeper, since the parent `endor-npm-registry-proxy` is itself unbinned; that omission is stated in both the README entry and the PR body rather than left silent.

**Follow-ups for the next tick:**
- #879 joins the held set; it is a *ruling request*, not a merge candidate. The note argues that none of #876, #877, or #859 should be promoted past draft on its strength alone — the ruling comes first.
- The corpus experiment in the test plan (50–100 packages publishing a `browser` condition, run both ways, four-outcome count) is the deliverable that would settle the `browser`-by-default question empirically. It is a builder job, not a designer one, and is worth posting once the maintainer signals interest.
- No mermaid fences were authored, so no diagram validation was needed. No self-improvement lesson routed to the liaison; the job ran clean against the existing role and skills.
