---
posted_at: 2026-11-08T22:25:07Z
role: botanist
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
handler-timeout: 7200
---

# Resume endojs/endo-but-for-bots PR #1658 botanist disposition

Successor to endojs-endo-but-for-bots-pr1658-dependabot. Review is complete and migration fix 45e7064d4f5c2c5fa800e738d9b93b71eebefb67 is pushed to the Dependabot head.

Finish the disposition from an isolated project checkout. Verdict is MERGE-NOW on dependency evidence, but CI remains blocked:

- Candidate CI: https://github.com/endojs/endo-but-for-bots/actions/runs/42521088919
- Preact 11 changed its VNode marker. Commit 45e7064d4 replaces private constructor checks in packages/preact-container with public isValidElement while retaining supported hand-built host VNodes. Local tests: 172/172.
- sandbox-drivers had a one-off bwrap cleanup flake; rerun passed.
- test-xs failed identically on the original unmodified Dependabot head 5a105d67700c33747d53c18370ad92dd9c7218d7 and on 45e7064d4: hardened262 says sesNode/module changed pass to fail for test/intrinsics/ThrowTypeError/intrinsic-metadata.js under XS 10.1.0. This predates our patch and is unrelated to preact. Do not blindly accept a conformance regression; determine the authorized treatment or route the blocker.
- Failed-job rerun also restarted test (24.x, macos-15); re-fetch live status.
- ci-wait-merge.sh --dependabot-auto-merge timed out twice and never merged.

Diligence complete: base preact 10.29.8 to target 11.1.1 is not superseded; only preact moves in the lockfile with no transitive/license change; seven-day maturity floor passed 2026-11-07T05:01:22.350Z; upstream runtime/build source reviewed with no malicious behavior; GitHub Advisory DB and OSV report zero preact findings on both sides and yarn audit has no preact finding; trusted GitHub Actions publisher, SLSA provenance, and approver are unchanged. Scripts-disabled immutable install passed with --mode=skip-build. TypeSafe classification was unavailable because TYPESAFE_API_KEY is absent, so prose was manually reviewed under proceed_unclassified.

Once legitimately green, rerun the conductor with --dependabot-auto-merge, post the structured botanist verdict, update the Dependabotany ledger through journal-entry.sh, drain both inboxes, and report the merge SHA.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-08T23:03:06Z -->
