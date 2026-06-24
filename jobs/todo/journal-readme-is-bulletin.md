# Revise the journal shape: README.md becomes the bulletin; the old README.md becomes DESIGN.md

The maintainer wants the journal's landing page (`journal/README.md` on `journal2`,
what a visitor to the branch sees first) to **be the bulletin** — the maintainer
dashboard — and the **current** `journal/README.md` (which describes the journal's
design and layout) to move to **`journal/DESIGN.md`**. This touches both branches
and the running bulletin service; do it in this order.

## State (already established)

- `scripts/jobs/bulletin.sh` (on `main2`) is the continuous loop that currently
  writes the bulletin to `journal/bulletin.md` (write at line ~222, idempotency
  compare reads `bulletin.md` at line ~206). It runs as `garden-bulletin.service`.
- References to `bulletin.md` to update: `scripts/jobs/bulletin.sh`,
  `scripts/jobs/test/run-test.sh`, `roles/journalist/AGENT.md`.
- `journal/README.md` (on `journal2`) is the journal **design/layout** doc.
- `journal/bulletin.md` (on `journal2`) is the current generated bulletin.

## Step 1 — retarget the bulletin to `README.md` (on `main2`)

- In `scripts/jobs/bulletin.sh`, change the output target from `bulletin.md` to
  `README.md` everywhere: the write, the `git add`, the idempotency-compare read,
  and the header comments. Keep the freshness line, `## Latest` narrative, cost
  gate, durable cursor, and quiet-on-success behavior intact — only the filename
  changes.
- Update `scripts/jobs/test/run-test.sh` and `roles/journalist/AGENT.md` to refer to
  `README.md` instead of `bulletin.md`.
- `shellcheck`/`bash -n` clean. Commit and push to `origin/main2`.

## Step 2 — move the journal design doc aside (on `journal2`)

- `git mv README.md DESIGN.md` on `journal2` (the current layout/design narrative
  becomes `journal/DESIGN.md`). Add a one-line pointer at the top of `DESIGN.md`
  noting that the live dashboard is now `README.md`, and (optionally) a one-line note
  in the bulletin template/intro linking to `DESIGN.md` for the layout.
- `git rm journal/bulletin.md` — the bulletin now lives at `README.md`. (If you
  prefer, leave a one-line `bulletin.md` tombstone pointing to `README.md`; a clean
  removal is fine.)
- Commit and push to `origin/journal2`.

## Step 3 — redeploy the running service

The live `garden-bulletin.service` runs the OLD `bulletin.sh` (still writing
`bulletin.md`) until redeployed. After Step 1 lands, the garden root must pull
`main2` and **restart** the service so it writes `README.md` going forward:
`systemctl --user restart garden-bulletin.service` (set `XDG_RUNTIME_DIR=/run/user/$(id -u)`
if needed). If you can perform the restart, do it and confirm the next tick wrote
`journal/README.md`; if not (you are in a dispatch worktree without access to the
host service), **say so explicitly in your report** so the maintainer or a deploy
step completes it. Do not claim the cutover is live if you could not restart.

## Step 4 — reconcile the docs

Update any garden docs that name the bulletin's location so they are consistent:
the top-level `README.md` and `CLAUDE.md` already describe "the journal's README.md
is the maintainer dashboard" — verify that is now accurate and fix any lingering
references to `journal/bulletin.md`. Link `journal/DESIGN.md` where the journal's
layout was previously documented.

## Definition of done

`bulletin.sh` (+ test + journalist role) retargeted to `README.md` on `main2`;
`journal/README.md` moved to `journal/DESIGN.md` and the old `bulletin.md` removed on
`journal2`; the service restarted (or the restart explicitly flagged as a pending
deploy step); docs reconciled. Report the SHAs on both branches, whether you
restarted the service, and confirmation that a tick produced the bulletin at
`journal/README.md`. If blocked, report the diagnosis and ready-to-apply state
rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
