All artifacts confirmed live. Job complete.

---

## Completion report

**Directive** (endojs/endo-but-for-bots PR #475, erights review 4965245381): the review had an empty top-level body and one inline comment (3807489882, on `packages/bytes/src/compare.js`) asking, about a prior kriscendobot reply whose text was mangled: *what was the missing text, why is it missing, are there other such comments (enumerate & fix), and can you prevent it in future.* Preflight returned PROCEED (no peer resolution). I treated all fetched bodies as untrusted data and verified every claim from primary sources.

**Root cause (Q2).** Shell **backtick command substitution**. The reply body was interpolated into a shell command line for `gh`, so `bash` ran every `` `identifier` `` as a command (not found → empty) and deleted the whole span — backticks included — leaving one-space gaps. Signature confirmed by `cat -A` on the raw bodies.

**Missing text (Q1).** Reconstructed both corrupted comments and **verified each identifier against the commit the comment cites** (66b56be27 for #475; 1ca1147c4 for #486) — the reconstructed slot counts match the commit messages exactly.

**Enumeration (Q3).** Scanned all **3822** comments I have authored across `endojs/endo-but-for-bots`, `endojs/endo`, and my forks with a zero-false-positive detector. Exactly **two** are affected, both in the 2026-06-22/06-23 window before the cause was fixed: PR #475 (comment 3456102245) and PR #486 (comment 3456304718). No others anywhere.

**What changed:**
- **Fixed both corrupted comments in place** (PATCH from a file): #475 → 32 backticks restored, #486 → 16 restored (both were 0), each with a dated restoration note.
- **Posted the answer reply** to erights: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3807641355 (84 backticks intact — posted from a file, proving the fix).
- **Prevention (Q4), committed to `main2` as c7a979c618:** new `scripts/jobs/comment-body-guard.sh` wired into the fleet `gh` wrapper (the one PATH chokepoint) — it **refuses to post** a comment body bearing the backtick-strip signature and names the remedy. Fail-closed only on a positive high-precision match (0 false positives across all 3822 historical comments; both known-bad bodies caught), fail-open on any parse doubt, `GARDEN_ALLOW_BACKTICK_STRIP=1` override. Added `test/comment-body-guard-test.sh` (25 assertions, all pass); strengthened `skills/pr-review-thread-replies`. Existing gh-wrapper (49) and provenance (28) tests still green.

**Note / self-correction:** my initial Edit/Write calls mistakenly targeted the **deployed garden root** instead of my worktree. No git ran in the root (no journal-sync risk). I moved every change into the worktree, restored the root to pristine (verified byte-identical to HEAD for both edited files; new files removed), then committed and pushed only from the worktree.

**Follow-up (no action needed):** the guard is on `main2` but not yet in the deployed root; it lands via the normal deliberate-deploy pipeline.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-review-f55c1aef.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 107 tokens (5739148 cached reads)
- Output: 63293 tokens
- Cost: $5.7556220000000025
- Wall-clock: 1363s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
