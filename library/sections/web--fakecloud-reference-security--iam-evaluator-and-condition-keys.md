---
title: IAM evaluator and condition keys
source_kind: web
source_url: https://fakecloud.dev/docs/reference/security/
source_content_sha256: beadb5c08e912872183ee20a26ba9aa3f2eac1253f1e9610c1cb946d4a52196e
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, policy-language-authorization]
status: current
---

fakecloud's opt-in IAM evaluator enforces only IAM, STS, SQS, SNS, S3, KMS, DynamoDB, and DynamoDB Streams; it implements all 28 condition operators with IfExists and set qualifiers, a fixed global-key set, and service-specific keys including `dynamodb:LeadingKeys` and `dynamodb:Attributes`, and safe-fails any unextracted key or unknown operator to not-applying.

**Modes.** `off` (default: stored, never consulted); `soft` (evaluated, denies logged on `fakecloud::iam::audit`, request allowed); `strict` (denied requests fail with `AccessDeniedException`). Account root and the `test*` AKIDs always pass.

**Enforced services** (all supported actions of each): IAM, STS, SQS, SNS, S3, KMS, DynamoDB (tables, indexes, backups, exports, imports, global tables; batches need the batch action on every table; transactions need the per-item action on each table), DynamoDB Streams. "Other services are not enforced even with `FAKECLOUD_IAM=strict`." Cognito, Secrets Manager, SSM, and Lambda invoke are therefore not policy-checked.

**Evaluator scope.** Allow/Deny with Deny precedence; `Action`/`NotAction` and `Resource`/`NotResource` with `*` and `?`; policy variables (`${aws:username}`, `${aws:PrincipalTag/<key>}`, defaults, escapes); all 28 operators (String, Numeric, Date, Bool, Binary, IpAddress, Arn, Null) with `...IfExists` and `ForAllValues:` / `ForAnyValue:`; identity policies on users, groups, roles; AWS-managed policies resolved from a built-in catalog; empty policy set is implicit deny.

**Global keys:** `aws:username`, `aws:userid`, `aws:PrincipalArn`, `aws:PrincipalAccount`, `aws:PrincipalType`, `aws:SourceIp`, `aws:CurrentTime`, `aws:EpochTime`, `aws:SecureTransport` (true iff `x-forwarded-proto: https`), `aws:RequestedRegion`.

**DynamoDB service-specific keys (verbatim rows):**

| Key | Populated on | Source |
|---|---|---|
| `dynamodb:LeadingKeys` / `dynamodb:FirstPartitionKeyValues` | `GetItem`, `PutItem`, `UpdateItem`, `DeleteItem`, `ConditionCheckItem`, `Query`, `BatchGetItem`, `BatchWriteItem`, `PartiQL*` | Partition-key values of the items addressed |
| `dynamodb:Attributes` | Item actions, `Query`, `Scan`, batches, `PartiQL*` | Top-level attribute names the request names: key / item attributes, `ProjectionExpression`, `AttributesToGet`, and every attribute an update, condition, filter or key-condition expression (or the legacy parameters) references |
| `dynamodb:Select` | `GetItem`, `Query`, `Scan`, `BatchGetItem`, `PartiQLSelect` | `Select` or the implied value |
| `dynamodb:ReturnValues` | `PutItem`, `UpdateItem`, `DeleteItem` | `ReturnValues`, `NONE` by default |
| `dynamodb:ReturnConsumedCapacity` | Data-plane actions | `ReturnConsumedCapacity` |
| `dynamodb:EnclosingOperation` | Item actions inside transactions; `PartiQL*` inside `ExecuteTransaction` | The enclosing operation's name |
| `dynamodb:FullTableScan` | `PartiQLSelect` | `true` without a partition-key equality |

Other service keys: `s3:prefix`/`delimiter`/`max-keys`, `sns:Protocol`/`Endpoint`, `lambda:FunctionArn`/`Principal`, `sqs:MessageAttribute.<Name>`.

**Safe-fail.** "Any unimplemented operator, unknown key, or parse failure ... evaluates to `false` — i.e. the statement does not apply." Note the direction: a `Deny` conditioned on an unextracted key does not fire, while an `Allow` conditioned on one does not grant.

**Resource-based policies** wired into evaluation: S3 bucket, SNS topic, Lambda function, KMS key, DynamoDB table and stream policies, plus role trust policies on every `AssumeRole*`, combined with AWS cross-account semantics (explicit Deny wins; same-account needs either grant; cross-account needs both).

Source: [fakecloud docs/reference/security](https://fakecloud.dev/docs/reference/security/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
