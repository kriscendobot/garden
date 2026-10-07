---
title: Native loader candidates, and the absent JavaScript fallback
source: packages/natives/native/loader-state.js
source_repo: can1357/oh-my-pi
source_commit: d62621738def767b2b4ce447ab21aceeccff03cc
source_date: 2026-10-06
source_authors: [can1357, roboomp, Wolfie, David Andrews]
ingested: 2026-10-07
ingested_by: scholar
topics: [tooling, llm-agent-frameworks]
status: current
---

> Abstract: `@oh-my-pi/pi-natives` loads one N-API addon, `pi_natives.<platform>-<arch>[-modern|-baseline].node`. It tries an ordered list of candidate paths and CPU variants, checks each loaded addon's release stamp, and throws an aggregated "Failed to load pi_natives native addon … Tried:" error when none loads. There is no JavaScript implementation to fall back to. This refutes the third-party explainer's unverified claim that the loader "falls back to JS if native is missing". The only soft fallback is that a symbol a stale addon lacks becomes a stub that throws a diagnostic.

## What the loader owns (module header)

"Owns every step between 'Node imports `native/index.js`' and 'the right `pi_natives.<platform>-<arch>*.node` is required, validated, and returned': platform/variant detection, candidate-path resolution, on-disk staging from `node_modules` (Windows update safety), embedded-addon extraction (Bun standalone binaries), release-stamp validation, and the aggregated error surface for diagnostic-friendly failures." `native/index.js` is "one `loadNative()` call plus the generated surface-area exports."

## Fallbacks that do exist

1. **CPU variant.** On x64 the loader picks `modern` (AVX2) or `baseline`. The order of authority is the user's `PI_NATIVE_VARIANT` override, then a private cache variable inherited by workers and subprocesses, then one detection per process. A `modern` verdict still tries `-modern.node`, then `-baseline.node`, then the plain file name.
2. **Candidate paths.** The package's `native/` directory and the executable's directory, a per-platform leaf package, and the per-version cache `~/.omp/natives/<version>/`. On Windows `node_modules` installs, the addon is first staged into the version cache so `bun install -g` can overwrite the locked original. For Bun-compiled binaries, an extracted embedded addon is prepended.
3. **Old Tokio runtime.** If an addon predates the `__ompInstallTokioRuntime` export, it uses napi-rs's default runtime.
4. **Stale-addon export stubs.** In a workspace checkout, release-stamp validation is skipped so a tree that has pulled a new release can boot before rebuilding. Every symbol the stale addon predates is then exported as `missingNativeExport`, a function that throws a message naming the addon path, both releases, and `bun run build:native`. On a *current* addon a missing export stays `undefined`, because callers probe `typeof native.x === "function"` to detect features a build does not implement.

## What happens when no addon loads

`loadNative()` collects each candidate's `require` or validation error. If none succeeds it throws: `Unsupported platform: <tag>` when the platform is not one of `linux-x64`, `linux-arm64`, `darwin-x64`, `darwin-arm64`, `win32-x64`, or `win32-arm64`, and otherwise `Failed to load pi_natives native addon for <label>` with the full "Tried:" list and help text. Release-stamp validation also distinguishes a *disk-stale* addon ("reinstall to re-sync") from a *process-stale* one, where an in-place upgrade landed while the old addon stayed resident ("restart omp … reinstalling changes nothing").

So grep, glob, shell, iso, ast, and the other native features have no pure-JavaScript substitute behind this loader. Without a loadable `.node` file, importing `@oh-my-pi/pi-natives` fails.

## Relation to the explainer ledger

The [divergence ledger](web--oh-my-pi-design-rust-core--divergence-ledger-against-source.md) left this row as "(deferred): The JavaScript fallback was not verified this cycle." This section is the verification. The ledger itself is append-only and not edited in place, so this section and the [explainer concept page](../concepts/oh-my-pi-design-explainer.md) carry the resolution. The binary arithmetic correction stands as recorded: one addon per platform and variant, not one per Rust crate.

Source: [packages/natives/native/loader-state.js](https://github.com/can1357/oh-my-pi/blob/d62621738def767b2b4ce447ab21aceeccff03cc/packages/natives/native/loader-state.js) at commit `d6262173`.
