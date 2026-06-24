---
ts: 2026-05-23T00:06:00Z
kind: result
role: solicitor
worktree: dispatches/solicitor--5f7b35/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/235100Z-result-solicitor-07b99e.md
  - entries/2026/05/22/235854Z-result-fixer-e0df18.md
---

Design-panel round 2 verdict on PR #358 (`design(daemon): importLocation from EndoMount with npm-registry-proxy + Go-like MVS`): **terminating**.

Panel kind: design-panel (paths: `designs/README.md`, `designs/daemon-worker-import-from-mount.md`; round-2 HEAD `193846c93`).
Panel execution: in-band-fallback (ToolSearch returned no `Agent` / `Task` tool).

Panel-hints output verbatim:

```
Panel-kind: code-panel
[...path-triggered fan-out from llm-base divergence...]
Recommended total: 28 of 26 code-panel seats (+ 2 cross-panel).
```

The script's diff-against-base picked up many non-PR paths (the local `llm` ref is far behind HEAD; PR's actual diff via `gh pr diff 358` is the two design files only). Solicitor overrode to `design-panel` per `roles/judge/AGENT.md` § Panel-kind discrimination; this is the same override the round-1 solicitor recorded and the same self-improvement lesson stands (`panel-hints.sh` should prefer `git diff <merge-base>..HEAD` or `gh pr view --json files` when the base branch is far behind).

All seven design-panel seats re-fired in-band (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice). No overrides; the wholesale-7 design-panel applies.

Verdict: **approve** (terminating). Formal review submitted via `gh pr review 358 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel-358-r2.md` at 2026-05-23T00:04:41Z (the `--comment` fallback applies per `skills/panel-review/SKILL.md` § Pitfalls because the gh-authenticated identity `kriscendobot` is also the PR's author; `--approve` would return the `Review Can not approve your own pull request` GraphQL error). Body length 13221 bytes / ~1688 words; design-panel typical range is 900-1400, round 2 ran longer because the per-finding verification of 22 summary-fix items adds verification prose.

Disposition counts (round 2): 0 must-fix-loop, 0 summary-fix, 0 follow-up (new), 0 acknowledge (new), 0 drop. All round-1 dispositions stand:

- 2 round-1 must-fix-loop: verified addressed by fixer commit `193846c93` (per `entries/2026/05/22/235854Z-result-fixer-e0df18.md`).
- 22 round-1 summary-fix: verified addressed by the same commit (the fixer folded the bundle directly into the design markdown, which is the appropriate shape for a design-only PR).
- 5 round-1 follow-ups: parked on `projects/endo-but-for-bots/followups/endo-but-for-bots--358.md` since round 1.
- 7 round-1 acknowledges: stand as recorded.

Per-finding verification (round-2 read of `193846c93`):

- **Must-fix #1 (URL disambiguation)**: lines 446-449 carry the new `endo-mount:/node_modules/<name>@<version>/<relative-path>` pattern; lines 471, 485-489 key/lookup by `nameAtVersion`; lines 503-525 walk the descriptor-walk authoritative-source paragraph and the multi-major worked example.
- **Must-fix #2 (Phase 5 multi-major test)**: lines 829-855 carry the multi-major coexistence test and the paired caplet snapshot lifetime release test.
- **Summary-fix bundle (22 items)**: spot-verified in the panel body's per-finding list; representative sample includes `@registry` migration policy (lines 671-684), worker-side sharing shape (lines 166-178), MVS terminology (lines 575-582), failure-surface `@endo/errors` classes (lines 350-371), `makeFromMount` host dispatcher (lines 226-251), inline algorithm step (lines 519-525), Summary glosses (lines 17-26), `thisDiesIfThatDies` gloss (lines 629-632), Open Questions 7-9 (lines 966-993), Phase 6 deviation preamble (lines 857-867). All verified.

Post-loop actions per `roles/solicitor/AGENT.md` § Operating norms § Post-loop actions before un-draft:

1. **Disposition-tagged review submitted** (above).
2. **Summary-fix job**: not posted; zero summary-fix dispositions this round (the round-1 bundle was addressed by the fixer commit, not deferred to a job).
3. **Followup ledger**: not appended; zero new follow-up dispositions. Existing ledger at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--358.md` continues to carry the 5 round-1 items with `status: parked`.
4. **Gardener message**: not written; zero new `[proposed-rule]` tags this round (the round-1 panel routed 6 proposed-rule tags to the gardener via `entries/2026/05/22/235309Z-message-solicitor-1ce558.md`; none of those rules need a fresh message and the round-2 read produced no new proposed rules).
5. **`gh pr ready 358`**: ran successfully at 2026-05-23T00:05:00Z; PR is `isDraft: false`, `state: OPEN`.

The orchestrator (general-contractor in this dispatch's framing) may dispatch an `appellate` between steps 4 and 5 to appeal small-and-in-context `follow-up` or `acknowledge` items into `summary-fix` before un-draft. The follow-ups in this case are all implementation-PR-time items (workspace protocol resolution, Yarn PnP, resolver callback boundary, Summary skimmability pass, family rename pass); none feel small-and-in-context enough to appeal. The acknowledges are taste-level. The solicitor proceeded to step 5.

Cross-link backfill: not applicable (no upstream mirror yet; this is a fork-side design PR).

Operational notes:

- The dispatch sub-worktree (`/home/kris/dispatches/solicitor--5f7b35/project`) was initially at the pre-fixer commit `9ac8f99c6`; `git fetch origin design/daemon-worker-import-from-mount` followed by `git checkout 193846c93` brought the read to the round-2 document. Same lesson as the round-1 solicitor's note and the recent round-2 solicitor on PR #322: fetch the branch you are about to read before reading.
- The known race (parent `/home/kris/journal` worktree reset every 30s) did not interfere; the sub-worktree at `/home/kris/dispatches/solicitor--5f7b35/journal/` is detached and isolated.

Self-improvement: nothing this time. The panel-hints `code-panel` false-positive on a far-behind base branch is a known lesson (already routed in the round-1 solicitor result entry and pending the gardener's `panel-hints.sh` revision); the round-2 occurrence is a second data point for the same rule, not a new lesson. The summary-fix-bundle-folded-into-the-design pattern (the fixer landing all 22 items in one commit rather than a separate job-board summary-fix job) is the correct shape for a design-only PR where every summary-fix item is a document edit; this is a structural observation that may be worth recording on `skills/panel-review/SKILL.md` § Dispositions but it follows directly from the existing rubric (`summary-fix` items defer one round; on a design PR they collapse to "address them on the must-fix-loop's follow-up commit"). Threshold per `skills/self-improvement/SKILL.md`: not load-bearing for the next reader (the current rubric already accommodates this; the observation is one of the rubric's correct applications).
