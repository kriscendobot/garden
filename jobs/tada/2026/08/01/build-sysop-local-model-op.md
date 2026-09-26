Inbox empty. Work is complete.

## Completion report

**Implemented the sysop `local-model` provisioning op** per `designs/sysop-local-model.md`. Landed on **main2 at revision `be985a3c01`**.

### What changed
- **`scripts/jobs/sysop.sh`** — new `local-model` op in the closed vocabulary. It joins the destructive tier (maintainer attestation required), and is the sole **async** op: the sysop never runs `ollama pull` in its oneshot tick. It validates + freezes the request, starts the fixed non-enabled pull unit with `--no-block`, and a new `poll_local_model` step at the top of every tick advances the host-local execution record (accepted-in-progress → accepted-and-applied | failed). All existing sysop invariants are preserved (deterministic/no-LLM, runs on every host, not leader-gated, still ticks under drain, host-scoped, idempotent, logged to `sysop-log/<GARDEN>/<msgid>.md`, acked). Guards fail closed **before any network/unit activity**: extra-field parse-error, missing/unclassified target, missing `pull_bytes`, ollama absent, endpoint unreachable, already-present no-op, insufficient-disk (`free ≥ pull_bytes + max(10 GiB, pull_bytes/4)`), and same-target-attach / different-target-busy serialization via a host-local `flock`.
- **`scripts/jobs/common.sh`** — added `ollama_models_dir` and `model_pull_bytes`; the three tier-inventory readers (`model_dispatch_tier`, `job_tier`, `tier_model_for_provider`) now read a throwaway 4th field so the optional `pull_bytes` column never leaks into the dispatch tier.
- **`scripts/jobs/pull-local-model.sh`** + **`scripts/systemd/garden-local-model-pull.service`** (new) — the deterministic async pull worker; the unit has **no `[Install]`** (never auto-enabled by `install-units.sh`) and `TimeoutStartSec=infinity`.
- **`scripts/jobs/model-tier-inventory.tsv`** — documented the optional 4th `pull_bytes` column.
- **`scripts/jobs/send-host-op.sh`**, **`CLAUDE.md`**, **`designs/sysop.md`** — documented the op (operators address it generically; `send-host-op.sh` already passes `key=value` pairs through).
- **`scripts/jobs/test/sysop-test.sh`** — 12 new hermetic cases (no real pull, no real systemd/ollama): trust-gate refusal (missing + non-maintainer `authorized_by`), extra-field parse-error, missing-`pull_bytes` fail-closed, ollama-absent, endpoint-unreachable, already-present no-op, insufficient-disk (asserts observed+required bytes), the full start→finalize happy path, no-`[Install]` assertion, and a fast op processed while a pull is in flight. **47 passed, 0 failed.** Syntax checked on every edited script.

### Operator invocation
To provision a named host's `local` default model:
```
scripts/jobs/send-host-op.sh endolin-garden-ece02cb4 op=local-model authorized_by=<maintainer-login>
```
The sender must be on `config/sysop-issuers` and `<maintainer-login>` on `maintainers/allowlist`.

### What still needs a human
- **The `garden-heal-local-qwen36-routing` fix has NOT landed** — `model-tier-inventory.tsv` still carries the phantom `local  qwen3:0.6b  myrmidon`. As instructed, I did **not** inline a literal tag. Until the corrected inventory lands qwen3.6 **with a reviewed `pull_bytes` (4th column) on the `local` row**, the op fails closed with a clear "no reviewed pull_bytes … deploy corrected inventory" message on any host — which is the designed behavior, not a bug. Whoever lands qwen3.6 must add its reviewed download size in the new 4th column.
- A host must **deploy** this change (and the corrected inventory) before it can receive `local-model`, and its garden Ollama endpoint must already be reachable (`hermits: N>0`, or an attested `unit action=start name=garden-ollama.service`); the op refuses rather than starting/enabling Ollama itself.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-sysop-local-model-op.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 133 tokens (8544907 cached reads)
- Output: 65556 tokens
- Cost: $7.474039499999999
- Wall-clock: 944s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
