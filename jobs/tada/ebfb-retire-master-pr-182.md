Complete. `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE` (CI pending — not a conflict). The retire operation landed cleanly.

## Completion report — `ebfb-retire-master-pr-182` (weaver)

**Task:** Retire the moving `master` base for `endojs/endo-but-for-bots#182` under the 2026-07-16 directive, freezing it to a reflection of **upstream** `endojs/endo` master.

**Preconditions confirmed:**
- PR #182 is **OPEN**, non-draft, and targeted `master` at claim time.
- Not cross-repository — head branch `test/947-isimmutabledataproperty-absent` and base both live on `endojs/endo-but-for-bots` (the bot's working fork of `endojs/endo`). Single commit, a 32-line SES regression test (`packages/ses/test/scope-constants.test.js`), authored by kriskowal.

**What I did:**
1. Fetched **upstream `endojs/endo` master** = `46d4edf3` (deliberately *not* the fork master, which has diverged to `fcbb540e`).
2. Reflection branch **`master-46d4edf` already existed** on the fork and pointed exactly at `46d4edf3` — reused it (no push needed).
3. Rebased the PR head onto `46d4edf3`. Clean — pure single-file addition, `ef52a83f → b9f8ec1e`, diff unchanged (1 file, +32).
4. Pushed head with `--force-with-lease` (leased against the prior `ef52a83f`).
5. Set the PR base to `master-46d4edf` via `gh pr edit`.

**Final state:** OPEN, base `master-46d4edf`, head `b9f8ec1e`, `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE` (CI running, not a conflict). The fork's `master` branch was never touched.

**Observation for maintainer (not a blocker):** This PR had been idle since 2026-05-22 (~8 weeks) and is maintainer-authored (kriskowal), not bot-authored. It rebased cleanly and is mergeable, so it was **not** a stale mirror requiring a skip — the sweep was not wedged. Flagging the idle age only in case #182 should be shepherded to merge or closed as part of the broader retirement work.
