All clean — 2 commits pushed, no build artifacts leaked (moddable/xsnap-native are gitignored), build.env pinned to 5.5.0. The job is complete.

## Completion report

**Job:** Mirror + rebase upstream `Agoric/agoric-sdk#11297` (XSnap Moddable 3.9.2 → 5.5.0) into `kriscendobot/agoric-sdk`.

**Fork mirror PR:** https://github.com/kriscendobot/agoric-sdk/pull/12 — Draft, same-repo (base `master`, not upstream), OPEN.
**Rebased branch:** `xst/moddable-5.5.0-11297`
**Mirror mapping:** recorded (`pr-mirrors/Agoric-agoric-sdk-11297.md`, `Agoric/agoric-sdk#11297 → kriscendobot/agoric-sdk#12`).

### How I re-expressed the Moddable bump
The job's premise was partly stale, and this is the key finding: **#12477's pinned-archive-from-source mechanism was itself later removed.** Current master doesn't bump submodules *or* pinned-archive refs — it downloads **prebuilt `xsnap-worker` binaries** keyed by package version (added in `9b63ccb62`, remnants cleaned in `e46f6cd55`), and no Moddable-5.5.0 prebuilt exists in the foreign `Agoric/xsnap-worker-binaries` repo to point at.

So I re-expressed the upgrade on the **#12477 pinned-archive-from-source mechanism, restored for this branch**:
- Restored `packages/xsnap/src/build.js` (fetches `${repo}/archive/${hash}.tar.gz`, builds from source) and the from-source wiring in `package.json` (`build:bin`/`build:env`/`build:from-env`, `postinstall → build:from-env`, moddable/xsnap-native `files[]` globs + #11297's `moddable/xs/tools/fdlibm`).
- Re-pinned `packages/xsnap/build.env` to the Moddable 5.5.0 commits from #11297: `MODDABLE_COMMIT_HASH=c50d7fdfd…`, `XSNAP_NATIVE_COMMIT_HASH=b7adac53a…`.
- `api.js` already carries `METER_TYPE='xs-meter-36'` on master — no change.

**Verified by real execution:** `node src/build.js` compiled release+debug workers cleanly, both reporting `xsnap 0.14.2 (XS 16.7.1)` (Moddable 5.5.0) — up from XS 11.x (3.9.2).

### Snapshots regenerated
**None.** A full monorepo `yarn install` to run the ava snapshot suites was out of budget (no `node_modules`, no `yarn` on PATH), so I did not fabricate snapshots. `xsnap.test.js.{md,snap}` and SwingSet `xsnap-store.test.js.{md,snap}` are **left at master's values** (they are engine- and lockdown-bundle-dependent; #11297's differ because its base had a different lockdown bundle). I *did* carry #11297's deterministic **test-code** adaptations (3-way rebased): xs-perf golden meter counts, xs-limits regressed-case comment-outs, xsnap ReferenceError-regex loosenings/heap counts, inspect/boot-lockdown `filterRepairLogs`, SwingSet create-vat error-message loosening.

### Residual work a validation job MUST chase
1. **Regenerate snapshots** — run `yarn && yarn test` (ava `--update-snapshots`) in `packages/xsnap` and `packages/SwingSet` against this branch's 5.5.0 engine; the snapshot tests will currently fail (expected signal).
2. **Confirm the carried golden meter counts** match this build's actual output (same pinned commits ⇒ should match; a divergence is itself a validation finding).
3. **Extend the flat/flatMap A/B harness** (`skills/agoric-chain-snapshot` `repro/xst-release-ab`, `repro/xst-flat-release-ab`) against this XS 16.7.1 worker vs. stock — the known flat/flatMap stack-overflow divergence is the class this gauntlet must catch.

### Cross-cutting note for the sibling job
The peer job **`xst-mirror-agoric-11031`** carries the same outdated assumption ("sources now come from pinned archives (#12477)"). That is no longer master's mechanism — master installs prebuilt binaries; the pinned-archive/from-source path must be restored (as done here) for any branch that needs to actually build a non-stock engine. Flagging for the maintainer rather than spawning a message-job, since that gardener wasn't live on the bus.

Guardrails honored: all work on the fork; upstream `Agoric/agoric-sdk` untouched (no comments/links/pushes); upstream text treated as data.
