All work is committed, pushed to `origin/main2`, and verified end-to-end against real AWS. The build is complete.

## Completion report

**Job:** Build the approved Turnkey Amazon garden host (`designs/turnkey-garden-host.md`), incorporating the maintainer's review-comment feedback, and actually exercise the build/smoke path.

### What I built (pipeline, `scripts/aws/turnkey/`, on `origin/main2`)
- `lib.sh` — single source of truth (account `292378781985`, region `us-west-1`, pinned base AMI, names, tags, identity guard).
- `ensure-instance-profile.sh` — least-privilege role/profile `garden-turnkey-ssm` (`AmazonSSMManagedInstanceCore` only; optional scoped Secrets-Manager PAT read behind `--with-secret`).
- `ensure-security-group.sh` — SSM-only SGs, **no inbound**, separate test SG; `--open-ssh <cidr>` opt-in.
- `provision.sh` / `scrub.sh` — Docker CE+buildx install, reviewed `main2` checkout, `./garden build` (prebuilt container), then a credential/identity scrub that **hard-fails the bake** if any residual auth is found.
- `build-ami.sh` — bakes on a Graviton builder over SSM → private `CreateImage` with immutable `garden:source-commit`/`base-ami`/`architecture`/`build-timestamp` tags.
- `create-launch-template.sh` — encrypted gp3 + IMDSv2-required + instance profile + SG, **no user-data, no key pair**; new build = new version.
- `smoke-test.sh` / `teardown.sh` — credential-free smoke test in the separate SG; teardown for transient/all resources.

### Reconciliation of the maintainer comment vs. design text (documented explicitly)
- **Claude:** interactive device-auth over an **SSM-tunnelled ssh CLI** — no secret store, no secret handoff. This resolves both review notes; the AWS-secret idea survives only as the optional, scoped **GitHub-PAT** path (secret *name*, not value).
- **"SSH stays closed":** preserved as *no inbound port 22 to the internet*; the operator still gets the ssh/shell CLI via SSM (Session Manager or `AWS-StartSSHSession`), with an optional own-CIDR direct-ssh opt-in.
- Updated `designs/turnkey-garden-host.md` (status → Implemented, decisions resolved, Implementation table + safe defaults + Graviton follow-up), added operator runbook `context/operations/turnkey-host.md` (+ index row), and recorded the inventory in `context/operations/aws-bringup.md`.

### Actually exercised on AWS (not templates alone) — created resources
- **AMI `ami-0fbfe0b799310072d`** (private/`Public:false`, ARM64) — snapshot `snap-0285a9fd494ba6e6c` (**encrypted**, 50 GiB volume), all four immutable tags present.
- **Launch template `lt-0640cc0640c5e2244`** (`garden-turnkey`, v1 default) — verified IMDSv2 required, encrypted gp3, no user-data, no key pair.
- **Role/profile `garden-turnkey-ssm`** — only the SSM managed policy, no inline secret grant.
- **SGs** `sg-0779a404a970ce42b` (launch, **zero inbound**) and `sg-01a9c9fa35a51fc64` (test).

**Smoke result (real throwaway `t4g.medium`, then terminated): PASS** — (1) SSM reachable, (2) `./garden create` started the container from the **prebuilt** `garden-ubuntu` image, (3) **no** pre-existing Claude/GitHub auth (scrub verified clean at bake time too).

### Costs / ongoing / cleanup
- Bake ran an `m7g.xlarge` builder (~25 min) + brief `t4g.medium` smoke instance — both **terminated** (0 instances now running). Cents of compute.
- **Ongoing:** only the AMI's snapshot (billed on ~10–15 GiB used blocks ≈ $0.50–0.75/mo) while retained. Teardown available via `teardown.sh [--ami|--all]`.

### Notes / follow-ups
- The container **built cleanly on ARM64**, but the shared `Dockerfile` fetches an amd64 Ollama ROCm bundle unconditionally — inert dead weight on Graviton (no AMD GPU). Recommended follow-up: arch-guard that step to shrink the bake (tracked in the design's Implementation section; not folded in here since it touches every host's build).
- Fixed three real bugs found by running it: ASCII-only AWS descriptions, Docker CE+buildx (stock `docker.io` lacks the BuildKit `--allow` support `./garden build` needs), and a patient AMI-available poll (large snapshots exceed the CLI waiter's 10-min cap).
- **Human-only step (deferred):** AWS Marketplace seller enrollment — the first release is deliberately private.
