Fix round 1 for endojs/endo-but-for-bots PR #1343 is done. The must-fix items from the round-1 panel review are applied and pushed, and CI is green: 26 checks, 0 failed (`ci-wait-merge` rc 0).

**What I pushed** (three follow-up commits; the head moved from `e6963911e` to `647d77050` through `safe-push-pr-head.sh`):

1. **`fix(daemon)`** (`bab1ed7bc`):
   - **Old retained records:** a retained guest saved before this change (with `introducedNames`) is now read as the equivalent `endowments`. Before, reconnecting such a guest crashed with a `TypeError` (assessor, typist, migrator, breaker, corner-prober).
   - **Protected special names:** the rule against replacing daemon-bound special names (`@agent`, `@self`, `@host`, `@mail`, `@nets`, `@planes`) is now enforced in `guest.js`, where those names are bound. Only `@main` can be replaced. Several seats said that replacing `@main` is what the feature is for. The up-front check in `host.js` stays, with a comment (assessor, corner-prober, locksmith, warden, purist).
   - **Reconnects:** a retained guest reconnecting with the same special-name paths reuses the identifiers resolved at creation. Removing or rebinding the host's source name no longer breaks it.
   - **Race:** when two concurrent `provideGuest` calls create the same unretained guest, special endowments are no longer silently dropped. `makeGuest` now throws instead.
   - **`__proto__`:** an endowment named `__proto__` is no longer silently lost. The maps are built with `Object.fromEntries`, and the provisioner now uses the shared `isSpecialName` check.
   - The `MakeGuestOptions` doc now says which entries keep their original identifiers on reconnect and which are looked up again by name.
2. **`test(daemon)`** (`eecb51978`): four new tests in `provision-lifecycle.test.js`:
   - every protected name is rejected, and replacing `@main` works;
   - special names survive removing and rebinding their source;
   - an old-shape `introducedNames` record still reconnects;
   - a `__proto__` endowment is kept on both the retained and unretained paths.
3. **`docs`** (`647d77050`):
   - the changeset now has an `@endo/agentry` patch entry and notes the default `@main` and the old-record handling (curator);
   - agentry's README and a code comment no longer describe the removed `introducedNames` option of `provideGuest` (integrator).

**PR metadata** (integrator and coverage-auditor):
- Title is now `feat(daemon)!: endow guests through one @-partitioned endowments map`.
- The body follows the repo's PR template, with `Closes: #982` and the Upgrade Considerations section filled in.
- The body says `packages/lal` is Node-only, which is why its `test:xs` stub stays.

**Local checks:** `provision-lifecycle.test.js` passes 9/9 on Node 24. Daemon and agentry `lint:types` pass, eslint reports 0 errors, and prettier is clean. The tests have to run on Node 24 (`/usr/local/n/versions/node/24.21.0`). Under the default Node 22 the daemon won't start, because the cached better-sqlite3 build is for Node 24.

**Follow-ups:**
- **Not done:** the panel's should-fix and comment-only items:
  - pruner's help-text and README trims;
  - stylist's renames of `endowments`, `specialNames` and `opts`;
  - typist's `ResolvedEndowments` type and assertion function;
  - a shared adapter for the CLI and agentry;
  - not formulating the default worker when `@main` is replaced;
  - a CLI test for `--introduce`;
  - the `formula-record.js` guest fields.

  Panel-2 can raise them again.
- **Squash before merge:** packager flagged the existing `fixup!` commits (`d5719e8e7`, `e6963911e`); they need an autosquash before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4754434 cached reads)
- Output: 22851 tokens
- Cost: $2.4302108000000002
- Wall-clock: 2205s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
