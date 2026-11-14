Shepherd report for endojs/endo-but-for-bots PR #1596 (draft, M3 `mvs-resolver`)

The failing zizmor check is not caused by #1596, so I left the PR alone. The fix is already open as #1659, and I parked a weave of #1596 that starts when #1659 merges.

**What's wrong:** zizmor is the only red check on the PR. Every other check passed or was skipped. zizmor v1.31.1 flags `ref-version-mismatch` at line 49 of two workflow files:
- `.github/workflows/update-action-pins.yml`
- `.github/workflows/update-action-pins-major.yml`

Both pin `peter-evans/create-pull-request@5f6978faf0…` with the comment `# v8`. That sha is v8.1.1, but the floating `v8` tag has since moved to v8.1.3 (`3ffccacd`), so the comment no longer matches. #1596 changes only `packages/exo-npm/*`, `designs/*` and a changeset; it touches no workflow files. Live `llm` has the same two lines, so every PR on that base sees this red.

**The fix:** https://github.com/endojs/endo-but-for-bots/pull/1659 changes both comments to `# v8.1.1`. It is green, mergeable and not a draft, and it waits on the maintainer to merge it. I did not copy the fix into #1596; it is unrelated to the M3 change and would duplicate #1659. The #667 shepherd made the same call earlier today.

**Follow-up:** I parked `weave-endojs-endo-but-for-bots-pr1596-after-pr1659` on the plan board, blocked on #1659. It runs when #1659 merges or closes. It will check that `llm` has the corrected comments, weave #1596 onto a fresh frozen base, and drive CI to green with the PR kept as a draft. If #1659 closes without the fix landing, it messages the maintainer instead.

**Maintainer action:** merging #1659 clears zizmor on every PR based on `llm`, including this one.

No commits to the garden or to #1596.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1596.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (695009 cached reads)
- Output: 4404 tokens
- Cost: $0.6854817999999999
- Wall-clock: 736s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
