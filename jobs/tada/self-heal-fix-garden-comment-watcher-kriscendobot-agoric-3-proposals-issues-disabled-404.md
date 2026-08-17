Inbox empty. The work is complete and pushed to main2.

## Completion report

**Situation on arrival:** The core fix this job asks for had *already* been implemented — but by **multiple** independent gardeners whose commits all landed, creating a real defect. `544355d` and `cb00b99e` each added the Issues-disabled 404 recovery, and the reconciliation kept **both** per-PR enumeration blocks, so every `surface=pr-comment` on an Issues-disabled fork was emitted **twice per tick**. I verified this empirically with a stubbed `gh` (comment `770001` emitted 2×, rc=0) — the existing `grep -q` tests couldn't see it.

**Concurrent landing:** While I worked, a third gardener (`d7cfcc6`) pushed the primary dedup — removing the duplicate block and adding exact-count assertions to the ID1/IDIS test families. Rather than duplicate that, I reset onto their commit and kept only my **unique, still-unaddressed** contributions.

**What I landed (`414954d25e` on main2):**
1. **Collapsed the redundant surface-1 `has_issues` re-probe.** The `else` branch re-probed `repos/<repo>.has_issues` a second time, duplicating the authoritative check `repo_issues_disabled` (the `elif`) already performs — a dead/redundant path contradicting the "probe once" discipline. Now a plain `note_fetch_failure` (every `else` case is a genuine lost fetch → freeze; a gone repo still reaches REPO-GONE).
2. **Removed the duplicate `issues_disabled=""` declaration** (kept the one grouped with the other fetch-state flags).
3. **Requirement 4** — annotated `fork-watch-provisioner.sh` (header + the auto-provisioned comment arming record's rationale) with the `has_issues:false` fork case: arming is correct as-is because the source degrades, so no `has_issues` gate at arming time; the note just stops the next reader being surprised by the repo-wide 404 in the journal blob. Sender-gate semantics untouched.

**Verification:** `bash -n` clean on both files; no dangling variable refs. `comment-watcher-test.sh` **334 passed, 0 failed** (includes ID2/ID3/IDEN confirming my `else` simplification preserves the freeze-on-`has_issues:true` and freeze-on-transient-without-probing behavior); `fork-watch-provisioner-test.sh` **55 passed, 0 failed**.

**Net state of the four job requirements on main2:** (1) authoritative `has_issues` classification — ✅ landed + hardened; (2) per-PR `pr-comment` fallback, single clean block — ✅; (3) regression tests incl. exact-count and the 404/has_issues:true/repo-gone cases — ✅ (via `d7cfcc6` + pre-existing); (4) provisioner note — ✅ landed by me.

**Follow-ups:** None. No inbox messages. Worth noting for the fleet: this job was worked by ~4 overlapping claimants — a symptom of the same automatic-dispatch job being served repeatedly; the duplicate-landing it caused is now cleaned up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-agoric-3-proposals-issues-disabled-404.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 119 tokens (6521317 cached reads)
- Output: 46073 tokens
- Cost: $5.643608500000003
- Wall-clock: 930s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
