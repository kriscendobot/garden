---
ts: 2026-05-29T13:21:30Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--af3bda
prs:
  - repo: endojs/endo-but-for-bots
    pr: 377
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/377#issuecomment-4571432
  - entries/2026/05/29/054559Z-result-fixer-bc7a55.md
  - entries/2026/05/29/111830Z-tick-steward-a7b8c9.md
---

# dispatch: fixer — respond to maintainer feedback on #377 (esvu retry strategy)

Maintainer kriskowal commented on PR #377 at 2026-05-29T13:20:27Z:

> This appears to have been insufficient. How do we know that the flakes
> are intermittent? Do we have an expectation that a fast retry loop will
> not make the situation worse? Should we use a back-off strategy? Can
> we lean harder into caching?

This is real maintainer feedback on the steward-owned DRAFT mirror of
endojs/endo#3291. Per `roles/steward/AGENT.md` § Maintainer-feedback
response, source-touching feedback routes to the fixer.

## Context

PR #377 mirrors endojs/endo#3291: a single-file shell-script change to
`packages/benchmark/install-engines.sh` that wraps each
`yarn dlx esvu install <engine>` call in a 3-attempt retry with a 5s
sleep between attempts.

The PR's CI confirmed (steward cycle 21, tick `111830Z-tick-steward-a7b8c9`)
that the retry mechanism *is* firing in the CI log — `esvu install xs
attempt 1/3 failed`, `attempt 2/3 failed`, then progressing to V8 with the
same pattern. Both XS and V8 exhausted all 3 attempts. The breakage looks
deeper than retries can rescue (the `Extracting /tmp/esvu-...zip` step
seems to be where the install fails — possibly a download from moddable's
release server is corrupt, or the extraction is hitting a runner-side
issue).

## Task

Address each of the maintainer's four questions on the same comment
thread, and adjust the patch if the investigation supports it:

1. **"How do we know that the flakes are intermittent?"**
   Gather evidence: pull the most recent ~10 test-xs job runs across
   open PRs (#377, #79, #375 if applicable, and any historical runs on
   master). Tabulate the failure shape — is it always
   `esvu ✖ Some engines were not installed` on the
   `Extracting /tmp/esvu-...zip` step? Always both engines? Always the
   same engine first? Are some runs passing? If most runs pass and only
   some fail (intermittent), the current retry-on-failure approach is
   the right shape. If every recent run fails (systemic), the fix in
   the PR is the wrong tool entirely.

2. **"Do we have an expectation that a fast retry loop will not make
   the situation worse?"**
   Consider the failure modes: if the upstream is rate-limiting (GitHub
   releases, moddable's S3 bucket), a fast retry loop *would* make it
   worse — hitting the same rate limit again immediately. If it's
   transient TCP/CDN, the fast retry should work. The current code
   sleeps 5s between attempts; whether that's adequate depends on the
   underlying failure mode (question 1).

3. **"Should we use a back-off strategy?"**
   Exponential backoff (5s, 10s, 20s) would address rate-limit cases.
   Consider whether the PR should be revised to use exponential or
   capped-exponential backoff instead of constant 5s.

4. **"Can we lean harder into caching?"**
   The esvu downloads land in a per-runner temp dir (`/tmp/esvu-...`).
   GitHub Actions supports `actions/cache@v4` keyed on engine version.
   If we cache `~/.esvu` or wherever esvu installs to, after one
   successful run the binary persists across job invocations on the
   same runner. Consider whether the PR scope should be widened to add
   caching, or whether that's a follow-up.

## Procedure

1. **Investigate first**. Gather the CI evidence (recent runs across
   PRs, failure shape, whether the failure is the same step every
   time). Read the existing `install-engines.sh` script's retry shape
   to understand exactly what's wrapped and what isn't.
2. **Decide the response shape**. Either:
   - (a) The investigation supports an adjustment to the patch (e.g.,
     exponential backoff, longer initial sleep, or scope-widen to
     include caching). Push a refined commit and explain the change in
     the reply.
   - (b) The investigation supports the current patch (intermittent
     flake, current backoff is adequate, caching is a separable
     concern). Reply explaining why, citing evidence.
   - (c) Mixed: respond to each question individually, possibly with
     small patch revisions for parts and explanations for others.
3. **Reply to the maintainer's comment** on issue thread at
   https://github.com/endojs/endo-but-for-bots/pull/377#issuecomment-4571432
   per `garden/skills/pr-review-thread-replies/SKILL.md` (top-level
   issue comment reply, not an inline review thread). Each of the
   four questions should be addressed.
4. **If a code change is part of the response**, push to the PR
   branch (`fix-benchmark-install-engines-retry`) and mention the
   new head SHA in the reply. The bot has direct push access.

## Per-action authorizations (forwarded)

- Reading CI logs across recent PRs / runs. Authorized.
- Push refined commit(s) to
  `endojs/endo-but-for-bots:fix-benchmark-install-engines-retry` under
  bot identity, if the investigation supports a patch revision.
  Authorized.
- Top-level issue-comment reply on PR #377 addressing the maintainer.
  Authorized.

## Not authorized

- Modifying `endojs/endo#3291` itself (that's upstream; if the
  investigation surfaces an upstream-relevant point, surface to the
  steward as a candidate boatman dispatch on the appropriate host).
- Un-drafting PR #377 (judge's call on chain termination).
- Force-pushing to `master`.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--af3bda/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--af3bda/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. `garden/skills/review-feedback-followup-commits/SKILL.md`
5. `garden/skills/pr-ci-watch/SKILL.md` (for investigating CI history).
6. Other skills the fixer role names just-in-time.

Project worktree starts at `project/` on
`fix-benchmark-install-engines-retry` (detached HEAD at `f43996e07`).

## Report

A `result` journal entry. Include: investigation findings (CI evidence
summary), the disposition for each of the four maintainer questions,
new head SHA if a commit was pushed, the comment ID of the reply on
issue thread.
