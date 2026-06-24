---
ts: 2026-06-02T22:46:51Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d83076
prs:
  - repo: endojs/endo-but-for-bots
    pr: 388
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/388
  - https://github.com/endojs/endo-but-for-bots/pull/388#pullrequestreview-4413566645
---

# dispatch: fixer — #388 carry kriskowal review (scope-bounded: in-PR items only)

User explicit ask:

> Please dispatch a subagent to respond to
> https://github.com/endojs/endo-but-for-bots/pull/388 if not yet
> already in flight.

PR endojs/endo-but-for-bots#388 is kriscendobot DRAFT (Phase 2 of the
Endo Gateway stack: UDS bootstrap registrar + proof-of-possession).
Base is `design/gateway-package`, head `f8d1d223b`. Two-commit shape
(impl + yarn.lock).

kriskowal review `4413566645` (CHANGES_REQUESTED, 2026-06-02T21:17:56Z)
has 1 top-level body comment + 14 inline asks. Some asks are stack-wide
or cross-package and need maintainer-engaged scoping; others are
concrete in-PR fixes the fixer can land in one commit. This dispatch
delineates which is which.

Pre-dispatch sweep done: 1 review on #388 (this one); 0 issue
comments; 14 inline comments all belonging to this review. No
older standing asks to fold in.

## In-scope items (apply in one commit)

### 1. Delete the changeset (inline `3344371101`)

> No changesets needed on changes destined for the llm branch.

Delete `.changeset/endo-gateway-bootstrap-registrar.md`.

### 2. Tighten typedef to `Uint8Array<ArrayBuffer>` (inline `3344380292`, bootstrap.js:129)

Apply locally on the single line. Do NOT widen this into a
stack-wide Uint8Array refactor — see Deferred § below.

### 3. Rename `checkBytes` → `checkBytesLength` (inline `3344387661`, bootstrap.js:175)

Function is at `bootstrap.js:175` (`const checkBytes = (candidate,
fieldName, expectedLength) => {`); three call sites at lines 199,
206, 213 (`publicKey`, `signature`, `nonce` respectively). The
maintainer's note "Applies to methods below, as well" suggests the
rename naturally extends to any other check-style helpers — there's
just the one here, so rename it and proceed.

### 4. Rename `listRegistrations` → `listRegisteredPeers` (inline `3344408499`, bootstrap.js:552)

Rename touches:
- `packages/gateway/src/bootstrap.js` (definition at line 537;
  typedef at line 318; harden({}) export at line 560; comment ref
  at line 469)
- `packages/gateway/test/bootstrap.test.js` (3 call sites at 244,
  463, 472)

### 5. RangeError coverage check (inline `3344457685`, node-crypto-powers.js:155)

> Are we sure that this covers all emissible classes of error for
> the try block? RangeError can occur at any time for OOM.

Inspect the try block at lines ~135-160 around `verify(...)`. The
catch returns `false`. Verify whether RangeError (OOM) gets the
same false-return treatment or whether it propagates. If
RangeError currently propagates and should not, broaden the catch.
If it's already covered, leave a one-line comment confirming.

Apply judgment; if unsure, leave the code as-is and post a thread
reply noting your verification (no code change).

### 6. Use `@endo/hex` (inline `3344462878`, proof-of-possession.js:194)

The local `toHex` helper at line 197 manually encodes bytes →
lowercase hex. `packages/hex/` exists and exports `encode` /
`decode`. Replace `toHex(bytes)` calls with the `@endo/hex` import.

Add `@endo/hex` to `packages/gateway/package.json` dependencies and
update yarn.lock via `corepack yarn install` (the lockfile commit
is separate per repo convention).

### 7. Early-break in nonce sweep (inline `3344469336`, proof-of-possession.js:296)

> We can rely on insertion order and monotonically increasing time
> for the map, so can break early.

The `sweep()` function at line 290 iterates `pending` and deletes
expired entries. Since entries are inserted with monotonically
increasing `expiresAt`, the first entry whose `expiresAt > now`
means all subsequent entries are also unexpired — `break` rather
than continuing the scan.

## Deferred items (post a top-level PR comment explaining)

