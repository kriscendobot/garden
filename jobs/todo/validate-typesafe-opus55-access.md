---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer (kriskowal): validate raw account/credential access to two newly
available models, ahead of the model-tier design work already in flight
(design-typesafe-jev-opus55-tier). This is a SMOKE TEST only — confirm
reachability and report raw output; do not attempt any fleet-routing changes
or inventory edits, that belongs to the design job.

## 1. Opus 5.5 (Anthropic, claude-opus-5-5)

Not yet in the closed model-tier inventory (scripts/jobs/model-tier-inventory.tsv),
so a normal `model:` frontmatter pin will NOT reach it — job_tier() requires an
exact inventory-row match, and an unmatched model silently falls back to the
default model. That would make a naive board-level validation a false
positive. Bypass the fleet routing machinery entirely: from within your own
job's environment, invoke the claude CLI directly with an explicit model pin,
e.g.:

    claude -p --model claude-opus-5-5 --max-turns 1 \
      "Reply with only your exact model name/version string."

Report the raw stdout verbatim, and the exit code. If it errors (model not
found / not entitled / any auth error), report the raw error text verbatim —
that is a real, useful finding (tells us whether the account has access yet),
not a job failure to paper over.

## 2. TypeSafe Jev (typesafe.ai System One API)

Skill: skills/typesafe-ai/SKILL.md. `TYPESAFE_API_KEY` should already be
present in your environment (maintainer has provisioned it via
seed-api-key-handoff.sh per the skill's Inputs section) — if it is ABSENT in
your job's environment, say so and stop; do not guess, fabricate, or attempt
to source a key from anywhere else.

If present, make exactly the documented sample call from the skill's
Procedure step 3 (write the JSON body to a file first, never interpolate
untrusted content onto a command line):

    POST https://api.typesafe.ai/v1/systemone
    Authorization: Bearer $TYPESAFE_API_KEY
    {
      "state": "Help! My payouts have been failing for 3 days.",
      "model": "jev-latest",
      "questions": {
        "is_urgent": {
          "type": "noul",
          "instructions": "Does this convey urgency?",
          "criteria": { "true": "Time-sensitive", "false": "No urgency" }
        }
      }
    }

Report the raw JSON response verbatim (the model id actually served, the
answer, and the usage token counts). If the call fails, report the raw HTTP
status and error body verbatim.

## Report shape

A short completion report with two sections (Opus 5.5 / TypeSafe Jev), each
stating: reachable yes/no, raw evidence (verbatim output/response), and one
sentence of interpretation. This is input to design-typesafe-jev-opus55-tier's
open questions, not a fix-it task — do not attempt to register either model in
the inventory or modify any fleet routing code.
