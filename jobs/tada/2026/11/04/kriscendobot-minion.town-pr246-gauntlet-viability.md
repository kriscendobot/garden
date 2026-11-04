The PR is viable, so I'm writing the report now.

**Viability result: proceed.** PR #246 is open, unmerged and still a draft. Its head is `6e2b23a9`, and its base `main-89e6156` is identical to current `main`.

Deciding question: On current `main`, do the shell-owned "Open in new tab" links the maintainer asked to remove today still exist, with no other PR or newer base change having already removed them?

Answer: Yes.

Evidence:
- **Need still holds:** `main` still has `#clip-open` at `deploy/aws/www/index.html:467` and `#clip-caption-link` at `index.html:476`. It also has the matching wiring and the "Use “Open in new tab”" text at `deploy/aws/www/shell.js:220`.
- **Current ask:** kriskowal requested the removal on 2026-11-04 during the interactive evaluation session. It is recorded in `build-minion-town-remove-open-in-new-tab-20261104`, a child of `minion-town-new-clip-gutter-orchestration-20261104`. The production check, `verify-minion-town-remove-open-in-new-tab-prod-20261104`, is parked on this PR.
- **Nothing newer on the base:** comparing the PR's base to `main` shows 0 commits ahead or behind. The PR has no comments or reviews, so nobody has disputed it.
- **Not superseded:** a search for "new tab" and the open PR list found no other PR removing these links.
- **CI, partial view:** the two workflow runs I could read for the head commit, the clip frame browser gate and test (typecheck + vitest), both succeeded. The bot token can't read check runs, so I took the rest of CI from the builder's report, which says it was green.

Points for the panel (neither blocks the gauntlet):
- **Conflict with draft #247:** `designs/ordered-gutter-context-menu.md` proposes an **Open in new tab** item in the gutter's right-click menu. That is a different control from the two links removed here, so it doesn't displace this PR. It does sit awkwardly with the removal, and #247's review should settle it.
- **Refused frames lose their way out:** `designs/clip-shell-framework.md` on `main` relies on the caption link as the escape when a clip refuses framing, and this PR's diff changes that design. After the change, a refused clip has no top-level link. That follows directly from what the maintainer asked for, but the panel should confirm the design text and browser gate agree on it.

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no changes to the PR or the garden.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr246-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (271463 cached reads)
- Output: 3636 tokens
- Cost: $0.49552460000000004
- Wall-clock: 111s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
