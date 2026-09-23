---
ts: 2026-06-04T03:27:21Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--770ee3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - entries/2026/06/04/032356Z-dispatch-liaison-770ee3.md
  - entries/2026/06/04/032215Z-result-shepherd-ed2960.md
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4618674467
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4618636545
---

# result: fixer — #411 CFT hang diagnostic + vestigial-step cleanup

## Files touched

- `.github/workflows/browser-test.yml` (+6 / -2 lines).
  - Dropped the `Put unstable chrome where playwright would look for it` step (the `mv /opt/google/chrome /opt/google/chrome-unstable` rename). Vestige of the disabled `selenium/standalone-chrome` container that is commented out at the top of the job.
  - Added `env: { DEBUG: pw:install }` on the `Install Playwright Browsers` step, with a comment explaining the diagnostic intent.

## New head SHA

- `3fbe0af31` on `ci/cache-playwright-browsers`.
- Push: `37440d0e2..3fbe0af31` (regular append, no force).
- Commit message: `ci(browser-test): add DEBUG=pw:install + drop vestigial chrome rename`.

## Reply comment

- `4618674467`: https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4618674467
- Top-level summary on PR 411, replying to kriskowal's `4618636545` ("Please take a look at the CI failure at https://github.com/endojs/endo/pull/3296"). The dispatch brief named the target as `4618214234`, which does not exist on this PR; the closest semantically-matching kriskowal prompt was `4618636545` and the shepherd's classification reply landed there as `4618654468`. This fixer reply continues that thread.
- The comment summarizes the shepherd's diagnosis (download is not the bottleneck; post-download phase hangs in CFT install), names what landed (`pw:install` debug + chrome-rename drop), and names what was deferred (the Playwright pin downgrade) along with the three possible next-run outcomes.

## Judgment calls

- **Landed h1 + h2 only.** Per the brief: defer the Playwright version bump (h3) to a separate dispatch if h1+h2 do not resolve. The next CI run on this PR is the discriminator: if `pw:install` surfaces a fixable step, fix it; if dropping the chrome-rename resolves the hang on its own, done; if it still hangs with informative debug output, the downgrade is justified.
- **Comment ID reconciliation.** Replied on `4618636545` after confirming `4618214234` does not exist in `endojs/endo-but-for-bots` issue comments. The target was unambiguous from the dispatch context (kriskowal's prompt that triggered the shepherd dispatch).
- **`env:` placement.** The `nick-fields/retry` action runs `command` in a child shell that inherits the step's `env`. Verified by yaml-parsing the workflow; the env propagates without requiring `with: env:` shape or `command: DEBUG=pw:install ...` inlining. Cleaner: lives on the step, comments out the rationale.
- **No package.json or lockfile touched.** The brief restricted authorization to the workflow file. h3 (downgrade) would touch `browser-test/package.json` and `browser-test/package-lock.json` and is explicitly deferred.
- **No re-request review and no shepherd re-dispatch.** The PR is the maintainer's issue-comment thread, not a `CHANGES_REQUESTED` review. The next CI run carries the diagnostic signal; the orchestrator decides whether to dispatch another shepherd or chain to h3 based on what the next run shows.
- **No pre-push-gates / pre-pr-checklist run.** The change is `.github/workflows/*.yml` only; the gates are JS-source / docs gates and do not apply. The YAML was validated with `python3 yaml.safe_load`.

## Authorization audit

All actions taken were authorized by the dispatch:

- Workflow file edit: authorized.
- One regular-append commit + push: authorized.
- Issue-comment reply on PR 411: authorized.
- No upstream endo#3296 touches.
- No package.json/lockfile changes (h3 explicitly deferred).
- No force-push, un-draft, or merge.

Self-improvement: nothing this time.
