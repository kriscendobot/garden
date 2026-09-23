Pushed cleanly to `main2` (HEAD == origin/main2). Done.

---

## Completion report

**Job:** Simplify leader election to `journal/leader` + `GARDEN` (kriskowal directive, 2026-06-29). Landed on `main2` as commit `5bafb2ef7`.

### What changed (the simplification)
- **Leader marker → `journal/leader`.** A single file at the journal root holding the leader's `GARDEN` identity, decoupled from the `hosts/<host>` heartbeat filenames. Was `hosts/main-host`.
- **Host identity → `GARDEN`** (default `hostname -s`). The internal alias `GARDEN_HOST` is **removed everywhere** — every script now uses the one `GARDEN` var (journal index key, claim metadata, heartbeat key, and the leader comparand).
- **Predicate:** `is_main_host()` (name kept) now reads `leader` and is leader **iff `leader == $GARDEN`**; empty marker ⇒ fail-open leader (single-host unchanged). `main_host()` renamed to `leader_host()`.
- **`GARDEN_MAIN_HOST_*` family → `GARDEN_LEADER*`:** env override `GARDEN_LEADER`, plus `_MARKER_PATH` (`leader`), `_CLONE`, `_CACHE` (`$GARDEN_STATE/leader/cached`), `_TTL`, `_DEFAULT`. The TTL cache is preserved (it keeps per-tick ExecConditions off the journal).

### Consumers converted (61 files)
`common.sh`, `set-main-host.sh` (now CAS-writes `leader`, commit msg `leader=…`), `set-gardeners.sh`, `is-main-host.sh`, all 13 leader-only unit comments, every `$GARDEN_HOST` commit-message/heartbeat site across the jobs scripts, the driver + watcher + skills helpers, and the docs (`CLAUDE.md`, `README.md`, `designs/multibot-leader-follower.md`, `designs/README.md`, `roles/liaison/AGENT.md`). Script **filenames** `is-main-host.sh`/`set-main-host.sh` were kept (renaming them is gratuitous churn to 13 ExecConditions and adds nothing; the predicate name `is_main_host` is the directive-mandated keep).

### Tests / grep-gate
- `scripts/jobs/test/main-host-test.sh`: **38/38 pass** — asserts leader iff `leader == $GARDEN`, empty ⇒ leader, follower skips, set-main-host flips, TTL cache, all-13 ExecCondition gating.
- `run-test.sh` **SUBTEST 28 passes** (full leader/follower set).
- **Grep-gate is clean:** no `GARDEN_HOST`, `GARDEN_MAIN_HOST`, or `hosts/main-host` remain anywhere (verified tree-wide).
- The full `run-test.sh` reports 237 passed / **4 failed, all in SUBTEST 26 (ISSUE INBOX)** — those scripts (`issue-inbox-watcher.sh`, `issue-source-gh.sh`) are **byte-identical to base** (never in my diff) and the failures are pre-existing gh-fixture/`out:`-empty issues unrelated to this change. SUBTEST 26 had `jq` present (not the jq hazard).

### ⚠️ Cutover note (for the liaison's drain + upgrade)
This is code on every leader-gated unit, so a **restart is required**. After `main2` deploys to the root checkout via the deliberate-deploy path (drain → merge → restart fleet):

1. **Set the new marker to the live host:** `scripts/jobs/set-main-host.sh endolinbot2`
   - I verified read-only against the live journal: the systemd manager runs `GARDEN=endolinbot2`; `hosts/endolinbot2` heartbeat is fresh (2026-06-29), `hosts/endolinbot` is 5 days stale (2026-06-24); `leader` is absent. So **`leader` must be `endolinbot2`** — the live host with the fresh heartbeat.
2. **Remove the stale old marker** from the journal: delete `hosts/main-host` (now unused) and commit/push to `journal2`.
3. Restart sequence is the standard deliberate-deploy fleet restart (`deploy-garden.sh`), which re-execs every singleton onto the new code; `is_main_host` then re-evaluates on the next tick and the 13 dormant singletons (foreman, proxy, issue-inbox, comment-watcher, deadmail, reaper, follow-up, scheduler, triager, mention-watcher, mentor, mirror-closer, library-source-drift-scan) promote on `endolinbot2`.

Note: even before step 1, the empty `leader` marker fail-opens to leader on a single live host, so the singletons would promote on `endolinbot2` regardless — but writing `leader=endolinbot2` makes it explicit and correct for any future second host.

**Follow-ups:** none required. The 4 pre-existing SUBTEST 26 failures are a separate issue-inbox/gh-fixture defect worth a future job but out of scope here.
