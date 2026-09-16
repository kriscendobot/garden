# Design: attested `exec` for the sysop

The sysop gains an `exec` operation: a maintainer-attested, deterministic path for
running an arbitrary Bash command on one addressed garden host. This keeps the
property that matters in the existing sysop—plain code from message to process,
with no model and no inference—without pretending that a short operation
enumeration is a security boundary. A host-pinned gardener job can already run
general commands; `exec` makes the no-LLM path direct, bounded, and auditable.

This design changes no named operation. `set-workers`, `drain`, `reset-failed`,
and `restore` remain in the benign tier. `unit`, `deploy`, `local-model`, and
`maintain` remain in the destructive tier. `exec` joins the destructive tier.
This document supersedes the closed-vocabulary and arbitrary-command prohibitions
in [the original sysop design](sysop.md), but not its host addressing, named-op,
acknowledgement, or no-LLM contracts.

Maintainer directive: kriskowal, 2026-09-16.

## Decision summary

- `exec` requires `authorized_by: <login>` on `maintainers/allowlist`. The check
  happens before the command is decoded, validated, persisted, or started.
- `from_host` remains informational and self-asserted. Attestation is the
  operation gate; journal-push access is the outer perimeter. Any garden host may
  send an attested `exec` to any other garden host.
- `exec` honors drain. A drained host continues ticking the sysop and continues
  accepting the named `drain off` operation, but refuses `exec` without starting
  it. The sender must submit a new message after the drain is lifted.
- Execution is asynchronous, with one `exec` active per host. The sysop starts a
  dedicated non-enabled user unit and later ticks poll its result, as
  `local-model` and `maintain` already do.
- The default deadline is 300 seconds and the hard maximum is 1,800 seconds. A
  timeout terminates the whole execution cgroup, escalating from TERM to KILL
  after 10 seconds.
- Combined stdout and stderr are drained throughout execution. The audit record
  retains a bounded 64 KiB (the first and last 32 KiB), plus the byte count and
  SHA-256 of the complete stream.
- The command starts in a fresh per-message directory outside `$GARDEN_ROOT`,
  with a fixed environment and `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT`.
- A durable host-local receipt keyed by message id is written before process
  start and is never discarded automatically. This, not command idempotence,
  prevents a redelivery from executing twice.
- The boatman/kriskowal credential boundary is a build gate. The current tree and
  live container do not yet prove the invariant strongly enough; the concrete
  discrepancy and the required acceptance check are recorded below. `exec` must
  not ship until that gate passes.

## Message contract and ordering

The exact body grammar is:

```text
op: exec
authorized_by: <maintainer-login>
command_b64: <canonical RFC 4648 base64, one line>
timeout_seconds: <optional decimal integer, 1..1800>
reply_to: <optional existing sysop reply address>
```

No other body key is accepted. The decoded command may be empty only if the
sender deliberately encoded an empty byte string; it is capped at 32 KiB and may
contain newlines and any non-NUL byte. NUL is refused because `bash -c` cannot
represent it. Base64 avoids frontmatter ambiguity and preserves the exact bytes
that are later audited. `send-host-op.sh` may grow an ergonomic stdin or `--`
form, but it must emit this same representation; there is only one wire format.

The parser performs these steps in order:

1. Read only enough transport structure to identify `op: exec` and extract
   `authorized_by`.
2. Refuse a missing maintainer or a login absent from the already-loaded
   `maintainers/allowlist`. This is the existing destructive-tier gate in
   `sysop.sh`, extended by adding `exec` to its case arm. No command field is
   decoded or interpreted before this check.
3. Check drain and refuse if active.
4. Validate the exact key set, timeout syntax/range, base64 canonical form,
   decoded size, and NUL exclusion. Compute and freeze the command digest.
5. Under the host-local exec lock, resolve the message id against durable
   receipts and the one active execution, then either replay its recorded state,
   refuse `busy`, or atomically create its `prepared` receipt.
6. Start the execution unit with `--no-block`, transition the receipt to
   `started`, write `accepted-in-progress` to `sysop-log`, and ack.

