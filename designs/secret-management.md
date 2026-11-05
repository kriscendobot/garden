---
created: 2026-11-05
updated: 2026-11-05
author: designer
---

# File-based secret management

## Decision

Garden-managed API keys live only in the host checkout at
`<garden-root>/.garden-state/secrets/`. The host directory is mode `0700`; key
files are mode `0600`, owned by the garden user, gitignored, and bind-mounted at
the same absolute path read-only inside the container. A nested read-only mount
is required even though the whole checkout is already mirrored: it prevents a
container process from changing or deleting a host key. A host rename or
container reset does not move the directory.

The tracked registry `scripts/secrets/registry.tsv` is the single inventory of
garden-managed kinds. Its initial rows are `anthropic`, `moonshot`, `fireworks`,
`openrouter`, `ollama-cloud`, and `typesafe`, mapping respectively to the six
`*_API_KEY` names currently forwarded by `garden`. Each row fixes the filename,
validator, consumer mode (`harness` or `direct`), allowed origin and path family,
and default maximum age. The registry contains no values and no executable
shell fragments.

Changing a direct-service key affects the next request. Changing a harness key
affects the next job: the per-service launcher reads the file immediately before
starting the CLI and places only that key in only that child. No container or
systemd service is recreated or restarted.

This supersedes the TLS-intercepting approach in
[`host-key-injection-proxy.md`](host-key-injection-proxy.md). The garden does not
need a CA, HTTPS interception, or a new host proxy to obtain live rotation.

## Existing inventory

A value-free survey on 2026-11-05 found four credential classes:

| Class | Current home and fleet difference | Disposition |
| --- | --- | --- |
| Garden provider keys | Creation-time environment: Anthropic, Moonshot, Fireworks, OpenRouter, Ollama Cloud, TypeSafe. On leader `endolin-garden-ece02cb4`, presence-only probes found Moonshot and Fireworks set and the other four absent; in particular TypeSafe is absent. Follower API-key presence is intentionally not published centrally. | Move these six kinds to the new directory, per host. |
| Harness logins | Claude Code uses `~/.claude/.credentials.json`; Codex uses files under `~/.codex/`. The leader has working Claude and Codex logins. Follower `oros-studio-garden-ce242c49` runs three monks on its separate `claude-oros` subscription and no clerics; its 2026-11-04 health record warned that the Claude sign-in needed renewal. | Keep the CLI-owned files. They are already live bind-mounted files; a new job observes a re-login without container recreation. |
| Bot and cloud identity | Each host has its own bot SSH key and `gh` login. The existing `gh` wrapper reads the live bot token per call. The leader also has a verified `garden-fleet` AWS profile; recent Oros records say it has no AWS CLI or AWS credential and its bot token has narrower GitHub permissions. | Keep the native stores and their existing probes. Do not copy them into the API-key registry. Prefer short AWS sessions or instance roles as hosts evolve. |
| Remotely held secrets | The minion.town MCP client secret is read from AWS Secrets Manager at refresh time and only a short-lived token is cached under `.garden-state/minion-mcp/`. Other application secrets already in Secrets Manager or SSM are read by their owning workload. | Keep them there. Do not materialize a second file copy. |

The leader/follower asymmetry is expected, not drift: subscription accounts,
provider access, GitHub permissions, and AWS roles are per host. The journal and
hub never carry values or a declarative fleet-wide capability inventory. The
outbound audit necessarily reveals non-secret host, kind, and use metadata, but
claim gates never consume it as a capability declaration.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Lifecycle / commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| maintainer -> host store | `set-key.sh` validates and atomically replaces a file | the maintainer chooses, rotates, revokes, or removes a key | the host key file | the maintainer | secret bytes on hidden terminal input or stdin |
| host store -> service wrapper | trusted launcher or broker reads one registered file at call time | registry fixes service, endpoint, projection, and age policy | none | wrapper owns one invocation | direct key stays in broker; harness key crosses only at the next boundary |
| wrapper -> journal/provider | ledger commits before egress; wrapper then injects authentication | existing job authorization plus endpoint allowlist | `journal2:outbound/<service>/` owns the non-secret audit record | accepted ledger push commits; provider owns the remote effect | authorized request and provider response |
| handler -> harness child | provider launcher supplies one child environment | worker-kind registry selects the one provider | CLI-owned session state only | handler owns process start; CLI owns its session | one unavoidable child environment variable, or a CLI login file |

The host store owns persistent key state. Only the maintainer commits or removes
that state; a wrapper is read-only. The wrapper retries a failed provider request
but never rolls a key back. The next wrapper call is the replay boundary. The
handler classifies process execution; the job spine decides requeue or completion.
The inner/outer naming check is satisfied: `secret store`, `service wrapper`,
`outbound record`, and `harness launch` name their own mechanisms, not a provider
or job lifecycle they do not own.

## Placement and status tools

