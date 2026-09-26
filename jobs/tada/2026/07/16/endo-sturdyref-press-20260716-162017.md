SturdyRef press tick complete (job `endo-sturdyref-press-20260716-162017`, dispatched 16:20Z): the 07-13 stall is over — the maintainer re-engaged on 07-14/15 — and this tick landed the one explicitly-directed, unblocked artifact.

**Landscape shift found on assessment (verified via `gh`, 16:21–16:30Z):**
- **#521 is CLOSED** (07-15), per kriskowal's directive *"close, collapse the stack, and propose a single review"* → replaced by **#737** (`build/sturdyref-pass-style-ocapn-single`, single commit under kriscendobot, was 26/26 CI-green, no maintainer review yet).
- **#695** and **#697** (designs) both got kriskowal CHANGES_REQUESTED reviews on 07-15 that peers already addressed same-day; both await re-review.
- **#541 + bridge cuts #698–#704** still stack on closed #521's old branch — restack/fold pending the maintainer's holistic-review preference.
- No live peer on sturdyref work (`inbox-list.sh`: only unrelated pr263/esheets/finbot/xs2rust agents; `jobs/doin/` held only pr263) — clear to press.

**What I did (the press):**
- Applied kriskowal's direct instruction from #521 review comment `discussion_r3582807958` — renamed the pass-style discriminator `'sturdyref'` → `'sturdyRef'` — and pushed **`ce7341b47d`** to #737's head branch (rebase-CAS push accepted first try). 10 files, +32/−32: `PassStyle` union, helper `styleName` + shape checks, ocapn mint + codec-table key, tests. Wire-level OCapN vocabulary (`ocapn-sturdyref` Syrup label, `OcapnSturdyRefCodec`, `ocapn://` URI kind, `SturdyRef` toStringTag) deliberately untouched. PR stays DRAFT.
- **Verified by real execution** in the isolated project worktree: `yarn test` → pass-style **68 passed**, marshal **82 passed** (1 skipped), ocapn **534 passed** (after fixing two rename-follow-through sites the tests caught: the ocapn passable codec-table key and one error-message regex); `yarn lint` (`tsc && eslint`) → **0 errors** in all three packages. CI re-run on `ce7341b47d` was not awaited — "not verified" here; the next tick / pr737 shepherd lane watches it.
- Commented on #737 (`issuecomment-4994276944`) with the evidence, and re-surfaced the two decisions buried in closed #521's thread so they're answerable on the live PR: the marshal rank-encoding **prefix pick** (options A/`q` recommended, B/`t`, C/`w`) and the **stack-collapse** preference for #541/#698–#704.
- Posted progress entry `entries/2026/07/16/163300Z-progress-gardener-6485d5.md` with next-tick guidance (implement prefix follow-through on a pick; fold or restack the daemon stack on his answer; no escalation — maintainer is active).

**Confinement statement:** this tick changed spelling only — no confinement surface moved. The shape tests re-ran green including the forgery/decoy rejections: the swiss-num secret is never a property on a SturdyRef instance, and the raw locator stays in ocapn's closely-held off-band map (no-location preserved); token unlinkability (no-identification) remains pending the #695-gated provide/accept build.

**Follow-ups:** maintainer-gated on kriskowal — first review of #737, re-reviews of #695/#697, the prefix pick, and the stack-collapse answer. All are now visible on live PRs; the hourly cadence and the comment watcher will catch his replies.
