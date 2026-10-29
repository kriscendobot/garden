I ran the read-only style pre-pass for PR #1575, panel round 3, and it failed. So I didn't run `panel.sh`, didn't send out any jurors and didn't post a PR review.

- **Pinned pair:** base `71b9ab575bd3f5899832d8373cb7dcbf2b0f237d`, head `88a03ee7c820bf4acc170bc18cb531b78a35bb8a`, from `endojs/endo-but-for-bots`, branch `feature/api-key-provider-adapters`. The PR is open and still a draft.
- **Checkout:** I made an isolated project checkout at `/home/kris/garden/scratch/project-wt-endojs--427535468430-f06c46b3` and checked out the head detached. `git rev-parse HEAD` matched the head ID.
- **Pre-pass result:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 1 with two failing probes, both in `packages/fae`:
  - `packages/fae/driver.js:17` uses an inline `import('@endo/eventual-send')` in a JSDoc `@param`. It needs an `@import` tag at the top of the file.
  - `packages/fae/test/driver-credentials.test.js` uses a bare `Far`. It needs `makeExo`, or a justified exemption.

Fix-3 should get the exact output below.

<!-- gauntlet-style-prepass-output-begin -->
probe no-inline-import-jsdoc    fail (exit 1)
  fail: packages/fae/driver.js:17 @param uses inline import('@endo/eventual-send'); add a top-of-file @import tag and use a bare type reference
probe prefer-endo-primitives    fail (exit 1)
  fail: packages/fae/test/driver-credentials.test.js adds bare Far (use makeExo with an interface guard); use makeExo from @endo/exo (or mark a justified prefer-endo-primitives-exempt file)
advisory comment concision      warn (non-blocking)
  fire pruner packages/fae/driver.js:10 (+4-line prose comment) — decide whether it adds a non-obvious invariant or rationale; require deletion if it only narrates adjacent code
result: 2 failing stage(s); address and re-run.
<!-- gauntlet-style-prepass-output-end -->

<!-- gauntlet-stage-result: panel=prepass-failed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178963 cached reads)
- Output: 1592 tokens
- Cost: $0.4229686
- Wall-clock: 44s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
