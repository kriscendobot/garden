The job is complete. All requirements are satisfied on `origin/main2`.

## Completion report

**Situation on claim.** This job had already been claimed and worked by several concurrent gardeners, whose commits landed on `main2` while I worked (`544355d`, `cb00b99e`, `d7cfcc6`, `414954d`). The Issues-disabled crash-loop was functionally fixed, but the collision left residual defects and one unmet spec point. My role became verification + reconciliation of the tail.

**What I verified was already correct on `main2`:**
- **Req 1 (narrow confirmation):** a definitive 404 degrades only after `repo_issues_disabled` authoritatively confirms `has_issues:false`; a 404 with `has_issues:true`, a transient blip, or any non-404 error still freezes the cursor (LOST-FETCH intact).
- **Req 2 (per-PR fallback):** the section-3 open-PR walk recovers `surface=pr-comment` per open PR via `issues/<n>/comments`, reusing the existing open-PR list, with the same `since`/`$bot`/`/pull/` classification and `note_fetch_failure` guard.
- **Req 4:** the dependency note exists in `issue-source-gh.sh` and in `fork-watch-provisioner.sh`'s arming rationale.
- **Req 5 (regression tests):** the `ID1`/`ID2` and `IDIS`/`IDEN` families cover both required cases, with exact-count assertions guarding the double-emission.

**What I found and contributed:**
1. **Caught the double-emission bug** the two colliding fixes introduced (each recovered PR conversation comment emitted twice) and proved it against a stub — a concurrent commit (`d7cfcc6`) landed an equivalent fix + count assertions before my push, so the tree converged.
2. **Delivered the last unmet spec point (Req 3): WARN-level logging.** Every prior commit left the degrade at INFO (`<6>`); my commit **`745fa90891`** prepends `WARN:` so `log()` escalates it to syslog `<4>`, keeping the degrade greppable in the journal. Message text unchanged, so the `ID`/`IDIS` greps still match — **334 passed, 0 failed**.

**Verification:** `bash -n` clean; `comment-watcher-test.sh` 334/0; `gh-api-retry-test.sh` 47/0; `comment-provenance-test.sh` 28/0. Pushed and confirmed on `origin/main2` (`745fa90891`).

**Follow-ups:** none. The crash loop is resolved fleet-wide for every `has_issues:false` auto-provisioned fork.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-agoric-sdk-issues-comments-404.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 113 tokens (6959944 cached reads)
- Output: 45724 tokens
- Cost: $6.0541149999999995
- Wall-clock: 1070s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
