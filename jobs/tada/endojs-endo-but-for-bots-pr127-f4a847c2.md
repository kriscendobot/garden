PR #127 is OPEN with my commit `6ad77bf88` at its head. Job complete.

---

## Completion report

**Directive** (kriskowal, PR #127 comment): append a `glorp(glob, grep)` function to the mount-extensions stack that composes glob and grep in a way that can be pushed down to native code.

**Preflight**: `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved this). Fetched comment treated as untrusted data; the instruction itself came trusted via the job spec.

**What I did** — added a fused `glorp` mount search extension on branch `feat/mount-extensions` (commit `6ad77bf88`):
- **`src/mount.js`** — `glorp(glob, grep, options?)`: both patterns are *required positionals*, so the whole operation is one call whose two patterns a native filesystem can fuse into a single enumerate-and-scan pass (no glob result set round-tripping through JS the way `grep(pattern, { glob })` does). Reference impl composes the existing `glob`/`grep` surface; a native powers layer may override it. Returns the same `{ file, line, text }` records as `grep`, honoring the same confinement/deny-pattern filtering.
- **`src/interfaces.js`** — `M.call(M.string(), M.string()).optional({ maxResults })` guard.
- **`src/types.d.ts`** — `glorp` signature on the `EndoMount` interface.
- **`src/help.md`** + **`src/help-text-data.js`** — help entries.
- **`test/mount-platform-fs-conformance.test.js`** — pinned `glorp` into `ENDOMOUNT_EXTENSIONS` (and its comment).
- **`test/mount.test.js`** — new test: `glorp` honors the glob filter (excludes the denied `.aws` tree) and equals `grep(pattern, { glob })`.

**Verification**: `yarn ava` mount (78), conformance (19), helpdown (18) suites all green; `tsc` clean; eslint 0 errors (only pre-existing warnings); prettier clean.

**PR state**: The PR had been auto-closed by the bot on 2026-07-09 (not by the maintainer, and not merged). Since kriskowal was directing fresh work onto the stack, I reopened it, pushed the commit (push CAS succeeded), posted a summary comment, and 🚀-reacted the directive comment. PR #127 is now OPEN at head `6ad77bf88`.

**Follow-ups**: none required. Note `grep`'s `options.glob` was intentionally left in place — `glorp` is the explicit two-pattern composition primitive alongside it, not a replacement. (Local `yarn install` couldn't build `better-sqlite3`, unrelated to this change; the mount tests don't depend on it and ran clean.)
