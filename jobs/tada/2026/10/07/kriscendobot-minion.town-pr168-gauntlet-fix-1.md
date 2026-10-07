## Fix round 1 for kriscendobot/minion.town#168: panel items applied, CI green

I rewrote `designs/guest-oauth-bonds.md` to address the panel's round-1 review (6 of 10 seats asked for changes) and pushed it as one follow-up commit, `792bb4bb819`, using `safe-push-pr-head.sh` (de8fffd → 792bb4b). CI finished green: `ci-wait-merge.sh` returned 0 with 3 of 3 checks passing.

**Must-fix items:**
- **Revoker dropped** (skeptic 1, ergonomist 1, and also critic 1 and decomplector 1). The per-bond HMAC "revoker" is gone. Removal is now `DELETE /api/guest/recovery-sign-ins/{bondId}`, which needs the guest's bearer and only deletes bonds owned by that guest. An unknown, stale or foreign bond id gets the same `404`. A short paragraph in the design explains why the extra token added nothing.
- **Legacy bonds get ids** (skeptic 2). The migration now gives every existing bond a fresh `bondId`, so old bonds can be listed and removed like new ones. It groups rows by the fingerprint already stored on them, decrypts nothing, copies the encrypted identifier as it is, and is safe to re-run.
- **Link fixed** (pedant 1). The #114 design isn't on `main` yet, so a relative path would be a broken link. It is now cited by PR number instead of a branch file URL.

**Should-fix and comment items also addressed:**
- **Bonding an already-used sign-in.** The `409` now comes with a way forward: open the guest that sign-in already recovers, remove it there, then add it here. This also fixes the lockout the critic and skeptic described.
- **Fingerprint key.** Fingerprints now use their own key that never rotates with the encryption key, so rotation doesn't break lookups.
- **`uses` field.** Removed, along with §6.4; that material moved into Open question 2.
- **Build order.** Open question 3 is now a decision in Build notes: this build waits for the #114 build to land the shared store.
- **MCP copy.** The "MCP is separate" paragraph now depends on a config flag, and the test checks the copy against the flag.
- **Sign-out after removal.** The design now explains why it signs out, covers both oauth2-proxy and Cognito logout, and says so in the confirmation.
- **Errors.** A table gives each error (`404`, `409`, `401`, `429`, `5xx`) its own message and next step.
- **Legacy rows.** They show a position ("1 of 2") and fill in their details the first time they are used.
- **List rate limit.** The list is fetched only when the section is opened, and the limit is now 120 per hour.
- **Naming and wording.** One noun throughout ("recovery sign-in"), "bond" is defined at the top, PR numbers are explained where first used, and the `…` characters are now plain ASCII.
- **Tests.** New ones cover migration and key rotation. The production checks no longer depend on #166. The headless SIWE check is honestly marked manual until a first run proves it works, and there is a manual browser-render check.
- **PR description.** I cut the summary sections the pruner flagged and now list only the two remaining open questions.
- Both mermaid diagrams parse (`OK sequence`, `OK stateDiagram`).

**Declined on purpose:** I didn't replace `§` or change headings to title case (pedant's should-fix items). Other designs in the repo use `§` throughout and sentence-case headings.

**Next:** the driver re-posts panel round 2. There were no inbox messages.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1205683 cached reads)
- Output: 17096 tokens
- Cost: $1.1958326
- Wall-clock: 531s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
