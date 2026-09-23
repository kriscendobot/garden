CI is now fully green and `mergeStateStatus` is `CLEAN`. The PR remains a draft by design (it's a "Draft plain mirror" of upstream endo#2865 — shepherd's job is CI green, not un-drafting). Inbox is empty. Job complete.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763 — drive CI to green.

**Starting state:** 14/15 checks passing; only `cover` was RED.

**Root cause #1 (cover):** The new `@endo/pola-io` package (added by this mirror of upstream endo#2865) had `"test:c8": "c8 $C8_OPTIONS ava ..."` using a bare `$C8_OPTIONS`. Yarn's portable shell errors with `Unbound variable "C8_OPTIONS"` when the var is unset (as it is in the `cover` job). Every other package in the repo uses the safe default-empty form `${C8_OPTIONS:-}`.
- **Fix:** changed to `c8 ${C8_OPTIONS:-} ava --config=ava-nesm.config.js` (commit `4fb0bb9f43`). Reproduced the failure and verified the fix locally (ava tests pass, unbound-variable error gone).

**Root cause #2 (zizmor, surfaced after cover went green):** The `Workflow security audit` (zizmor) began failing on a *pre-existing* stale action pin inherited from the frozen July base: `ci.yml:279` pinned `dorny/paths-filter@d1c1ffe... # v3`, but zizmor's tightened pin-comment audit now flags that sha since the `v3` tag has moved. Confirmed other current same-repo PRs pass zizmor using the newer `v4.0.2` pin.
- **Fix:** bumped to `dorny/paths-filter@7b450fff21473bca461d4b92ce414b9d0420d706 # v4.0.2` — the exact known-good pin already passing on other endo-but-for-bots PRs (commit `805f3235ff`).

**Final state:** All 15 checks pass (`cover`, `zizmor`, all `test`/`test262`/`lint`/`build`/etc.). PR #763 `mergeStateStatus: CLEAN`. PR remains `isDraft: true` intentionally — it is a "Draft plain mirror" and un-drafting is not part of the shepherd mandate.

**Follow-ups:** None required for CI. Note for awareness: root cause #2 is a stale pin that also lives on `origin/master` (v3) and could resurface on other frozen-base mirror PRs until upstream master bumps the pin; not actionable within this job's scope.

Both fixes pushed to the PR head branch `mirror/endo-2865-pola-io`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr763-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2316543 cached reads)
- Output: 20595 tokens
- Cost: $2.3555975
- Wall-clock: 1279s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
