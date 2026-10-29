Un-draft stage for endojs/endo-but-for-bots#1583 ("docs: reconcile hardened text codec supersession") is done: the PR is now ready for review.

**Gate:**
- **Before the change:** fresh metadata showed state OPEN, `isDraft=true`, head `82de63bdb4f65cbff15c83f6177274b5274789b5`. That is exactly the head the panel passed.
- **Change:** I ran `gh pr ready` on the PR.
- **After the change:** it now shows `isDraft=false` and the head is still `82de63bd…`.

**Advisory appellate pass** (a short `claude -p` review; it did not block the un-draft). The PR touches only two files, `designs/README.md` and `designs/hardened-text-codecs-shim.md`. It flagged these for the maintainer:
- **Status wording disagrees.** The design header says "Implemented; XS smoke coverage remains", while the README says "Implemented" and "core implemented". The "(Phases 1-2)" qualifier was dropped from all of them.
- **Bare reference.** The README prose mentions `#1349` without a link and doesn't say which repo it belongs to.
- **Lost cross-reference.** A pointer to "§ Sampling and degradation" and "Design Decision 3" was removed. Other docs in `designs/` may still describe #1349 as an open draft.
- **Claims a reviewer can't check from the diff alone:**
  - commit `679d9afaa4` and #3376 landing on 2026-10-29
  - #3377 being the closed upstream mirror of #1349
  - #1425 owning the XS lockdown repair
  - the list of Chromium versions
  - the `cauterizeProperty` description and whether it matches the code on `llm`
- **Possibly stale snapshot.** The Phase 3 audit still cites `llm` commit `7ff30afbce` and "16 call sites", although the "Updated" stamp moved to 2026-10-29.
- **Created date mismatch.** The README prose says "added 2026-05-06", but the table and the design header say 2026-05-04. This predates the PR.
- **Untracked follow-up.** The follow-up that would keep only the XS assertions has no job or issue tracking it.

No other follow-ups.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1583-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (231251 cached reads)
- Output: 1607 tokens
- Cost: $0.4310622
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
