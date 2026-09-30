I reworked endojs/endo-but-for-bots#774 in place into the layer-1 SturdyRef shim, following the design in endojs/endo-but-for-bots#1389. Locally, `yarn test` (15 passing), `yarn lint` (0 errors, 9 warnings) and the composite `tsc -b` all pass. CI is not confirmed. The first run failed `lint` because Prettier wanted a test file reformatted. I fixed that and pushed, but after about 45 minutes the new `lint` and test jobs were still queued without a result. `prettier --check` on the package now passes locally.

**What the package does now** (head `95609a7c4b`, branch `build/sturdyref-shim-first-wins`):
- **`new SturdyRef(handler)`**: builds a ref like `new Proxy`. The ref is frozen, has no own properties, and its prototype carries only `constructor` and the `SturdyRef` tag. The handler's `enliven` hook is read once, at construction. The handler is kept in a private `WeakMap` and can't be reached from the ref. Calling it without `new`, or with a handler that has no `enliven`, throws.
- **`SturdyRef.enliven(ref)`**: calls `handler.enliven(ref)` in a later turn. If the hook throws, or the argument isn't a ref, it returns a rejected promise rather than throwing.
- **`SturdyRef.isSturdyRef(value)`**: a brand check that reveals nothing about what the ref holds.
- **Kept from the old version**:
  - first-wins install that can't be replaced;
  - the `index.js` ponyfill (now exports `makeSturdyRef`, `enliven`, `isSturdyRef`, plus the provide/select/make helpers) and the eager `shim.js`;
  - hardening happens lazily, after `lockdown`.
- **Removed**: `fromLocation`/`toLocation`, the locator `WeakMap`, and minting with `Far`. `@endo/pass-style` is now only a dev dependency, so `passStyleOf` rejects a ref until layer 3 makes refs passable. A pre-existing global must now be a function with `enliven` and `isSturdyRef`; the old namespace shape is rejected.
- **Tests** follow the design's table of which old tests to keep, rewrite or drop. The old "withheld from child compartments" test now just records the current default (no SES permit, so a child compartment doesn't see the global); layer 2 will change that.
- I rewrote the README and changeset and regenerated the package's composite tsconfig. `yarn install` left `yarn.lock` unchanged, so there is no lock commit.

**Branch and PR changes:**
- Squashed the old fixup and rebased onto frozen `llm-7ff30af`. The branch is now: the original feat commit, the existing `chore: Update yarn.lock` commit, and one new rework commit.
- Moved the PR base from live `llm` to `llm-7ff30af` and retitled it "feat(sturdyref): layer 1 — SturdyRef shim with handler/enliven construction".
- Rewrote the PR body with links to the arc, #695 and #1389, a "## Stack index" section, and this job's garden-job marker. It is still a draft.
- Posted a stack-index update on kriscendobot/garden#47 saying layer 2 should stack on `build/sturdyref-shim-first-wins`. That comment gives head `d63dd51146`, which is now out of date; the current head is `95609a7c4b`.

**Follow-ups:**
- Confirm `lint` and the test jobs go green for `95609a7c4b` before the gauntlet or layer 2 relies on this PR.
- Draft #737 was based on this branch and has not been rebased, as the job asked; its diff will now look wrong until the maintainer decides whether to close it as superseded.
- The design's open questions (e.g. whether the hook runs in a later turn, whether the handler is hardened) are built to its proposed defaults: later turn, hook read once, handler not hardened, instances inherit from `SturdyRef.prototype`. Any change of mind on #1389 would need a small change here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-shim-build-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3776844 cached reads)
- Output: 25052 tokens
- Cost: $2.0560967999999997
- Wall-clock: 3314s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
