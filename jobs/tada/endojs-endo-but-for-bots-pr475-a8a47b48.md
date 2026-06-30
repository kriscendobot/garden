The 4 `test` matrix jobs are still running (they exercise the same suite `cover`/`test:c8` already validated green). All other checks pass, no failures. The work is complete and pushed. Final report:

---

## Completion report — endojs/endo-but-for-bots PR #475

Worked the erights attention directive (comment 4839980005). Head is now `9e4c2d9af`. CI: **lint, cover, build, test-xs, test262, browser-tests, hermes, ocapn, zizmor all pass**; the 4 `test (os×node)` matrix jobs are still running (same suite `cover` already passed). PR went from CONFLICTING → MERGEABLE.

**1. Lint errors (`1ae5dcdef`)** — all 8 were in `test262-runner/scripts/node-prelude-header.js` (the lintable fixture). Its eslintConfig override omitted `global-require` (the fixture intentionally `require()`s inside an `if`) and lacked `env.es2021`, so `globalThis` was undefined. Added both. Package lints clean.

**2. Conflicts (`4804d20ed`)** — merged current `master` (literal "update"; a 36-commit rebase would re-resolve the same conflicts repeatedly). Resolved 4 files: kept `ocapn/syrup/compare.js` deleted (branch replaced it with `compareBytes`; master's change was cosmetic), `writeBytestring` as arrow + branch's simplified body, and the branch's narrowing for `byteArray.{js,test.js}` (master's only change there was the function→arrow sweep, already arrow-style on the branch). Offered to redo as a clean rebase/retcon if preferred.

**3. XS native test (`658ddda4c`)** — **investigated and flagged: no current engine supports the native path.** xst (Moddable 5.0.0 / XS 15.5.1, and 8.0.1 / XS 17.9.1) and Node 22 all lack native `sliceToImmutable`, so under SES the shim's emulated path is always active (`frozenBytes` yields ownKeys=0, never the native exotic). XS even throws on `Object.freeze` of a Uint8Array over a native immutable buffer, so a native-shape byteArray is unconstructable; an XS upgrade within released Moddable does not unlock it. Added a detection tripwire test (passes Node+SES; fails when native arrives, signalling native-path coverage is needed). Posted the findings plus two clarifying questions to kriskowal/erights (test shape; and two adjacent infra gaps I found — CI's `test262` job is stubbed `exit 0`, and the XS+SES suite currently can't parse under xst in strict mode).

**4. Regression caught by `cover` and fixed (`9e4c2d9af`)** — the merge **silently dropped** a guard in `passStyleOf.js` (a non-conflict file git auto-merged, where master's `document.all` rewrite edited the same region as the branch's addition). The lost guard routes an unclaimed mutable-buffer Uint8Array to "Cannot pass mutable typed arrays" instead of a confusing remotable error, and matters under `LOCKDOWN_HARDEN_TAMING=unsafe`. Re-added; pass-style now green across all three SES configs (55/54/55), marshal 79, ocapn syrup 33.

**Comments posted:** summary (issue-comment 4840130636) + follow-up (4840168475), both on the PR.

**Follow-ups for the maintainer:** awaiting kriskowal/erights answers on (a) desired XS-test shape, (b) whether to file issues to re-enable test262 in CI and fix the XS strict-mode prelude parse. These are out of scope for this PR.

**Self-improvement:** After a *merge*-based conflict resolution, verify with the **full multi-config** suite (lockdown + unsafe + endo), not just the default lockdown config — git can silently drop a branch's additions in auto-merged non-conflict files when the base edited the same region, and only the unsafe config exposed it here. The `rebase-before-followup` skill notes "silent commit drops" for rebases; the merge analog (silently dropped hunks in auto-merged files) is worth the same vigilance and a quick `git diff <base>...HEAD` sanity check on semantically-central files even when they didn't conflict.
