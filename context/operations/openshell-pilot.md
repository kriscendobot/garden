---
created: 2026-09-29
updated: 2026-09-29
author: builder
---

# OpenShell host pilot

Run by hand **on endolin-garden2, outside `./garden`**, as your ordinary user.
Never give the garden container a Podman/Docker socket. This kit leaves the fleet
unchanged and uses separate host `systemd --user` units and container storage.
**The host trial has not been run; only mocked tests have run.**

Pinned release: **v0.1.2**, source
[`1358941b818d4126a7374aaf5216d87fc960e122`](https://github.com/NVIDIA/OpenShell/tree/1358941b818d4126a7374aaf5216d87fc960e122).
Spec: [confinement fit report](https://github.com/kriscendobot/garden/blob/journal2/projects/garden/openshell-confinement-fit.md).

## Run on the host

From the host checkout containing this change:

```sh
cd /home/kris/garden2
./scripts/openshell-pilot.sh preflight
# Resolve the printed prerequisites deliberately, then:
./scripts/openshell-pilot.sh install
./scripts/openshell-pilot.sh up
./scripts/openshell-pilot.sh test
./scripts/openshell-pilot.sh report
```

Preflight never runs sudo. Missing packages on Debian/Ubuntu may require an
administrator to run `apt install podman uidmap util-linux systemd openssl curl python3`.
The administrator must choose non-overlapping subordinate UID/GID ranges of at
least 65536 entries, enable `loginctl enable-linger "$USER"`, and resolve reported
user-namespace, AppArmor, kernel, or cgroup delegation failures. Do not disable
AppArmor or change kernel settings merely to pass the trial.

Checks cover actual user-namespace creation, delegated cgroup v2 CPU/memory/PID
controllers, Landlock ABI >=3, seccomp user-notify, executable prefix/state
filesystems, and `/tmp`. Executable host `/tmp` is a warning; installation and
persistent state never use it. Workload `/tmp` is explicitly `noexec,nosuid,nodev`.

`install` verifies hard-coded SHA-256 release archive hashes before extracting
only the CLI/gateway executable; repeat installs check installed hashes. `up`
pulls versioned runtime images and Ubuntu 24.04, builds Python/curl/git/gh/AWS CLI
into the workload, records immutable local image IDs, and reuses them thereafter.
Initial apt resolution is not reproducible. Model CLIs/auth are outside this trial.

The gateway uses fresh encrypted credential storage, pilot-specific mTLS on
`127.0.0.1:17670`, a clean environment, isolated configuration, and disabled
telemetry. Synthetic listeners use loopback ports 18443 (HTTPS) and 18444 (host
control), only during tests. These ports must be free. The test CA changes only
pilot image trust. Certificates expire after seven days; export results and
uninstall/reinstall for a later trial.

```sh
systemctl --user status garden-openshell-pilot-podman.service garden-openshell-pilot-gateway.service
journalctl --user -u garden-openshell-pilot-gateway.service --since '10 minutes ago'
```

## What the default test establishes

A generated fake bearer is bound to curl and exact `GET /echo` on the local TLS
endpoint. The endpoint records an exact bearer match and returns only a Boolean.
The host scans workload file/cat, environment, `/proc/self/environ`, child,
formatted exception output, and bounded gateway/sandbox logs without uploading
the secret. POST and another path must return OpenShell's `policy_denied`.
A live non-allowlisted endpoint, an ungranted binary, and metadata/link-local
egress must be inaccessible.

Host `.claude/.credentials.json`, `.codex`, `.ssh`, `.aws`, `.config/gh`, a host
canary, the control tree, and a known image canary outside the Landlock allowlist
must not open. The runner never reads or mounts real host secret files.
Successful startup/exec requires the pinned runtime's active Landlock allow/deny,
seccomp notification/ADDFD, and task-memory qualification. Additional checks cover
non-root identity, zero effective capabilities, no_new_privs, seccomp, inspected
mounts/network/resource limits, `/tmp` execution, and container/provider cleanup.

Failures block real stages **before their credential files are read**. Reports
contain PASS/FAIL/SKIP/NOT RUN, timestamps, versions, hashes, and image IDs;
raw output, credentials, account responses, and bucket keys are discarded.
Full upstream conformance, DNS-rebinding/reload races, real crash/core dumps,
refresh latency, and adversarial escape assessment remain **NOT RUN**. Passing
this bounded pilot is not production approval or removal of token authority.

## Optional GitHub stage

Issue a short-lived **fine-grained read-only PAT** for a disposable repository
and test account. Never use an existing bot/maintainer token, `gh auth token`,
or ferry credentials. The attestation flag asserts provenance and scope; the
kit cannot infer complete token permissions. Only `github_pat_` values qualify.

```sh
install -d -m 700 "$HOME/openshell-pilot-inputs"
(umask 077; read -r -s -p 'Throwaway GitHub PAT: ' pilot_token; printf '\n'; printf '%s' "$pilot_token" > "$HOME/openshell-pilot-inputs/github-token")
./scripts/openshell-pilot.sh test --github --attest-throwaway-read-only \
  --github-token-file "$HOME/openshell-pilot-inputs/github-token" \
  --github-login TEST_ACCOUNT \
  --github-repository TEST_ACCOUNT/DISPOSABLE_REPOSITORY
```

After synthetic checks, it verifies `/user`, reads refs over HTTPS, and requires
OpenShell's denial of an **empty** `git-receive-pack` POST. No pack or ref update
is submitted. Grants cover `/user`, exact repository discovery, and upload-pack;
there is no SSH, GraphQL, API-write, or push grant.

## Optional AWS stage

Use a disposable bucket and role limited by IAM to the intended read, with no
role chaining, SSM sessions, or unrelated resources. Supply temporary source
STS credentials that can assume that role and expire in 5-60 minutes.
Never source `~/.aws`, ambient instance credentials, or permanent keys.
The gateway assumes the requested role; workload values remain placeholders.

Save a mode-0600, non-hardlinked JSON file through a secure provider output flow
or editor. Exact top-level fields: `AccessKeyId`, `SecretAccessKey`,
`SessionToken`, `Expiration` (RFC3339 with timezone). The access key must start
with `ASIA`; extra fields, nesting under `Credentials`, and `AKIA` keys are refused.

```sh
chmod 600 "$HOME/openshell-pilot-inputs/aws-session.json"
./scripts/openshell-pilot.sh test --aws --attest-throwaway-read-only \
  --aws-credentials-file "$HOME/openshell-pilot-inputs/aws-session.json" \
  --aws-role-arn arn:aws:iam::123456789012:role/DISPOSABLE_READ_ONLY_ROLE \
  --aws-region us-west-2 --aws-bucket DISPOSABLE_BUCKET
```

Checks cover SigV4 GetCallerIdentity for the requested assumed role and
ListObjectsV2 (at most one key, no download). IAM is essential: STS POST `/`
does not distinguish every STS operation. The `aws ssm describe-instance-information`
caveat check requires recognizable denial because SSM has **no endpoint grant**.
This does not qualify Session Manager, its plugin, websockets, or chunk signing;
do not add SSM hosts or run sessions without a separate reviewed trial.

Both real stages require their own flag/file. Symlinks, hard links, permissive
modes, and known Anthropic/Codex/SSH/AWS/gh/ferry/maintainer paths are refused.
There is no ambient provider discovery or `--from-existing` flow.

## Export and teardown

`report` prints a Markdown path. Export it before uninstall:

```sh
pilot_state="${XDG_STATE_HOME:-$HOME/.local/state}/openshell-pilot"
cp "$pilot_state/openshell-pilot-results-$(date +%F).md" "$HOME/openshell-pilot-results-$(date +%F).md"
./scripts/openshell-pilot.sh down
./scripts/openshell-pilot.sh uninstall
```

Review and land the file at `projects/garden/openshell-pilot-results-YYYY-MM-DD.md`
on journal2 through the journal lander. The kit never pushes the journal.
`down` stops gateway, dedicated-store containers, and API service, retaining
state. `uninstall` also resets only that store and removes marked state, prefix,
runtime directory, and units. It leaves root packages, linger, kernel settings,
ordinary Podman/Docker storage, and other OpenShell installs alone.
Revoke throwaway credentials and remove supplied input files yourself.

Paths: `$HOME/.local/lib/openshell-pilot`,
`${XDG_STATE_HOME:-$HOME/.local/state}/openshell-pilot` (must be below home),
and ephemeral `/run/user/<uid>/openshell-pilot`. Existing unmarked directories,
symlinked paths, and unrelated units are refused. Keep XDG_STATE_HOME consistent
across lifecycle commands.

## Container-safe development checks

```sh
./scripts/openshell-pilot.sh install --dry-run
./scripts/openshell-pilot/test.sh
```

Dry-run only prints a plan; there is no live guard override. Tests use inert
archives and mocked subprocesses, with ShellCheck on both entry points.
Host compatibility remains unverified until the maintainer runs the trial.

Implementation references were the pinned CLI/schema, provider profiles, Podman,
TLS, and runtime qualification source; hashes came from release asset metadata
on 2026-09-29. The Podman README and gateway configuration reference were fetched
and preclassified together: Jev 1.13.0, injection 0.22/clean, slant neutral/1.0,
proceed; 21,748 input and 71 output tokens. Source archive SHA-256:
`4eeb6c2df8325da8c1d73b40fe321bbe08b89ec7adb0d567cb723c14971aa90f`.
