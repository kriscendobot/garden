Completed reconciliation and staging checkpoint.

- Counts: XS 56; hardened262 42; endor vendored 42 identical to hardened262; endor engine corpus 29 unrelated cases.
- Report: `journal/projects/proposal-compartments/test262-reconciliation.md` at `a3d4142ba5`.
- Staging commit: `46ccd0ef43` on `kriscendobot/test262:proposal-compartments`. It records an intentionally empty fixture directory: no valid legacy fixture survives the new design.
- Unresolved: source-key/import operation, root-global selection, deferred namespace for cycles, synchronous evaluation scope, and feature tags.
- Evidence: audited exact pinned commits; fixture counts and blob comparisons executed; `git diff --check` passed; `npm run --silent diff` reported only the README; pushed remote hashes matched local heads.

Self-improvement: nothing this time.
