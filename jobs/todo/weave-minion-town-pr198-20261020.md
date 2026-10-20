---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: weaver
delegation: minion-town-pr-screening
# Weave kriscendobot/minion.town#198 onto current main
PR: https://github.com/kriscendobot/minion.town/pull/198 (head feat/beta-home-splash-waitlist @ 5ea626915dd6, base now `main` @ ea08cf05508).
Two screened conductor attempts (screen-minion-town-pr198-5ea6269-conduct, -r2) were refused by ci-wait-merge.sh: rebase-blocked reason=needs-weave.
Commit 1/23 (bbf6c15f feat(web): one landing at /, closed-beta splash and waitlist) conflicts in:
  DEPLOYMENT.md, deploy/aws/www/index.html, designs/clip-shell-framework.md
Rebase onto current main, resolve conflicts preserving both sides' intent, force-push the head. The proxy re-screens the new head and posts a fresh conductor; do not merge.
