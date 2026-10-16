# Gauntlet fix round 13: kriscendobot/minion.town PR #180

I applied the panel-13 must-fix and should-fix items in five follow-up commits. The PR head moved from `f9422e0` to `94ce118`, and CI is green on the new head (`ci-wait-merge.sh` returned 0).

**Must-fix items:**
- **wire-watcher** (`118e6c1`): the caplet used to send its owner credential, and retention keys, to whatever process held the control port. It now checks the listener first: it sends a fresh nonce to a new `/hello` route and continues only if the reply proves the listener holds the root secret.
  - A new test runs a fake listener that sends back a forged proof. It confirms the fake only ever receives `/hello` requests, with no authorization header and no secret.
  - New server-side tests cover `/hello` itself.
  - Also in this commit: control errors now name the peer and keep the JSON parse message (saboteur), and the long `control.ts` header comment is cut down (pruner).
- **assessor** (`b0284cf`): the original deploy script did evaluate the secret correctly on the box, so the finding was wrong. I rewrote it anyway so the evaluation is obvious: the secret goes into a variable, its length is checked (64 characters), then it is written to the file. Running the rendered script against a temp path gave a 64-character value with mode 600. The same commit trims the narrating comments (pruner) and replaces the em dashes typist flagged.
- **engine-realist** (`c6f138f`): a `remove` could land between a git partition being created and bound, leaving a partition that counts against the owner's cap but can't be reached. `remove` now takes the same per-name lock as the git bind. The new interleaving test fails when the lock is taken out.
- **stylist** (`052db82`): renamed the rest parameter to `installArguments`. The juror's suggested `arguments` is a reserved name in strict-mode modules, so it can't be used.

**Should-fix items:**
- **fast-checker and corner-prober** (`c6f138f` and `94ce118`):
  - a property test that 2–8 racing `create` calls on one name produce exactly one partition;
  - tests for a racing `create`/`readOnly` and for `readOnly(name, name)`;
  - a property test for both port variables;
  - boundary tests for the startup check that decides whether guests get git tools (missing, empty, malformed or non-loopback origin; 32-character, 31-character and missing secret).
- **archivist**: `DEPLOYMENT.md` now says the minted-URL files and test clones are temporary, and shows deleting them after the tokens are revoked.

**Declined, with reasons in the PR comment:**
- **benchmarker**: the commit claims a limit on how much rescanning a guest at its cap can force, not a speedup, and the existing test already checks that.
- **procurer**: both suggested imports are blocked.
- **coverage-auditor**: the repo has no c8 setup.

**Verification:** typecheck is clean. In the full local test run, one test fails: `capability.test.ts > propagates a git failure…`. It fails the same way locally on the unmodified `f9422e0` and passed in CI there, so it's specific to this host and not caused by these changes.

**Follow-ups:**
- Response comment on the PR: https://github.com/kriscendobot/minion.town/pull/180#issuecomment-6211915513
- Panel-14 is the driver's job, not this stage's.
- That local `capability.test.ts` failure may be worth a look on its own.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-13.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (5245782 cached reads)
- Output: 30864 tokens
- Cost: $2.5918843999999988
- Wall-clock: 1611s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
