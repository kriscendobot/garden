---
role: fixer
tier: mentor
fallback-tier: minion
pr: https://github.com/kriscendobot/minion.town/pull/146
dispatch: automatic
---

# Fix kriscendobot/minion.town PR #146: depend on upstream @endo/cancel, drop the vendored TS port

Source: kriskowal CHANGES_REQUESTED review
https://github.com/kriscendobot/minion.town/pull/146#pullrequestreview-5387502389
- Review body: "I would rather convert this to JavaScript than to duplicate every
  JavaScript dependency to make it amenable to TS."
- Inline on `src/endo/cancel-kit.ts:1`: "Just use the upstream JavaScript. If it is
  not sufficient as a TS dep, make it sufficient."

Directive: delete the vendored TypeScript port `src/endo/cancel-kit.ts` (and its
port-specific test `test/endo-cancel-kit.test.ts`), and import `makeCancelKit`
from the upstream `@endo/cancel` package instead. Never re-port an upstream
JS dependency into TS in this repo.

Steps:
1. `@endo/cancel` (endojs/endo-but-for-bots, branch `llm`, `packages/cancel`) is
   not on npmjs.com or npm.minion.town yet. Publish it — with its unpublished
   `@endo/*` closure (`@endo/errors`, `@endo/harden`, … at the same immutable
   commit) — to `npm.minion.town` under a dev version/tag, following
   minion.town `deploy/aws/npm-registry/README.md` § Publishing and installing
   and § Publishing pitfalls (`workspace:` ranges must be rewritten; use
   `yarn npm publish` or rewrite to exact staged versions; publish the whole
   closure). If you lack the publisher credential on this host, message the
   maintainer via message-user.sh rather than vendoring.
2. Add `@endo/cancel` at that exact dev version to minion.town `package.json`
   (+ lockfile, separate commit if lockfile conventions require), configure
   the `@endo` scope registry if consumers need it, and switch
   `src/endo/claude/agents.ts` to `import { makeCancelKit } from "@endo/cancel"`.
3. If `npm run typecheck` fails because the upstream package's types are
   insufficient for a TS consumer (e.g. `types-index.types.d.ts` /
   generated `.d.ts` missing from the packed tarball), FIX IT UPSTREAM in
   endojs/endo-but-for-bots (`packages/cancel` on a PR against `llm`/its frozen
   base), republish, and consume that — do not paper over it with a local
   `.d.ts` shim or a TS copy.
4. Keep the behavior tests in `test/claude-delegation*.test.ts`; drop tests that
   only exercised the vendored port. `npm run typecheck` and `npm test` green
   (the known pre-existing `git-remote/capability` failure aside).
5. Update the PR description (remove the "vendored TypeScript port" section;
   state the published version), push review-feedback follow-up commits with
   `scripts/jobs/gardening/safe-push-pr-head.sh`, and reply to the inline
   thread with the commit SHA(s).

Note: gauntlet `minion-town-pr140-endo-cancel-gauntlet` has a fix-2 stage
queued for panel nits on the vendored file; those become moot once it is
deleted.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T16:53:29Z
