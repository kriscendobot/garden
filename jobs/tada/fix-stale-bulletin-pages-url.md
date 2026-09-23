## Completion report

Job scope: fix stale `kriskowal.github.io` Pages URLs (and related `kriskowal/garden` canonical-repo references) left over from the `kriskowal/garden` → `kriscendobot/garden` transfer.

**Finding:** already done. Commit `14fd4feca1` ("fix: repoint the bulletin after the kriscendobot/garden transfer") is present on `main2` and is an ancestor of this worktree's HEAD — it was landed by an earlier attempt at this same job before the reaper requeue. It:
- Fixed `docs/bulletin/DESIGN.md` and `docs/bulletin/SETUP.md` to the live `kriscendobot.github.io/garden/bulletin/` URL.
- Hardened the token-scope docs (fine-grained tokens don't follow a repo transfer) and made `app.js` surface a clear error on a wrong-owner/expired token instead of failing silently.
- Canonicalized other current-fact repo references (`designs/issue-inbox.md`, `render-endo-redirect.sh`, `pages-runs-gh.sh`).
- Deliberately left issue/PR links, test fixtures, and the migration-alias config (`GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES`) as historical/functional text, and kept `repo-transfer.md`'s `kriskowal.github.io` mention since it narrates the now-dead address, not a live link.

I re-verified this session: grepped the whole repo for `kriskowal.github.io` (only the one deliberate historical hit in `repo-transfer.md` remains) and for `kriskowal/garden` / `github.com/kriskowal` broadly (all remaining hits are historical issue/PR citations, test fixtures, or config describing the transfer — consistent with the judgment call already made). CLAUDE.md's previously-cited stale reference no longer exists (was in an old, since-restructured revision of the file).

No changes needed; working tree is clean. No follow-ups.
