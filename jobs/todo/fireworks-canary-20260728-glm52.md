---
role: gardener
model: fireworks/accounts/fireworks/models/glm-5p2
---
# Fireworks canary (isolated, reversible, no external side effects)

You are a bounded canary validating that the `fireworker` (Fireworks AI) lane can
execute a job end to end. Do exactly the steps below and nothing more. Do NOT
touch any repository content, do NOT commit, do NOT push, do NOT call GitHub, and
do NOT modify any file outside the one temporary file named here.

Work entirely inside your own per-job worktree (your cwd).

## Steps

1. Create a file named `.fireworks-canary` in your cwd whose entire contents are
   exactly this one line:

       fireworks-canary-glm52-ok

2. Read the file back and confirm the contents match that marker exactly.

3. Remove the file (`rm .fireworks-canary`).

4. Run `git status --porcelain` in your cwd and confirm the output is EMPTY.

## Report

Write a short report stating:

- the exact marker string you read back in step 2,
- that the file was removed,
- that `git status --porcelain` was empty,

and include the line `CANARY-MARKER: fireworks-canary-glm52-ok` on its own line.

Then emit the normal job completion marker as your final line.
