Fix round 1 for endojs/endo-but-for-bots PR #1574 is pushed and CI is green. One should-fix item, trimming the PR body, is not done: this host's token gets a 403 when it tries to edit PRs on endojs.

**What I applied.** There was no pre-pass block, so I worked from the latest panel verdict (review 5662429777, "Must-fix before merge", eight seats). The commit is `a4afa2b12`, pushed with `safe-push-pr-head.sh` (`2ea0389b9 → a4afa2b12`). It changes `designs/api-key-agent-workbench.md` and `designs/README.md`. Everything is in the design doc unless noted.

- **Skeptic must-fix 1 (no named lock for "atomic admission"):** the chain check now runs inside the parent design's existing per-provider admission step. Every grant in a tree shares one provider, so concurrent siblings are serialized there. Ancestor sums are computed from the ledger rows. A running counter is allowed only as a cache that can be rebuilt from the ledger.
- **`grantPath` (copyeditor 5):** it is now stored as `gRoot/gB/gC/`, so "this row belongs to ancestor `a`" is a true prefix match.
- **`pause` (decomplector 1, skeptic 2, critic 3):** `pause` now writes one fact, the grant `state`, and leaves wake alone. Deferrals caused by a pause don't count toward the parent's eight-attempt limit, but its 72-hour expiry still applies. The normal retry backoff also re-checks admission. A pause holds no reservations, and paused time is not credited back. `askSubagent` returns `deferred` plus a `blockedBy` code to the parent.
- **Revocation (decomplector 2, critic 4):** the grant's state alone decides admission; the generation counter is only the parent design's cache invalidation. The doc now states the invariant the reconciler restores after a crash mid-cascade: no live agent record has a deleting or deleted ancestor.
- **Refused vs. clamped (copyeditor 1, critic 2):** `spawn` and `resize` both refuse limits above the parent's. Children's records are not rewritten. `getStatus()` reports `recordedLimits` and `effectiveLimits` (the smallest value along the chain).
- **Copyeditor 2 and 3:** the endowment picker is now worded as a proposal. The "a child never holds more than its parent" claim now names the spawner exception and says equal authority is allowed.
- **Pedant 1:** em-dash table cells are now `n/a`.
- **Archivist 1–4:** fixed the `§` references with real anchors, fixed the hashline header claim, and corrected the parent-section names.
- **Should-fix and comment items:**
  - `endow` is split into `add` and `mint`.
  - `ChildLimits`, `BudgetReading` and `DelegationSummary` are defined; omitted limits inherit the parent's.
  - A spawn is idempotent on (parent, name), so the caller-supplied key is gone.
  - Refusals are thrown errors with a `.code`.
  - `stop` is marked as a deprecated alias of `revoke`.
  - `list()` keeps Fae's names-only return, and a new `listDelegations()` returns summaries.
  - Renamed `editHashline` to `editHashlines`.
  - `pause` is justified against "resize to zero".
  - W6 is gated on open question 3; W2 builds against a temporary mount.
  - The spawn-then-revoke cost is noted, and the forbidden-endowment list is called defense in depth.
  - Typo and wording fixes: `glob` doesn't take regexes, "follower", "reattach", `⊂`, and unlabeled numbers.
  - Text is one sentence per line, with bold lead-ins.
  - Design Decisions 1, 2, 3 and 5 are deleted, plus the paragraph that restated the ownership-map table.
  - Removed the defaults from open question 1, the glorp process note, and the tally from the README pass note.

**Follow-up: PR body.** `gh pr edit` failed with "Resource not accessible by personal access token". Someone on a host that can write to the endojs PR (such as `endolin-garden-ece02cb4`) needs to shorten the body to about 200 words. That means replacing the Description bullet tour and the open-questions list with pointers to the design, and merging the Compatibility and Upgrade sections. Leave the `<!-- garden-job: design-claude-api-agent-workbench-20261027 -->` marker in place. The draft text was in `/tmp` and will not survive this run.

**CI:** `ci-wait-merge.sh --no-merge` exited 0, with 30 of 30 checks passing.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2261964 cached reads)
- Output: 26369 tokens
- Cost: $1.8602608000000003
- Wall-clock: 1762s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