“Before any parse” in the attestation requirement means before any operation-
specific parsing or command interpretation; reading the message envelope, op
name, and attestation field is necessarily the gate's input.

## Drain asymmetry

The sysop itself must continue to tick under drain. That is what keeps `drain
off` reachable and avoids an undrainable host. This rationale does not extend to
an arbitrary command.

`exec` therefore honors drain at two points: synchronously before a receipt is
prepared, and again in the execution runner immediately before `bash` starts. A
drain that wins either check produces a terminal `refused-draining` receipt, log,
and ack; the command never runs. If drain begins after the second check, the
already-started command is work in progress and may finish, matching drain's
ordinary “finish current work, undertake no new work” meaning. Named operations
remain unchanged and in particular `drain off` remains available.

Refusal, rather than deferred execution, is deliberate. A command that silently
starts hours after its attestation is harder to reason about and may no longer be
appropriate. A fresh post-drain message is a fresh operator decision and a new
audit identity.

## Execution envelope

The sysop tick never runs the command inline. It freezes the request beneath
`$GARDEN_STATE/sysop/exec/receipts/<msgid>/` and starts a fixed template unit,
`garden-sysop-exec@<msgid>.service`. The instance receives only the validated
message id; the runner reads the frozen command and limits from the receipt. No
command bytes appear in a unit name or an `ExecStart=` line.

The unit invokes exactly:

```text
/bin/bash --noprofile --norc -o pipefail -c <decoded-command>
```

There is no LLM, prompt construction, classification, repair, or retry anywhere
in the path. Shell expansion is Bash's specified execution semantics, not an
inference step. The exit status is Bash's status.

The initial working directory is a new mode-0700 directory at
`$GARDEN_STATE/sysop/exec/work/<msgid>`, outside the deployed checkout. There is
no caller-selected `cwd`. A command that needs another directory must say `cd`
explicitly, so that choice appears in the recorded command.

The runner clears the inherited environment and supplies only:

- a fixed `PATH` to reviewed system and garden tool directories;
- `HOME=$GARDEN_ROOT`, `GARDEN_ROOT`, `GARDEN_STATE`, and `GARDEN`;
- `LANG=C.UTF-8`, `LC_ALL=C.UTF-8`, `TZ=UTC`, and `TERM=dumb`;
- `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT` (preserving any stricter compiled-in
  behavior rather than inheriting a caller value).

It uses umask 077. It does not inherit `GH_TOKEN`, `GARDEN_GH_IDENTITY`,
`SSH_AUTH_SOCK`, API keys, or agent/session variables. The ordinary bot
credentials under the garden home remain reachable because arbitrary host work
sometimes legitimately needs the bot identity; the separate invariant is that
human/boatman credentials do not exist in this execution perimeter.

Only one `exec` may be active on a host. A different message arriving while one
runs is terminally refused as `busy`, not queued. This keeps resource use and
operator expectations bounded while leaving the sysop tick free to process
`drain off` and named ops.

The requested timeout defaults to 300 seconds and must be in `1..1800`. At the
deadline, the runner sends TERM to the execution's entire cgroup, waits 10
seconds, then sends KILL. `KillMode=control-group`, `SendSIGKILL=yes`, and a unit
runtime ceiling provide independent enforcement. Normal completion also kills
leftover descendants in that cgroup, so `cmd &` cannot accidentally leak beyond
the op. An explicitly invoked external supervisor such as `systemd-run` can
create an independently owned process; that is an intentional side effect of
the attested arbitrary command and is visible in the command audit, not something
the runner can prevent while still offering arbitrary shell execution.

The unit may outlive the sysop tick; that is the point of the async shape. Later
ticks observe `prepared`, `started`, and terminal result files. A reboot or unit
loss with no terminal result becomes `interrupted` and is never automatically
rerun.

## Bounded output and audit record

Stdout and stderr are combined in process-write order. A bounded collector keeps
draining the pipe so a verbose child neither blocks nor grows a file without
limit. It retains the first 32 KiB and last 32 KiB, while streaming the complete
byte sequence through SHA-256 and a byte counter. The collector writes its result
atomically. Output is treated as bytes, not parsed as text.

