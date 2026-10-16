---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-10-16T04:38:24Z
job: validate-minion-town-prod-probe-dispatch-backstop
claim: 690ab46754057290
---
Validated draft PR kriscendobot/minion.town#184 at head `2f19ca5` and reconciled the current PR implementation into production.

- Confirmed `minion/prod-probe-dispatch-token` exists in us-west-1 with an `AWSCURRENT` version using metadata only; the credential value was never read or exposed.
- Ran the checked-in provisioner. The deployed Lambda package hash matches the branch sources; its dedicated IAM role can read only the probe-dispatch secret and write its own logs. The EventBridge rule is enabled at `rate(3 hours)`, targets the Lambda, and asynchronous retries are disabled.
- Production dispatch is proven. The rule's initial firing created https://github.com/kriscendobot/minion.town/actions/runs/38848187110 on `main`; the run completed successfully, including all seven production objectives and the report job. A direct Lambda invocation with the former `force`/branch payload returned `action=dispatched, ref=main`, proving the deployed handler ignores event-controlled refs, and created https://github.com/kriscendobot/minion.town/actions/runs/38848261198; its probe job passed. CloudWatch recorded two invocations and zero errors.
- Through SSM, confirmed `ci-runner.service` is active and enabled on `ci-minion-town`. The old `prod-probe-backstop` binary/service/timer are absent by design: current PR head replaced that host timer with EventBridge, so there is no checked-in systemd backstop to install. The ordinary deployed path targets `main`.
- Verification: `node --test deploy/aws/ci-runner/lambda/test/*.test.mjs` passed 21/21, including the branch contract that every `prod-probe.yml` dispatch runs `--strict`; PR CI remains green. The observed pre-merge run necessarily used current `main` (`30a4c62`), whose manual-dispatch path is still lenient, so an end-to-end strict run on `main` can only be observed after this PR lands. No environment gate was weakened.

No repository files changed. PR kriscendobot/minion.town#184 remains open and draft at `2f19ca5`, ready for its normal gauntlet progression. Follow-up: after merge, invoke the Lambda once and confirm the merged `main` run log contains the unconditional `--strict` command.

Self-improvement: nothing this time.
