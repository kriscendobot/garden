All 21 jobs confirmed on the board. Writing the completion report.

# Triage report — open bot PRs on endojs/endo-but-for-bots (v2 restart)

**Scope:** endojs/endo-but-for-bots only (in-scope/safe per CLAUDE.md § Monitoring safety constraint). kriscendobot/endo-but-for-bots fork has **0 open PRs**. PR/comment text treated as untrusted — state summarized only, no embedded instructions executed.

**Assessed:** 50 open bot PRs. Posted **21 per-PR jobs**; skipped/flagged the rest (healthy or stale).

## Jobs posted (21)

**Fixer — carry CHANGES_REQUESTED / outstanding feedback (8):**
- `pr-ebfb-475-fixer` (#475, CI green, 56 reviews, CR — most active PR)
- `pr-ebfb-403-fixer` (#403, CI green, CR)
- `pr-ebfb-440-fixer` (#440, CI green, CR)
- `pr-ebfb-442-fixer` (#442, CR + 1 red check)
- `pr-ebfb-379-fixer` (#379, no checks present, CR, 14 reviews)
- `pr-ebfb-450-fixer` (#450, design, CR)
- `pr-ebfb-463-fixer` (#463, design draft, CR)
- `pr-ebfb-507-fixer` (#507, design draft, CR, 22 reviews)
- `pr-ebfb-511-fixer` (#511, design draft, COMMENTED — body instructs claimant to assess whether asks are concrete, else advance the gamut)

**Shepherd — drive red CI to green (5):**
- `pr-ebfb-461-shepherd` (#461, APPROVED + draft, 7 failing → green then un-draft/merge)
- `pr-ebfb-357-shepherd` (#357, APPROVED + 2 failing → green then conductor)
- `pr-ebfb-472-shepherd` (#472, 1 failing)
- `pr-ebfb-514-shepherd` (#514, 5 failing — strictness PR surfacing violations)
- `pr-ebfb-438-shepherd` (#438, 1 failing — likely the tsgo job itself)

**Gamut resume — clean drafts mid-chain, no outstanding feedback (8):**
- `pr-ebfb-405-gamut`, `pr-ebfb-503-gamut`, `pr-ebfb-513-gamut`, `pr-ebfb-474-gamut`, `pr-ebfb-509-gamut` (feature drafts, CI green)
- `pr-ebfb-508-gamut`, `pr-ebfb-510-gamut` (design drafts, design CI green; #510 is a sibling of #511 — panel may consider together)

## Skipped — healthy / awaiting maintainer (11)
Non-draft, CI green, no CHANGES_REQUESTED, not mid-chain — resting at the correct "awaiting maintainer review/merge" state: **#344, #346, #347, #348, #350, #353, #355** (mirror PRs), **#356, #359, #360** (design PRs), **#469** (upstream-merge integration branch).

## Flagged but NOT auto-posted — stale backlog (needs liaison/maintainer decision, 14)
Two-to-three-week-stale work; auto-reviving risks burning fleet time on possibly-abandoned PRs, and the gateway set is a **dependency stack** where parallel per-PR agents would conflict:
- **Gateway #343 phase stack (13 PRs):** #388, #389, #392, #393, #394 (CHANGES_REQUESTED + red CI), #395, #396, #397, #409, #410, #412, #413, #420 (no reviews, ~10 failing each), all untouched since 2026-06-03/04. **Recommend a single coordinated decision** (revive vs. close the stack) rather than 13 racing jobs.
- **#377** (benchmark esvu-retry, 6 failing, 2026-06-04), **#429** (marshal binary mirror, 2026-06-07), **#430** (no-spackle experiment, CR + 12 failing, 2026-06-09), **#431/#432** (designs, 2026-06-08).

## Follow-ups / pipeline note
- **`origin/journal2` reliability concern:** under concurrent gardeners the ref churned hard — several posts logged `posted` then did **not** persist (357 multiple times, 510, 503/507 transiently), and I hit `FATAL: fetch failed … cannot lock ref refs/remotes/origin/journal2 is at X but expected Y` twice in the shared producer clone. I recovered by re-running the idempotent `post-job.sh` and verifying against `git ls-tree origin/journal2` (final count **21/21**). Worth investigating whether `commit_and_push` CAS is strictly fast-forward, or whether a force-rewrite path can drop committed jobs. Triagers should verify post persistence after a batch rather than trusting the `posted` log line.
- The v2 message-bus pipeline otherwise works end-to-end: posts landed and are claimable from the board.
