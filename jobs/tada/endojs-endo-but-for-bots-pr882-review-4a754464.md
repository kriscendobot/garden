Work is pushed and the tree is clean. Report follows.

## Completion report

Addressed kriskowal's `CHANGES_REQUESTED` review ([pullrequestreview-4800433644](https://github.com/endojs/endo-but-for-bots/pull/882#pullrequestreview-4800433644)) on endojs/endo-but-for-bots#882 — empty body, 5 inline comments, all resolved. Preflight returned exit 0 (no peer resolution), so I did the work.

Rebased onto current `llm` (clean; the 11 intervening commits touch none of these files), then four one-concern commits. Head **`78ba7235c6`**.

| Ask | Commit |
| --- | --- |
| Excluded-packages list is a smell | `9371c22fbf` |
| `makeArchive` / `makeFromTree` / `makeUnconfined` — plan closing the gap | `ae5c7fd608` |
| Use `endo/bytes` | `9cdb6a9789` |
| (residue) now-dead XS text codecs | `78ba7235c6` |

**The exclusion list was doing nothing.** I verified before deleting: both bundles this PR generates are byte-identical with and without it (`worker_bootstrap.js` `8c0c4d33…`, `ses_boot.js` `a3e9cda7…`), and neither contains a `node:` builtin import. Exactly the reviewer's reasoning — `makeBundle` retains only reachable modules. Both script headers now record that and name `exports`/`imports` conditions as the real mechanism.

**The gap plan** went into `designs/worker-rust-xs.md` § Known Gaps as one dependency-ordered item (`makeArchive` → `makeFromTree` → `makeUnconfined`, the last being the only one needing new Rust host surface). Each method now points there from both its JSDoc and its thrown message. I did not open a tracking issue — issue opens are outside standing authorization on this repo; offered it to the maintainer instead.

**One correction I had to make mid-job.** I first told the reviewer that `bundle-bus-daemon-rust-xs.mjs`'s list was load-bearing because dropping it failed the bundle. Testing both ways showed that bundler fails *identically with its list intact* — so the review's point holds uniformly across all three bundlers. That surfaced a finding worth flagging: **`daemon_bootstrap.js` cannot currently be generated on `llm` at all** (16 unresolved Node builtins across `@endo/git`, `@endo/host-spawner`, `@endo/platform`), pre-existing and untouched by this PR's commits. It bears on the PR's premise — the two restored generators build clean, but the one that survived is itself broken, so a fresh checkout still can't produce all three `include_str!` artifacts. Corrected on the PR in both the thread and an addendum comment.

**Verification at `78ba7235c6`:** both restored generators build and parse; `tsc` on `packages/daemon` clean; `eslint` on `packages/daemon/src` 0 errors; `prettier --check` clean; `yarn.lock` untouched. Not run: the Rust/XS end-to-end suite (needs a `cargo` release build of `endor`).

Comments posted (repo's standing authorization): 6 inline replies + 2 top-level. Journaled as two `result` entries.

**Left undone, deliberately:** I did not re-request review — that authorization is gated on CI green, and CI is queue-saturated (7 pass, 0 fail, 17 still queued at 0s elapsed after ~45 min). The fleet's `ci-watcher` auto-posts a shepherd job if it goes red, so the outcome is covered.

**Follow-ups worth posting as jobs:** fix `bundle-bus-daemon-rust-xs.mjs` with an `xs` condition on the three offending packages — the one place the conditions mechanism is genuinely load-bearing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr882-review-4a754464.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 207 tokens (13026472 cached reads)
- Output: 62946 tokens
- Cost: $9.759813000000001
- Wall-clock: 1015s

<!-- garden-usage-end -->
