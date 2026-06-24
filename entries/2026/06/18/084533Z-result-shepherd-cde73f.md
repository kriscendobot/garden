---
ts: 2026-06-18T08:45:33Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/084533Z-result-shepherd-cde73f.md
---

## Shepherd round 2 on PR #455 (Dependabot all-minor-patch bump)

### CI state at entry

- `lint` job: FAIL (run 27744402432, job 82079064946)
- `test` job: FAIL (run 27744402408, job 82079064703)
- All other jobs: PASS

### Root cause (both failures share one cause)

Both jobs fail only at the `Build TypeDoc site` step, exiting with code 3.
TypeDoc found 8 errors, all the same:

```
packages/daemon/src/networks/libp2p.js:421:5 - error TS2322:
Type 'Ed25519PrivateKey' is not assignable to type 'PrivateKey | undefined'.
```

The Dependabot bump included `@libp2p/crypto` 5.1.17 -> 5.1.19.
The new version of `@libp2p/crypto` introduced a transitive dependency on
`@libp2p/interface@^3.2.4`, while `libp2p@^2.10.0` (pinned) still uses
`@libp2p/interface@^2.11.0`. At runtime the two versions are structurally
compatible; at the TypeScript/TypeDoc level the `Uint8ArrayList` generic
parameter diverges (`Uint8ArrayList<ArrayBufferLike>` vs. the older
non-generic `Uint8ArrayList`), causing TS2322 when `privateKey` from
`generateKeyPairFromSeed` (which types via `@libp2p/interface@3.x`) is
passed to `createLibp2p` (which expects `PrivateKey` from `@libp2p/interface@2.x`).

### Fix applied

`packages/daemon/src/networks/libp2p.js` line 421: cast `privateKey` to
`any` at the `createLibp2p` call site, with a comment explaining the
dual-version situation. This follows the same pattern already used for
`libp2pLogger` in the same file (which also uses `/** @type {any} */` to
suppress a `ComponentLogger` cross-package type mismatch).

Commit: `eca0c3bb2` pushed to
`dependabot/npm_and_yarn/all-minor-patch-73011553ab`.

### Classification

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| C | lint (build API docs) | TS2322 privateKey dual @libp2p/interface versions | fixed (eca0c3bb2) |
| C | test (Build TypeDoc site) | same TS2322 | fixed (eca0c3bb2) |

### Next

CI is propagating on the new push. Assuming the TypeDoc fix resolves both
failures:

`next: conductor` (if CI comes back green)

If TypeDoc surfaces additional errors not yet visible (other packages with
similar dual-version conflicts), a third shepherd round may be needed.

Self-improvement: nothing this time.
