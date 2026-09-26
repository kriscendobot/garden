Inbox empty. The work is complete.

## Completion report

**Job:** `improve-local-verify-root-types` — add an overrideable repo-root TypeScript-program check to `local-verify.sh` with sufficient Node heap, matching CI, so JavaScript test type errors cannot pass local verification in packages with `checkJs: false`.

**What I did**

Added a new additive `root-types` step to the local-verify harness, modeled on the existing `package-uniformity` step (same repo-root-command-CI-runs-outside-`yarn lint` shape as endojs/endo-but-for-bots#1015).

**What changed** (committed `95dce3223e`, pushed to `main2`):

- `scripts/jobs/gardening/local-verify.sh`
  - Inserted `root-types` into `STEPS` (after `package-uniformity`, before `codegen`).
  - New `discover_root_types()` with layered discovery: `LOCAL_VERIFY_ROOT_TYPES` override wins verbatim (`-`/empty skips) → single project wrap script (`RT_WRAP_SCRIPTS`) → else, when a repo-root `tsconfig.json` exists **and** its *resolved* program type-checks JS (`checkJs: true`, read authoritatively from `tsc --showConfig` so the `extends` chain is honored), emit `NODE_OPTIONS=--max-old-space-size=<GARDEN_ROOT_TYPES_HEAP_MB:-8192> <yarn> tsc -p <cfg> --noEmit`. Inert where the root program doesn't check JS, there's no root tsconfig, or `tsc` isn't resolvable (avoids the local-fail/CI-pass divergence the skill forbids). Wired into `discover()` and header comments.
  - The larger heap addresses the memory-documented OOM (exit 134) of the whole-repo program at Node's ~2 GB default; overrideable via `GARDEN_ROOT_TYPES_HEAP_MB`, tsconfig path via `GARDEN_ROOT_TYPES_TSCONFIG`.
- `scripts/jobs/test/local-verify-test.sh` — new regression group #19 (8 sub-cases: heap applied, ill-typed `.js` fails loud with TS2322 in blob, checkJs:false inert, no-tsconfig inert, `=-` skip, `=<cmd>` verbatim, heap override, wrap-script subsumes reconstruction). **90 passed, 0 failed.**
- `skills/local-verify/SKILL.md` — documented the step, its discovery precedence, the knobs, and the #1125 grounding.

`bash -n` and `shellcheck` clean on both scripts.

**Follow-ups:** none. The gate is generic and inert on non-applicable projects; endo's root program (checkJs:true, deps installed in a verify context) triggers it as intended.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-local-verify-root-types.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (2438633 cached reads)
- Output: 31170 tokens
- Cost: $3.1186065000000003
- Wall-clock: 436s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
