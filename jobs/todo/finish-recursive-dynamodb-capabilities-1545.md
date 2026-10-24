---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
handler-timeout: 10800
Repo: endojs/endo-but-for-bots, branch gardener/fu-design-recursive-dynamodb-capabilities-1, draft PR https://github.com/endojs/endo-but-for-bots/pull/1545 against llm-d5ac419.
Continue and finish the @endo/exo-dynamodb implementation against the latest design at https://github.com/kriscendobot/minion.town/pull/221 commit d65ac219e63b8e32a94d4df282efe501cb9f6633. The initial implementation commit 95ff807a077a598c0b0967a58472d0993f827d6f predates that final design revision and is not contract-complete.
Reconcile at least: both derive methods resolve Result<Derived> with capability plus grantId; control exposes async withdraw and lineage; expected malformed/widening/revoked failures resolve rather than reject; Restriction uses keySpace, per-index KeyRange maps, nested shape with a Condition guard, itemBytes and requestsPerSecond; numeric exact/interval constraints and query intersection; index results outside base key space are dropped rather than failing the page; GSI consistent reads are refused; idempotency keys on individual writes; durable named-grant tombstone/restart interfaces; required property, deny-before-send, index leakage, revocation, restart, audit, confinement, DynamoDB Local, and isolated-IAM coverage.
The current CI failures observed on run 40060852427 are pre-existing sandbox-driver failures (bwrap ulimit/process cleanup), and mutual-dependency run 40060852432 lacks tred; classify against base before changing package code.
Preserve the existing garden job marker and update the draft PR rather than opening another PR. Run package and repository checks, push the head branch with CAS discipline, and report any integration tests that cannot run.
