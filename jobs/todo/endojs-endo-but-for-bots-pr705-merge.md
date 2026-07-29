# Merge endojs/endo-but-for-bots PR #705

Role: [conductor](roles/conductor/AGENT.md).

Land https://github.com/endojs/endo-but-for-bots/pull/705 —
"feat(agent-tools): git remote push tier — makeGitRemoteTool, with push
force-with-lease". Head `build/agent-tools-git-remote-push-tier`, base `llm`.

Readiness at dispatch (2026-07-29, verified):

- `isDraft: false` — no un-draft step needed.
- `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`.
- All 24 checks pass (`build`, `lint`, `test` on 22.x/24.x × ubuntu/macos,
  `test-xs`, `test-hermes`, `test262`, `viable-release`, `cover`, `zizmor`, …).
- Approving review by @kriskowal
  (https://github.com/endojs/endo-but-for-bots/pull/705#pullrequestreview-4802878336),
  whose single inline ask — "Does this file interfere with the npm pack
  process?" on `packages/agent-tools/src/json-tools/git-remote.d.ts` — is
  resolved: answered in
  https://github.com/endojs/endo-but-for-bots/pull/705#discussion_r3670049980
  (no, the package is `private: true` and the pack path skips it), with the
  dormant package-wide condition it surfaced recorded as
  https://github.com/endojs/endo-but-for-bots/issues/884. No code change was
  needed, so the head SHA is unchanged from the one CI validated.

Base is the live `llm` trunk, not a frozen `llm-<sha>` snapshot, so no unfreeze
is required. Re-verify green + mergeable at claim time (the PR has been open a
while and the base may have moved); rebase per the role's step 2 if behind.

Bot repo — merging is authorized. Choose the merge shape per the conductor role;
this job deliberately does not name one.