The terminal `sysop-log/<GARDEN>/<msgid>.md` record includes:

```text
op: exec
authorized_by: <login>
from_host: <self-asserted sender>
host: <executing GARDEN>
msgid: <id>
command_b64: <exact bytes passed to bash -c>
command_sha256: <digest>
shell: /bin/bash --noprofile --norc -o pipefail -c
cwd: <fixed per-message work directory>
timeout_seconds: <effective bound>
started_at: <UTC timestamp or absent if refused>
finished_at: <UTC timestamp>
outcome: accepted-and-applied|failed|timed-out|interrupted|refused
exit_status: <0..255 or unknown>
term_signal: <name or none>
output_bytes: <complete combined-stream byte count>
output_sha256: <complete combined-stream digest>
output_truncated: true|false
output_head_b64: <at most 32768 bytes>
output_tail_b64: <at most 32768 bytes; empty when untruncated>
```

Base64 keeps arbitrary commands and output from corrupting the log format. The
record is sufficient to reconstruct exactly what was passed to Bash, the fixed
execution context, its status, and every retained output byte. The full output
is deliberately not promised past 64 KiB; its total length and digest still make
truncation explicit and detectable. The terminal ack carries the outcome, exit
status, truncation flag, and a short decoded tail suitable for operator display;
the journal record is authoritative.

An `accepted-in-progress` record may be updated to the terminal record, following
the existing async-op convention. A refusal records the original command only
after attestation has passed; an unattested request records metadata and refusal
reason but does not decode or echo attacker-controlled command bytes.

## Exactly-once execution

Arbitrary commands are not idempotent, so the existing three-layer argument in
`sysop.md` is insufficient as written. The seen cursor can be lost, the journal
log write is best-effort, and “natural op idempotency” does not apply to `exec`.

The message id is the execution identity. Before start, the sysop atomically
creates a host-local receipt under a lock. Its state progresses monotonically:

```text
prepared -> started -> succeeded|failed|timed-out|interrupted|refused
```

The receipt contains the command digest before `started` is possible. Receipt
directories are never automatically deleted; their payload is bounded, and the
64 KiB captured output may be dropped after the journal terminal record lands,
but the small tombstone (`msgid`, digest, state, status, timestamps) remains.
Any delivery of the same message id consults the receipt first:

- terminal: reproduce the existing ack and ensure the journal record exists;
- prepared/started: attach to and poll that execution;
- no receipt: and only then, prepare and start once.

The start transition and unit runner use an exclusive create/lock so a crash
between `systemctl start` and the journal write cannot cause a second start. The
runner itself refuses to execute unless it can atomically change that same
receipt from `prepared` to `started`; a second unit invocation is a no-op. A
crash whose exact start status cannot be proven is resolved to `interrupted`,
never retried. This chooses at-most-once side effects over silently duplicating a
non-idempotent command.

The out-of-journal seen marker and `sysop-log` remain useful delivery and audit
layers, but the host-local receipt is the load-bearing deduplication fact for
`exec`.

## Trust and issuer model

`from_host` is self-asserted. There is no issuer gate and no claim that one can be
built from that field. Any principal that can push to `journal2` can originate a
message for any host and can forge message fields. Journal-push access is the
outer perimeter.

Within that perimeter, `authorized_by` is an attestation and deliberate-intent
gate, not a signature. The target checks it against its freshly synced
`maintainers/allowlist` before touching the command. This prevents accidental use
and leaves the named maintainer in the immutable message/audit history; it does
not defeat a malicious journal writer capable of forging the field. That is the
same explicit trust model as the existing destructive tier, now honestly applied
to the general capability.

## Boatman and ferry boundary: verified facts and ship gate

The intended load-bearing invariant is architectural: the sysop cannot reach the
boatman. The boatman environment carrying kriskowal credentials is outside the
garden container perimeter, does not run a full garden, and reads no message-bus
inbox. Therefore neither a forged `identity_switch_authorized` string nor an
attested `exec` can perform an identity switch or upstream ferry: the required
credential material and boatman execution path are absent.

