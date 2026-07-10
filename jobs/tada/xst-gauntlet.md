All legs complete, both pushes landed, PR comment posted, inbox clean. Final report:

## Completion report — `xst-gauntlet`

**issue_spine:** issue-kriskowal-garden-33
**Target:** fork PR `kriscendobot/agoric-sdk#13`, branch `xst/integrate-variant-bump` (fork-only; upstream Agoric untouched)

### What I did
Built both variants on this host (legacy `xsnap 0.14.2 / XS 13.3.0`, latest `xsnap 0.14.2 / XS 16.7.1`; `better-sqlite3`, `xsnap-lockdown`, and `swingset-xsnap-supervisor` bundles built by hand to clear environmental gaps), then ran each gauntlet leg and recorded pass/fail with evidence.

### Per-leg verdict
| # | Leg | Verdict |
|---|-----|---------|
| 1 | Snapshot regen under latest | ✅ legacy byte-stable (snapshot-hash goldens pass unchanged) · ⚠️ latest regen is architectural (test itself demands "special accommodation, not new hashes") → follow-up |
| 2 | Golden meter counts | ✅ **fixed** — see finding below |
| 3 | Transcript replay | ✅ legacy zero-divergence (transcript-one load/save, transcript-light, reload-snapshot reuse/restart xs-worker all green) |
| 4 | `force:integration` | ⛔ infeasible here (full chain bring-up) → substituted with the `test-all-packages` package suites: xsnap legacy 76-pass/latest 78-pass, SwingSet xsnap-store+transcript+reload+create-vat+metering all green |
| 5 | Snapshot-format round-trip | ✅ legacy save→restore→resume clean at xsnap and SwingSet levels; hash goldens byte-identical |
| 6 | A/B divergence harness | ✅ 8/21 probes diverge, **all** explained by the XS 13.3.0→16.7.1 delta; core determinism + flat/flatMap overflow identical on both; no surprise divergence |

### Key finding (fixed and pushed)
The 5.5.0 merge had left `packages/xsnap/test/xs-perf.test.js` goldens pinned to the **latest** engine, so a clean `yarn test` was **red on the default (legacy/consensus) engine** — 3 failures. I restored the legacy goldens as the committed default (compute `1_380_185`/heap `103_930`, REDOS `140`, un-`failing` the metering-switch test) with the latest values preserved in comments. Pushed as commit `04180a18d` to `xst/integrate-variant-bump`; default lane now green (7 pass/2 skip).

### What changed
- **Fork** `kriscendobot/agoric-sdk` (`04180a18d`): `test/xs-perf.test.js` legacy-golden restore.
- **Garden** `main2` (`b2122dd0e`): new `skills/agoric-chain-snapshot/repro/xst-variant-ab/` (A/B probe + README with the recorded divergence table) — the Leg-6 harness extension.
- **Fork PR #13**: posted the full per-leg summary comment (issuecomment-4933123969).

### Follow-ups (not reworked here — architectural)
1. **Variant-gated `latest` test lane** — the outstanding work before `latest` can be called fully validated: `xsnap.test.js` snapshot-hash goldens + latest meter goldens + the `metering-switch` `.failing` marker need a variant-selected mechanism (default legacy stays byte-stable). This is Leg-1/Leg-2 latest half.
2. **Full-chain `force:integration`** on a capable host (docker/a3p) — Leg 4 proper.
3. Informational: **XS 16.7.1 does not independently clear the ymax0 leaf-flat value-stack leak** at the on-chain worker stack size; the fork's `flatMap→loop` source fix remains the remedy on both trains.

### Fit to call "validated"?
The **legacy (default consensus) train is validated** by this run. The **latest** train spawns and runs workloads consistently but its test lane is not yet green-by-construction — pending follow-up #1.
