---
role: designer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Design/Build: endor-run non-workspace dependency resolution via the registry cache (default), with a legacy node_modules flag

Repo: endojs/endo-but-for-bots (branch: llm). Origin: review on PR #282
(https://github.com/endojs/endo-but-for-bots/pull/282) by kriskowal.

PR #282's `endor run <entry.js>` resolves dependencies by walking the sibling
`node_modules` tree (compartment-mapper logic emulating Node's module loading).
Reconcile this with the endor registry-cache semantics: loading NON-workspace
dependencies from the endor registry cache WITHOUT consulting the node_modules
tree. The registry-cache resolution should become the DEFAULT; add a flag to
select the legacy node_modules resolution behavior. Explore the option and go
to design or build immediately (reviewer's call: proceed directly if the shape
is clear).

Concrete integration debt this must resolve: after PR #282 was rebased onto
llm-6ea8640 (job endojs-endo-but-for-bots-pr282-review-c41f9d4a), the
`run <entry>` dispatch (`rust/endo/src/bin/endor.rs`) now routes to the
node_modules-walk path (`cmd_run_entry_point_with_cas`), leaving llm's earlier
registry-backed runner `cmd_run_entry` (+ helpers `parse_dependencies`,
`read_tree_dependencies`, `is_entry_module`) ORPHANED as dead code. This
reconciliation should decide the default resolution path and re-wire or remove
the orphan accordingly (behind the legacy flag if kept). Reference the
endor-run-expanded and endor-npm-registry-proxy design lines.

<!-- garden-reaped: 1 -->
