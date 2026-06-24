---
ts: 2026-05-14T06:05:38Z
kind: message
role: boatman
project: endo
worktree: dispatches/boatman--re-ferry-syrup-frame-109--20260514-055543--1e1ee4/project
repo: endojs/endo
to: steward
refs:
  - entries/2026/05/14/055635Z-dispatch-liaison-cf8e02.md
  - entries/2026/05/13/014830Z-result-liaison-7e3b9a.md
prs:
  - repo: endojs/endo
    pr: 3256
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
---

Re-ferry of #109 -> #3256 landed at upstream `acddddba16d524c8eb16d71fb35c43f34fa491ae` (force-pushed over prior `ed80869d`). The package was renamed (`@endo/syrups` -> `@endo/syrup-frame`) since the prior ferry, and a thousands-separator chore landed; both are folded into the new squashed commit. Three identity-discipline actions on `endojs/endo` (a primary repo) belong to the steward, plus one open question to flag for the liaison.

## 1. Proposed PR #3256 title update

Current title: `feat(syrups): add @endo/syrups package (comma-less netstring variant)`

Proposed title: `feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`

The new title widens the slug to `syrup-frame` (matching the renamed package) and surfaces the opt-in netlayer framing the package enables. The source PR's current title (`feat(syrup-frame): syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`) is the model; I added the conventional `add` verb and the `for` qualifier to make the upstream title read as a finished change rather than a topic.

`gh pr edit 3256 --repo endojs/endo --title 'feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing'`

## 2. Proposed PR #3256 body update

The current body still describes the package as `@endo/syrups`, lists files, and reads as the prior pre-rename state. Replace it with the body below (which matches the new commit message, derived from the source PR's current body but cleaned of fork-only `Refs:` cross-references):

```markdown
## Description

Adds a new workspace package `@endo/syrup-frame`: a sibling of `@endo/netstring` whose framing omits the trailing `,` separator, so each framed payload on the wire is literally a Syrup byte-string record (`<length>:<payload>`). The exported surface is symmetric with `@endo/netstring`: `makeSyrupsReader` and `makeSyrupsWriter`, including the `chunked` zero-copy writer mode.

The OCapN TCP-for-testing netlayer gains an opt-in `framing` option. The default `'none'` preserves the current wire format used by the `ocapn/ocapn-test-suite` Python `testing_only_tcp` netlayer (a single syrup-encoded record per write, no length prefix). Passing `framing: 'syrups'` wraps each message in the new framing so the transport becomes robust to TCP chunk boundaries that split a single OCapN message, and two peers that both opt in share a single length-prefixed primitive with the syrup payload format itself.

### Security Considerations

The package parses untrusted byte streams. The reader rejects malformed prefixes, oversize length declarations (configurable via `maxMessageLength`, default 999_999_999), missing colon, empty prefix, and trailing characters after a complete frame. No new authority is introduced beyond the `Uint8Array` reader/writer pair the package exports. All exported factories, the inner generator, and the returned writer object are `harden()`-ed. The opt-in TCP netlayer framing does not alter the authority boundary of the netlayer; it changes only how bytes are grouped on the wire.

### Scaling Considerations

`maxMessageLength` bounds reader memory at the message granularity. The chunked writer mode avoids a prefix-plus-payload buffer copy. The netlayer framing wrapper adds one length-prefix per message and no other steady-state cost.

### Documentation Considerations

The new package's `README.md` describes the grammar, the asymmetry against `@endo/netstring`, the OCapN TCP-for-testing scope, the API, and the options. Initial-release notes ship in the package changeset. The TCP-netlayer framing option ships with its own changeset describing the opt-in. No deployed-data migration is required.

### Testing Considerations

The new package carries reader, writer, chunked-write, concurrent-write, byte-by-byte fragmentation, trailing-comma rejection, and `writer.throw` forwarding tests, run under both `lockdown` and `noop-harden` configurations. An additional netlayer test exercises a syrups-framed TCP handshake end to end against the JS netlayer.

### Compatibility Considerations

New package; no backwards-compatibility concerns. `@endo/netstring` is unmodified; existing callers are unaffected. The Endo daemon's `tcp+netstring+json+captp0` transport remains netstring-compliant. The TCP-for-testing netlayer's default framing is unchanged; the new behavior is opt-in.

### Upgrade Considerations

No upgrade action required. Initial release of a new package and an additive, opt-in option on an existing test-only netlayer.
```

`gh pr edit 3256 --repo endojs/endo --body-file <path-with-the-body-above>`.

## 3. Proposed explanatory comment on PR #3256

Brief note acknowledging the force-push to anyone who had the prior tip in their local checkout, and naming the two substantive deltas:

```
Force-pushed to incorporate two upstream-relevant updates from the source branch since the initial open:

1. Package rename: `@endo/syrups` -> `@endo/syrup-frame`. The `(syrups)` slug refers to the wire-format only; the package's job is framing, so the rename matches what the package does. Files moved from `packages/syrups/` to `packages/syrup-frame/`; `package.json` `name`, exports, README, and changeset updated to match. The opt-in netlayer option remains `framing: 'syrups'` (the wire-format name).

2. Underscores in the `maxMessageLength` default: the literal is now spelled `999_999_999` rather than `999999999`. No behavior change.

Title and body updated to match. The squashed commit's net diff against `master` is unchanged in shape (17 files, +1500/-31).
```

`gh pr comment 3256 --repo endojs/endo --body <path-with-the-comment-above>`.

## 4. Open question for liaison/user follow-up

The upstream branch is named `feat/syrups-package`. To match the renamed package it would arguably be `feat/syrup-frame-package`. Renaming the upstream branch is a destructive operation: it requires deleting `feat/syrups-package` and creating `feat/syrup-frame-package` from the same tip, which would close PR #3256 (GitHub does not retarget a PR's head branch on rename) and require opening a fresh PR. I deliberately did not do this; the existing PR has accumulated review-history weight and a forwarded reference from #109 that is worth preserving. Flag for liaison/user: leave the branch name as is, or accept a fresh PR for the renamed branch.

## Posting cadence

The title edit, body edit, and comment can all post on the steward's next cycle, in any order. The comment is the only one that fans out a notification to PR watchers; it is fine for it to land alongside or after the title/body edits.

Self-improvement: nothing this time. The pr-formation discipline (template sections verbatim, no checklists, no file callouts, behavior over diff) carried straight from the prior ferry's body shape into the renamed-package version with no rework. The rename mostly affected the package-name string in the prose, not the structure.
