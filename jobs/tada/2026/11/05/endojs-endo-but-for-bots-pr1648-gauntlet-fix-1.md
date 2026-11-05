Fix round 1 for endojs/endo-but-for-bots#1648 is pushed and CI is green: all 36 checks pass on head `9e3b22abac`.

I applied the must-fix items from panel review 5776935076 in two commits: `2176799b05` (the fixes) and `9e3b22abac` (a type fix, below). Both were pushed with `safe-push-pr-head.sh`.

**What changed**
- **Guest name checks (locksmith, purist):** `list`, `has` and `remove` take a variable number of name arguments. Every argument is now checked, so calls like `list('@host')` or `remove('friend', '@protected')` are refused. Tests cover these calls.
- **Provider kind at creation (assessor):** creating an agent now refuses a provider kind its harness doesn't support (`provider-kind-unsupported`), as reattaching already did.
- **Wake cursor (saboteur, breaker, corner-prober):** `confirmedCursor` must now name an unread message the owner was shown. Tests confirm that cursors `0`, `4` and a 31-digit value are refused for both `skip` and `process`.
- **Owner/key collisions (purist):** operation and name keys now use an unambiguous `JSON.stringify([ownerId, key])` encoding, and a retry also checks the owner. A test confirms that owner `alice` with key `team:create` no longer collides with owner `alice:team` with key `create`.
- **Restored snapshot (warden):** the snapshot read back from the journal is now hardened.
- **Types and doc comments (typist, archivist):** added named types and annotated `createWithUse` and `reattachWithUse`. The 10 doc comments that had two `@param` tags on one line now have one per line, and two untyped parameters are typed.
- **Package exports (packager, surfacer, pruner):** removed the public exports for `agent-factory.js`, `agent-factory-module.js` and `agent-guest-powers.js`. Nothing outside the package used them. The README section that described internal files is cut to a short note on configuring the daemon module, and the changeset is rewritten as a release note with one sentence per line.
- **Daemon test (transplanter):** uses the OS temp directory instead of a hardcoded `/tmp`.

Locally, the 33 agent-factory tests, prettier, ESLint (warnings only) and both TypeScript checks passed. The repo-wide check runs out of memory at Node's default heap and needs `--max-old-space-size=8192`.

**CI**
- The first push failed lint: the repo-wide TypeScript check rejected the new type because the tests pass the harness name as a plain string. My earlier local run of that check had crashed without my noticing. `9e3b22abac` widens the type to `string`; the harness is still checked against the catalog when the code runs.
- On that run, `sandbox-drivers` and `test (24.x, ubuntu-latest)` failed on the same `bwrap timeout and repeated cancellation reap process groups` test in `packages/sandbox`, which this PR doesn't touch. `sandbox-drivers` had passed on both earlier heads, so I treated it as flaky and reran the failed jobs; both passed.

**Not done, for the next panel round**
- I did not add `@endo/daemon` to the changeset. That package only gained a test, which doesn't call for a version bump.
- I did not apply the should-fix items: the stylist's renames and the engine-realist's concerns about reconciliation cost.
- I did not edit the PR description (pruner).
- No test yet exercises the provider-kind refusal, at creation or at reattachment.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1648-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (5418841 cached reads)
- Output: 22762 tokens
- Cost: $2.3307202
- Wall-clock: 7247s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
