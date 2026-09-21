Pushed to main2 (`b6d6a990c92`).

## Completion report

**Job:** Add `TYPESAFE_API_KEY` to the container env-var handoff allowlist.

**What I did**

The stated goal — "the garden picks up `TYPESAFE_API_KEY` on next container recreation" — spans two hops, so I wired both:

1. **`scripts/systemd/seed-api-key-handoff.sh`** — added `TYPESAFE_API_KEY` to the allowlist loop (the one-line addition the directive specified). Container PID 1 → lingering systemd user manager. Same base64url charset validation applies uniformly; no per-key logic.
2. **`garden`** launcher — added the matching `-e "TYPESAFE_API_KEY=..."` forward (host → container). The seed line alone would have been a no-op: the seed script reads the var from the container's environment, and that environment is populated only by the launcher's `docker run -e` list. Also documented the var in the `garden --help` Environment section, mirroring the existing keys.
3. **`scripts/jobs/test/api-key-handoff-test.sh`** — the test enumerates keys explicitly, so I extended it: added `TYPESAFE_API_KEY` to the `env -u` scrub, the seeded values, and the expected output. All 7 assertions pass.

**No key value invented/assumed/hardcoded.** Every change is gated on `${TYPESAFE_API_KEY:-}` being non-empty at runtime; nothing supplies or defaults a value. The test uses only a synthetic placeholder (`synthetic-typesafe`), consistent with the other keys.

**Docs:** No dedicated operator doc enumerates "handoff-eligible key names" as a generic list — the per-provider pages (e.g. `ollama-cloud.md`) and the `starting.md` comment are keyed to *worker kinds*, and TypeSafe has no worker kind or consumption path yet, so I did not fabricate one. The `garden --help` Environment block is the actual enumeration and now includes the new key. I intentionally did **not** reference `skills/typesafe-ai/SKILL.md` in the help text because that skill does not exist on `main2` yet (the prior `incorporate-typesafe-agent-skill` job is not landed).

**Follow-ups:** Consumption of `TYPESAFE_API_KEY` (wiring it into a worker/handler and defining a TypeSafe worker kind) remains a separate later step, as the directive noted, contingent on a key value existing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/typesafe-api-key-handoff-allowlist.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1036679 cached reads)
- Output: 8570 tokens
- Cost: $1.2067414999999997
- Wall-clock: 157s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