Post a top-level PR comment on #388 (issue-comment via `gh pr
comment`, not a thread reply since the body has no anchor) with the
following deferral list. Each deferred item names what was asked
and why it's not applied in this dispatch.

### D1. Top-level body — UDS → "sock" rename (stack-wide)

> Let's avoid the initialism UDS, preferring "sock". The "sock" may
> either be implemented as a UNIX domain socket or Windows named
> pipe depending on the platform, as with the Endo Daemon.

Defer reason: the rename spans `uds-paths.js` (filename + content),
docs/strings throughout the module, and consistency with the rest
of the gateway stack (#389 / #392 / #393 / #394 / #403 also use
the UDS naming). Stack-wide rename should be a single coordinated
PR per phase or one cross-phase pass. Note that `packages/where/`
already has `where-endo-sock.test.js` indicating "sock" is the
established convention in the repo — supports the rename, but the
scope crosses this PR.

### D2. `bootstrap.js:122` typedefs → `types.d.ts` (inline `3344377619`)

> Generally prefer to implement typedefs in `types.d.ts`. Please
> dispatch a message to the gardener and/or a builder to improve
> the style guide.

Defer reason: stack-wide convention shift; same directive applies
to #393's stack-wide review ("Typedefs go in `types.d.ts`. Use
Uint8Array as the sole unit of transmission for bytes."). Wants
coordinated handling. The gardener-message portion ("dispatch a
message to the gardener and/or a builder to improve the style
guide") is garden-meta work that the steward will queue separately.

### D3. `bootstrap.js:262` Uint8Array as interface lingua franca (inline `3344394317`)

Same as D2: stack-wide Uint8Array directive.

### D4. `bootstrap.js:427` `cancelled` promise pattern (inline `3344403912`)

> Consider using the `cancelled` promise pattern and obliging a
> daemon to maintain a CapTP connection for the lifetime of their
> registration. That way, a detached CapTP connection will
> automatically collect itself.

Defer reason: architectural lifecycle change; substantial. Should
land in a focused commit (separate from this multi-asks fix) so
the change is reviewable on its own.

### D5. `node-crypto-powers.js:61` "not necessary if Uint8Array lingua franca" (inline `3344448440`)

Defer reason: depends on D3 (Uint8Array lingua franca).

### D6. `proof-of-possession.js:227` consolidate into `@endo/bytes/constant-time-equals.js` (inline `3344465380`)

Defer reason: `@endo/bytes/constant-time-equals.js` does not yet
exist in this repo (`packages/bytes/` has `equals.js`, not the
constant-time variant). Consuming the file requires first creating
it in `@endo/bytes`, which is a cross-package addition outside the
scope of this PR. Once the file lands in `@endo/bytes`, the local
`constantTimeEqual` here can be replaced with the import.

### D7. `uds-paths.js:84` typedefs + carve-juror + scripted-skill (inline `3344477615`)

> Again about using `types.d.ts` instead of typedefs. Remember to
> use `@import`. Dispatch gardener to carve out a juror for this
> verification. Consider creating a scripted skill that looks for
> occurrences of `@typedef`.

Defer reason: same as D2 (stack-wide) + garden-meta (juror carving
+ scripted skill creation).

### D8. `uds-paths.js:1` fold into `@endo/where` (inline `3344480610`)

> Fold this into `@endo/where`.

Defer reason: cross-package refactor; `@endo/where` already has
sock-related tests (`where-endo-sock.test.js`) suggesting a place
for it, but the move spans two packages and requires coordinating
exports and `package.json` deps. Substantial; deserves a focused
PR.

## Procedure

1. From `project/`, apply In-scope items 1-7 above.
2. Run gates locally: `corepack yarn install`, `yarn lint`,
   `yarn ava packages/gateway/test/bootstrap.test.js`, etc.
3. Commit (one impl commit + one yarn.lock commit if yarn.lock
   moved):
   ```
   fix(gateway): apply @endo/hex, rename helpers, early-break nonce sweep
   ```
   …adjust subject as needed. Keep `chore: Update yarn.lock` as
   separate commit if applicable (repo convention).
4. Push regular-append: `git push origin
   HEAD:design/gateway-package-phase-2`.
5. Post a top-level PR comment on #388 listing what landed and the
   D1-D8 deferral reasons. Use `gh pr comment 388 --repo
   endojs/endo-but-for-bots --body-file <(...)`.
6. Optionally react with eyes/+1 on each inline comment via the
   `reactji-acknowledgment` skill (signals "saw it" for the
   deferred items).

## Per-action authorizations

- Delete `.changeset/endo-gateway-bootstrap-registrar.md`. Authorized.
- Edit `packages/gateway/src/bootstrap.js`,
  `packages/gateway/src/proof-of-possession.js`,
  `packages/gateway/src/node-crypto-powers.js`,
  `packages/gateway/test/bootstrap.test.js`. Authorized.
- Edit `packages/gateway/package.json` to add `@endo/hex` dep.
  Authorized.
- `corepack yarn install` for lockfile update. Authorized.
- One impl commit + one yarn.lock commit (separate) + regular-append
  push to `endojs/endo-but-for-bots:design/gateway-package-phase-2`.
  Authorized.
- Top-level PR comment on #388. Authorized.
- Reactji on inline comments. Optional.

## Not authorized

- Modifying any file under `packages/` other than `packages/gateway/`
  (no cross-package work in this dispatch).
- Renaming `uds-paths.js` or any UDS→sock content change (D1).
- Moving typedefs to types.d.ts (D2/D7).
- Stack-wide Uint8Array refactor beyond the single-line item 2
  (D3/D5).
- `cancelled` promise pattern application (D4).
- Creating `@endo/bytes/constant-time-equals.js` (D6).
- Folding `uds-paths.js` into `@endo/where` (D8).
- Dispatching the gardener or any other agent (steward decision).
- Un-drafting, re-drafting, force-pushing, or merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--d83076/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--d83076/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md` (optional;
   top-level comment via `gh pr comment` is also fine).
4. `garden/skills/reactji-acknowledgment/SKILL.md` (optional).

Project worktree at `project/` on `design/gateway-package-phase-2`
(head `f8d1d223b`). Base is `design/gateway-package`.

## Report

A `result` journal entry. Include:

- New head SHA after push.
- One-line summary per applied item (1-7) noting what changed.
- Local gate exit codes (`yarn lint`, `yarn ava` for gateway tests).
- Top-level PR comment ID.
- Reactji actions taken.
- Anything you decided to defer beyond the explicit D1-D8 with
  reason (e.g., if item 5 RangeError investigation lands on "leave
  as-is + post a thread reply").
