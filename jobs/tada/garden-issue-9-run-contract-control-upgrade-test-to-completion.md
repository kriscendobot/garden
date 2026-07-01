All three steps observed to terminal state, reply posted, skill update on main2. Job complete.

## Completion report

Ran mhofman's contract-control-upgrade protocol (#9 comment 4849982001) **to completion** through inquisitor against the cached real mainnet swing-store (`agoric-26146641`), and posted the evidence to kriskowal/garden#9 (**comment 4851105447**).

**What I did.** Drove ymax0's delegated `ContractControl` (kref `ko25961078`) `upgrade({bundleId})` on the live ZCF vat `v290` (incarnation 38). Two key corrections over the stalled prior runs: (1) the upgrade `bundleId` is the **contract** bundle (`b1-68c494…`), not v290's ZCF source bundle; (2) `await EV(cc).upgrade()` **deadlocks** because the overlay can't service post-upgrade wallet/vstorage traffic — so I built a concurrent-observer driver that enqueues on the raw controller, runs non-blocking, and polls the incarnation span + `kpStatus`, with slog preservation before shutdown.

**Observed outcomes (each polled to terminal state):**
| step | bundle | result | evidence |
|---|---|---|---|
| 1 baseline (beta2, current) | `b1-68c494…` | ✅ success | inc 38→39, clean import span `[.,249706)`, no rejection |
| 2 beta3 (hex `flatMap`, 10×) | `b1-2595e4b7…` | ❌ **vat-upgrade failure** | slog `"Stack meter exceeded"` ×30 (XS `E_STACK_OVERFLOW`/exit-12); span `[.,249705)`; identical bundle → `STACK_OVERFLOW {"code":12}` on inquisitor's own xsnap worker |
| 3 patched beta3 (`flatMap`→loop, 9×) | `b1-78f80faf…` | ✅ success | inc 38→39, clean import `[.,249706)`, no overflow |

Conclusion: the one-line `hex.js` `flatMap`→loop change carries the ymax0 contract-control upgrade past the value-stack overflow at the on-chain default `stackCount=4096`.

**Changed.** `skills/agoric-chain-snapshot/SKILL.md` on main2 (`5ff0e97e1`): recorded the completed 3-step result, the CC kref, the contract-vs-ZCF bundleId gotcha, the concurrent-observer driver pattern, and the success/failure signals. Repro drivers/bundles live in the standing `ymax0-inquisitor-build` scratch worktree (`repro/cc-upgrade-driver2.mjs`, `beta3-{overflow,patched}-bundle.json`).

**Follow-ups.** None required for the protocol. Note the beta3/patched bundles are the garden's source-built portfolio.contract repro pair (A/B-validated to overflow/clear at 4096 on the same worker inquisitor uses), not the literal release-asset beta3 — stated as such in the #9 reply. Killed all stray inquisitor/xsnap processes.
