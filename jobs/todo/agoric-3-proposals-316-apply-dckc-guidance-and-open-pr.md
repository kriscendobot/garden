# agoric-3-proposals #316 — apply dckc's (now-authorized) guidance, open the PR, reply to dckc
Repo: **kriscendobot/agoric-3-proposals** (BOT FORK; bot identity). **NEVER** upstream
Agoric/agoric-3-proposals — no upstream comments/links; all artifacts on the fork. (kriskowal's garden
issue #20 explicitly asked for the fork.)
**Context:** the #316 "missing proposals" work was done on the fork (a branch exists — job
`agoric-3-proposals-316-missing-proposals` is in tada) but **no PR was opened**, and **dckc's guidance
was ignored** because he wasn't authorized. dckc is now a maintainer (maintainers/allowlist) — heed him.
**dckc's directives (garden issue #20 comments):**
1. **Include the `b1-<hash>.json` bundle files** — they were omitted. Use **`scripts/fetch-all-bundles.ts`**
   to fetch them.
2. **Document the omitted proposal 113** — `/ibc.core.client.v1.MsgRecoverClient`, an **unsupported
   proposal type** correctly omitted — record that reason **in the code / commit / branch**.
3. **Open a PR** — dckc: "I see a branch but no PR. is that on purpose?" Open the PR on
   **kriscendobot/agoric-3-proposals** so the work is reviewable.
**Task:** on the existing fork branch — (a) run `scripts/fetch-all-bundles.ts` to add the missing
`b1-<hash>.json` bundles; (b) document the 113/MsgRecoverClient omission in-code + commit message;
(c) open the PR on kriscendobot/agoric-3-proposals; run any local verification. Then **reply to dckc on
garden issue #20** — acknowledge his guidance is now heeded (he was frustrated at being ignored — say so
plainly), summarize what changed, and link the PR. Verification-integrity: cite what you actually ran.
Scope: fork only; no upstream Agoric/agoric-3-proposals contact.
