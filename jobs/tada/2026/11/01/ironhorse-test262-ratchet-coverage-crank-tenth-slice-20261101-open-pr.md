I opened the draft PR **endojs/endo-but-for-bots#1617**: https://github.com/endojs/endo-but-for-bots/pull/1617

- **Refs checked first:** `git ls-remote` showed the head branch `ironhorse-test262-ratchet-strict-store-wrappers-20261101` at `80d33e0e32cc9ef4b7b33c286c6b5c5065aae7bc`. It also showed `llm-9a14ddf` and `llm` both at `9a14ddf660912ed624e2d9047671d43e3a2f0cec`. All three matched the job.
- **How it was opened:** I got an isolated checkout of the head with `ensure-project-worktree.sh`. A `--find-only` run of `ensure-pr.sh` found no existing PR for the predecessor's marker. I then ran `ensure-pr.sh` with the predecessor's base `ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101`, the exact title, and the PR body exactly as given.
- **Checked afterwards:** the PR is a draft against base `llm-9a14ddf`, its head is `80d33e0e…`, and the body carries the predecessor's `garden-job:` marker.
- **Nothing changed in code:** I made no code changes, no commits, and no pushes to either the project or the garden.

**One thing for you:** `ensure-pr.sh` could not record #1617 on the board. It found no `work/ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101` entry because that job isn't claimed on this host. Later jobs can still find the PR through the marker in its body, but anything that reads the PR number from the predecessor's board entry won't see it until someone links it there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (244197 cached reads)
- Output: 4082 tokens
- Cost: $0.5191914
- Wall-clock: 77s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