`scripts/secrets/set-key.sh <kind>` is the only placement tool. With a terminal it
uses `read -rs`; `--stdin` reads one value from standard input; `--remove` removes
the registered file. It rejects an unknown kind, empty input, newline/NUL,
whitespace, implausible length or alphabet, and a missing stable prefix where the
provider documents one. Validation errors name only the kind and rule. With
`umask 077`, it writes and `fsync`s a temporary file in the secrets directory,
validates the written file, and reasserts directory and file modes. An exclusive
store lock prevents a wrapper read during placement. The tool keeps the prior file as a
private rollback copy, renames the new file into place, lands the placement
record, and then releases the lock and deletes the rollback copy. A failed ledger
write restores the prior file before any wrapper can observe the replacement.
Removal uses the same move, ledger, delete-or-restore sequence. It never accepts a
value in argv and never prints or partially prints one.

Every successful place, replace, or remove lands a value-free record in
`outbound/secrets/`: host, kind, action, `placed_at`, and `authorized_by`. If that
ledger write fails, the operation reports failure and restores the prior state
before releasing the store lock. Agents may run `scripts/secrets/status.sh`, which reports only
`present|absent`, `valid|invalid`, and age. They never run the placement tool and
never type, paste, select, or retrieve a key. The maintainer performs placement on
each host.

`scripts/secrets/import-environment.sh` is the migration-only companion. It walks
the same fixed registry, imports present legacy variables through `set-key.sh
--stdin`, refuses to overwrite unless `--replace` is explicit, and reports kind
names only. It cannot enumerate arbitrary environment variables.

## Service wrappers and outbound ledger

There is one tracked entry point per service under `scripts/outbound/`; shared
parsing is library code, not a generic "read any secret" command. Every entry
point requires `--authorized-by <job-base-or-maintainer-attestation>`, validates
that label, rejects caller-supplied authentication headers and unregistered
origins, methods, or paths, and creates an accepted journal record before egress.
Journal unavailability is fail-closed.

Each record contains service, host, authorization label, UTC time, method, path,
and a `body` projection. The projection is the complete non-sensitive body when
safe. For prompts, foreign source text, and other content not suitable for the
public journal it is a structured body containing the question or operation,
byte length, and SHA-256 instead of the text. TypeSafe records its questions and
input hashes, never the classified source. No record contains an auth header,
key, credential fingerprint, provider response body, or token.

Direct HTTP consumers (`classify-foreign-content.sh`, `fetch-source.sh`'s strict
preflight, `muster-pilot.sh`, and `openrouter-promo-tool-canary.sh`) call their
service wrapper. A small `garden-secret-broker` user service owns the public Unix
socket and performs those HTTP calls: it re-reads the file, validates the exact
request, commits the ledger record, and gives the key to `curl` on config stdin
(`curl -K -`). The broker never returns a key. The socket protocol accepts no
arbitrary URL or header. A caller can exercise the registered operation and see
its result, but cannot turn the broker into a general credential oracle.

Harnesses are necessarily different. `claude`, `codex`, Kimi Code, and OpenCode
require either their login file or an environment variable. Their Anthropic,
Moonshot, Fireworks, OpenRouter, and Ollama Cloud launchers therefore:

1. commit one logical `EXEC` request record containing job, provider, model,
   fixed endpoint family, and prompt hash;
2. clear all six legacy key variables from the child environment;
3. read and inject only the selected provider key, or leave authentication to the
   selected CLI login; and
4. `exec` the CLI in the job sandbox.

The CLI's internal HTTP turns are opaque, so the ledger is exact at the wrapper
boundary rather than pretending to contain unseen wire bodies. Existing transcript
and usage capture remains the per-turn record. An API key or OAuth credential that
the CLI itself must consume cannot be hidden from that child: an API key is in its
environment, and a login credential is readable by that CLI. Rotation is still
live at the next job, and unrelated jobs no longer inherit every provider key.

## Fleet capabilities

`secret_available <kind>` is an uncached, local, value-free check: registered
file, regular file, correct owner/mode, non-empty, and shape-valid. It does not
call the provider. `host_capability_probe typesafe` uses this predicate instead
of `TYPESAFE_API_KEY`; the fresh post-claim check uses it again. Thus implicit
`scholar-ingest-*` requirements stop silently skipping only when this host has a
valid TypeSafe file. Other provider backend probes use the same predicate plus
their existing CLI and bounded liveness checks. Credential fingerprints hash the
file content in memory and retain only the digest in private host state; they
never publish it.

The same rules apply on leader and followers. A new follower has no provider
capability until the maintainer places that host's keys. An AWS host uses an
instance role/session for AWS and continues fetching an AWS-owned application
secret at use time; it does not import that value. `requirements-watch` continues
to report an unclaimed `requires:` job without publishing which named host lacks
which secret.

## Migration

There is no flag day.

