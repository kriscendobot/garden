---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Rewrite PR body of endojs/endo-but-for-bots#356 to the repository PR template

Panel-1 integrator/pruner must-fix on https://github.com/endojs/endo-but-for-bots/pull/356: the PR body lacks the template sections and carries a per-file tour. The fix-1 gauntlet stage on oros-studio could not edit it (PAT 403 on updatePullRequest). Replace the body verbatim with the text between the markers below via `gh pr edit 356 -R endojs/endo-but-for-bots --body-file <file>`, then verify with `gh pr view 356 -R endojs/endo-but-for-bots --json body`. Nothing else.

----- BODY -----
Refs: #343

## Description

Design-only PR adding a stack of gateway designs under `designs/`:

- `designs/gateway-package.md`: the overarching `@endo/gateway` package (supersedes `endo-gateway.md`).
- `designs/gateway-packaging-ci.md`: OS packaging (deb, rpm, Arch, Docker) built and signed in CI, with per-target publication.
- `designs/gateway-aws-deployment.md`: generic-Linux deployment to AWS (ALB, ASG, Packer AMI, Terraform).
- `designs/gateway-aws-attuned.md`: an AWS-native multi-tenant variant (S3, DynamoDB, Nitro Enclaves, Route53).

`designs/README.md` indexes the four designs and reconciles the roadmap. The maintainer directive behind the stack is recorded once in `gateway-packaging-ci.md` § Prompt. The branch also carries CI and test repairs inherited from its stale base (`llm-b1c3f4d`); these drop out when the PR is rebased onto a base that contains them.

### Security Considerations

The designs introduce new authority boundaries, specified in the documents: an owner-only admin socket separate from a group-relaxable registration socket, canonical hostname handling for routing, purpose-split enclave keys with no raw signing or decryption oracle, per-request tenant-scoped AWS credentials, and fingerprint-pinned package-repository keys. No code changes ship here.

### Scaling Considerations

None for this PR. The AWS designs discuss fleet sizing and gate the instance-type and delivery-mode choices on benchmarks.

### Documentation Considerations

The designs are documentation; `designs/README.md` is updated to match.

### Testing Considerations

Each design carries a test catalog for its eventual implementation. The only code change is a test-only port of `packages/ocapn/test/netlayer-tcp-syrup.test.js` to `makeOcapn`.

### Compatibility Considerations

None; no published package surface changes.

### Upgrade Considerations

None for this PR. The packaging design describes the eventual upgrade path for installed gateways.
----- END BODY -----
