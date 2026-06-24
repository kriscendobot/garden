---
ts: 2026-06-14T08:15:00Z
kind: result
role: fixer
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
dispatch_root: /home/kris/dispatches/fixer--71b7f5
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
  - repo: Agoric/agoric-sdk
    pr: 12527
    role: upstream-source
refs:
  - entries/2026/06/14/081000Z-dispatch-fixer-71b7f5.md
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4701153133
  - https://github.com/Agoric/agoric-sdk/pull/12527#pullrequestreview-4472042222
---

# result: fixer — applied 3 Copilot inline asks to mirror PR #5

Applied Copilot's three inline asks from upstream
`Agoric/agoric-sdk#12527` review `pullrequestreview-4472042222`
to the bot-fork mirror PR `kriscendobot/agoric-sdk#5`. Pushed
3 commits to `mirror/12527-endo-sync-refresh` (append-only;
no rebase, no force) and posted a top-level summary comment
on PR #5 at-mentioning `@kriskowal`. Upstream
`Agoric/agoric-sdk#12527` was not touched.

## Head SHAs

- Pre: `5e15800304ae557dd0c75805604147b4ee7823ea`
- Post: `baed7818f38b39db61d20901f7a5f0012b08245e`

## Per-ask resolution

### Ask 1 — `services/ymax-planner/src/utils.ts`

Restore a `key: K` overload alongside the existing `key: string`
overload on `lookupValueForKey`, so call sites with a statically
known key keep compile-time typo protection while call sites
that only have a `string` keep working (deferring the bad-key
check to runtime, as before).

Implementation note: arrow-function expressions cannot carry
TypeScript overload signatures, so the export was converted
from `export const lookupValueForKey = <K, V>(...) => {...}`
to a `function` declaration with two overload signatures plus
the implementation signature. The runtime behavior is identical;
only the call-site type narrowing is restored.

Commit `d9c9c0387aa5f7b5a62c4b3da08ff8b0747ee57c`.

### Ask 2 — `packages/SwingSet/tools/test-swingset.js`

Replace `/** @type {Promise<any>} */` cast with
`/** @type {Promise<EndoZipBase64Bundle>} */` to match the
declared return type of `BundleFromSourceSpecPower` in
`packages/SwingSet/src/controller/initializeSwingset.js`.
Added the `EndoZipBase64Bundle` JSDoc `@import` from
`../src/types-external.js` and consolidated the four prior
`@import` lines into two for readability. Affected line:
`tools/test-swingset.js:44` (was `:46` on dispatch brief,
shifted by the consolidated imports).

Commit `255c705e9a457db32e9af357a13232a3f8505fa2`.

### Ask 3 — `packages/SwingSet/src/kernel/slogger.js`

Swap `// @ts-expect-error objectMap return type widened by Endo update`
for `// @ts-ignore objectMap return type widened by Endo update`
at line 38, keeping the existing comment text. The intent is to
silence a noisy type mismatch from the Endo update; if a future
Endo bump narrows the return type back, `@ts-expect-error` would
flip CI red (TS2578 "Unused '@ts-expect-error' directive"), while
`@ts-ignore` is silent in that case.

Commit `baed7818f38b39db61d20901f7a5f0012b08245e`.

## Local lint:types results

Ran `corepack yarn install` (warnings only, all peer-dep noise
pre-existing on master) and then per-workspace `lint:types`:

- `@aglocal/ymax-planner`: only pre-existing TS2307 "Cannot find
  module" errors from workspaces whose `dist/` was not built
  (`@agoric/client-utils`, `@agoric/cosmic-proto`); zero errors
  in `utils.ts`, `support.ts`, or `plan-deposit.ts` (the touched
  file and its call sites). The overload restoration does not
  break any caller.
- `@agoric/swingset-vat`: clean (`exit=0`, zero output). Both
  the `Promise<EndoZipBase64Bundle>` cast and the `@ts-ignore`
  swap pass tsc.

The pre-existing `lint:types` noise in `@aglocal/ymax-planner`
is environmental (the dependency workspaces need to be built
first for their `.d.ts` to exist) and not introduced by this
PR; CI on the bot fork builds dependencies first and would not
see these errors.

## PR #5 top-level comment

Posted at:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4701153133>

Body lists the three commit SHAs, the per-ask file path and
short rationale, and notes that the local `lint:types` is green
on `@agoric/swingset-vat` and on `@aglocal/ymax-planner`
(modulo pre-existing missing-`dist/` declarations in unrelated
workspaces).

## Out-of-scope items

Did not:

- Touch upstream `Agoric/agoric-sdk#12527`. Ferry across is a
  separate boatman engagement from the credentialed host.
- Re-request review. Dispatch authorization explicitly excluded
  re-request; the maintainer is actively routing PR #5 and the
  fix lands as part of the drive-to-green work.
- Chase the broader drive-to-green stall the prior fixer (c997e7)
  was on. Scope was limited to Copilot's three asks.

## Self-improvement

Self-improvement: when a typescript arrow-function export needs
overload signatures, the conversion to `function` declaration is
non-trivial mechanically; the fixer should call it out in the
commit body (as I did) so a reviewer skimming the diff sees the
shape change is intentional and not a gratuitous refactor.
