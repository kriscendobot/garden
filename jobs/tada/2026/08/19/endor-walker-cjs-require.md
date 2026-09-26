The job is genuinely complete. Increment 1 is landed on PR #282's branch with all four Group A fixtures graduated and the parity suite green.

## Completion report — `endor-walker-cjs-require` (fixture-parity ratchet, Increment 1)

**Re-derivation:** Fresh worktree off `origin/main2`; the prior attempt committed nothing. Increment 0's substrate (parity oracle, structural golden diff, two-tier excludes, floor 7) was already on the PR head branch `feat/endor-run-entry-point-deps` at `253d90dba`. No Increment-1 commit existed — treated as a clean build.

**Delivered** (two commits, pushed to `endojs/endo-but-for-bots` branch `feat/endor-run-entry-point-deps`, now at `4ef606ec8`):

Taught `endor run`'s dependency walker (`rust/endo/src/entry_walk.rs`) to follow CommonJS `require()` edges, graduating **Group A** of the ratchet. Four fixtures flipped `Exclude`→`Exercise` with committed node-oracle goldens — `cjs-compat`, `cycle-cjs`, `digest`, `esm-imports-cjs-define` — and the exercised **floor ratcheted 7 → 11**. `fixtures-0` stays pending (its remaining blocker is Group C exports, delivered by Increment 2 — I refiled its note accordingly).

Walker changes, each reverse-engineered against the harness-free node oracle:
- **`scan_cjs_requires`** — a `require("x")` scanner matching `@endo/cjs-module-analyzer`'s specifier extraction for the fixtures: skips comments/strings/templates, ignores `require.resolve`/member accesses and non-string args, records syntactically (shadowed calls included, per `parser-struggles`). Dispatched for CommonJS modules; ES modules keep the static `import` scan.
- **Package-`type` classification** (`language_for_file`) — `.js` resolves to `cjs` under `"type":"commonjs"` and `mjs` under `"type":"module"`, matching compartment-mapper's `inferParsers`. Dependency packages follow that rule verbatim (so `cjs-compat`'s type-less `defineprop`/`parser-struggles`/… are correctly CommonJS); the `endor run` **entry** keeps its ESM-by-default CLI contract for a bare `.js` app with no explicit CommonJS type.
- **Compartment-map representation aligned with node** — bare-package mains keyed by resolved path (`./index.js`) not `.`; extension-omitting relative/subpath imports record the written specifier as an alias link alongside the resolved file (suppressed when the package has an `exports` map); unresolvable edges become `deferredError` modules so the archive still builds and the error surfaces at import time.

The `no-name` endor-baseline golden was re-pinned to the new resolved-path main keying (mechanical consequence of the bare-main change).

**Gate met:** `cjs-compat`/`cycle-cjs`/`digest`/`esm-imports-cjs-define` exercised with committed goldens; floor → 11; node oracle runs default options. Verification: full endo suite green (302 lib incl. 5 new CJS-scanner tests + updated walker contract tests, 3 bin, **5/5 parity**); scoreboard prints `11 exercised / 21 pending / 8 durable`; `gen-parity-golden.mjs --check` deterministic; `rustfmt` clean on changed files; clippy adds zero new warnings.

**Local-build note (not committed):** endor needs the gitignored Moddable `xs/` sources and empty `xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` stubs; I sourced them from the sibling Increment-0 worktree at the same commit and left them untracked (`c/moddable` was a build-only symlink, never staged).

**Follow-up:** Increment 2 (`endor-walker-exports-resolution`, Group C) is the next serial child; it graduates `fixtures-0` plus the conditional/subpath-exports cluster and consumes this increment's require()-following.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endor-walker-cjs-require.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (3 unmetered)
- Input: 234 tokens (24658832 cached reads)
- Output: 123735 tokens
- Cost: $18.591419000000002 (3 engagement(s) unpriced)
- Wall-clock: 2374s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
