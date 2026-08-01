---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-01T08:10:27Z
---
Byte-array press observation for endo-byte-array-press-20260801-030502:

- The view redesign is the design of record, but has not replaced the old shape across the live stack. endojs/endo-but-for-bots#475 carries the restrictive frozen whole-buffer Uint8Array view at 1b1dc75ba9c9; current llm fc0a0fb46167 still brands a bare immutable ArrayBuffer and still throws for CapData, Smallcaps, and encode-passable byteArray codecs. endojs/endo-but-for-bots#503 remains the obsolete bare-buffer/emulation front.
- Both front PRs are unchanged and have no new issue or review comments since 2026-07-30T20:35Z. Their outstanding threads are answered bot-side or acknowledged by erights. No live peer owns either front.
- Real-execution evidence on unchanged #475 head: `gh pr checks 475 --repo endojs/endo-but-for-bots` reports 17 passes, including Node 22/24 on Ubuntu/macOS, `test-xs`, and OCapN Python/Guile interop.
- endojs/endo-but-for-bots#671 merged. The watcher-owned registry follow-up is draft #888 at 12059c0d16f3 with 23 passing checks; its panel-1 job is queued and unclaimed. It currently uses the old bare-buffer APIs (`bytesToImmutable`/`bytesFromImmutable`, with `resolve` typed as `ArrayBuffer`), so it does not by itself complete the final frozen-Uint8Array-view shape. I did not take over the separately queued registry job.

No project changes. The front remains reviewer-blocked; the next queued artifact is the separate #888 panel round, with final integration still dependent on landing or refreshing the view model.
