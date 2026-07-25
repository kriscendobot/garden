# Bounded Moonshot Kimi K3 activation

The hosted `mystic` worker is an explicit-model-only Moonshot pool. It uses the
official Kimi Code CLI headless path with the garden routing id `model: kimi-k3`
(mapped to Kimi Code's documented wire model id `k3`) and `MOONSHOT_API_KEY`.
Every job has a private persisted `KIMI_CODE_HOME`, so a requeue resumes only its
own session state. Do not enable it as a default for design, build, or other
high-stakes work. The pool ships disabled and remains so until a maintainer directs
a bounded canary.

## 1. Supply the key before container creation

The launcher passes `MOONSHOT_API_KEY` only when it **creates** a container, the
same secret-safe handoff used for `ANTHROPIC_API_KEY`. The value is not written to
a unit file, repository, bind-mounted home, or log. PID 1 seeds only the two
allowlisted provider keys into `/run/environment.d` (a container tmpfs) before the
lingering user manager starts; systemd's environment-d generator gives the key to
that manager and `garden-mystic@*.service` workers. The manager starts through PAM
with a fresh environment, so it does not inherit PID 1 directly.

On the host, avoid shell tracing and export the real value only in the command's
environment:

```sh
./garden reset
MOONSHOT_API_KEY='replace-with-secret' ./garden create
```

An existing container cannot acquire a new creation-time secret by restart. If it
was created without the key, use this secret-safe recreation sequence (`reset`, then
create with the key in that command environment). If the container does not yet
exist, omit `reset` and run the second command. Do not use `docker inspect`, `set
-x`, or a command that prints the environment to test this.

## 2. Probe without leaking authorization

Inside `./garden sh`, make one status-only `/v1/models` request. This command prints
only the HTTP status. Do not add `-v`, do not echo the header, and do not save the
response as a fixture.

```sh
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $MOONSHOT_API_KEY" \
  https://api.moonshot.ai/v1/models
```

Expect a successful status before proceeding. A failure means stop at zero Mystic
workers and diagnose account, network, or endpoint access without copying the key
into logs or chat.

## 3. Bounded worker and tool-using canary

Still inside the container, enable exactly one worker:

```sh
scripts/jobs/set-mystics.sh 1
```

Post a small, reversible job with frontmatter that explicitly includes
`model: kimi-k3`. Make it use a harmless tool action, such as creating and removing
a file in its isolated worktree, and require its normal completion marker. Do not
target a production repository, a design/build role, a merge, or an external side
effect. The Mystic pool refuses unpinned, builder, and designer jobs by design, so
the canary cannot take ordinary or high-stakes board work.

## 4. Verify completion and reputation scope

After the canary, inspect its `jobs/tada/<base>.md` board completion and its emitted
reputation event. Confirm the event arm is scoped to `worker_kind: mystic`,
`provider: moonshot`, and `model: kimi-k3`, rather than an OpenAI, Anthropic, or local
provider. Then return the pool to zero unless a maintainer explicitly authorizes a
larger trial:

```sh
scripts/jobs/set-mystics.sh 0
```

Record whether Kimi Code completed Moonshot tool use and report capture. Until both
are observed, keep the compatibility question open and leave Mystic out of default
role routing.
