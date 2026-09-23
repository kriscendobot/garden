---
ts: 2026-05-15T00:05:21Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/235802Z-dispatch-liaison-02ccd8.md
  - entries/2026/05/15/000319Z-result-boatman-d0adfe.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 255
    role: source
  - repo: endojs/endo
    pr: 3262
    role: target
---

First-time ferry of `endojs/endo-but-for-bots#255` opened as `endojs/endo#3262` (DRAFT).

- Upstream PR: https://github.com/endojs/endo/pull/3262, draft state confirmed.
- Branch: `kriskowal-ocapn-guile-interop-resilience-ii`, head `407d25c5b7c7a1f91fbb13f91c9807ab8f3a07d1`, single commit on top of `origin/master` at `05823033d`.
- Title: `ci(ocapn-guile-interop): reorder substitute servers and widen sturdyref wait` (the boatman picked a frame-for-upstream title that surfaces both semantic edits the diff carries; the source's parenthetical "(iteration II)" dropped per `pr-formation`).
- Author + committer both `Kris Kowal <kris@cixar.com>`; `git interpret-trailers --parse` empty.
- Source-side cross-link comment on `endojs/endo-but-for-bots#255`: [issuecomment-4455705374](https://github.com/endojs/endo-but-for-bots/pull/255#issuecomment-4455705374).

Process note on the boatman's self-improvement line. The boatman flagged that the dispatch prompt told it to post the cross-link "under the bot identity" but only `kriskowal` is authenticated on `kmkmbp2021`. The role's "direct comments on the garden's own repo are fine" clause covered it (per the *Pre-staged authorizations* bulletin row: "endojs/endo-but-for-bots is the garden's own repo (broad comment authorization)"). The fact pattern is the same as the prior re-ferry of #226 (`entries/2026/05/14/180519Z-result-boatman-99ec85.md` had the same kriskowal-on-this-host comment), so two occurrences now. The misframing is on the liaison side: the dispatch prompt should say "post under whichever identity is authenticated on this host; the standing authorization on `endo-but-for-bots` permits both" rather than "under the bot identity". Worth landing in the eventual `skills/pr-handoff/SKILL.md` rather than a one-off correction.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: the dispatch prompt's "under the bot identity" framing on cross-link comments is host-specific and conflicts with what's available on `kmkmbp2021`. Future ferry dispatch prompts should say "under whichever identity is authenticated; the garden's own repo permits both" rather than presuming the bot host's setup. Below the structural-lesson threshold to write a per-host check into the role, but worth a one-liner in the eventual `skills/pr-handoff/SKILL.md`.
