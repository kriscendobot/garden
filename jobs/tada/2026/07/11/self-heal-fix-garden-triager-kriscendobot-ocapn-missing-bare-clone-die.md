All done. Final state confirmed: origin/main2 is at `4c0e275b0b`, all three affected suites green, and the follow-up gap is surfaced to the maintainer.

---

## Completion report

**Job:** Fix the `garden-triager@*` every-tick crash-loop (`triager.sh` hard-`die`d on a missing bare clone, and looked in the never-provisioned `repos/` store instead of `worktrees/`).

**What I found on arrival / during the work:** Two peer commits had already landed the two cheapest fixes — `GARDEN_REPOS` default repointed to `worktrees/` (`9ad9c72931`/`118f7384fc`) and the hard `die` softened to a clean skip (`e33d0b71ba`) — plus a regression-guard **case I** (`1628b0935e`) locking the clone-less-host skip behavior. That un-wedged the crash-loop but left the three watched repos with **no clone on any host** (`kriscendobot-{ocapn,agoric-3-proposals,cosgov}`) silently un-triaged, which is the gap my job's part 2 (self-provision) targets.

**What changed (landed on `main2`):**
- `common.sh` — factored clone-keeper's `is_own_git_repo`, `is_remote_location`, `derive_clone_url`, `bounded_clone` and the `GARDEN_CLONE_URL_BASE` default into shared helpers; `clone-keeper.sh` now sources them (no logic change).
- `triager.sh` — a missing clone is now **non-fatal**. Default is the fleet's clean skip; **`GARDEN_TRIAGE_SELF_PROVISION=1`** opts a host into self-provisioning the standing bare clone (derive URL from slug → bounded atomic `git clone --bare` into a sibling temp + `mv -T` → set the `origin/*` fetch refspec → fall through to the normal fetch). Unreachable source → skip + retry next tick + throttled maintainer escalation; underivable slug → escalation. Never exits 1.
- `test/triager-test.sh` — reworked case H into H1–H4 (opt-in provision succeeds→triages; default clean skip; unreachable→skip+escalate; underivable→escalate), all hermetic via a local upstream registry + `GARDEN_ALERT_CMD` capture stub.
- `test/clone-keeper-test.sh` — fixed a pre-existing parse bug (its single-line `sed` couldn't read the now-two-line shipped `GARDEN_TRACKED_CLONES` default → 3 spurious failures).

**Design decision:** I deliberately made provisioning **opt-in (default off)** rather than default-on. My first commit (`2c76c8cd92`) defaulted it on, which fought the peer's case I guard and left `main2` red; `4c0e275b0b` reconciles that — default behavior matches the just-landed skip-model, and the provisioning mechanism the spec asked for is present and tested, gated behind the knob so it doesn't auto-clone every watched repo on every host or risk escalation noise on possibly-nonexistent forks.

**Tests:** triager 62/0, clone-keeper 45/0, comment-watcher 213/0.

**Follow-up (messaged to the maintainer):** the 3 clone-less repos are no longer crashing but stay un-triaged under the default skip; to triage them, create their bare clones under `worktrees/`, or arm `GARDEN_TRIAGE_SELF_PROVISION=1` on one host after confirming those forks exist.
