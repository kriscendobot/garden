# Fix the two-Ollama conflict: one owner for local inference, and liveness checks that mean something

handler-timeout: 5400

A garden-library change on `main2` (no PR — the garden pushes `main2` directly). It
lands the durable half of an incident diagnosed 2026-07-28; the immediate half (the
system unit stopped and disabled on `endolin-garden2-5bcdff64`) is already done by
hand and lives only in that container's writable layer, so a rebuild or container
recreate reintroduces the bug until this job lands.

## The incident, in evidence

Two Ollama units are armed on every instance, each with a DIFFERENT model store:

- the **system** `ollama.service` — Ollama's own installer unit, auto-started by
  `RUN systemctl enable ollama.service` added to the Dockerfile in `6f5541cf01`
  (2026-07-14, for the GPU-group fix). Runs as the `ollama` service user, store
  `/usr/share/ollama/.ollama` — in the container's writable layer, **empty**.
- the **supervised** `garden-ollama.service` — landed `b8ffeaa950` (2026-07-20),
  backoff `d25cb4eb3f` (2026-07-22), and declared the STANDING WAY TO SERVE in
  `context/operations/local-inference-amd.md`. Runs as the bot user, store
  `$HOME/.ollama` — bind-mounted, holds `qwen3.6:latest` (23G, since 07-14).

PID 1 starts system units before the user manager starts session units, so the
system unit wins `127.0.0.1:11434` at every container boot. On this host it took the
port at 2026-07-25T00:12:34Z and served an empty model set for three days.

Consequences, all verified from capture blobs:

- Every `model: qwen3.6` hermit job 404'd on its first turn
  (`unexpected status 404 Not Found: model 'qwen3.6' not found`), failing `rc=1` in
  3-15 seconds. 99 of 100 resolvable failure captures from 07-24..27 carry that exact
  signature.
- That churn produced a 61-dispatch graveyard of the standing xs2rust press
  (`jobs/tada/xs2rust-endor-press-consolidation-20260727.md` has the full forensics).
- `garden-ollama.service` deferred **3,860 times** with
  `Ollama endpoint already answers at ... (another process owns 127.0.0.1:11434)`.

## What to change (all on `main2`)

1. **One owner.** Remove the `RUN systemctl enable ollama.service` from the
   `Dockerfile` so the image does not auto-arm the system unit, leaving
   `garden-ollama.service` (hermit-count-gated by `reconcile_ollama_unit`) the single
   owner of local inference. **Preserve what `6f5541cf01` was actually solving:** that
   commit enabled the system unit because the `ollama` SERVICE USER is the one it put
   in the `video`/`render` groups. If `garden-ollama` runs as the bot user, confirm the
   bot user gets the same GPU device-node group access (`entrypoint.sh` already grants
   it host-adaptively — verify, don't assume) or the endpoint silently drops to CPU.
   Read `context/operations/local-inference-amd.md` §§ 1, 2, 6 and § Container GPU
   access before touching this.
2. **Make the port guard mean something.** `scripts/jobs/ollama-serve.sh` backs off
   when ANY process answers the port. Require a **non-empty model set** (`/api/tags`
   or `/v1/models`) before treating a foreign listener as healthy; a listener serving
   zero models must NOT win the standoff — log loudly and/or take the port.
3. **Same fix in the readiness poll.** The hermit preflight
   (`scripts/jobs/handlers/codex-provider-common.sh`) polls `/v1/models` for
   readiness; `{"models":[]}` returns 200 and reads as ready. Require the PINNED model
   to be present, so a hermit fails its preflight with "endpoint serves no qwen3.6"
   instead of burning a claim on a guaranteed 404.
4. **Fail loud, once.** 61 dispatches died over eight days without anything surfacing
   "local inference is broken." Whatever path detects a model-less endpoint should
   raise ONE maintainer alert (`alert_maintainer`, deduped by signature), not a silent
   per-job failure. This is the part that turns a three-day outage into a same-hour one.
5. **Doc the invariant** in `context/operations/local-inference-amd.md`: exactly one
   unit serves `:11434`, which one, how it is armed, and the fact that a zero-hermit
   host serves nothing at all.

## Verification

Do not claim this works from reading alone — a rebuild is the only real test, and a
cold `docker build` is hours (hence the handler-timeout above; raise it in a follow-up
if you need more). At minimum:

- `shellcheck` the touched scripts and exercise the guard against a stub server that
  answers `:11434` with `{"models":[]}` — assert it does NOT stand down.
- Assert the preflight rejects a pinned model absent from the endpoint's list.
- State plainly in your report which checks were run live and which were reasoned.

## Notes

- Garden repo, `main2`, pushed directly — no PR (CLAUDE.md § Conventions).
- Do NOT run git with `$GARDEN_ROOT` as the enclosing repo; work in your own worktree.
- The running fleet does not pick this up until a deliberate deploy
  (`context/operations/deploy.md`), and the image not until `./garden build`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-28T01:24:07Z
