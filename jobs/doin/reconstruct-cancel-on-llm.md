# Reconstruct the @endo/cancel package on current llm (rebase the closed PR #345)

Maintainer directive: find the closed PR that introduced the **cancel package** and
**reconstruct it based on current `llm`** — "a straightforward creation of a fresh
branch from an existing PR's branch and rebasing it." This is the concrete execution
of kriskowal's #507 directive ("the cancel package should exist; reconduct it") and
unblocks #513 (whose fixer found `@endo/cancel` absent from its base).

Wear the **weaver** role (`roles/weaver/AGENT.md`; escalate to builder/fixer detail
if the rebase is non-mechanical). Repo: `endojs/endo-but-for-bots`.

## The closed PR (already located — confirm, don't re-search blindly)

**#345** — "feat(cancel): @endo/cancel cancellation primitive (mirror of endojs/endo#3032)":
- **MERGED** 2026-06-02 onto the **frozen** snapshot base `llm-5b1361d` (not live `llm`).
- Head branch: **`mirror/3032-cancel`**.
- That frozen base is why `@endo/cancel` never reached current `llm`.

## Task — fresh branch from the PR's branch, rebased onto current llm

1. Fetch `endojs/endo-but-for-bots`; confirm `@endo/cancel` (`packages/cancel/`) is
   indeed absent from **current live `llm`** (if it is already present, stop and
   report — the directive is satisfied).
2. **Create a fresh branch** (e.g. `reconduct/cancel-on-llm`) **from #345's head
   branch `mirror/3032-cancel`** (the PR's branch carries the package as authored).
3. **Rebase that fresh branch onto current live `llm`.** The package is additive
   (`packages/cancel/*`), so conflicts should be limited to workspace registration
   (`package.json` workspaces) and `yarn.lock` — resolve per
   `skills/conflict-resolution` / yarn-lock-separate-commit discipline. If the rebase
   turns out non-mechanical (the package's deps drifted on llm), escalate to a
   builder/fixer pass rather than forcing it.
4. **Open a new PR against current `llm`** reconstructing `@endo/cancel`, titled to
   make clear it re-lands #345's cancel package on live llm. Reference #345, #507, and
   #513 (the consumer) in the body.
5. Push under the **bot identity** (bot-fork branch; no identity switch). On success,
   reply on #507 and #513 noting the cancel package is reconstructed on llm.

Note: this supersedes the vaguer `reconduct-endo-cancel-507` verify-job — this is the
explicit reconstruction.

## Definition of done

A fresh branch from `mirror/3032-cancel` rebased onto current `llm`, a new PR opened
against `llm` re-landing `@endo/cancel`, conflicts resolved, pushed under the bot
identity, with #507/#513 informed. Report the new PR number and any non-mechanical
rebase issues. If `@endo/cancel` is already on current `llm`, report that instead of
duplicating it.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 65
  claimed_at: 2026-06-25T16:43:04Z
