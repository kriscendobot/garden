---
ts: 2026-06-03T00:20:11Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d831a0
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - https://github.com/endojs/endo-but-for-bots/pull/394#pullrequestreview-4414303711
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3345008843
  - https://github.com/endojs/endo-but-for-bots/pull/394#discussion_r3345015686
---

# dispatch: fixer — #394 address kriskowal review 4414303711 missed asks (bitwise comment + lewd hex)

User explicit ask:

> Please check your monitor for repository activity on
> endo-but-for-bots. This should have been caught
> https://github.com/endojs/endo-but-for-bots/pull/394

The steward's prior triage of kriskowal review `4414303711` (at
2026-06-02T23:35:32Z) only fetched the LAST inline comment (line
446, the Git-backed CAS architectural pivot, already journaled
as designer-scope deferral at `entries/2026/06/02/233624Z-message-
liaison-394-cas-pivot.md`). The review carried THREE inline
comments; the prior pass missed two. The user is correcting that
miss.

Pre-dispatch sweep complete:

- 2 reviews on #394; both reviewed.
- 3 inline comments on review `4414303711`:
  - `3345008843` @ `git-http-integration.test.js:98` — bitwise /
    `@endo/chacha12` ask. **In scope.**
  - `3345015686` @ `git-http-integration.test.js:414` — "Avoid
    lewd references; consider `0xb0b5c4fe`". **In scope.**
  - `3345066407` @ `git-http-integration.test.js:446` — Git-backed
    CAS architectural pivot. **Out of scope** (designer-scope
    deferral; per the prior journal note).
- 1 issue comment (the fixer's earlier ack at `4607470548`). No
  standing maintainer asks on top.

## Asks

### 1. `git-http-integration.test.js:98` (comment `3345008843`)

> We also have `@endo/chacha12` to work with. The bitwise
> prohibition may be lifted for cases that expressly call for
> bitwise arithmetic as we only need that rule to softly avoid
> logic vs bitwise operator confusion. At that, we don't need
> the rule at all since TypeScript checks will cover them more
> reliably.

Context: the prior fixer's `makeHex64` uses a multiplicative
LCG with mod-2^32 arithmetic, plus a long apologetic comment
block explaining the avoidance of bitwise. The maintainer
points out the apology isn't needed.

Two clean paths; pick one with judgment:

**Path A (light touch)**: Trim the apologetic comment block.
The LCG's modular form actually works fine — `state % 16` is
not bitwise-laden and no eslint-disable is required. Just
remove the "we use modular arithmetic instead of bitwise
operators so this module passes the project's `no-bitwise`
ESLint rule" sentence and the surrounding "this is why we
avoid bitwise" framing. Keep the LCG.

**Path B (use chacha12)**: If `@endo/chacha12` is available
in the repo and exposes a deterministic-PRNG-with-hex shape
suitable for tests, swap `makeHex64` to use it. Verify it
exists and the API fits BEFORE switching; if not, fall back
to Path A.

**Recommended: Path A.** It honors the maintainer's note
("we don't need the rule at all") with minimal diff. The
chacha12 swap is heavier and uncertain without verifying
the package's API; surface that as a follow-up if Path A
feels unsatisfying.

### 2. `git-http-integration.test.js:414` (comment `3345015686`)

> Avoid lewd references. Consider `0xb0b5c4fe`. For the
> gardener, the style guide should recommend positive
> examples, only.

Current code:

```js
const repoId = makeHex64(0xcafebabe);
const token = makeHex64(0xdeadbeef);
const wrongToken = makeHex64(0xfeedface);
```

The lewd reference is `0xcafebabe` (the "babe" connotation).
Replace with `0xb0b5c4fe` (reads as "BOBS CAFE", a positive
example — the maintainer's suggestion).

The other two (`0xdeadbeef`, `0xfeedface`) are standard
debugging / magic-number conventions; leave them or replace
with similar positive shapes if you prefer consistency. Use
judgment — the only required change is `0xcafebabe` →
`0xb0b5c4fe`.

### 3. Garden-meta follow-up (not for this dispatch)

The maintainer also said: "For the gardener, the style guide
should recommend positive examples, only." This is a
garden-meta directive about the gardener's style guide; it
calls for a separate gardener dispatch on the `kriskowal/garden`
repo, not work on #394. Journal a note in your result entry
calling out this follow-up so the steward queues it.

## Procedure

1. From `project/`, apply asks 1 and 2 to
   `packages/gateway/test/git-http-integration.test.js`.
2. Run gates locally: `yarn lint`, `yarn ava packages/gateway/
   test/git-http-integration.test.js` (or the file you edited).
3. The PR base is `design/gateway-package-phase-5` (#393); CI is
   broken at the inherited-stack level (lint + tests failing
   in `packages/ocapn` per the prior shepherd diagnosis). That
   is OUT OF SCOPE; just confirm the test you edited still
   passes locally.
4. Commit (single regular-append):
   ```
   fix(gateway): drop bitwise apology in makeHex64; replace cafebabe with b0b5c4fe (#3 review carry)
   ```
   (Adjust subject as you see fit.)
5. Push regular-append: `git push origin
   HEAD:design/gateway-package-phase-6`.
6. Reply on inline threads `3345008843` and `3345015686` per
   `pr-review-thread-replies` skill citing the new SHA. The
   architectural pivot at `3345066407` does NOT get a reply
   here (already deferred via the steward journal note).

## Per-action authorizations

- Edit `packages/gateway/test/git-http-integration.test.js`.
  Authorized.
- One regular-append commit + push to
  `endojs/endo-but-for-bots:design/gateway-package-phase-6`.
  Authorized.
- Inline-thread replies on `3345008843` and `3345015686`.
  Authorized.
- Reactji acknowledgment on the two inline comments (optional).

## Not authorized

- Touching any file under `packages/gateway/src/`.
- Touching `packages/ocapn/` or any other package (the
  inherited stack failures are out of scope here).
- Modifying the base branch (`design/gateway-package-phase-5`).
- Force-push, un-draft, re-draft, merge.
- Applying the Git-backed CAS architectural pivot from comment
  `3345066407` (designer scope; explicitly deferred).
- Editing the gardener's style guide on the garden repo (a
  separate dispatch, NOT this one).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--d831a0/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--d831a0/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`.
4. Other skills referenced just-in-time.

Project worktree at `project/` on
`design/gateway-package-phase-6` (head `b22e0db66`).

## Report

A `result` journal entry. Include:

- New head SHA after push.
- Diff summary (which lines/blocks changed in the test file).
- Local `yarn lint` + `yarn ava` exit codes for the test file.
- Inline-thread reply IDs.
- Note on whether you chose Path A or Path B for ask 1, and
  why.
- Reactji actions taken.
- The garden-meta style-guide follow-up call-out (so the
  steward can queue it).
