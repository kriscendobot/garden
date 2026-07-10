# Variant A/B — legacy (XS 13.3.0) vs latest (XS 16.7.1) consensus workers

Engine-level differential probe for the variant-integration branch
`kriscendobot/agoric-sdk#13` (`xst/integrate-variant-bump`), which ships two
xsnap-worker binaries:

| variant | tree | engine |
| --- | --- | --- |
| `legacy` (default) | `packages/xsnap/xsnap-native/` (prebuilt fetch) | XS 13.3.0 / Moddable 3.9.2 |
| `latest` | `packages/xsnap/latest/xsnap-native/` (`build.js --variant latest`) | XS 16.7.1 / Moddable 5.5.0 |

Where `../xst-release-ab/` and `../xst-flat-release-ab/` A/B the **stock `xst`
shell** built from Moddable release tags, this harness drives the **actual
consensus workers the branch produces**, through the real `xsnap.js`
`evaluate()` path (netstring protocol, on-chain value-stack size). It is the
Leg-6 tool of the `xst-gauntlet` validation (issue-kriskowal-garden-33).

## Run

From an agoric-sdk checkout of the branch with both variants built
(`cd packages/xsnap && yarn install:prebuilt && yarn build:latest`):

```sh
cd packages/xsnap
node --import @endo/init/debug.js \
  <garden>/skills/agoric-chain-snapshot/repro/xst-variant-ab/ab-probe.mjs
```

## Verified results (2026-07-10, x86-64 linux)

21 probes; **8 diverge, all explained by the XS 13.3.0 → 16.7.1 version delta —
no mysterious/unexplained divergence.**

| class | probes | result |
| --- | --- | --- |
| core determinism (float `toString`, `1/3`, `2**53`, bigint pow, `toFixed`, unicode regex, `sort`, deep `flat`, JSON key order) | 9 | **IDENTICAL on both** |
| flat/flatMap value-stack overflow (leaf + nested + `new Map(flatMap)`) | 5 | **IDENTICAL** — both overflow at the same on-chain stack size; XS 16.7.1 does **not** independently clear the ymax0 leaf-flat leak at the worker `stackCount`. The fork's `flatMap→loop` source fix (skills/.../xs-debugging) remains the remedy on both trains. |
| error-message wording | `err-notfunc`, `err-getprop` | DIVERGES — legacy `"(anonymous-N): no function"` / `"cannot coerce null to object"`; latest `"call: not a function (in (anonymous-N))"` / `"cannot coerce null to object (in (anonymous-N))"`. This is exactly what the branch's additive regexes in `create-vat.test.js` (`\|not a function`) and `xsnap.test.js` (optional `(?: [^:]+:)?` group) absorb. |
| immutable-ArrayBuffer proposal | `has-immutable-ab` | DIVERGES — present in XS 16.7.1, absent in 13.3.0. Explains the SES "About to overwrite ArrayBuffer.prototype" repair warning the branch filters via `message-tools.js` `filterRepairLogs`. |
| newer intrinsics (`Object.groupBy`/`Map.groupBy`, iterator helpers, `Set.prototype.intersection`/`union`, `Promise.withResolvers`, `String.prototype.isWellFormed`) | 5 | DIVERGES — all `function` on latest, `undefined` on legacy. Additive globals from the engine bump; drive the SES-permits repair noise, not consensus math. |

### Reading

The **legacy** worker is byte-identical to master's prebuilt engine, so nothing
here perturbs the consensus train. Every **latest** divergence is a documented
consequence of the engine upgrade (new intrinsics, sharper error strings,
immutable ArrayBuffer) — the same deltas the branch already accommodates in its
test adaptations. No first-class surprise divergence was found in engine
computation, number formatting, or the flat/flatMap overflow class.
