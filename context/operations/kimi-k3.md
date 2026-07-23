# Bounded Moonshot Kimi K3 activation

The hosted `mystic` worker is an explicit-model-only Moonshot pool. It invokes the
official Kimi Code CLI with `model: kimi-k3`, a per-job `KIMI_CODE_HOME`, and a
one-invocation `KIMI_MODEL_API_KEY` derived from `MOONSHOT_API_KEY`. Do not enable
it as a default for design, build, or other high-stakes work. `mystic` is the
provider/model-neutral worker-kind name; `moonshot` and `kimi-k3` remain recorded
in routing and reputation metadata.

## 1. Supply the key before container creation

The launcher passes `MOONSHOT_API_KEY` only when it **creates** a container. The
value is not written to the repository or logs. PID 1 receives it at creation, and
the user systemd manager and `garden-mystic@*.service` workers inherit it.

On the host, avoid shell tracing and export the real value only in the command's
environment:

```sh
./garden reset
MOONSHOT_API_KEY='replace-with-secret' ./garden create
```

`reset` is required only when the existing container was created without the key.
If the container does not yet exist, omit it and run the second command. Do not use
`docker inspect`, `set -x`, or a command that prints the environment to test this.

## 2. Probe without leaking authorization

Inside `./garden sh`, make one status-only `/v1/models` request. This command prints
only the HTTP status. Do not add `-v`, do not echo the header, and do not save the
response as a fixture.

```sh
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $MOONSHOT_API_KEY" \
  https://api.moonshot.ai/v1/models
```

Expect a successful status before proceeding. A failure means stop at zero mystic
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
effect. The mystic pool refuses unpinned jobs by design, so the canary cannot take
ordinary board work.

## 4. Verify completion and reputation scope

After the canary, inspect its `jobs/tada/<base>.md` board completion and its emitted
reputation event. Confirm the event arm is scoped to `worker_kind: mystic`,
`provider: moonshot`, and `model: kimi-k3`, rather than an OpenAI, Anthropic, or local
provider. Then return the pool to zero unless a maintainer explicitly authorizes a
larger trial:

```sh
scripts/jobs/set-mystics.sh 0
```

Record whether Kimi Code completed Moonshot chat completions and tool calls. Until
both are observed, keep the compatibility question open and leave Kimi out of
default role routing.
