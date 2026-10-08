I applied the panel-4 fixes to PR #168 (design doc `designs/guest-oauth-bonds.md`), pushed them as one follow-up commit, and CI came back green (3 of 3 checks).

**What I did**
- I read the panel-4 verdict posted 2026-10-08T00:10Z. It named two must-fix items: ergonomist #1 and novice #1.
- I worked in an isolated checkout of `kriscendobot/minion.town` on branch `design/guest-oauth-bonds`. I made one follow-up commit (`ebbaf22`, `design(guest-oauth-bonds): address panel round 4`) and pushed it with `safe-push-pr-head.sh` in advance mode. The head moved from `13402a5` to `ebbaf22`.
- `ci-wait-merge.sh --no-merge` returned rc 0, all green.

**Changes**
- **Novice must-fix:** a "Terms" list now sits right under the title, before "bond" first appears in the text. It defines recovery sign-in, bond (the same object, one `RecoveryIdentity` row), provider and label. The § 1 Naming paragraph now points back to that list.
- **Ergonomist must-fix:** § 4 has a new "Path families" bullet. It explains why add stays at `POST /account/guest-recovery` while list and remove are under `/api/guest`:
  - Add needs an identity proven through the sign-in proxy's auth gate.
  - List and remove must work without signing in, and the sign-in cookie must not give any authority over them.
  - It also says the shell keeps all three calls in one module, and that renaming the add route is left to the build that removes the legacy fallback.
- **Should-fix items also addressed:**
  - Decomplector #1: § 3 now lists the changes to `RecoveryIdentity` as explicit amendments to #114 § 2. It drops `status`, adds `signInId` and `label`, and explains why removal is a hard delete rather than a soft delete.
  - Critic #1: the migration now writes a `migrated_at` marker on each legacy row, and the cutover fallback skips marked rows. That stops a removed bond from being recovered through its legacy row. A new paragraph covers removal across the two stores, and test 6 now covers this case.
  - Critic #2 and skeptic #2: § 5 now says outright that the owner and a thief holding the bearer share one rate-limit budget, and that this is an accepted risk.
  - Ergonomist #3: § 7 now fixes the order of the section's elements, with the empty-state line stated separately.
  - Copyeditor #1–4: fixed subject-verb agreement, the comma splice, the unclear antecedent in § 6.5, and "in place" in § 6.3.

**Not addressed**
- Ergonomist #2 and #4–#5: the open/recover wording, the legacy-row label, and a single error body shape for all routes.
- Novice #2–#6: the related-work list, density of the migration and § 4 text, the § 6.3 reorder, and a worked example.
- Skeptic #1 and #3: pinning #121's head, and testing that legacy fingerprints use today's key.
- Critic #3 and #5: the fixed fingerprint key's leftover risk, and what happens if #129 or #133 change shape.

None of these were must-fix. Panel 5 may raise them again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (792049 cached reads)
- Output: 9187 tokens
- Cost: $0.9172778000000003
- Wall-clock: 377s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
