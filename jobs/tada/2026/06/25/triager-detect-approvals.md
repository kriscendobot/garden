The work is complete. Here is my completion report.

---

## Completion report — `triager-detect-approvals`

**SHA:** `753143f461127bb39252d9fcd11ce5163af317aa` (pushed to `origin/main2`, live `/home/kris` tree fast-forwarded to deploy). Worktree-isolated build off `origin/main2` per the garden-infra norm; committed with explicit pathspecs.

### What I added — maintainer-approval → finalization-to-merge

The comment-watcher/triager had **no APPROVED handling**, so a clean approval fell through and an approved+mergeable PR sat in DRAFT (observed on endo-but-for-bots #528). I added the path across two layers:

- **`comment-source-gh.sh`** — now surfaces an `APPROVED` review **even with an empty body and no inline comments**, prefixed `[APPROVED]` (alongside the existing `[INLINE-REVIEW]`/`[CHANGES_REQUESTED]` markers). Previously a clean approval was invisible to the watcher.
- **`comment-watcher.sh` `classify()`** — a trusted `[APPROVED]` review with **no bundled asks** classifies as `finalize`. An approval **bundled with asks** (inline comments, a verb, @-mention, or imperative body — e.g. #528's "express types in the .d.ts") routes the **whole review FIRST** via the existing capture-full-review path (a fixer resolves the asks); the review job body notes the finalize-after-asks step so that handler dispatches the conductor once mergeable+green.
- **Main loop gating** — before minting anything for `finalize`: enforces **bot-repos-only** (`is_bot_repo`: `endojs/endo-but-for-bots` + bot-owned forks; hard denylist on `agoric/agoric-sdk` and `endojs/endo`), then a **mergeable+green probe**. Exit-code-driven: ready → one idempotent `<slug>-pr<N>-conduct` **conductor** job (un-draft + merge, never naming a merge method); already merged/closed → **nothing**; open-but-not-ready → **shepherd** (never a forced merge).
- **New `pr-mergeable-gh.sh`** probe — rc `0` ready / `2` merged-or-closed / `1` not-ready, with the loud-on-missing-tool (jq/gh) discipline from the 2026-06-24 outage.

### Dispatch behavior (summary)
Trusted APPROVED + mergeable+green on a bot repo → exactly one `…-pr<N>-conduct` conductor job (idempotent on re-poll). APPROVED-with-asks → review job first, finalize deferred. APPROVED on a non-bot repo or from an untrusted sender → no merge dispatch. Already-merged → nothing. Not-green → shepherd.

### Tests & verification
- Added **T/U/V/W/X/Y** (watcher end-to-end, mergeable probe stubbed by exit code, trust via allowlist) + **Z** (source surfacing of empty-body APPROVED). **`comment-watcher-test.sh`: 77 passed, 0 failed** (no regression on the existing 60).
- `bash -n` clean on all three scripts + the test; `shellcheck` clean except the repo's pre-existing baseline infos (SC1091 source-not-followed, SC2034 `GARDEN_TAG`/`bot`, SC2015) that appear identically across every existing handler — none in the new code.

### Follow-up note — distinct orchestrator "curator" role?
**Not worth defining now.** The maintainer's word "curator" is the *finalization step*, which the **conductor** already owns (canonical un-draft + merge, "always --merge" norm). A parallel orchestrator role would duplicate that authority. There's a curator *juror* seat (panel context), but no orchestrator gap here. Recommend keeping the conductor mapping and revisiting only if curation grows responsibilities beyond merge (release notes, changelog curation, post-merge cleanup) that genuinely don't fit the conductor.
