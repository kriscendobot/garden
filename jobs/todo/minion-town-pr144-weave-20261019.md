---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave kriscendobot/minion.town PR #144 (guest coupons design) onto the current base

PR: https://github.com/kriscendobot/minion.town/pull/144 (head `design/guest-coupons`, base `main-7fb38ed`, a stale frozen base). It touches only `designs/guest-coupons.md` and `designs/invitation-only-guest-onboarding.md`, yet its checks (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`) fail on a very old run (id 36691445004, logs expired). The failures are almost certainly stale-base infrastructure, not the docs. #144 blocks the closed-beta chain: https://github.com/kriscendobot/minion.town/pull/199 cites it by section and must merge after it.

Do: update the merge base to the current `main` hash and rebase (frozen-base-branch, verify-upstream-state-before-pinning), resolve conflicts, force-push the head, move the PR base. Then watch CI. If the checks still fail, classify per ci-failure-classification-loop; if the cause is the Claude-harness image build on a docs-only change, note that https://github.com/kriscendobot/minion.town/pull/204 fixes that and report whether to wait for it. Leave the PR a DRAFT, keep the `<!-- garden-design-open-questions -->` marker, and do not merge. Report CI state to the maintainer inbox.
