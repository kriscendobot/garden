---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T20:41:15Z
---
project: endo
role: gardener
host: endolin-garden2-5bcdff64
job: endo-npm-cas-registry-press-20260730-143501

## Pressed PR #882 (restore XS bootstrap generators) — rebased onto llm, execution evidence verified

The npm-via-CAS finish line (Phases 1–5) is fully implemented on `llm`, but a fresh checkout could not produce real-execution evidence because the XS bootstrap bundles (`ses_boot.js`, `worker_bootstrap.js`) had no generator on `llm` — only stubs that throw at runtime. PR #882 restores the real generators but was CONFLICTING (based on an old `llm`).

### What I did

- Rebased #882's 10 commits cleanly onto current `llm` (`eb64412d76` → head `c781fcc660`).
- Generated the real `ses_boot.js` (69637 bytes) and `worker_bootstrap.js` (658080 bytes) from the restored generators.
- Built `endor` (populated the `c/moddable` submodule first).
- Ran the #882 test suite: 19 tests passed (bundle identity + worker facet).
- Force-pushed the rebased branch with lease; PR #882 is now MERGEABLE (was CONFLICTING), still DRAFT.
- Posted a comment on #882 with the full evidence.

### Real-execution evidence

`ENDOR_STATE_PATH=/tmp/endor-state ./target/debug/endor run /tmp/endor-smoke/main.js` (entry imports `is-odd@^3.0.0`):

```
endor[run]: assembled endor-npm-smoke (2 packages)
endor[run]:   is-number@6.0.0 51e96a7a6990c443f2536834b732daa6ae811ef92efa91fde3bf3c4247967df0
endor[run]:   is-odd@3.0.1 a46a5a58ee663f37a0199abb601967dd692bafa17b00d7ae38c510b6d9ac7462
endor-npm-smoke: is-odd(3) = true
endor-npm-smoke: is-odd(4) = false
```

`--offline` replay produced identical output (CAS hit, no network). `endor registry list` shows `(name, version) → CAS hash` rows. No `node_modules` or lockfile created.

### Next

#882 unblocks all `endor run` execution evidence on fresh checkouts. Once merged, the npm-proxy arc's remaining known gaps (workspace-protocol for unpublished monorepos, `process.env.NODE_ENV` shim decision) are the next unblocked increments. The daemon bootstrap bundler (`bundle-bus-daemon-rust-xs.mjs`) still fails on `llm` due to `node:` builtin resolution in the `git` package — separate from #882 and not needed for `endor run`.