1. **Compatibility release:** add the directory mount, registry, placement/import
   tools, broker, wrappers, sandbox, probes, and tests. Wrappers prefer a valid
   file and fall back to the matching environment variable for this release only.
   `garden` continues the current six-variable forwarding and
   `seed-api-key-handoff.sh` bridge. Each existing container is recreated once to
   acquire the nested secrets mount; adding, replacing, or removing keys after
   that migration does not recreate it.
2. The maintainer runs `import-environment.sh` on each live host, then
   `status.sh`. Move direct TypeSafe/OpenRouter callers first, then provider
   preflights and harness handlers, then `common.sh` capability/fingerprint logic.
   A fleet audit must show every enabled provider is file-backed; disabled kinds
   need no key.
3. **Removal release:** delete the six `docker run -e` arms and their entries in
   `seed-api-key-handoff.sh` (retain the unrelated journal-clone setting), remove
   environment fallback, and reject those six variables in worker-unit
   environments. Existing CLI login files are unchanged. A host missing a file
   scales that provider to zero and receives the existing actionable notice.

Operational docs for Moonshot, Fireworks, OpenRouter, Ollama Cloud, TypeSafe, and
first-run authentication change from "recreate the container" to `set-key.sh` and
presence-only `status.sh`. `CLAUDE.md` points operators and future workers to that
single operations page instead of restating the procedure.

## Least privilege and upkeep

Use one restricted key per host and service where the provider supports it; do
not share one fleet-wide key merely for convenience. The registry's default age
is configurable per kind and globally through `GARDEN_SECRET_MAX_AGE_DAYS`.
`garden-secret-watchdog` compares file mtime with that limit and posts one
edge-latched reminder naming host, kind, placement date, and age, never a value or
fingerprint. Rotation is replace-in-place; revocation at the provider remains a
maintainer action.

The watchdog also reports a loose end when a valid installed kind has no registry
consumer, or has no outbound record beyond a configurable idle period. It never
deletes a key: the maintainer first revokes it at the source, then uses
`set-key.sh <kind> --remove`. This catches stale experiments without teaching an
agent to decide credential custody.

An enforcing egress lock is a later defense layer. It should default-deny direct
provider traffic and open only the wrapper's registered host/method/path window.
File management does not depend on that work, but until it lands a harness child
holding an environment key can make calls outside its launcher.

## Threat model

Ordinary job and liaison harnesses run in a fail-closed bubblewrap namespace that
can see their worktree, required garden code, bot git/gh material, and only the
CLI credential needed for that harness. It overlays
`.garden-state/secrets/`, the broker's private state/socket, and
`/run/environment.d` as inaccessible, unshares PID visibility, and sanitizes the
environment before the CLI starts. If bubblewrap or user namespaces are
unavailable, a worker requiring a secret does not start. The direct-service
socket alone remains visible. The explicit operator `garden sh` escape hatch and
container root remain trusted administration surfaces and can read the mounted
store.

A prompt-injected agent can read and modify its authorized worktree and can invoke
an allowed direct-service wrapper, causing cost and disclosure of whatever body
the wrapper permits. It cannot read a direct-service key, ask the broker for an
arbitrary endpoint, or inspect sibling provider keys. A harness child can read its
own required environment key or login file and can misuse that authority until an
egress lock confines it; this is the irreducible limitation of current CLIs, not a
claim that environment variables are secret from their child.

The sandbox must deny the secret directory, legacy environment handoff, broker
private paths, other harness credential homes, host AWS material unless the job
requires AWS, and maintainer/ferry credentials in every case. The broker and
trusted parent handler are the only components allowed to cross the secret-file
boundary.

## Verification

- Hermetic tests cover terminal/stdin placement, validators, mode repair,
  temp-then-rename, removal, import refusal/replace, and output free of fixtures.
- A running-container test rotates a synthetic key on the host and proves the
  next broker request and next harness launch use the replacement without a
  container or service restart; concurrent requests see either whole old or whole
  new content, never a partial file.
- Wrapper tests reject missing authorization, arbitrary URLs/headers, bad methods,
  and provider egress before a ledger push; accepted calls prove ledger-before-send
  ordering and body projection.
- Sandbox tests run an adversarial child that attempts the secret directory,
  `/proc` parent environments, `/run/environment.d`, broker private socket, other
  harness homes, and AWS/ferry paths, while proving the worktree and public wrapper
  still work.
- Capability tests update `host-requirements-gating-test.sh` so a valid TypeSafe
  file admits `scholar-ingest-*`, and absent, malformed, wrong-mode, and legacy-env-
  only cases do not after fallback removal.
- A repository scan and transcript fixture assert that no key value reaches argv,
  environment outside the selected harness child, logs, journal, reports, or git.

## Follow-ups

The builder implements the compatibility release and its removal gate as
`build-secret-management-20261105`. The removal release is deployed only after
both live hosts pass the file-backed audit. Egress enforcement remains a separate
design and build after this migration.
