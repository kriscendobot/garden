Clean stage report for kriscendobot/minion.town PR #151 ("chore: begin JavaScript-only script migration", head `dcc2d64`). Nothing needed changing, so nothing was pushed, and CI is green.

**Coverage**
- Ran the PR's touched test files in an isolated checkout: `deploy-script-helpers`, `javascript-only-scripts`, `npm-registry-preflight` and `endo-claude-vendor`. All 24 tests pass.
- The repo has no vitest coverage provider installed, so I couldn't get line coverage numbers. I reviewed the new scripts by hand instead:
  - **Has tests:** the helper module `deploy/aws/scripts/lib/common.js` (only its `makeSsmCommand` helper), `collectAllowedEmails` (from `gen-allowed-emails.js`), `makeCaddyInstallScript` (from `deploy-caddy-route53.js`), the shell-script policy check (classifier, violation finder, and a run against the real repo), the registry preflight, and the vendor tool's output.
  - **Not unit-tested:** the `main()` functions that call AWS, write files into the repo, or run Docker, and `inspect-image.js`. These only touch external systems, so I added no tests.

**Dead code**
- The five deleted `.sh` files are no longer referenced anywhere in the repo.
- `lib/common.js` exports a few things nothing uses yet: `region`, `artifactsBucket`, `accountId` and `repoRoot`. They're the shared helper that part 2 of the parent orchestration `minion-town-shell-to-js-20261004` will use when it converts the bulk `deploy-*` scripts. Removing them now would only mean re-adding them, so I left them in.
- The `export const main` in `npm-registry-preflight.js` is never imported anywhere, but it does no harm.

**CI**
`ci-wait-merge.sh --no-merge` returned rc=0: 3 checks, 0 failed.

**Follow-ups:** none. The PR is still a draft; the later gauntlet stages handle review and un-drafting.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (614446 cached reads)
- Output: 4761 tokens
- Cost: $0.6888212000000001
- Wall-clock: 56s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
