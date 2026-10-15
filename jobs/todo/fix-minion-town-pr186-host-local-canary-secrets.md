---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Shrink kriscendobot/minion.town PR #186 to host-local root-canary secrets

Repo: kriscendobot/minion.town. PR: https://github.com/kriscendobot/minion.town/pull/186 (draft, "feat(canary): add the root MCP credential path").

The maintainer review of https://github.com/kriscendobot/minion.town/pull/191 (2026-10-15) settled that the root-canary secrets stay on `endolin-garden1` as host-local capabilities: no AWS reader role, trust policy or EC2 instance. Design: `designs/root-canary-reader-identity.md` on #191's head, Sections 4 and 7.

#186 still requires all three (`ROOT_CANARY_SOURCE_INSTANCE_ID`, `ec2 describe-instances`, the `minion-root-canary-reader` role and its host-restricted trust, the Secrets Manager resource policy naming it). Per that design:

- drop the reader role, its trust policy, the resource policy and the instance-id requirement from `deploy/aws/scripts/root-canary-deploy-client.mjs` and its docs/tests;
- change the mint to write the refresh token to a host-local file on the mint host instead of Secrets Manager;
- keep the dedicated Cognito client, the one-time interactive mint for Flow A, the token-free audit records and the failure contract.

Do NOT wait for the maintainer's GitHub login (not scheduled); it is needed only to run Flow A / the first formula-id reveal, not to land this change. Keep #186 a draft. Before editing, re-read #191 and its newest maintainer comments (e.g. issuecomment-6201208707, the formula-id/OCapN pivot, owned by job `kriscendobot-minion.town-pr191-9f800189`); if the maintainer has since redirected #186's scope, follow that and report rather than shrinking blindly.

Provenance: dead-lettered maintainer message to `validate-minion-town-root-canary-login-20261013` (jobs deadmail-20261015T195858Z-084fe2 / deadmail-20261015T195909Z-a7c006).
