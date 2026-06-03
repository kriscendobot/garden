---
ts: 2026-06-03T17:31:44Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--8f3bda
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 369
    role: source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3350596749
  - https://github.com/endojs/endo-but-for-bots/pull/369
---

# dispatch: fixer — #394 apply git-backed CAS spike (#369) discoveries

Maintainer @-mention on #394 (kriskowal, comment `3350596749`,
2026-06-03T17:30:18Z, on `packages/gateway/test/git-http-integration.test.js`):

> @kriscendobot Please take a look at the spike for git-backed
> CAS and apply discoveries here.

The "spike" is endo-but-for-bots#369 (`SPIKE docs(daemon):
draft daemon-git-backbone substrate-swap design`) by
`0xpatrickbot`, branch `pc-daemon-git-backbone`, base `llm`.
Five files; key artifact is `designs/daemon-git-backbone.md`.
The Rust side: `rust/endo/src/cas.rs` and Cargo files.

#369's body (verbatim):

> Backs the Rust `endor` daemon's content-addressed store
> (`rust/endo/src/cas.rs`) with git, sha256-keyed, replacing
> its hand-rolled flat-dir object store and in-memory refcount
> GC. The crux is **garbage collection**: with content as git
> objects and retention roots as git refs, GC reduces to git's
> own reachability, giving the CAS the durable, crash-safe
> live set it lacks today.
>
> Adds the design `designs/daemon-git-backbone.md` (four axes,
> all backed by git) and lands the first two.
>
> **The four axes** ... (full text in #369 body)

#394 head: `119d21f45` (the contractor's recent CAS pivot
landing one-repo-per-daemon + bearer-as-formula-ref shape per
kriskowal's earlier #394 review at `4414303711`). The
maintainer's new directive is to fold spike discoveries into
this work.

## Pre-dispatch sweep

The maintainer's recent review on #394 (`4414303711`,
2026-06-02T23:35:32Z) initially proposed the Git-backed CAS
pivot. The contractor's fixer landed it at `119d21f45`. The
spike #369 is a separate, deeper exploration of the same
pattern on the Rust daemon side. The directive is to bring
the spike's findings BACK into #394.

Note: the spike PR's design is the source-of-truth document.
The application here may be:
- Code changes to gateway-side CAS shape to match spike
  findings.
- Design-doc additions/cross-references on #394 if spike
  introduces concepts the gateway design should adopt.
- Test additions to verify properties the spike identifies.
- Or some combination.

Use judgment.

## Procedure

1. **Read `designs/daemon-git-backbone.md`** end-to-end from
   the #369 worktree. Take notes on the four axes, the GC-via-
   reachability shape, and the sha256 key choice.
   - Fetch: `git fetch origin pc-daemon-git-backbone` and
     check out / read the file from there.
   - Alternative: clone `0xpatrickbot/endo` fork if needed.
2. **Read `rust/endo/src/cas.rs`** from #369 to understand
   the Rust-side implementation.
3. **Survey #394's current state** at head `119d21f45`. The
   contractor's CAS pivot commit landed the one-repo-per-
   daemon, bearer-as-formula-ref shape. What's there? What's
   missing relative to the spike's four axes?
4. **Identify the discoveries to apply**. Map each axis from
   the spike to a #394-applicable change. The two axes the
   spike LANDED are higher priority than the two it didn't.
5. **Apply**. Either:
   - Code changes to `packages/gateway/src/`.
   - Test additions to `packages/gateway/test/`.
   - Design-doc additions/cross-references in
     `designs/gateway-package.md` or similar.
   - Or a combination.
6. **Run gates locally**: `yarn lint`, `yarn ava` on touched
   tests, `yarn lint:types`.
7. **Commit** (one or more, regular append; no force):
   ```
   feat(gateway): apply git-backbone-spike (#369) discoveries: <one-line summary>
   ```
8. **Push**: `git push origin HEAD:design/gateway-package-phase-6`.
9. **Post a top-level PR comment** on #394 summarizing what
   was applied from the spike + what was deferred + reason.
10. **Reply to the inline thread `3350596749`** with a brief
    "Applied at <new SHA>; details in top-level comment."

## Per-action authorizations

- Read #369's files (any path). Authorized.
- Edit files under `packages/gateway/` and `designs/`
  (only gateway-related design docs). Authorized.
- One or more regular-append commits + push to
  `endojs/endo-but-for-bots:design/gateway-package-phase-6`.
  Authorized.
- Top-level PR comment + inline reply on #394. Authorized.

## Not authorized

- Modifying `rust/endo/` (the spike's own scope).
- Modifying any non-gateway package source.
- Force-pushing.
- Touching the spike PR #369 itself.
- Un-drafting / re-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--8f3bda/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--8f3bda/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md` (for the
   inline reply).
4. Other skills referenced just-in-time.

Project worktree at `project/` on
`design/gateway-package-phase-6` (refetch — head should be
`119d21f45`).

## Report

A `result` journal entry. Include:

- Pre-application head SHA + post-application head SHA.
- Per-axis verdict: applied / partial / deferred (with one-
  line reason for each).
- Files touched and what changed.
- Local gate exit codes.
- Top-level comment ID.
- Inline reply ID.
- Any judgment calls (especially: which axes are
  gateway-applicable vs Rust-only).
