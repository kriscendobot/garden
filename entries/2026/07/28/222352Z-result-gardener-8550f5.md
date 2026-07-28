---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T22:23:54Z
---
---
project: endo-but-for-bots
prs: [882]
job: endojs-endo-but-for-bots-pr882-review-4a754464
---

# Addressed kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots#882

Review <https://github.com/endojs/endo-but-for-bots/pull/882#pullrequestreview-4800433644>
(5 inline comments, empty body). Rebased onto current `llm`, then three
follow-up commits, force-with-lease pushed; head `ae5c7fd608`.

| Ask | Commit |
| --- | --- |
| Excluded-packages list is a smell | `9371c22fbf` |
| `makeArchive` / `makeFromTree` / `makeUnconfined` gap — plan it | `ae5c7fd608` |
| Use `endo/bytes` | `9cdb6a9789` |

Substantive finding: the excluded-packages hook in both bundlers this PR
adds was a **complete no-op** — the generated bundles are byte-identical
with and without it (`worker_bootstrap.js`
`8c0c4d33252f803a7c00abf66757716bef38bbe87c68f1596144492fb019fd90`,
`ses_boot.js`
`a3e9cda7ef048dd62469a9ed8701801f9ae8dae86fda4b13a7c6cf08c3676b23`), and
neither contains a `node:` builtin import. `makeBundle` retains only
reachable modules, so pruning dependency edges no retained module traverses
changes nothing.

Left alone deliberately: `bundle-bus-daemon-rust-xs.mjs`'s list is NOT a
no-op — dropping it fails the bundle with 16 unresolved Node builtins across
`@endo/platform`, `@endo/git`, `@endo/host-spawner`. That is the real case
for the reviewer's `exports`/`imports`-conditions mechanism, and is a
follow-up against a file #882 does not touch.

Comments posted (all under the repo's standing authorization):

- <https://github.com/endojs/endo-but-for-bots/pull/882#discussion_r3669587619>
- <https://github.com/endojs/endo-but-for-bots/pull/882#discussion_r3669587969>
- <https://github.com/endojs/endo-but-for-bots/pull/882#discussion_r3669588835>
- <https://github.com/endojs/endo-but-for-bots/pull/882#discussion_r3669589367>
- <https://github.com/endojs/endo-but-for-bots/pull/882#discussion_r3669589580>
- <https://github.com/endojs/endo-but-for-bots/pull/882#issuecomment-5110301778>

No tracking issue opened: issue opens are outside standing authorization
here; offered to the maintainer in the reply and the summary.
