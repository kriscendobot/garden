The fix-round push is up and CI is green on the new head (`e8f163e01`), but two review items couldn't be finished from this host and one was deliberately skipped.

A concurrent fix run had already pushed three commits (`e405bbe6c`, `6d65d5d1e`, `dbf3a3fd2`) at 18:29Z, just before I claimed this job. They cover most of the round-2/3 must-fix items:
- **Missed call sites:** bare strings still passed to `adopt`, `send` and `evaluate` in fae, jaine, chat, space-whylip and the file explorer are now wrapped as paths (assessor, migrator).
- **Stale types and docs:** `ReadableNameHub.lookup`/`maybeLookup` narrowed to arrays and the help text regenerated (surfacer). The remaining `OrPath` names are renamed in `types.d.ts`, `host.js` and `interfaces.js` (stylist, purist). Old JSDoc and `@returns` types are fixed (archivist, typist), and the two long comments are shortened (pruner).
- **Changeset:** `@endo/sandbox` and `@endo/agentry` now get major bumps (changeset-auditor).

I checked the stylist's `petNameOrPath` finding in `packages/lal`: none of those names remain there or in daemon source.

**My commit** (`e8f163e01`, pushed with `safe-push-pr-head.sh` on top of those commits, nothing rewound):
- `packages/daemon/test/endo.test.js`: the new "bare-string guestName still revives" test uses `database` instead of `db` (stylist), reformatted with prettier.
- `packages/daemon/test/channel.test.js:1833-1834`: `→` changed to `->` in the rewritten comment (typist).

**CI:** `ci-wait-merge.sh --no-merge` returned 0, with 7 checks and 0 failures. The only jobs that actually ran on this draft head were change detection and zizmor; build, sanitizers and the guile interop job were skipped.

**Not done:**
- **PR description (integrator):** I drafted text explaining why the mount and `@endo/platform` fs guard stays string-or-array, and saying how this PR relates to #1343. `gh pr edit` failed with "Resource not accessible by personal access token" (the known PR-write limit on this host), so the description is unchanged. The PR also still has no linked follow-up issue for that platform work. This needs a job pinned to `host=endolin-garden-ece02cb4` or a maintainer.
- **Summary comment (scribe):** no fix-summary comment was posted, for the same reason.
- **Commit history (integrator, should-fix):** I did not regroup the 40+ sweep commits into one commit per package. That is a history rewrite; a `retcon #1390` job is the right tool.
- **Other should-fixes left open:** the platform `ReadableTree`/`Mount` guards still accept strings, and there is no table-driven test that every `NamePathArgumentShape` position rejects a string (purist). The `lal` primer (`primer/tools.md`) is unchanged (surfacer, weak signal).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 54 tokens (1639838 cached reads)
- Output: 7813 tokens
- Cost: $0.9949315999999998 (1 engagement(s) unpriced)
- Wall-clock: 8086s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
