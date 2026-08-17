Everything is verified and complete. The fix was already committed to `origin/main2` at HEAD (`544355d714`) — this job was requeued/resumed after an earlier attempt landed the work but never recorded the completion signal. I confirmed all deliverables are present and correct rather than redoing landed work.

Report:

---

**Job: self-heal comment-watcher crash-loop on Issues-disabled repos**

**State found:** The complete fix was already committed at `HEAD == origin/main2` (`544355d714`, "fix(comment-source): degrade Issues-disabled repos to a per-PR walk, not a crash-loop"), working tree clean. This is a resumed attempt — the prior run landed the code + tests but never emitted the completion signal, so the board requeued it. I verified all three required deliverables are present and working rather than re-authoring landed work.

**Deliverables confirmed present in `scripts/jobs/handlers/comment-source-gh.sh`:**
1. **ISSUES-DISABLED degrade** (lines 137–201): surface 1's definitive-404 failure path reuses the `*"Not Found"*|*"HTTP 404"*|*'"status":"404"'*` matcher, probes `repos/<repo> --jq .has_issues` once, and only on `false` sets `issues_disabled=1` + logs once — *not* a fetch failure. Transient signatures, `has_issues=true`, and an unreadable probe all fail CLOSED (freeze-and-retry). Probe runs only on the already-failed path.
2. **Per-PR PR-comment fallback** (lines 273–295): in `issues_disabled` mode, section 3's activity-bounded open-PR walk fetches `repos/$repo/issues/<n>/comments?since=...` per open PR, emitting the same `pr-comment` TSV rows with identical since/self-drop/`test("/pull/")` logic; a genuine failure there sets `fetch_failed` (LOST-FETCH invariant intact).
3. **Regression coverage** in `scripts/jobs/test/comment-watcher-test.sh` (ID family, lines 1673+): ID1 = 404 + `has_issues:false` → exit 0, `pr-comment` row surfaced via per-PR walk, cursor advances, no freeze; ID2 = 404 + `has_issues:true` → still exit nonzero/freeze; ID3 = transient 5xx + `has_issues:false` → freeze, never probes; ID4 = `has_issues:false` but a per-PR call fails → freeze/exit 1.

**Verification run:**
- `comment-watcher-test.sh`: **325 passed, 0 failed**.
- `gh api` confirms `kriscendobot/cosgov` → `has_issues:false, fork:true, open:0` and `kriscendobot/endo` → `has_issues:false`.
- `comment-source-gh.sh kriscendobot/cosgov` (0 PRs, issues disabled): logs `ISSUES DISABLED`, **exits 0**, emits nothing — no crash-loop.
- `comment-source-gh.sh kriscendobot/endo` (open PRs, issues disabled): **exits 0**, enumerates normally (0 rows only because its single open PR predates the activity window — correct behavior, no failure).
- Unit `garden-comment-watcher@kriscendobot-cosgov` on this host (`endolin-garden-ece02cb4`, a follower) is exec-condition-skipped (leader-gated); recent journal shows no exit-1 failures. The landed fix eliminates the crash-loop wherever the watcher runs; it reaches deployed roots via the deliberate-deploy path.

**Changes made this attempt:** none needed — code, tests, and behavior were already correct and committed. Nothing to commit or push.

**Follow-ups:** none. The 12 latent Issues-disabled watch repos (agoric-3-proposals, agoric-sdk, cosgov, endo, endo-but-for-bots, list, moddable, ocapn, proposal-compartments, test262, vattr97, ymax-stdio-mcp) are all covered by this degrade once the fix is deployed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-cosgov-issue-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 15 tokens (427072 cached reads)
- Output: 4988 tokens
- Cost: $0.839483 (1 engagement(s) unpriced)
- Wall-clock: 138s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
