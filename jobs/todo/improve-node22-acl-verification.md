---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
deploy/aws/scripts/lib/install-node22.sh
`deploy/aws/scripts/lib/install-node22.sh:45-54` trusts an existing Node installation when `getfacl` is unavailable, allowing undiscovered extended ACL writers. Provision ACL tooling before verification or fail closed, and add coverage for the missing-tool path.
