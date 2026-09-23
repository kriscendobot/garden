---
ts: 2026-06-07T05:39:30Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--d2984b`) for a **first-time ferry** (Shape 1) of bots#71 to a NEW endojs/endo PR closing issue #2879.

Source: endojs/endo-but-for-bots#71, branch `design/issue-2879-env-options-per-compartment`, head `8cf0cb632`, base sha `6804b7dc8` (older than current master), 3 commits (all Kris Kowal): `980053849` test(marshal): per-compartment ENDO_RANK_STRINGS is scoped + `2b890a617` fix(marshal): address review (bot-side gamut review) + `8cf0cb632` chore: Update yarn.lock. 5 files (marshal test + fixtures + package.json + yarn.lock). NOT draft (gamut-passed). No existing upstream PR/branch; test not on master; first-time.

Boatman brief (Shape 1): detach at current endo master `4a04d078b`; cherry-pick the test work; **squash commits 1+2** into one clean `test(env-options,marshal): per-compartment options are scoped` (the 2nd is a bot-side review fixup of the 1st - one logical change; one-voice-upstream); regenerate yarn.lock on current master (`corepack yarn install`) as a separate `chore: Update yarn.lock` rather than carrying the old-base lockfile; author+committer `Kris Kowal <kriskowal@kriskowal.com>`; strip `(#2879)` subject suffixes (put `Closes #2879` - the OPEN upstream issue - in the body); RUN `interpret-trailers --parse` EMPTY; if recompute hits non-lockfile conflicts from the 6804b7dc8->4a04d078b base gap, resolve mechanically or STOP; new branch `kriskowal-2879-env-options-per-compartment`; open the upstream PR **ready-for-review** (source is un-drafted/gamut-passed) with a pr-formation body (behavior over diff; Closes #2879; no fork refs); create garden-side cross-link on bots#71 (use --paginate when searching existing comments). `identity_switch_authorized: true`.

Expected report: new upstream PR URL + number, branch + head, squash/yarn-regen outcome, Kris Kowal + trailers-empty, mergeable, CI, cross-link id.
