All work complete. Fork branch head confirmed at `e37b4f0`, summary comment posted, inbox clean.

---

## Completion report

**Job:** Address all feedback + CI failures from upstream Agoric/agoric-3-proposals#320 on our fork mirror kriscendobot/agoric-3-proposals PR #1.

**Scope discipline:** Read #320 strictly read-only for content. All artifacts + the reply comment went to the **fork PR #1** only; no comments, links, or pushes to upstream.

### What I found and did

1. **CI `test-packages` failure — root-caused and fixed.**
   The failing step is `Typecheck synthetic-chain` (`yarn tsc` in `packages/synthetic-chain`). This is a **pre-existing base breakage** (upstream `main` is also red on `test-packages`), **not** introduced by this PR — the PR only adds `proposals/` files and touches nothing under `packages/`. The base commit `f2eaf7c` ("upgrade Agoric/Endo deps") dropped the `@agoric/inter-protocol`/`@agoric/fast-usdc` devDependencies that were transitively supplying `@agoric/smart-wallet`, whose types `commonUpgradeHelpers.ts` imports (`OfferSpec`, `ExecuteOfferAction`) → `TS2307` ×2 + knock-on `TS2578` ×3 in `econHelpers.js`.
   **Fix:** added `@agoric/smart-wallet@0.5.4-dev-04baeed.0.04baeed` (matching the current dev snapshot; publishes `src/offers.js`/`src/smartWallet.js` + `.d.ts`, no exports map, so the deep imports resolve) as an explicit devDependency of `@agoric/synthetic-chain`; updated root `yarn.lock`.

2. **Missing changeset — added** `.changeset/restore-smart-wallet-types.md` (`@agoric/synthetic-chain: patch`).

3. **CodeRabbit** — its review on #320 was stalled at the "processing… please wait" placeholder; no walkthrough or actionable inline comments were produced. Nothing substantive to address.

4. **Other feedback** — no human reviews, no inline comments; only bots (SemanticDiff, changeset-bot, CodeRabbit-in-progress). @dckc's guidance (bundles via `scripts/fetch-all-bundles.ts`, omitted proposal 113 documented) left intact.

### Verification (real execution)
- Reproduced the CI failure locally: before fix, `yarn tsc` → **exit 2** with the exact 5 errors from the CI log.
- After fix: `yarn tsc` → **exit 0**; full `prettier --check .` → **exit 0**.
- **Could not verify:** the `yarn test` (ava) step (needs native `better-sqlite3`, blocked in this sandbox) and the Docker `proposals-matrix-test` (needs Depot/registry infra). The change is types/deps-only and touches no runtime or test code.

### Pushed / posted
- Commit `e37b4f0` → `kriscendobot/agoric-3-proposals` branch `add-proposals-111-116` (bot identity `endolinbot`).
- Summary comment on fork PR #1: https://github.com/kriscendobot/agoric-3-proposals/pull/1#issuecomment-4858568884

### Follow-ups / caveats
- The fork does **not** run GitHub Actions (workflows are dormant on the fork and can't be dispatched via API without also firing the heavy, secret-dependent docker matrix), so green CI is attested by the local reproduction, not a fork CI run.
- Upstream #320 has the same `test-packages` breakage; the same one-line devDependency fix would green it there, but that's upstream and out of scope.
- No changes pushed to garden `main2` — this job's deliverable is entirely fork code; the garden worktree was only an incidental workspace.
