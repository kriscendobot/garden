All done. Final report below.

---

## Completion report: `bulletin-message-links-or-body`

**What I did.** Made the bulletin's "Messages to the maintainer" section followable — each entry now carries **both** a link to the message blob and the full message body inline (the task allowed either; both were clean).

**What changed** (in `scripts/jobs/bulletin.sh`, `compute_dashboard`'s `maint` loop):
- Added a `msg_body_quote()` helper that emits everything after the frontmatter `---` delimiter as a Markdown blockquote — each line prefixed with `> ` (blank lines → bare `>`), leading/trailing blanks trimmed, empty body → `> (empty message)`. Prefixing every line keeps fenced code blocks **balanced inside the quote**, so a Markdown- or fence-containing body cannot break the surrounding bulletin.
- The loop keeps the existing header line (`id` / from / reply_to), appends ` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/<id>)`, then the blockquoted full body. Dropped the now-unused one-line `sum` teaser.
- Added a SUBTEST 10 assertion in `scripts/jobs/test/run-test.sh`: a fixture maintainer message (with a fenced block + a `##` heading) must render the blob link, the full body as a blockquote (not a teaser), and a balanced fence.

**Verification.**
- `bash -n` clean on both files; `shellcheck` adds no new warnings (only pre-existing `GARDEN_TAG`/`render_board`/`SC1091` infos).
- The full test suite aborts at SUBTEST 1 (concurrency) in this sandbox — background gardener processes can't claim jobs here (0 claims), an environmental limitation unrelated to this change, so it never reaches SUBTEST 10. I verified SUBTEST 10's exact scenario with a focused harness mirroring its setup: the section rendered the header, the blob link, and the full body as a balanced blockquote — all five new assertions pass.

**Deploy.** Committed and pushed to `origin/main2` as **`4fa4c29f`** (bot identity `endolinbot`); built in an isolated worktree off `origin/main2`, then synced just `scripts/jobs/bulletin.sh` into the shared tree (its only divergence from origin was this change) and restarted `garden-bulletin.service` via `systemctl --user`. **Tick confirmed:** the loop reposted within ~8s, and the live `journal2:README.md` now shows each maintainer message with a blob link and full blockquoted body — including a long Markdown-table research message that renders intact.

**Follow-ups.** None required. Note: the bulletin's cost gate means it reposts only when the dashboard content changes; the format change itself triggered the one repost (new rendering differed from the posted one), which is expected and already happened.
