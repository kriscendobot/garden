Inbox empty. The job is complete — verified end-to-end, committed, and pushed to `main2`.

---

## Completion report — improve-gh-wrapper-fail-closed-on-writes

**Change (pushed to `main2` as `2cc7b92172`):**

**`scripts/jobs/bin/gh`** — the token-resolution fallback (GH_TOKEN unset AND `gh auth token --user <id>` unresolvable) now **fails closed on writes** instead of exec'ing the real gh as the global active account:
- Added `gh_is_write()` — matches state-changing invocations: `pr create|comment|review|merge|edit|close|reopen|ready|lock|unlock`, `issue create|comment|edit|close|reopen|delete|lock|unlock|pin|unpin|transfer`, `release create|edit|delete|upload`, and mutating `api`.
- Added `_gh_api_is_write()` — treats `-X/--method` ≠ GET/HEAD as a write and any field flag (`-f/-F`) with no explicit read method as a write (the reactji/comment `-X POST … -f content=` shape); consumes value-bearing flags so a header/jq value can't be misread; **carves out `gh api graphql`** as a read so the mirror-pr-state / mirror-closer graphql pollers keep degrading rather than fail-closing.
- The fallback branches three ways: token resolves → inject (unchanged); token fails + **write** → loud `kind:error` message naming the unresolved identity, `exit 1`, real gh never exec'd; token fails + **read** → tolerant degrade-to-bare-gh (unchanged). The boatman's explicit `GARDEN_GH_IDENTITY` / pre-set `GH_TOKEN` paths never enter this fallback — authorized-ferry surface preserved.

**`scripts/jobs/test/gh-wrapper-fail-closed-test.sh`** — new hermetic regression test, **49/49 passing**: writes fail closed (real gh never runs, incl. reactji/POST/PATCH/DELETE shapes), reads degrade (incl. `api` GET, `-X GET -f`, graphql, view/list, auth status), token-resolved write injects+execs, pre-set `GH_TOKEN` passes through. Lint-clean (`bash -n`, `shellcheck -S warning` on the wrapper).

**Two bugs found and fixed during resume verification** (the test hung/misfired in the interrupted session):
1. The inherited fleet PATH carries the **deployed** wrapper, so the test's `type -aP gh` self-skip picked that other wrapper copy → infinite recursion. Fixed by stripping `scripts/jobs/bin` entries before prepending the fake.
2. The fleet `/tmp` is **noexec**, so the fake `gh` placed there was invisible to the wrapper's executability search → the wrapper fell through to the **real** `/usr/bin/gh`, whose live bot token resolved, and the write subtests **fired real mutations on kriskowal/garden**. Fixed by basing the fake on an exec-capable filesystem ($HOME) with a noexec self-probe, plus an empty `GH_CONFIG_DIR` safety net so a future resolution regression can never authenticate as the bot.

**Remediation of that real-GitHub damage (fully reverted):** reopened PR #7 (the buggy run had closed it), deleted the two stray "hi" comments (on #5 and #7); confirmed no stray issues/PRs were created (the `create` calls had failed without side effects). Repo state restored to pre-test.

**Follow-ups:** none required. The wrapper's normal path (bot token resolves → inject) is unchanged and smoke-tested (`gh api user` → `kriscendobot`). Heads-up for the record: PR #7 on kriskowal/garden was momentarily closed and reopened by the test-setup bug above, now remediated.
