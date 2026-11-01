Draft PR #1609 is open and its CI is green except two oracle tests that already fail on other PRs. A previous attempt of this job pushed and opened it, so I did no new engine work or pushes this time.

**What the slice does** (https://github.com/endojs/endo-but-for-bots/pull/1609, base `llm-9a14ddf`, head `9ab51376c4`). It carries the job marker, so it is this job's PR:
- **Engine fix:** the default global object and every `Compartment` global now inherit from `%Object.prototype%`, as the spec and XS do. Bare-name lookup now asks the global's actual prototype instead of asking `%Object.prototype%` directly. This closes architecture-review gaps CORE-4 / PROP-7.
- **Ratchet:** a full whole-tree sweep at pinned test262 `be13516f` moves 18 case/mode rows from fail to pass across 10 shards. They include the `parseInt`/`parseFloat`/`decodeURI*`/`encodeURI*` enumerability checks, `Object/getPrototypeOf/15.2.3.2-2-30`, and `language/global-code/decl-lex`.
- **Left alone:** the destructuring-into-`const` rows. XS never throws there, so they stay as baselined `fail` rows and this slice can't fix them.
- **Also in the PR:** new dual-run tests and regenerated boot-heap goldens, metamorphic hashes and fuzz seeds.

**CI:** both failing jobs (`test-ironhorse-oracle`, `ironhorse-oracle-sanitizers`) fail only on `stage3-math/054.js` and `055.js`. The oracle returns `Math.asinh(1.7)` and `Math.acosh(2.3)` one last-digit different from Ironhorse. That comes from glibc on the Ubuntu 26.04 runners, not from this change; it is tracked in #1585, and the fix, #1613, is still open. Everything else passes, including `test-ironhorse`, release, macOS, fuzz and lint.

**Follow-ups:**
- **Gauntlet halted:** the gauntlet already ran on this PR and stopped at the clean stage with "maintainer action required", most likely because of that red CI. Once #1613 merges, the PR needs a weave or CI re-run and then a fresh *run the gauntlet #1609*.
- **Fixture conflicts:** the other open crank slices (#1599, #1600, #1602, #1604, #1605) also move the boot-heap fixtures. Whichever of them lands after this one has to regenerate its goldens, hashes and seeds.
- **Left for later:** XS reports `String(globalThis)` as `[object global]`, while Ironhorse now gives `[object Object]`. A few nearby rows still fail for other reasons, such as `global-object.js` strict and `getOwnPropertyDescriptor/15.2.3.3-4-{109,212..215}`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-ninth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (531458 cached reads)
- Output: 3820 tokens
- Cost: $0.6705475999999999
- Wall-clock: 62s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