The positive separation visible in this tree is concrete:

- `garden` bind-mounts only the instance checkout as the container home and does
  not forward the host's SSH agent.
- `context/first-run/auth.md` provisions a bot SSH key and bot `gh` token into
  that garden home; the normal `gh` wrapper defaults to the bot.
- On the claimed target host on 2026-09-16, the live garden environment reported
  only `kriscendobot` in `gh auth status`, and its SSH agent reported no
  identities.

However, the current repository/runtime also exposes contradictions that mean the
invariant is **not yet proved strongly enough to ship `exec`**:

- `roles/boatman/AGENT.md` and `CLAUDE.md` still describe a gardener in a full
  garden on a credentialed host claiming a ferry job and selecting
  `GARDEN_GH_IDENTITY=kriskowal`.
- The current launcher uses a privileged container, and on the inspected host the
  garden user has passwordless sudo and can see the host block device. Merely not
  bind-mounting a credential directory is not a security boundary if arbitrary
  code can become privileged enough to mount the host filesystem.

These are build prerequisites, not an open design choice. Before `exec` is
enabled, the ferry documentation and deployment must reflect the directive's
separate boatman architecture, and an acceptance probe from the exact exec unit
must establish all of the following: no kriskowal `gh` account/token, no human SSH
key or loaded agent identity, no bind-mounted human credential directory/socket,
no passwordless privilege escalation or host-device mount path that reaches those
credentials, and no boatman inbox/daemon in the garden. Failure of any probe
disables/refuses `exec`; it is not a warning.

This invariant would stop being true if kriskowal credentials were copied into a
bot garden home, a human SSH agent or credential directory were forwarded or
mounted, the sysop were installed in the external boatman environment, the
boatman were made a bus consumer, or a privilege/device/helper path let the exec
unit cross from the container into the credentialed host. As `CLAUDE.md` already
states, landing human credentials on a bot host is a separate,
security-weighted decision; doing so requires disabling `exec` until a new
containment design is approved.

## Root-repository invariant

The initial cwd is never `$GARDEN_ROOT` or any directory beneath it. The clean
environment sets `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT`, exactly as the worker
spine does, so a git command in an uninitialized directory under the root cannot
walk upward and attach to the deployed repository. The fixed cwd also removes the
most likely accidental path entirely.

This is an accident barrier, not a false sandbox claim. An arbitrary attested
command can explicitly say `cd "$GARDEN_ROOT"` or `/usr/bin/git -C
"$GARDEN_ROOT"`; preventing every spelling would require restricting arbitrary
shell execution. Such an explicit command remains possible and is visible in the
command audit. The standing prohibition on development git in the deployed root,
the sanctioned `deploy`/`maintain` paths, and the root-repo guard remain in force.

## Build and verification obligations

The follow-on implementation must:

1. Add `exec` to the destructive attestation arm before its operation-specific
   parser, leaving every existing named op unchanged.
2. Add exact-field parsing, canonical base64 validation, drain checks, the
   host-local receipt state machine, runner/collector, async template unit, poller,
   terminal audit update, and sender ergonomics described above.
3. Correct the general sysop documentation's claims that arbitrary execution is
   permanently forbidden and that every op is naturally idempotent.
4. Resolve and mechanically gate the boatman separation discrepancies above
   before enabling `exec` on any host.
5. Test unattested and unknown-maintainer requests without decoding the command;
   exact grammar; multiline/non-UTF-8 command preservation; command-size,
   timeout, and output bounds; exit/signal/timeout reporting; combined-output
   truncation and digest; clean environment and cwd; git ceiling; busy refusal;
   operation while the sysop tick returns; TERM-ignoring child KILL; reboot/unit
   interruption; all crash windows around receipt/start/log; repeated delivery
   and cursor/log loss without re-execution; refusal while drained; `drain off`
   still working while drained; and the ferry-boundary acceptance probe.

No implementation is part of this design change.
