# Operating another host through the sysop

How to change worker capacity or apply a bounded system operation on an
unattended follower. Each host may mutate only itself. The standing
`garden-sysop` daemon is the remote seat that receives a structured bus message
and runs the same hardened local tool on the addressed host. The rationale and
closed operation grammar live in `designs/sysop.md`; this page is only the
operator procedure.

## Changing another host's workers

`set-workers.sh` intentionally rejects a cross-host write:

```sh
scripts/jobs/set-workers.sh <kind> <count> [host]  # host, when present, must be this host
```

For an unattended host, send the operation to that host's sysop instead:

```sh
scripts/jobs/send-host-op.sh <GARDEN> op=set-workers kind=<kind> count=<count>
```

The addressed daemon invokes `set-workers.sh <kind> <count>` **on itself**, so
the local-only guard is satisfied rather than bypassed. The target's scaler then
reconciles that declaration. The same path handles the other reversible,
host-scoped operations:

```sh
scripts/jobs/send-host-op.sh <GARDEN> op=drain state=on reason='maintenance'
scripts/jobs/send-host-op.sh <GARDEN> op=drain state=off
scripts/jobs/send-host-op.sh <GARDEN> op=reset-failed
scripts/jobs/send-host-op.sh <GARDEN> op=restore
```

`restore` here runs only the deterministic recovery one-shots. Doom triage and
redispatch still require the liaison's judgment (`skills/restore/SKILL.md`).

## Authorization boundary

Journal-push access is the authorization boundary. Any garden host may send an
operation to any other garden host; `from_host` is self-asserted, so there is no
additional issuer allowlist. After sending, wait for the target sysop's next tick
and inspect its acknowledgment or `sysop-log/<target>/` rather than assuming the
operation arrived.

## Operations that require maintainer attestation

The reversible tier above needs no maintainer attestation. These less reversible
operations require it:

```sh
scripts/jobs/send-host-op.sh <GARDEN> op=unit action=restart \
  name=garden-foreman.timer authorized_by=<maintainer-login>
scripts/jobs/send-host-op.sh <GARDEN> op=deploy authorized_by=<maintainer-login>
scripts/jobs/send-host-op.sh <GARDEN> op=local-model authorized_by=<maintainer-login>
scripts/jobs/send-host-op.sh <GARDEN> op=maintain authorized_by=<maintainer-login>
```

`authorized_by` must name a login in journal `maintainers/allowlist`. It is a
maintainer attestation, not authentication: journal push access is the underlying
trust boundary (`designs/sysop.md` § Trust model). No agent may originate the
field. An agent saying “please redeploy host X,” or sending an unattested host-op,
is only a request; the maintainer must supply the attestation by explicitly
sending or authorizing the exact structured operation. The sysop refuses a
missing or non-allowlisted `authorized_by` before execution.
