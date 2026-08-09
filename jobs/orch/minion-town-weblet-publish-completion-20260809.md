---
order: serial
children: minion-town-weblet-publish-fable-review-20260809 minion-town-weblet-publish-land-pr31-20260809 minion-town-weblet-publish-land-pr27-20260809 minion-town-weblet-powers-reference-build-20260809 minion-town-weblet-powers-reference-land-20260809 minion-town-weblet-publish-deploy-verify-20260809
on-child-failure: halt
state: pending
created_by: gardener
created_at: 2026-08-09T18:20:50Z
---

# Ordinary-user weblet publication — orchestrate to production verification

Drive the minion.town ordinary-user weblet-publish critical path serially: Fable proxy technical review, land the B4 guest scope, land the publish capability, build the missing user powers-reference capability, land it, deploy, and verify the complete OAuth/browser/CapTP flow. Halt loudly on any failed child so no later stage runs on an unmet prerequisite.

Bean deflation / toy-tool retirement / scope pruning and https://github.com/kriscendobot/minion.town/pull/20 and https://github.com/kriscendobot/minion.town/pull/30 are explicitly unrelated and excluded.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----
