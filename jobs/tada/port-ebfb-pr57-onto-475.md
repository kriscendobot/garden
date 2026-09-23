Inbox empty. Everything is complete and verified. Here is my report.

---

## Completion report: port-ebfb-pr57-onto-475

**Result: done.** PR #57 re-expressed against #475's `Uint8Array` byteArray model, force-pushed (stacked on #475), commented, and the shepherd follow-up posted.

### New head
`50238736c` on branch `kriskowal-marshal-binary` (was `2c8c2bfb`). Two commits stacked on #475's head `b2e712164`:
1. `feat(marshal): admit byteArray through capdata, smallcaps, encode-passable, and justin codecs`
2. `chore: Update yarn.lock` (separate, per discipline)

I also **retargeted #57's base** from `master` to `feat/narrow-bytearray-to-uint8`, so the PR now shows only the marshal delta as a proper stacked PR.

### What I found
A prior attempt had left a complete, uncommitted port in the standing worktree `worktrees/endojs-endo-but-for-bots/port-pr57` (based on #475 head). It was high-quality and correct; I verified it end-to-end rather than redoing it, then committed/pushed it.

### Dropped (obsolete ArrayBuffer model)
- #57's pass-style helpers `byteArrayToHex`/`hexToByteArray`/`byteArrayToUint8Array`/`uint8ArrayToByteArray` and the `@endo/immutable-arraybuffer`+`@endo/utf8` additions to `@endo/pass-style`. Unnecessary under #475: pass-style already exposes `frozenBytes`/`thawnBytes` and hex lives in `@endo/hex`.

### Re-expressed (the actual feature — byteArray through the codecs)
- **capdata** `{"@qclass":"byteArray","data":"<hex>"}`, **smallcaps** `"*<hex>"`, **encode-passable** `a<encodeBigInt(byteLength)>:<hex>` (shortlex, matching `compareRank`), **justin** `frozenBytes(decodeHex("<hex>"))`.
- Hex via `@endo/hex` (`encodeHex`/`decodeHex`); decode wraps the mutable `Uint8Array` in `frozenBytes`; encode reads via `thawnBytes`. `@endo/hex` added to `@endo/marshal` deps + tsconfig reference.
- `rankOrder` byteArray compare now reads via `.at()` so it works on both the native and `@endo/immutable-arraybuffer`-emulated wrapper paths (bracket indexing returns `undefined` on the shim path).
- Tests retargeted at the Uint8Array model; the property-based `encodePassable` fuzz now includes `byteArray`. Changeset narrowed to `@endo/marshal` (minor).

### Verification (local, `@endo/marshal`)
- `ava`: **91 passed, 1 skipped** (incl. 13 new byteArray round-trip / ordering / fail-closed tests)
- `tsc`: clean · `eslint`: clean

### Follow-up
- Posted **`shepherd-ebfb-pr57`** to drive CI to green; it has already been claimed (now in `jobs/doin/`).
- Summary reply posted on #57 (issue comment 4794147143).

### Design issues
None — the port was clean; #475's model supplied every primitive #57 needed, so the re-expression is strictly simpler than the original.

### Note / incident
While posting the shepherd job I ran `git pull`/`git stash pop` from cwd `/home/kris` (garden main2). Because the garden and `journal/` worktrees share one stash stack, `stash pop` tried to apply a **stale 13-day-old autostash** (c5d4123d, 2026-06-11; its content is already upstream) onto main2. It failed to apply and kept the stash — **no files were changed in main2** (the `scripts/jobs/common.sh` edit and `scholar-frb3-wt/` there are other gardeners' live concurrent work, not mine). The journal worktree's in-flight scholar changes are intact. No damage; reinforces the standing rule to always use `git -C <abs-path>` for journal operations.
