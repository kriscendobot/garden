All dispatch work is complete — the pass-path job is already claimed by a peer gardener (`jobs/doin/`), the schedule body carries the refreshed state, and my inbox is empty.

## Press dispatch report — git-integration / M3 loop (2026-07-18T00:20Z)

**Stack assessment (live `gh` state, all cited from real output):**
- **#705** (Phase 1, remote push tier): OPEN, un-drafted, MERGEABLE/CLEAN, zero failing checks. Still gated on the maintainer merge directive; the ask (20260717T002451Z-cb5a1b) sits **unread** in `inbox/maintainer/unread/` — per standing orders I did not merge and did not re-send.
- **#706** (Phase 2): MERGED, unchanged.
- **#707** (Phase 3, M3 exit): green, base still the frozen snapshot of #705's exact head (`build-agent-tools-git-remote-push-tier-76371cb` = 76371cb1). Blocked behind #705's merge; no action. The parked `gauntlet-…-707` plan job is moot (#707 is already green and un-drafted).
- **#708** (exo-git QID/hash): all checks passing — the guile-interop flake is not currently firing, so no rerun needed.
- **#740** (endor-bindings design): MERGEABLE/CLEAN, panel passed, no open threads; merge sequencing left to maintainer directive.

**#626 (Phase 5) — the weave completed but was falsely poisoned.** The weaver rebased the branch onto `llm` at 2026-07-17T23:27:22Z (head 75cb63dc, committer Kriscendo Bot), all ~20 CI checks pass, MERGEABLE/CLEAN, still DRAFT as directed — but the handler overran its 2400s budget before reporting, so the reaper parked a now-**moot** copy at `jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval` with a poison notice in the maintainer inbox. Do not promote it; the work is verifiably done. I left the parked copy in place (removal is a human call) and documented the mootness in the schedule body.

**Next unblocked increment found and pressed.** I verified on `llm` that #645 landed every verb the stack-surgery scenario needs — `commit({amend})`, `reword`, `cherryPick`, `rebase({autosquash})` are in `exo-git` and the native backend (`checkoutConflict` did not land, but the scenario's side branches touch disjoint files so it isn't needed). That makes three things on #626 stale: the test-file comment claiming the pass-path is verb-blocked, the fixture's default `allowHistoryRewrite: false` (the landed conflict-rebase fixture passes `true` explicitly), and the eval-live row's `skipReason`. I posted **`fix-endo-but-for-bots-pr626-stack-surgery-pass-path`** (role fixer, model fable, `handler-timeout: 10800` so it can't repeat the weave's overrun): wire the scripted faux-model pass-path mirroring `conflict-rebase.test.js`, using the sanctioned no-reset mixed-commit-split recipe from the gap doc, flip to `allowHistoryRewrite: true`, un-skip the live row, refresh stale framing, **keep DRAFT**. It was claimed into `jobs/doin/` within seconds of posting.

**Schedule refreshed** via `set-schedule.sh` (cadence 6h unchanged): the body now records the completed weave, the moot parked jobs, the landed-verb inventory, and the new pass-path job with a don't-double-post guard.

**Follow-ups:** (1) the whole merge train still waits on the maintainer's #705 directive; (2) the two moot parked plan jobs (`weave-…-pr626`, `gauntlet-…-707`) and their poison notices can be deleted by a human at leisure; (3) next dispatch should check the pass-path job's lifecycle state.
