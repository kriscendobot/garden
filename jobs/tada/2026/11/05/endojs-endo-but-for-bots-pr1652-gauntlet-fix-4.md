## Completion report: FIX round 4 for endojs/endo-but-for-bots#1652

I applied the must-fix items from panel-4's latest review to the PR head (`design/unified-virtual-filesystem`) in one commit, `d8363fa2a7`, and pushed it with `safe-push-pr-head.sh` (4ca7b3319c → d8363fa2a7). CI came back green: `ci-wait-merge.sh` returned 0 with 31 of 31 checks done and none failed.

The job had no pre-pass block, so the findings came from review 5783851291, headed "Must-fix before merge". All edits are in `designs/unified-virtual-filesystem.md`:

- **Locator signatures (critic, and skeptic on rung 9):**
  - The version-1 locator layout now has a 32-byte `peerKey` field, and the signature covers it.
  - A validator must check that `peerKey` matches the URL host of the locator, which is already the peer's hex key in the existing format (`packages/daemon/src/locator.js`).
  - I added a key-binding flow for export. A peer signs its own references. A reference hosted by another peer is written only if it carries that peer's signature; otherwise export throws a new `LOCATOR_UNSIGNED` error.
  - Rung 9 now covers only references hosted by the exporting peer. A new rung 9b, with a cross-peer round-trip test, waits on the design of the remote signing method. The open question is reworded to match.
- **Revocation and `Value` children (skeptic):** a controlled or revocable view now refuses to return a `Value` child that holds a capability, throwing a new `VALUE_WITHHELD` error. A minter can opt in with `{ values: 'share' }`, and the doc now says revocation does not reach a capability already handed out that way. I added a retain-then-revoke test and a withheld-child test.
- **Symlink race (skeptic):** native path resolution must now open each segment relative to the parent directory's descriptor without following symlinks (`openat`/`O_NOFOLLOW`, `openat2`/`RESOLVE_BENEATH`, or equivalent). Checking a path and then opening it by name is forbidden. A host with no such primitive must refuse symlinks under the root. I added a conformance test for a symlink swapped in mid-resolution.
- **`Snapshot` versus `capture()` (decomplector):** `capture()` now returns a separate `Capture` type with its own `equivalent` and a `snapshot()` method. Mutators' `expected` and `Snapshot.equivalent` accept only a `Snapshot`. I updated the view-algebra laws, the comparison text and the conformance tests to match.
- **Ambiguous lookup (ergonomist):** binding `undefined` is now forbidden, so `maybeLookup` returning `undefined` always means the name is absent.
- **Readability (novice):**
  - The builder example now explains that a controlled view is rooted at `src` before it calls `c.lookup(['main.js'])`.
  - A new table separates the two signatures (locator file vs. manifest). Another shows what each restore mode checks, installs and may resolve.
- **Formatting and copyedits (pedant, copyeditor):** the locator byte layout is now a Markdown table, and the RFC 8032 and RFC 8949 citations are consistent links. I fixed all four copyedit findings. Prettier passes.

**Not addressed:**
- **Should-fix items:** I left the decomplector's `EntryKind` scope, the ergonomist's method discovery, and the novice's reading path for users vs. implementers.
- **Pedant's `designs/README.md` row widths:** I did not rewrap them. The table already has many rows of 200 to 1,800+ characters.
- **New names:** `VALUE_WITHHELD`, `LOCATOR_UNSIGNED` and the export option `references: 'omit'` are new in this round, so panel-5 should review them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1079287 cached reads)
- Output: 12886 tokens
- Cost: $1.0940494
- Wall-clock: 834s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
