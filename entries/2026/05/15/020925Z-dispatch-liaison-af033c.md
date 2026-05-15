---
ts: 2026-05-15T02:09:25Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/014119Z-result-liaison-9224ee.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Re-ferry `endojs/endo-but-for-bots#109` over `endojs/endo#3256`. Bot-side has been **rebased and restructured** since the last ferry (which landed `acddddba` as a single squash commit per `entries/2026/05/13/230733Z-...`): the work is now **two logical commits** at the top of `feat/syrups-package`, and the branch's base has advanced to current upstream `master`.

The two new bot-side commits (HEAD `45ec2797a`):

1. `24560074 feat(syrup-frame): add @endo/syrup-frame package` (endolinbot, 2026-05-15T01:55:30Z) — package addition.
2. `069c24d6 feat(ocapn): add opt-in syrups framing to TCP-testing netlayer` (endolinbot, 2026-05-15T01:55:38Z) — consumer-side opt-in.

Compared to the upstream's current squash `acddddba` (Kris Kowal, single commit titled `feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`), the bot side now splits the same content into two logical commits with separate package-add vs consumer-opt-in framing. This is a deliberate restructure (matches the pattern the user has been preferring across re-ferries this session).

The upstream PR carries one substantive review: `kumavis APPROVED 2026-05-14T02:42:25Z`. `endojs/endo:master` is not branch-protected, so the approval should persist as a record across a force-push (GitHub dismisses on force-push only when `dismiss_stale_reviews` is enabled in protection). The boatman should proceed; if the approval is auto-dismissed for any reason, the substantive review-record remains in the PR thread and a re-request can re-engage kumavis.

**Source**: `endojs/endo-but-for-bots#109`, branch `feat/syrups-package`, head `45ec2797a15653edd9c16200a2117650a0020363`. State OPEN, MERGEABLE. Base on `master` (current `0ec70c6dd`, after ascending through the recent squash-merges of #3252 [zizmor], #3255 [eslint-import-x], #3257 [bytes], #3261 [amaro], #3262 [guile-interop]).

**Upstream**: `endojs/endo#3256`, branch `feat/syrups-package`, current head `acddddba16d524c8eb16d71fb35c43f34fa491ae`. State OPEN, APPROVED (kumavis), CI 28 SUCCESS / 0 FAILURE on the current squash. Current master is `0ec70c6dd`.

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry).

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109--20260515-020912--af033c/`. Project worktree on `endojs/endo:feat/syrups-package` (detached at `acddddba`).

**Boatman direction**:

- Recompute from `origin/master` (per the boatman wisdom branch in `entries/2026/05/14/061345Z-result-boatman-bf7290.md`: the upstream branch represents a *different shape* from the source's intent, so recompute rather than cherry-pick-on-prior-tip).
- Cherry-pick the two source commits (`24560074..069c24d6`) onto `origin/master`. **Preserve as two commits** (the restructure is the point of this re-ferry; do not squash back to one). Use the cherry-pick + `git commit --amend --reset-author --no-edit` pattern surfaced in `entries/2026/05/15/005114Z-result-boatman-eaabd7.md` to rewrite author + committer to `Kris Kowal <kris@cixar.com>`.
- If a cherry-pick conflicts in the 28-commit upstream gap, resolve. The bulk-change zone is the `packages/syrup-frame/*` package (new) and the `packages/ocapn/*` TCP-testing netlayer files (modified); upstream master may have touched the latter via the bytes merge (#3257). Pause and `message`-to-liaison only if a conflict is non-trivial.
- Strip bot trailers. Verify with `git log origin/master..HEAD --pretty=fuller` and `git interpret-trailers --parse` per commit. Strip any `(fix lint job on …)` or similar bot-internal commit-subject footers during the amend (the recent #244 ferry stripped one of these; same pattern applies here if either source commit carries one).
- Force-push to `feat/syrups-package`. The current single squash `acddddba` will be replaced with two commits.
- **Title update**: the upstream PR title (`feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`) reflects the combined-squash framing. Since the work now lives in two commits with distinct framing, the boatman should evaluate whether to keep the combined title or split it. Reasonable choices: (a) keep the existing combined title as the PR-level summary (the PR still does both things; the commit shape is internal to the PR), or (b) shorten to `feat(syrup-frame): @endo/syrup-frame package + opt-in framing for OCapN TCP-for-testing` for cleaner upstream phrasing. Pick whichever reads better; either is fine, no user instruction either way. The user did **not** ask for a title or description update this round (compare to the explicit `update the title and description` ask on the prior #253 re-ferry); leave the body unchanged unless the title-shape change suggests a body tweak per `pr-formation`.
- Source-side cross-link comment on `endo-but-for-bots#109`: post under whichever identity is authenticated (kriskowal only on this host; standing authorization on `endo-but-for-bots` permits both). Name the upstream PR URL and new head SHA.
- Identity discipline: no direct comments on `endojs/endo#3256`. Route through steward if any explanatory comment is warranted; the prior re-ferry to `acddddba` did this (per `entries/2026/05/13/230647Z-...`).

**Expected report** (≤350 words): upstream head SHA after force-push, two new commit SHAs in order, attribution-verified, source-side cross-link URL, title-change decision (keep / split / shorten), kumavis-approval persistence check (still APPROVED?), steward-message path if any, one-line `Self-improvement: ...`. If anything blocks (non-trivial conflict, unexpected upstream tip), `message`-to-liaison and stop.
