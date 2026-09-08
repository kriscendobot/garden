---
created: 2026-09-08
updated: 2026-09-08
author: gardener (designer)
---

# Provisioning and upgrading the Claude Code harness in minion.town

| Field | Value |
| --- | --- |
| Status | Proposed |
| Parent | [Claude on minion.town arc, item 1](https://github.com/kriscendobot/garden/issues/89) |
| Initial pin | Claude Code `2.1.236` |
| Upgrade owner | Dependabot proposal -> garden botanist gate -> automatic conduct |

## Decision

The minion.town runtime artifact always contains one exact, integrity-checked
Claude Code native binary. `ENDO_CLAUDE_ENABLED` controls whether minion.town
exposes and starts the Claude-agent wiring. It does not select a second image and
does not install software at runtime.

The authoritative pin is a small tracked manifest at
`tools/claude-harness/release.json`. A sibling exact npm dependency exists only
to give Dependabot a version source. The image build downloads the native binary
directly from Anthropic for its target architecture, verifies both the compressed
artifact and decompressed binary against the tracked manifest, and copies only the
binary and manifest into the runtime image. It does not run Anthropic's mutable
`install.sh` during a build and does not install every platform's npm package.

This follows Anthropic's documented native-install shape while keeping the image
reproducible. Anthropic documents exact-version installs, per-platform checksums,
and a signed release manifest in [Advanced setup](https://code.claude.com/docs/en/setup#advanced-installation-options).

## The pin

The first pin is `2.1.236`, the version named by Anthropic's `stable` channel on
2026-09-08. Record these values in `tools/claude-harness/release.json`:

| Field | `linux/amd64` | `linux/arm64` |
| --- | --- | --- |
| Anthropic platform | `linux-x64` | `linux-arm64` |
| Release commit | `82959839e9405dd642b4e3eaa6ef4101bf285fee` | same |
| Compressed SHA-256 | `944815ef17d3ee89b04d352bc68217835d45fa32b7906adbe223153159f8411d` | `78bf0f46b9349c28150a308fbf9a25ebd1de412052cb5a0b317437c375aefbb0` |
| Binary SHA-256 | `6c8818fa22187aa555c242be4abbacc44d6b71a32ac9631ee7b2b5d12f51f752` | `c38d37deaf1643083326c48a6acc0afb09dada126e6bda77ef1a4410ae60ca12` |
| Compressed bytes | 73,511,767 | 72,310,411 |
| Binary bytes | 334,645,552 | 331,798,760 |

The release commit value is
`82959839e9405dd642b4e3eaa6ef4101bf285fee`. The manifest also records the
release build time (`2026-08-19T16:49:51Z`) and Anthropic signing-key fingerprint
`31DD DE24 DDFA B679 F42D 7BD2 BAA9 29FF 1A7E CACE`. The deliberately redundant
version in `tools/claude-harness/package.json` is exact, never `latest`, `stable`,
`^`, or `~`. A check fails when it differs from `release.json`.

The corresponding `package-lock.json` lets Dependabot and reviewers see npm's
package graph and integrity values. It is not copied into the runtime image.
`release.json` is the build input because minion.town's AWS host is ARM64 while
GitHub's ordinary runner is x64; installing the npm package on the runner would
silently select the wrong optional native package.

## Image installation

Add a `claude-harness` stage before the application stages in `Dockerfile`. The
stage depends only on the tracked release manifest and an installer helper, so an
application source change cannot invalidate it.

The helper performs this closed sequence:

1. Map Docker BuildKit's `TARGETARCH` (`amd64` or `arm64`) to the manifest entry.
   Reject every other architecture.
2. Download the exact versioned `claude.zst` URL under
   `https://downloads.claude.ai/claude-code-releases/<version>/<platform>/`.
3. Check the compressed SHA-256, decompress with `zstd`, check the binary
   SHA-256 and byte count, and install it as mode `0755`.
4. Run the target binary under the target platform and require
   `claude --version` to print `2.1.236 (Claude Code)`. Also require
   `claude --help` to advertise the integration contract used by `@endo/claude`:
   `--print`, `--bare`, `--mcp-config`, `--strict-mcp-config`, and `--tools`.

For a cross-platform build, step 4 runs through BuildKit's registered emulator.
The runtime stage copies the single binary to `/usr/local/bin/claude` and the
manifest to `/usr/share/minion-town/claude-code-release.json`. It sets
`DISABLE_UPDATES=1`; only a rebuilt artifact may change the binary. A read-only
runtime filesystem then reinforces that policy.

At this initial pin, the cold network addition is about 69 to 70 MiB per target
and the unpacked runtime addition is about 316 to 319 MiB. The download,
decompression, and verification stay in one cacheable stage. The image publisher
must preserve a remote BuildKit cache keyed by `release.json`, because a fresh
GitHub runner otherwise makes every application deploy pay that cold download.
Only a pin change should miss this cache.

Every failure is fatal: missing download, checksum mismatch, decompression
failure, wrong version, missing command-line flag, or unsupported architecture
stops `docker build`. No partial image is tagged or published, and deployment
continues serving the preceding image digest. There is no flag-off exception that
publishes an image without the harness.

### The current AWS path

The live AWS workflow currently runs `deploy/aws/scripts/deploy-app.sh`, which
assembles a tarball on an x64 runner and installs it on an ARM64 EC2 host. It does
not consume `Dockerfile`. A builder must therefore reuse the same manifest-driven
helper with an explicit `linux/arm64` target to place `bin/claude` in that tarball,
then expose that path to the service. The helper must run before the S3 upload, so
a harness failure cannot replace `/opt/minion-town`.

Docker and EC2 packaging are adapters around the same pin and verifier. Landing
only the Dockerfile change proves the image case but does not satisfy the current
AWS deployment.

## Standing upgrade obligation

An upgrade is dependency work, not an operator remembering to run `claude
update`.

1. Configure Dependabot for `/tools/claude-harness` on a weekly Monday 09:00 UTC
   cadence with a [seven-day cooldown](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/dependabot-options-reference#cooldown-).
   It proposes the newest exact npm release old enough to clear the ordinary
   supply-chain maturity window. There is at most one open Claude Code bump.
2. The existing per-repository Dependabot watcher notices that PR and posts a
   [botanist](../roles/botanist/AGENT.md) job. The botanist's existing
   supersession check, seven-day maturity floor, release-note and advisory
   review, scripts-disabled install, CI gate, and bot-owned-repository
   disposition apply unchanged. The review also diffs the readable npm wrapper
   and postinstall code; the native executable remains opaque, so its signed
   release provenance and behavior probes are required evidence rather than a
   claim that its source was reviewed.
3. As the mechanical update step, the botanist runs a tracked refresh command.
   It downloads Anthropic's `manifest.json` and detached signature, verifies the
   signature with the tracked release key and exact fingerprint, and regenerates
   both architecture rows in `release.json`. A key change cannot ride inside an
   ordinary version bump; it requires its own maintainer-reviewed change.
4. CI rejects a version mismatch or hand-edited checksum, builds both Linux
   architectures from a cold harness stage, runs the command-line contract
   checks, and runs minion.town's ordinary typecheck and tests. The PR remains
   embargoed or red until every gate passes.
5. Once the botanist renders `MERGE-NOW`, the existing Dependabot auto-conduct
   path merges it. The normal deployment builds a new immutable artifact and
   promotes it only after the deployment smoke below passes. No human reminder or
   interactive update is on the critical path.

The successful upgrade evidence is one durable PR and deployment receipt naming:

- old and new exact versions;
- npm publish time and maturity-floor result;
- Anthropic manifest release commit, build time, signing-key fingerprint, and
  both compressed and binary SHA-256 values;
- passing image builds for `linux/amd64` and `linux/arm64`, with the observed
  `claude --version` output and required help flags;
- application test run URLs;
- the promoted image or tarball digest and the immediately preceding digest;
- a post-deploy invocation of the installed binary that reports the new version,
  plus the flag-off health probe and a flag-on `needs-auth` probe showing that the
  real spawn path reaches the harness without receiving a credential.

This receipt borrows the [sysop](sysop.md) operation shape: exact input, actor,
target, result, and rollback target are durable, and a sender can distinguish
"done" from "never ran". It does not reuse sysop's maintainer attestation gate.
The narrower Dependabot author check, pin-only diff, botanist verdict, and CI
gates are the standing authorization for this one dependency operation.

The last probe checks provisioning and wiring only. Authenticated inference is
owned by the arc's end-to-end evaluation and must not become a build-time secret
requirement.

### Rollback

Keep the preceding successful runtime artifact addressable. If build or smoke
fails, nothing is promoted. If a regression appears after promotion, redeploy the
preceding digest first, then revert the pin PR. Git retains the prior manifest,
and its exact versioned URLs and checksums reproduce the old harness. Never use
`claude update` or an in-container downgrade as rollback: that would create an
unattested binary different from the image digest.

## Credential separation

The image contains no Claude credential. The Docker build receives no
`ANTHROPIC_API_KEY`, `ANTHROPIC_AUTH_TOKEN`, subscription token, `.credentials.json`,
`CLAUDE_CONFIG_DIR`, or home-directory copy. CI contract checks use no credential.
Consequently the image, its layers, build cache, and release manifest are safe to
publish.

Credentials enter only after the artifact starts. The `@claude-account` runtime
flow receives a user's credential through its authenticated HTTPS setup route and
the host-only provider supplies it to that user's spawned harness through the
`apiKeyHelper` seam. A deployment-owned API credential, if one is introduced,
must come from the platform's runtime secret injection and be scoped to the one
child process. Neither route writes a credential into `/usr/local/bin`,
`/usr/share/minion-town`, the image config, or deployment receipt. This matches
Claude Code's documented [runtime credential sources and precedence](https://code.claude.com/docs/en/authentication#authentication-precedence).

## Interaction with `ENDO_CLAUDE_ENABLED`

Harness presence is unconditional. `ENDO_CLAUDE_ENABLED` is a runtime product
gate around the Claude-agent routes, tools, and process spawn already introduced
by [minion.town PR 87](https://github.com/kriscendobot/minion.town/pull/87). It is
not a build argument.

This costs the image size even while the feature is off, but preserves one tested
and publishable artifact. A flag change can enable the feature without rebuilding,
there is no "flag enabled but executable missing" state, and Docker cache is not
split between two image families. When the flag is false, no Claude process starts
and no credential is requested; the installed binary is inert.

## Test plan

- Unit-test manifest parsing, architecture mapping, unsupported architectures,
  version mismatches, and both checksum-failure paths using local fixtures.
- Build and inspect both target images. Require one `claude` binary, the tracked
  manifest, no credential-shaped environment or file, and `DISABLE_UPDATES=1`.
- Run `claude --version` and the help-contract check inside each target image.
- Prove cache behavior with two builds: an application-only edit reuses the
  harness layer; a release-manifest edit invalidates it.
- Corrupt each downloaded artifact in a fixture and require the build to fail
  before tag or upload.
- Exercise both deployment adapters. The Docker image and current ARM64 AWS
  tarball must report the same pinned version and binary SHA-256.
- Run minion.town with the flag absent and confirm ordinary health and tool
  discovery are unchanged. Run with the flag enabled and no runtime credential,
  and require the existing `needs-auth` result rather than `ENOENT`, a crash, or
  an implicit installer.
