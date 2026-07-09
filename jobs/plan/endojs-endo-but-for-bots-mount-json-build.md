---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-mount-ext-rebuild-orch-127
priority: normal
posted_by: producer
posted_at: 2026-07-09T18:51:29Z
---

---
role: builder
---

# Build: mount JSON read/write (PR D of the #127 reconstruction)

Repo: endojs/endo-but-for-bots. Spec: `designs/mount-extensions-reconstruction.md`
§ "PR D — JSON file read and write" on design PR
https://github.com/endojs/endo-but-for-bots/pull/648 (read from branch
`design/mount-extensions-reconstruction` if not yet merged).

Implement `readJson`, `maybeReadJson` (undefined on missing file, throw on
invalid JSON — review comment 3548857836), and `writeJson` (2-space indent
plus trailing newline; throw when `JSON.stringify` yields undefined), with
help text, types, interface shapes, and conformance-allowlist entries. Head
branch `feat/mount-json`, base = head of `feat/mount-grep` (stacked; PR C
must be open first). Run the standard PR-creation chain.
