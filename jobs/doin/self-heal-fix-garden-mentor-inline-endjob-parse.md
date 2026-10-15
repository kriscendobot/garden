---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
The mentor's semantic-output parser (the code that emits "EOF reached inside JOB '<name>' with no closing ENDJOB (unterminated block)" in the mentor-claude / mentor scripts under scripts/jobs/) rejects a well-formed job block when the provider writes it on a single line. The OpenAI provider returned `JOB improve-require-execution-role <body…> ENDJOB`, with the name, body and terminator all on one line. The capture is saved at .garden-state/mentor/rejected/20261015T075404.663562281Z-openai.txt. The result is a FATAL exit 1, "improve handler failed; leaving markers so the next tick retries", and a retry loop every tick. Fix:
1. Make the parser tolerant. Accept a trailing `ENDJOB` token at the end of any line, not only on a line by itself. Split `JOB <slug> <rest>` so the text after the slug becomes the body.
2. Normalise the output before parsing, for example by putting `JOB` and `ENDJOB` tokens on their own lines when they appear inline.
3. Tighten the mentor prompt to say that JOB and ENDJOB must each be on their own line.
4. Add a regression test that uses the rejected capture above as a fixture and expects one parsed job named improve-require-execution-role. Also test that a genuinely unterminated block is still rejected.
Keep the existing refusal to fall back to another provider after a real malformed reply.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T08:04:16Z
