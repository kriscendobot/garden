# Completion report: `endojs-endo-but-for-bots-pr868-lint-fix`

**Outcome: PR #868's `lint` check is green. All 24 CI checks pass; `mergeStateStatus: CLEAN`.** Head is now `d48bde2fbbcc789cdd36264abe79b55c997126e2` (fast-forward on dependabot's `f8cf6acf6`; no force-push, and dependabot had not rebased).

## What I did

**Confirmed the diagnosis before acting.** Reproduced all 7 `unicorn/numeric-separators-style` errors locally at exactly the reported lines, and read the v72 rule source directly: `formatNumber` now passes `{...options, groupLength: options.fractionGroupLength}` to the fractional part, with `number.fractionGroupLength` defaulting to `Infinity` — no fractional grouping at all. The job's root-cause analysis was correct in every particular.

**The fix** (one commit, `d48bde2fb`):

- `packages/eslint-plugin/src/configs/shared.js` — added `fractionGroupLength: 3`, plus a three-line comment recording *why* the key must be stated (the `Infinity` default is not guessable from the option name). Verified empirically that this restores exact v56 behaviour: all three real literal shapes lint clean, and their unseparated forms auto-fix back to the separated ones.
- `packages/eslint-plugin/test/internal-numeric-separators.test.js` — the `deepStrictEqual` wiring assertion needed the new key. I also added regression coverage the old test lacked entirely: the three broken literal shapes as `valid` cases, their unseparated forms as `invalid` cases, and two short fractional parts that stay bare. **Verified it fails closed** — reverting `fractionGroupLength` from the preset takes the suite from 147/147 to 146 pass / 1 fail.
- `.changeset/eslint-plugin-unicorn-72.md` — `major`, per your note that `eslint-plugin-unicorn` is a runtime `dependencies` entry of the published `@endo/eslint-plugin` 2.6.0.

I did **not** use `eslint --fix`, per your instruction and for the reason you gave.

## One finding worth your attention

**`eslint-plugin-unicorn@72` declares `peerDependencies: { eslint: ">=10.4" }`, while `@endo/eslint-plugin` declares `eslint: "^8.57.0 || ^9.0.0 || ^10.0.0"`.** Those are inconsistent, and it lands on downstream consumers — this repo is on ESLint 10.7.0 and lints green either way.

It also cuts against a deliberate recent decision: `e4a4c2339 fix(eslint-plugin): keep presets consumable by ESLint 9 consumers` went to real trouble (filtering the preset through the running ESLint's `builtinRules` registry) specifically to keep ESLint 9 consumers working. This bump silently undoes that for anyone installing the result.

I did not touch the peer range — narrowing it drops declared ESLint 8/9 support, which is a maintainer decision, not a lint fix. The changeset states the consequence honestly, and I laid out the options (narrow to `^10.4.0`, or hold the bump) in the PR comment. Blast radius is otherwise narrow: the preset registers unicorn but enables exactly one of its rules.

## Verification

Ran the CI-equivalent set locally against the **full repo** before pushing — all pass: `scripts/eslint-repo.sh` (0 errors), `prettier --check`, `shellcheck.sh`, eslint-plugin tests (147/147), eslint-plugin `tsc`, root `tsc --noEmit`, `generate-composite-tsconfigs.mjs --check`, `check-security-md.sh`, `check-package-uniformity.mjs`. CI then confirmed green with no local-pass/CI-fail discrepancy.

Summary comment posted: [#868 (comment)](https://github.com/endojs/endo-but-for-bots/pull/868#issuecomment-5107132422). I did **not** merge or un-embargo; EMBARGO-2026-08-02 and the scheduled recheck stand.

## Automation defect found and filed

Getting the local checks to run at all surfaced a real garden defect, which I've posted as job **`fix-warm-cache-yarn-install-state`** with a full diagnosis:

**`local-verify.sh` verifies nothing in any warm-cache-populated worktree.** `ensure-project-worktree.sh`'s `list_node_modules()` snapshots only directories *named* `node_modules`; `.yarn/install-state.gz` lives outside them and is never captured or restored. Yarn 4 then refuses `yarn run <script>` — which is exactly how `local-verify.sh` discovers and runs every step — so all six steps report `STEP … FAILED` pointing at one identical blob whose contents are a yarn usage error. Reproduced here; corroborated across several other warm-hit worktrees on this host that have `node_modules/` but no install state.

It fails loud rather than silently green, so it's a blind spot rather than a false pass — but it means the standing "run every lint and test locally before pushing" policy has not actually been met by the harness on warm worktrees. That's why I ran every check by hand via direct `node`/bin-shim invocations instead. I deliberately did not fix it inline: the candidate fixes touch shared worktree provisioning on every host, and `link_tree` hardlinks share inodes with the cache, so an ill-considered `yarn install` there could mutate other jobs' trees. The job lays out three options with that hazard flagged. I also recorded the workaround in the `endo-local-test-bin-shims` memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr868-lint-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 211 tokens (13862854 cached reads)
- Output: 53469 tokens
- Cost: $9.804843
- Wall-clock: 2187s

<!-- garden-usage-end -->
