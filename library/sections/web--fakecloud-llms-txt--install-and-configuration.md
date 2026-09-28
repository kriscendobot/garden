---
title: Install and configuration
source_kind: web
source_url: https://fakecloud.dev/llms.txt
source_content_sha256: 7da0553629fa56a54689e661b91e2675fc06b469e00242984b086d40e06b553d
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, tooling]
status: current
---

fakecloud installs by script, Homebrew, `cargo install`, or the `ghcr.io/faiscadev/fakecloud` image; apps point any AWS SDK at `http://localhost:4566` with dummy credentials; flags include `--persist`, `--verify-sigv4`, and `--iam soft|strict`.

Install paths at retrieval:

- Install script: `curl -fsSL https://fakecloud.dev/install.sh | bash` (macOS and Linux).
- Homebrew: `brew install fakecloud`.
- Cargo: `cargo install fakecloud`.
- Docker: `docker run --rm -p 4566:4566 ghcr.io/faiscadev/fakecloud`.

Usage: run `fakecloud`, then point any AWS SDK at `http://localhost:4566` with dummy credentials (`access_key=test`, `secret_key=test`). Health: `curl http://localhost:4566/_fakecloud/health`.

Configuration flags and environment variables named on the page: `--addr`, `--region`, `--account-id`, `--log-level`, `--persist`, `--verify-sigv4`, `--iam soft|strict` (the parity page also spells the strict mode as `FAKECLOUD_IAM=strict`). The page links a LocalStack migration guide (docker-compose, GitHub Actions, Terraform, CDK, Serverless Framework configs), a CI integration-testing guide (GitHub Actions, GitLab CI, CircleCI), a Lambda-testing tutorial, and a "Moto equivalent for Go/Java/Node" post.

Supply-chain note (scholar): the documented one-line install pipes a remote script to `bash`; a CI adopter that wants a pinned, reviewable dependency should prefer the versioned container image or `cargo install` with a pinned version.

Source: [fakecloud llms.txt (agent-oriented project summary)](https://fakecloud.dev/llms.txt), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
