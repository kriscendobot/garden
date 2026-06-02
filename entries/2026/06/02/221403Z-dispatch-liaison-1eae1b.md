---
ts: 2026-06-02T22:14:03Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--1eae1b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - https://github.com/endojs/endo-but-for-bots/pull/394#pullrequestreview-4413543939
---

# dispatch: fixer — #394 add git-CLI integration test for Gateway smart-HTTP

User explicit ask:

> Please dispatch a subagent to respond to
> https://github.com/endojs/endo-but-for-bots/pull/394#pullrequestreview-4413543939
> if not already in flight.

PR endojs/endo-but-for-bots#394 is kriscendobot DRAFT (Phase 6 of the
Endo Gateway stack). Adds the `GitHttpHandler` exo + unit tests +
`makeGateway` wiring. Base is `design/gateway-package-phase-5` (#393),
NOT master — this PR is stacked.

kriskowal review `4413543939` (CHANGES_REQUESTED, 2026-06-02T20:53:21Z)
body, verbatim:

> Please add an integration test that uses the `git` CLI to push and
> pull refs, with a bearer token, to an ephemeral Gateway service.

Pre-dispatch sweep done (per memory
`feedback_sweep_mirror_pr_before_carry_dispatch.md`):

- 1 review on #394 (this one).
- 0 issue comments.
- 0 other inline comments.

Only one ask. No standing maintainer items to fold in.

## Scope

Add ONE integration test that:

1. Spawns a real Gateway HTTP server on an ephemeral TCP port (e.g.
   `http.createServer(handler).listen(0)`; read the assigned port
   from `server.address().port`).
2. Wires `makeGateway({...})` with a `resolveRepo` that returns a
   repo capability backed by a real on-disk Git repo (under a tmp
   directory created by Node's `fs.mkdtemp` / `os.tmpdir()`).
3. Generates a formula-identifier-shaped repo-id (64-char lowercase
   hex) and a bearer token (also 64-char lowercase hex per
   `daemon-256-bit-identifiers.md`) and threads them through the
   `resolveRepo` adapter.
4. Spawns the real `git` CLI (`child_process.spawn('git', ...)`)
   with an HTTP remote URL of the form
   `http://127.0.0.1:<port>/git/<repo-id>/` and supplies the bearer
   via `http.extraHeader=Authorization: bearer <token>` *or* the
   git-credential helper that emits the empty-user Basic form. Both
   schemes are documented as accepted in `src/git-http.js`; use
   whichever is easier to wire in the test.
5. Asserts that a `git push` succeeds and that a subsequent
   `git pull` from a second clone retrieves the pushed ref.

The integration test belongs in either `packages/gateway/test/git-http.test.js`
(extending the existing file) or a new
`packages/gateway/test/git-http-integration.test.js`. Use your
judgment on file placement. Use ava (the framework already in use).

If the test requires the `git` CLI binary, gate it with the standard
ava-skip pattern when not available so CI does not break on
git-less environments. (CI runners always have git; local dev may
not. Check `which git` and `test.skip` if unavailable.)

## Repo-capability shape

The existing `src/git-http.js` is the authoritative reference for
what `resolveRepo` must return. Skim the JSDoc near `ResolveRepo`
and the call sites to understand the contract. The test can use a
simple in-process `node:child_process.spawnSync('git', ['init',
'--bare', repoDir])`-backed adapter that returns a handler
forwarding smart-HTTP RPCs into the real git's `git http-backend`
CGI binary (the canonical server-side smart-HTTP implementation).

A clean shape:

```
const repoDir = await mkdtemp(join(tmpdir(), 'gw-git-'));
await spawn('git', ['init', '--bare', repoDir]).done;
const resolveRepo = async ({ repoId, token }) => {
  if (repoId === expectedRepoId && token === expectedToken) {
    return makeFsBackedRepoCapability({ repoDir });
  }
  return undefined;
};
```

…where `makeFsBackedRepoCapability` shells out to `git
http-backend` per request. This is the standard pattern for testing
smart-HTTP servers.

## Out of scope for this dispatch

- DO NOT apply the stack-wide directive from kriskowal's #393 review
  ("Typedefs in types.d.ts; Uint8Array as sole unit of transmission
  for bytes; apply to this stack top to bottom"). That's a separate
  decision and a separate dispatch — the user did not authorize it
  here. If you encounter places where the existing code uses
  strings-as-bytes that the directive would touch, leave them; just
  add the test.
- DO NOT modify `src/git-http.js` itself (kriskowal asked for a
  test, not implementation changes).
- DO NOT modify the base branch (`design/gateway-package-phase-5`,
  #393). The integration test is purely additive on #394.

## Procedure

1. From `project/`, sketch the integration test in
   `packages/gateway/test/git-http-integration.test.js` (new file)
   or extend `git-http.test.js` (existing file) per your judgment.
2. Run it locally: `yarn ava packages/gateway/test/git-http-integration.test.js`
   (or whichever file you used). Iterate until green.
3. Commit:
   ```
   git commit -m "test(gateway): git-CLI smart-HTTP push/pull integration with bearer auth"
   ```
   (Adjust if you put the test in the existing file rather than a
   new one.)
4. Push regular-append: `git push origin
   HEAD:design/gateway-package-phase-6`.
5. Post a top-level reply on the PR (issue-comment) acknowledging
   the addition with the new test path and commit SHA. Use the
   `pr-review-thread-replies` skill OR a plain `gh pr comment` —
   the review body has no inline anchor (review state
   CHANGES_REQUESTED on the PR top-level), so an issue-comment
   reply is the correct shape.

## Per-action authorizations

- Create new test file or extend existing test file. Authorized.
- Spawn `git`, `mkdtemp`, ephemeral TCP listen during local test
  run. Authorized.
- One commit + regular append push to
  `endojs/endo-but-for-bots:design/gateway-package-phase-6`.
  Authorized.
- Top-level PR comment on #394. Authorized.

## Not authorized

- Editing `src/git-http.js` or any non-test source.
- Editing `design/gateway-package-phase-5` (#393's branch).
- Force-push, un-draft, re-draft, merge.
- Applying the stack-wide Uint8Array/types.d.ts directive.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--1eae1b/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--1eae1b/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md` (or just use
   `gh pr comment` — see Procedure step 5).

Project worktree at `project/` on `design/gateway-package-phase-6`
(head `b15126d72`). Base is `design/gateway-package-phase-5`.

## Report

A `result` journal entry. Include:

- New head SHA after push.
- Test file path (new or extended).
- Local `yarn ava` exit code + test count for the new test(s).
- Top-level comment ID on PR #394.
- A note on which auth scheme (Bearer vs Basic) the test exercises
  and why.
