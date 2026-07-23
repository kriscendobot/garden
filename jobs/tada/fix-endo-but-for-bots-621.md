Completed follow-up for https://github.com/endojs/endo-but-for-bots/pull/621.

The authorized caretaker-attenuation fix was already pushed at 61b511b5ea88f56b7a125f22755aea786abca440, so no additional source commit was needed. Resolved all three addressed maintainer review threads; kriskowal remains requested for review.

Verification: `npx --yes prettier@3.5.3 --check designs/README.md designs/caretaker-attenuation.md designs/endoclaw-oauth.md` passed; `git diff --check origin/llm..HEAD` passed; GitHub reports build, lint, test, browser-tests, and zizmor successful. A full local Yarn install was attempted but could not finish because better-sqlite3 native build exited 128, so no broader local suite was run.
