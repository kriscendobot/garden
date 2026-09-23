---
title: Integration tests (labels and merge-queue interaction)
source: CONTRIBUTING.md
source_repo: agoric/agoric-sdk
source_commit: de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, testing]
status: current
notes: The `force:integration` / `bypass:integration` labels are the canonical hooks for any role triaging an agoric-sdk PR's CI state. If integration tests run only at merge time (because they were bypassed), the PR author still owns any post-merge breakage.
---

> Abstract: Integration tests in agoric-sdk are slow and do not run on every PR push by default. They run automatically when a PR is flagged for the merge queue via one of the `automerge` labels (and are required before landing). The `force:integration` label runs them unconditionally; `bypass:integration` prevents them from running. If a commit lands without going through the merge queue, or with `bypass:integration`, the tests run on the merge commit instead — the PR author remains responsible for any post-merge breakage.

### Integration tests

Some tests take time to complete and will not run by default on every PR push.
However once a PR is ready for review and flagged for merging through one of
the `automerge` labels, these integrations tests will run and be required
before the PR can land.

If you believe your PR may impact the result of the integration tests, you can
force them to run unconditionally by using the label `force:integration`. If
you know your PR has no impact on integration tests, you can use the label
`bypass:integration` to prevent them from running at all.

If a commit was merged without going through the merge queue (`automerge`
label), or if the integration tests were bypassed in the PR, the tests will
run on the merge commit instead. While the PR has landed at that point, it is
still the responsibility of the PR author to fix any breakage.

Source: [CONTRIBUTING.md](https://github.com/Agoric/agoric-sdk/blob/de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22/CONTRIBUTING.md) at commit `de2c4cbc`.
