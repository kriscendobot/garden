---
ts: 2026-06-04T00:16:16Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--091a1a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/418
  - https://github.com/endojs/endo-but-for-bots/pull/418#discussion_r3352662259
---

# dispatch: fixer — #418 inject evasive parsers from Node-specific layer (worker.js stays platform-agnostic)

Maintainer review `4423692346` (CHANGES_REQUESTED), single
inline at `packages/daemon/src/worker.js:1` (comment
`3352662259`):

> The evasive transforms are Node.js platform-specific. We
> should inject the parsers in `worker-node.js`, possibly
> from `worker-node-powers.js`, so that `worker.js` remains
> platform-agnostic and does not entrain Babel on platforms
> that do not use it. To that end, we need validation from
> the Rust side that it has not regressed due to this change.

Pre-dispatch sweep: 1 inline comment tied to this review, no
other unaddressed asks (per memory rule
`feedback_fetch_all_inline_comments_per_review.md`).

## Target

- PR: endojs/endo-but-for-bots#418
- Branch: `fix/endo-make-node-evasive-runtime`
- Head: `1bbf703d7`
- Base: `llm-720a396`
- State: DRAFT
- Title: `fix(daemon): apply evasive transform at runtime in
  Node worker (regressed in ZIP-pivot)`

## Required refactor

1. Read `packages/daemon/src/worker.js` to identify where
   evasive-transform parsers are currently wired.
2. Read `packages/daemon/src/worker-node.js` and
   `packages/daemon/src/worker-node-powers.js` to understand
   the Node-specific injection seam.
3. Move parser construction / wiring from `worker.js`
   (platform-agnostic) to `worker-node.js` /
   `worker-node-powers.js` (Node-specific).
4. `worker.js` accepts the parsers as injected dependencies
   (a power, a constructor argument, etc.); does NOT import
   Babel directly.
5. Verify the diff: `worker.js` should no longer reference
   `@babel/*` packages.
6. Run gates: `yarn workspace @endo/daemon lint`,
   `lint:types`, `ava` on relevant tests.

## Rust-side validation

The maintainer asks for Rust-side validation. The bot may not
have a Rust toolchain readily available. Options:

- **A** (in-scope if feasible): run `cargo test` in
  `rust/endo/` or equivalent. Report results.
- **B** (defer with note): Rust toolchain not available;
  note this in the result + reply on the inline thread.
  Maintainer can verify locally with `cargo test` or hand
  off to the Rust-credentialed verifier.

Use judgment based on toolchain availability.

## Procedure

1. Investigate the seam shape (worker.js + worker-node.js +
   worker-node-powers.js).
2. Refactor: move parser injection out of worker.js into the
   Node-specific layer.
3. Run local gates (Node side).
4. Attempt Rust-side validation (A) or defer (B).
5. Commit (regular append):
   ```
   refactor(daemon): inject evasive-transform parsers from worker-node-powers (keeps worker.js platform-agnostic)
   ```
6. Push to `fix/endo-make-node-evasive-runtime`.
7. Reply on inline thread `3352662259` with new SHA + brief
   summary of the refactor + Rust-validation status (option
   A result OR option B deferral).

## Per-action authorizations

- Edit `packages/daemon/src/worker.js`,
  `packages/daemon/src/worker-node.js`,
  `packages/daemon/src/worker-node-powers.js`. Authorized.
- Add tests or test edits in `packages/daemon/test/` if the
  refactor needs them. Authorized.
- One regular-append commit + push. Authorized.
- Reply on inline thread `3352662259`. Authorized.

## Not authorized

- Editing any package other than `packages/daemon/`.
- Touching `rust/endo/` source (the maintainer asks for
  VALIDATION, not modification).
- Force-pushing.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--091a1a/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--091a1a/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. Other skills referenced just-in-time.

Project worktree at `project/` on `fix/endo-make-node-evasive-runtime`
(head `1bbf703d7`).

## Report

A `result` journal entry. Include:

- Pre-refactor seam shape (one paragraph).
- Post-refactor seam shape (one paragraph).
- New head SHA + commit message.
- Local gate exit codes (Node side).
- Rust-validation: option A (with results) OR option B
  (deferred with reason).
- Inline-thread reply ID.
- Any judgment calls.
