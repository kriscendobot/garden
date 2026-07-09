---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-09T20:40:03Z -->

---
role: builder
---

# Build: mount grep (PR C of the #127 reconstruction)

Repo: endojs/endo-but-for-bots. Spec: `designs/mount-extensions-reconstruction.md`
§ "PR C — grep" on design PR
https://github.com/endojs/endo-but-for-bots/pull/648 (read from branch
`design/mount-extensions-reconstruction` if not yet merged).

Implement `EndoMount.grep(pattern, options?)` selecting files through
`glob(options.glob)`, ECMAScript RegExp source with no flags, CRLF-normalized
line text, 1-based line numbers, `maxResults` cap, silent skip of unreadable
files. Extend the shared case tables with `mount-grep-cases.json` per the
design's grep coverage list. Head branch `feat/mount-grep`, base = head of
`feat/mount-glob` (stacked; PR B must be open first). Run the standard
PR-creation chain.
