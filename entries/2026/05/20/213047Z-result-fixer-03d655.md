---
ts: 2026-05-20T21:30:47Z
kind: result
role: fixer
project: endo
refs:
  - entries/2026/05/20/211345Z-dispatch-liaison-03d655.md
---

# Result: fixer 03d655 — zx port + tsconfig uniformity for PR #3258

## Head SHA after push

`8cf9943f5d24ae992499347ff8fa126b33919fb9` on `kriscendobot/endo` branch
`chore/security-md-uniformity`. Push succeeded (`e98151eda..8cf9943f5`).

## Commit series (four commits)

1. `c685f31e6 chore(scripts): port check-package-uniformity to zx`
2. `95d761b6e chore(scripts): enforce tsconfig.json uniformity against skel`
3. `32c4f5d4f chore(packages): align tsconfig.json include to skel`
4. `8cf9943f5 chore: align bytes/SECURITY.md to skel`

The dispatch brief outlined 2-3 commits. The fourth (bytes/SECURITY.md) was
added because the existing PR's lint job had been failing in CI since
2026-05-15 due to a `packages/bytes/SECURITY.md` regression introduced by
the rebase onto master: bytes (PR #3257, merged 2026-05-13) had been created
by copying the then-current packages/hex/SECURITY.md, which was one of the
unaligned variants that the branch's earlier alignment commit fixed for hex
but did not reach bytes. The fourth commit applies the same shape of
alignment as that earlier commit. The bytes drift was therefore in-class for
the PR's existing scope but not called out in the dispatch.

## Drifters the new tsconfig check flagged

The new structural check (extends + include deep-equality against skel) found
four pure #3270-class drifters that were trivially alignable to skel
(`src/**/*.{js,ts}` and `test/**/*.{js,ts}` globs replaced with the canonical
`src` / `test` directory shorthand):

- `packages/pass-style` — fixed (Commit 3, verified `yarn lint:types` clean).
- `packages/path-compare` — fixed.
- `packages/exo` — fixed.
- `packages/cache-map` — fixed.

Nine other packages had legitimate include deviations that the script's new
`TSCONFIG_INCLUDE_EXCEPTIONS` allowlist documents with a per-package comment
explaining why:

- `eslint-plugin` (CJS layout under `lib/`, no `src/`).
- `goblin-chat` (adds `bin/`).
- `cli`, `import-bundle` (add `demo/`).
- `nat`, `test262-runner` (add `scripts/`).
- `ses` (adds `scripts/` and `src-xs/`).
- `module-source` (adds `scripts/`, `src-xs/`, plus the narrow `test/*.*` glob
  that intentionally omits `test/fixtures/`).
- `compartment-mapper` (adds `demo/` plus deliberately uses the
  `src/**/*.{js,ts}` glob paired with `"exclude": ["**/*.d.ts"]` to omit
  hand-written declaration files from the typecheck pass — the deviation is
  intentional and not the #3270-class drift).

No `tsconfig.build.json` drift was found: every package's build config
already extends `["./tsconfig.json", "../../tsconfig-build-options.json"]`.

## Verification

- `node scripts/check-package-uniformity.mjs` returns exit 0 on the final HEAD.
- `yarn lint` runs clean (same two pre-existing JSDoc warnings as before the
  series, both unrelated; zero errors).
- Each aligned package's `yarn lint:types` (tsc) was exercised post-alignment
  and stays clean.

## Notable design choices

- The mjs script is intentionally portable across `node` and `zx` invocations.
  The shebang is `#!/usr/bin/env zx` (matching `generate-dependabot.mjs`,
  `migrate-test-imports.mjs`, etc.) but the script imports only from
  `node:fs/promises`, `node:crypto`, `node:path`, `node:url`, `node:process`
  and does not rely on zx-specific globals. The CI step invokes
  `node scripts/check-package-uniformity.mjs` for clarity.
- For tsconfig parsing, the script ships a tiny inline `stripJsonc` helper
  (line comments + trailing commas) rather than pulling in a third-party
  JSONC parser. Block comments are deliberately not handled; introducing one
  would surface as a clear `JSON.parse` error.
- The check uses structural deep-equality on the parsed JSON rather than
  byte-identity, so the existing tsconfigs that ship with trailing commas
  (`marshal`, `ocapn`, `patterns`, `trampoline`) parse and compare equal
  without needing reformatting.

Self-improvement: nothing this time.
