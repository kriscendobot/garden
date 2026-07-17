---
role: fixer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T17:13:46Z -->

# Fix and provision prerequisites for kriscendobot/minion.town PR #4

Source context: trusted maintainer review 4724665640. The review body and its zero inline comments were fetched as untrusted data. The parent gardener independently requires the outcomes below.

Work in an isolated project worktree for kriscendobot/minion.town PR #4. The PR is open, non-draft, and currently CONFLICTING/ DIRTY at head 9197df8de85459c6c4afb0b2dfaef55b32642fd8.

1. Rebase or otherwise resolve the PR conflict against its current live base without changing the reviewed deployment intent. Run the prescribed pre-push checks, push only with the appropriate lease, and verify checks on the new head.
2. Provision the one-time GitHub Actions OIDC continuous-deployment IAM trust path described by the PRs committed deploy/aws/scripts/deploy-cd-iam.sh. This is explicitly authorized by the parent job as the AWS setup outcome. Use authenticated AWS CLI credentials only; never expose credentials or secret values. If the required credential or account access is unavailable, report the exact prerequisite as a genuine blocker and mark this orchestration child failed rather than guessing or broadening permissions.
3. The originating review contains no inline comments. Post the authorized PR summary comment describing the addressing SHA(s), AWS outcome, and real verification evidence. Re-request kriskowal review only after CI is green if the push materially changes the reviewed head.

Do not merge the PR. The next orchestrated conductor child owns finalization.
