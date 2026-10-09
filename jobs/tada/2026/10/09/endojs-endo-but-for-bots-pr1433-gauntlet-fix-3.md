# Gauntlet fix round 3: endojs/endo-but-for-bots PR #1433

I applied the round-3 panel's must-fix and the should-fix items several jurors agreed on, pushed them in one commit, and CI is green on all 28 checks (`ci-wait-merge` rc=0).

**Commit:** `4971d47a5` was pushed to `kriscendobot/endo-but-for-bots:design/formula-identifier-indirection` (moving it from `22ed601bf`) with `safe-push-pr-head.sh`. Only `designs/daemon-formula-identifier-indirection.md` changed.

**Must-fix (decomplector #1).** I added a "Why a registry, and why bindings" section:
- **Shares:** a pet name is not something you hand out, so per-link revocation needs one row for each issued link.
- **Bindings:** kept for three stated reasons. The maintainer's direction names pet-store entries explicitly. Pet-store contents leave the store through more than facet methods (directory listings, `synced_store_entry`, dumps). Retention roots become uniform.
- **Fallback:** the section spells out a shares-only version that drops migration steps 2 and 3. This leaves the binding question to the maintainer instead of changing the direction silently.

**Should-fix items the jurors agreed on:**
- **Headline claim** (critic, decomplector): it now reads "no newly exported link contains a formula identifier", and says this holds unconditionally only after legacy shutdown.
- **Issuing links** (critic, decomplector, ergonomist): `share()` is now the only way to issue one. `locate` is a deprecated alias that mints a fresh share on every call, so the shared "default share" and its `default` flag are gone (skeptic #5 too).
- **Migration:** each stored legacy locator now gets its own share. I added the root policy, a rule that deleting the stored row revokes its share (no orphans), and a log of how many shares were issued.
- **Control object** (critic, ergonomist, decomplector #4):
  - `FormulaReferenceControl` is renamed `ShareControl` and is now a formula, so it survives restart.
  - The `generation` and `predecessor` columns are replaced by one `lineage` column, with at most one active row per lineage.
  - The rotation retry, concurrent rotation, stale-copy and revoke-after-rotate cases are now specified. A caller whose `rotate()` reply was lost calls `getLocator()` instead of rotating again.
  - A new `listShares` method lets a publisher recover controls it lost.
- **`ReferenceUnavailable`** (ergonomist #3, critic #4): it is a thrown error that clients can tell apart from network errors. The document states its single-lookup timing shape and leaves fine-grained timing out of scope.
- **Egress inventory** (skeptic #1): stage 1 is now gated on a grep-backed list of every place an identifier can leave the daemon. It covers facet results, mail `from`/`to` (`mail.js` turns these into locators), error messages, help output, logs and replicated tables. Acceptance criterion 1 now points at that list.
- **Deprecating `identify`** (ergonomist #4): the public method and the CLI `--identifier` flag now reject with an error naming the replacements.
- **Cross-peer and mixed versions** (critic #6, skeptic #3, ergonomist #6):
  - Foreign legacy locators are named as a known loss at shutdown.
  - Remote shares are found by `peerKey`, so a forged key reaches a registry where the number is unknown.
  - An old daemon rejects an `r1` link locally as malformed, so the failure is visible, not silent.
  - The daemon is the only process that resolves references, so cache invalidation is local (skeptic #4).
- **Staged rollout** (critic #5, novice #6): restated as four stages with dependencies and what a user can observe at each. The rollback section now says it is an operator restore, separate from the migration's idempotence, and that links issued after the upgrade are lost on rollback.
- **Option 3:** added the comparison between a denylist and tombstones (critic #7).
- **New tests:** concurrent rotate, codec rejection, `listShares` recovery, and two stored copies migrating to two distinct shares.
- **Readability** (novice #1, #2): added a Problem and Terms section at the top. Replaced the `→` arrow with "v3-to-v4" (copyeditor). Updated date is now 2026-10-09.

**Not done:**
- I did not move the Direction section below the Summary (novice #1); I added the Problem section above it instead.
- I did not split out the invitation detail in the Summary (novice #3).
- I did not split inspector sessions into a separate design (decomplector #5, comment-only).

**Follow-ups:** the driver re-posts panel round 4. I did not update the `designs/README.md` estimate row; its wording still matches the design.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2396205 cached reads)
- Output: 20628 tokens
- Cost: $1.6725849999999995
- Wall-clock: 1848s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
