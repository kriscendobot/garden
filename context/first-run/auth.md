# The three credentials

A fresh clone holds no credentials. A working instance needs exactly three, and
each has a **liaison-run half** and an irreducible **human-only click**: the
**claude** login (or an API key), the **bot ssh key**, and the **bot gh token**.
This page is the probes, the halves, and the human moments — plus the
conservative non-bypass launch variant for a user who wants per-command prompts.
All three credentials land in the bind-mounted home and persist across
`./garden reset`. If your question is "how does the bot authenticate" or "why is
`gh` acting as the wrong identity," you are here; the ferry's separate,
maintainer-only human-identity path is `README.md` § The ferry and
`roles/boatman/AGENT.md`.

## 1. Claude auth — inside golden-path step 2, zero extra steps

The exec'd `claude` runs its own first-launch onboarding: pick a login method,
open the printed URL **in a browser on the host** (the container has none),
paste the code back. The credential lands in the bind-mounted home.

- **Beaten path:** a **Claude subscription login** — the whole fleet runs on one
  subscription.
- **Alternate path:** export `ANTHROPIC_API_KEY` **before the first
  `./garden`**; the launcher forwards it at container creation and the login is
  skipped entirely.

Neither is a procedure the human runs by hand — the tool prompts for it. It is
one sentence of residue: "have a Claude subscription or an API key."

## 2. Bot ssh key — liaison generates, human pastes

The launcher deliberately does **not** forward your SSH agent: an
agent-forwarded human identity must not leak into bot actions. The bot uses its
own key under `<garden-root>/.ssh/` (which is `~/.ssh/` inside the container,
gitignored). The liaison's half:

1. Probe `.ssh/` for an existing `id_ed25519`.
2. If absent, generate one and **print the public half**.
3. **Wait** while the human pastes it into the **bot** GitHub account's SSH keys
   — the human-only click.

## 3. Bot gh token — liaison runs login, human authorizes

Inside the container, authenticate `gh` as the **bot**:

1. Probe `gh auth status`.
2. If unauthenticated, run `gh auth login` and **relay the device-flow URL and
   code** to the human, who opens it and clicks "authorize" — the human-only
   click. The token lands in `.config/gh/` (bind-mounted, gitignored).
3. **Verify** by whoami-ing the fleet's `gh` wrapper — it must report the bot
   login, not your identity. The wrapper pins every call to the bot; the one
   exception is the ferry's explicit `GARDEN_GH_IDENTITY=kriskowal` override
   (`designs/fleet-gh-identity.md`).

## The conservative non-bypass launch variant

Bare `./garden` execs the liaison with `--dangerously-skip-permissions` (auto
mode) — matching the fleet's existing headless posture and making the tutorial
usable (prompt-per-command would turn the tour into dozens of nags). The
interactive liaison still **asks before consequential garden operations** per
the tutorial's ask-before-acting contract (`README.md` in this tree, §
Interaction norms).

A user who wants per-command prompts instead of bypass can launch conservatively
via the debug shell:

```sh
./garden sh                                    # today's enter behavior: bash -l, no claude
claude --permission-mode acceptEdits           # prompt on non-edit actions
```

Optionally seed a `scripts/jobs/*` allowlist so the routine board commands stop
prompting. This variant is documented, **not defaulted** — auto mode is the
default (`designs/streamlined-onboarding.md` § 1.3). Claude Code's own one-time
bypass acknowledgment (a single keystroke on first launch) stays as the explicit
opt-in moment.
