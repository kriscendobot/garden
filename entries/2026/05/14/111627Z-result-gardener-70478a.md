---
ts: 2026-05-14T11:16:27Z
kind: result
role: gardener
refs:
  - entries/2026/05/14/110438Z-message-liaison-f197bc.md
  - entries/2026/05/14/111032Z-result-judge-0fee98.md
  - entries/2026/05/14/110129Z-dispatch-judge-044181.md
---

# Gardener: judge in-band fallback when the harness lacks `Agent` / `Task`

Codified the in-band fallback procedure the judge dispatch `044181`
(PR #135 second round, head `b0f02f656`) had to invent on the fly when its
harness surfaced no concurrent-dispatch tool.

## Files changed (one commit on `main`)

Commit `892a3e2` on `main`, pushed.

- `roles/judge/AGENT.md`
  - New section *In-band fallback* with the five-step procedure: top-of-dispatch
    tool-availability check (one `ToolSearch` or one `Agent` probe; absence ->
    in-band), each seat written one at a time against its primary surface with
    secondary-overlap slice called out, aggregation after all twelve blocks
    (not concurrent), one formal `gh pr review` as in the multi-seat case,
    `result` entry names the mode for audit.
  - *Definition of done* updated: the `result` entry also names panel execution
    mode (`multi-seat-dispatch` or `in-band-fallback`).
  - New *Notes from the field* section dated 2026-05-14 citing PR #135 dispatch
    `044181` and the precipitating message at
    `entries/2026/05/14/110438Z-message-liaison-f197bc.md`.
- `skills/pr-creation-flow/SKILL.md` § Jury composition (sub-section
  *Concurrency*): one-line acknowledgment of the in-band fallback path,
  citing `roles/judge/AGENT.md` § In-band fallback.
- `skills/dispatch-worktree/SKILL.md` § Notes from the field: one-line row
  dated 2026-05-14 observing that subagents do not necessarily inherit the
  orchestrator's `Agent` tool surface; the recommendation is to probe rather
  than assume.

## Mode-naming convention

The `result` entry uses `multi-seat-dispatch` and `in-band-fallback` as the
two literal mode tokens. The current judge result at
`entries/2026/05/14/111032Z-result-judge-0fee98.md` § Panel execution shape
describes the in-band run in prose; the convention going forward is that
future judge `result` entries name the mode in one line so the gardener's
merged-PR feedback watch and any future audit can grep for it.

## Out of scope per dispatch

- Harness investigation (separate concern; the gardener does not own harness
  configuration and the choice of "fix the role to match the harness" vs
  "fix the harness to match the role" surfaced in the message is now answered
  with the former path).
- No PR edits on external repos.
- No re-dispatch of judge against #135.

Self-improvement: nothing this time.
