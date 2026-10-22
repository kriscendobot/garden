## Gauntlet FIX round 1: endojs/endo-but-for-bots PR #1539

I applied the panel-1 must-fix items in one follow-up commit, pushed it to the PR head, and CI is green (30 checks, 0 failed, `ci-wait-merge` rc 0).

**Source of the fixes:** there was no pre-pass block in the job, so I worked from the latest panel review (5619172368, "Must-fix before merge"). Six seats asked for changes: critic, skeptic, decomplector, ergonomist, copyeditor, pedant and novice. Before writing, I checked each finding against the live guards and the git and PR history.

**Commit `5152b05aa`** on `kriscendobot/endo-but-for-bots:docs/fs-interface-consolidation-status`, pushed with `safe-push-pr-head.sh` as a fast-forward from `155355ce4`:

- **`designs/fs-interface-consolidation.md`**
  - **Blob API (critic, skeptic):** C4, the result-shape table, the inventory and the checklist now describe the API that actually ships. That is `sha256()` (base64), `size()` and `bytes()` from `rangeReadMethodGuards`, plus `byteRange()` and `textRange()` from `rangeAttenuationMethodGuards`, bundled as `ReadableBlobRangeInterface`. The doc now says plainly that the `getInfo()`/`fetch(offset, length)` pair from PR #467 was replaced by PR #1301.
  - **Unsupported "verified" claim (skeptic):** the statement that entry-as-path "was verified" is now given as compatibility reasoning, and the doc says no run measured the breakage.
  - **C1 decision (decomplector, ergonomist, pedant, novice):** C1 now says which option shipped, and it is option (b). `EndoMount` overrides `lookup` and `maybeLookup` with `PathArgShape`, so a `MountEntry` can be passed directly to `lookup`. The draft's recommendation of (a) is kept only as history. The "Canonical shape" design decision was rewritten to match.
  - **Credit to the right PRs (decomplector):** a new "Delivery history" section records what each PR delivered: #467, then #277 (live `followNameChanges`), #643 (contract alignment), #713 (commit `2cb917473`) and #1301.
  - **Tense and wording (copyeditor, pedant):** the C2–C5 sections, Sequencing (now titled "historical") and "No big-bang" are in completed past tense. The awkward completion sentence was rewritten as the copyeditor suggested. New prose uses no em dashes, and "C1–C5" with an en dash became "C1 through C5".
- **Linked designs (ergonomist):** `namehub-interface-unification.md` and `filesystem-watchers.md` were marked Complete, with notes pointing to the delivering PRs and to § C1. Both were already listed as Complete in `designs/README.md`.

**Checks run:** `thesaurus-cliche-grep` and `orthographer-divergence-grep` against `origin/llm-d5ac419` both came back clean.

**Follow-ups (not done in this round):**
- `designs/readableblob-range-attenuation.md` still says "Proposed" (the README says "In Progress"), even though step 1 shipped in #1301. I left it alone as outside this PR's must-fix scope.
- The thesaurus seat could not check the PR title and body in panel-1. That finding was comment-only, and panel-2 will re-run it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1539-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3491805 cached reads)
- Output: 21313 tokens
- Cost: $1.9092370000000003
- Wall-clock: 1193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
