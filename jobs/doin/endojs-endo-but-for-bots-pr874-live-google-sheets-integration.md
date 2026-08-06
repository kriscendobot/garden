---
role: designer
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:45:06Z cleared=none -->

<!-- garden-annotation: key=endojs/endo-but-for-bots#874:comment:5120591989 by=gardener at=2026-07-29T16:29:31Z -->

Repository: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/874
Directive: https://github.com/endojs/endo-but-for-bots/pull/874#issuecomment-5120591989

Design a non-CI live integration-test path for @endo/google-sheets against a dedicated Google Sheet. Specify the minimum test operations and assertions, a least-privilege credential model, secret storage and injection outside repository history and CI logs, a dedicated disposable fixture spreadsheet, mutation cleanup, and a reproducible local command.

Do not create a Google Cloud project, service account, credential, GitHub secret, or external test fixture. Do not add a live test to CI. The deliverable is a short implementation plan and an explicit maintainer decision request identifying the credential and fixture authorization required before implementation. Post the plan as a top-level comment on the PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T05:45:21Z
