---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 358
created_at: 2026-05-22T23:50:30Z
last_appended_at: 2026-05-22T23:50:30Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#358

Created from the design-panel round 1 verdict (7 seats, in-band fallback) on design-only PR #358 (`design(daemon): importLocation from EndoMount with npm-registry-proxy + Go-like MVS`). Round 1 returned two must-fix-loop items (multi-major URL disambiguation in `makeMountReadPowers`; multi-major coexistence test in Phase 5 catalog). The follow-up dispositions queued here for revisit at merge time.

## Items

- [ ] **Workspace-protocol resolution support.**
  **Source juror(s)**: critic, ergonomist.
  **Round**: 1.
  **Recommended action**: § *Open Questions* item 2 acknowledges workspace protocol but the first-cut "reject `workspace:` specifiers" is fragile because workspace protocol is the everyday shape in monorepos (including `endojs/endo-but-for-bots/packages/*`). When PR #358 (or its upstream mirror, when ferried) merges, open a follow-up PR that adds workspace-detection to `EndoRegistry.resolve`: detect the workspace root via `package.json#workspaces`, resolve `workspace:` references to the matching sibling subdirectory before falling through to MVS. Likely a new phase (Phase 7) on the design.

- [ ] **Yarn PnP loader support.**
  **Source juror(s)**: skeptic.
  **Round**: 1.
  **Recommended action**: § *MVS interaction with on-disk `package-lock.json`* is silent on Yarn PnP. PnP workspaces have `.pnp.cjs` instead of `package-lock.json` and may not have `node_modules`-shaped resolution at all. When the PR or its mirror merges, open a follow-up issue on `endojs/endo` (or the design corpus) tracking PnP support: either explicit reject with a clear error, or a `.pnp.cjs`-aware resolver path.

- [ ] **Rust-side resolver callback boundary for peerDependencies.**
  **Source juror(s)**: decomplector.
  **Round**: 1.
  **Recommended action**: § *Resolution path: who walks the graph* commits to a JS-side resolver method (`EndoRegistry.resolve`) returning a transitive closure. As `endor-npm-registry-proxy` grows `peerDependencies` enforcement and conditional exports, the resolver may want to call back into JS for policy decisions. When PR #358's Phase 4-5 lands and the resolver's behavior is empirically known, revisit the boundary: either keep the single-call shape with policy in the resolution options bag, or add a callback shape on `EndoRegistry.resolve`. Open as an issue on the design corpus rather than a new design unless the boundary changes shape materially.

- [ ] **Summary-paragraph skimmability pass.**
  **Source juror(s)**: copyeditor.
  **Round**: 1.
  **Recommended action**: § *Summary* opens with one long paragraph block (lines 9-20). When the PR or its mirror merges, open a follow-up PR (or amend on a future revision of `daemon-worker-import-from-mount.md`) that breaks the Summary into one paragraph per decision: what changes, how it's wired, why this is a sibling of `makeFromTree`. Cosmetic; not load-bearing.

- [ ] **`make<X>` vs `makeFrom<X>` daemon-host method-family rename pass.**
  **Source juror(s)**: ergonomist.
  **Round**: 1.
  **Recommended action**: The daemon-host method family carries two naming shapes: `make<Output>` (`makeArchive`, `makeUnconfined`) and `makeFrom<Input>` (`makeFromTree`, `makeFromPackage`, `makeUnconfinedFromTree`). The split is inherited from `daemon-make-archive.md`; this design extends it. When the family stabilizes (e.g., after `makeFromPackage` ships and stays), open a follow-up PR to align on one naming shape across the whole family, or document the deliberate split with a rationale in the daemon-host doc. Open as an issue on `endojs/endo` (or the design corpus) tagged "rename discipline".
