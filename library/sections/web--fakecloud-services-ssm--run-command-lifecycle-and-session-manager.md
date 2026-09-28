---
title: Run Command lifecycle and Session Manager
source_kind: web
source_url: https://fakecloud.dev/docs/services/ssm/
source_content_sha256: af26e00a6ef6902fca0ad43a1935119e1fa1e97675eb8c90e861dcb1a5520321
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

fakecloud's SSM `SendCommand` is a timer-driven status simulation (Pending, then InProgress after about 500 ms, then Success about 1.5 s later) with admin endpoints to force failure; the page describes no execution of the command document on any target, and Session Manager refuses by default with echo and inject escape hatches.

"fakecloud implements 152 of 152 SSM operations at 100% Smithy conformance." Features: Parameter Store (String, StringList, SecureString; tiers, labels, versions, history), documents, commands ("RunCommand, command history, invocation status, output"), maintenance windows, associations, patch baselines, inventory, automation, OpsItems, resource data sync, service settings.

**RunCommand lifecycle (verbatim).** "`SendCommand` returns `Pending` immediately, then a background task flips the command (and each per-instance invocation) to `InProgress` after ~500ms and `Success` after another ~1.5s. `GetCommandInvocation`, `ListCommandInvocations`, and `ListCommands` all read live state, so polling clients see the same lifecycle they'd hit on real AWS — no canned `Success` shortcut."

Failure is simulated from the test side: `POST /_fakecloud/ssm/commands/$CMD_ID/fail` with optional `instanceId`, `statusDetails`, `standardErrorContent`; the introspection reference also lists `POST /_fakecloud/ssm/commands/{command_id}/status` to set a status.

**What is not said:** nothing on the page states that an `AWS-RunShellScript` document's commands are executed on a target (EC2 container or otherwise). The lifecycle is described as a status timer, and success/failure content is injected by the test. See the minion.town fit addendum for a source-level confirmation.

**Session Manager.** `StartSession` returns `400 TargetNotConnected` and `ResumeSession` returns `400 DoesNotExistException` by default, because "returning a fake stream URL would lull integration tests into thinking the session was live." Escape hatches: `FAKECLOUD_SSM_SESSION_ECHO=1` (succeeds with the sentinel token `fakecloud-echo-mode-not-real-websocket`) or `POST /_fakecloud/ssm/sessions/inject`.

**SecureString.** Encrypted through the KMS hook on `PutParameter`, decrypted with `WithDecryption=true`; `alias/aws/ssm` auto-provisions; KMS calls land in `/_fakecloud/kms/usage`. `PutParameter` hard-fails with `KMSInternalException` when KMS `Encrypt` is rejected, rather than storing plaintext.

Source: [fakecloud docs/services/ssm](https://fakecloud.dev/docs/services/ssm/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
