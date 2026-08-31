CI green. Fix stage complete.

## Completion report

Applied the round-5 design panel's must-fix items to `designs/familiar-run-apps-vfs.md` on PR #241 (endojs/endo-but-for-bots, head `design/familiar-run-vfs-apps`), pushed as one review-feedback follow-up commit (`f9b89e025`), and watched CI to green.

**request-changes findings addressed:**
- **critic** — (1) Reconciled the error taxonomy: replaced the invented `ResolutionError`/`IngestionError` with the canonical `Registry*Error` classes owned by `registry-capability.md`/`mvs-resolver.md`, added an explicit mapping table, and named the one npm-specific version-conflict case `RegistryVersionConflictError` as a stated proposed addition to the owning layer's failure surface. (2) Enumerated the formula `type` dispatch input in § Shape and pinned its lifecycle (set at formula incarnation, per-formula, guest cannot set it).
- **skeptic** — (1) Added a "phantom-dependency compatibility" cost section weighing the loss of `node_modules` hoisting, plus a fail-closed test and an Alternatives cross-reference. (2) Stated the ad-hoc compartment map reuses the mapper's `exports`/conditional-exports-aware resolution, not a blind file walk. (3) Qualified the "Go-mod-shaped" framing up front (npm upper bounds drop Go MVS's no-conflict guarantee → fails closed).
- **decomplector** — (1) Made sub-case dispatch an explicit tagged hint (`{kind:'entry'}` vs `{kind:'compartment-map'}`) instead of filename sniffing, throughout. (2) Trimmed § Resolution to the design's delta and referenced the owning algorithm rather than restating it.
- **novice** — Added a "detailed below" forward-map note to the relationship section; glossed "Lal"; made the Ejection glossary entry self-contained.

**comment-only (cheap, applied):** named both formula-type branches (`confined-app`/`host-node-app`); framed Ejection as a "scratch checkout" variant; title-cased the H1; converted the glossary to a bulleted list; sentence-level clarity fixes; kept the doc em-dash-free and free of typist-hostile code points.

CI: 5 checks, 0 failed → GREEN (rc 0). No follow-ups; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr241-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (9868539 cached reads)
- Output: 46433 tokens
- Cost: $7.4483815
- Wall-clock: 1084s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
