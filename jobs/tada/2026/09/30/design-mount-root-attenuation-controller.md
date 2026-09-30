---
handed-off: open-pr-design-mount-root-attenuation-controller
deliverable-complete: false
---
## Report: design-mount-root-attenuation-controller

I wrote and pushed the design, but I couldn't open the PR. On this host (oros-studio-garden-ce242c49) the bot token gets a 403 when it tries to create a pull request on endojs. The one remaining step is handed to a successor job pinned to an endolin host.

**Design**
- **File:** `designs/daemon-mount-visible-roots.md` on endojs/endo-but-for-bots. Slug is `daemon-mount-visible-roots`.
- **Branches:** the head branch `design/daemon-mount-visible-roots` has one commit adding the file. The frozen base `llm-825c598bc` is a snapshot of `llm` at 825c598bc. Both are pushed.
- **Mount view:** a mount with one "home" root plus a set of visible roots. Paths still resolve against the real POSIX namespace, and a path is allowed if it lands under any visible root. So a symlink into another visible root resolves, and anything else stays hidden exactly as an escaping link is today. The existing single-root check (`assertConfined` and its siblings) becomes the one-root case of this.
- **Controller facet:** `EndoMountRootsControl` has `addRoot`, `removeRoot`, `listRoots` and `revoke`, following the existing `makeRevocableMount` / `EndoMountControl` caretaker pattern.
  - A root is added as an `EndoMount` capability, never a path string, so the controller can't reach anything its holder couldn't already read.
  - Each added root keeps its source mount's read-only bit, denied names and revocation.
- **Persistence:** the root set lives in a daemon-owned pet store behind new `mount-view` / `mount-view-control` formulas, created by a new host-only method `EndoHost.provideMountView`.
- **pnpm case from #1340:** a new `resolve()` method gives #1340's tree reader a canonical location without exposing host paths. That lifts #1340's hoisted-layout requirement for pnpm stores and workspaces whose targets sit under a visible root.
- **Other sections:** it links to `daemon-mount.md`, `daemon-mount-capabilities.md` and PR #1340 (the #1340 design isn't on `llm` yet). It also has an ownership map, four implementation phases, a test plan, and three open questions:
  1. Should callers be able to address other roots directly, rather than only by following links?
  2. Should `provideSubMount` over a view keep the view's root set?
  3. Should a content-addressed snapshot be allowed as a root?
- **Diagram:** the one mermaid diagram passes the parse check.

**Handoff**
- I posted `open-pr-design-mount-root-attenuation-controller` with `requires: host=endolin-garden-ece02cb4`. Its only task is to run `ensure-pr.sh` with this job's base, so the PR carries this job's marker. The PR title and body are included word for word, the PR stays draft, and the successor names it in its report so the design-review panel gets staged.
- My first post of that job was dropped as a duplicate, because its body contained the #1340 comment URL and was matched to this still-running job. Reposting with an explicit identity (`design-pr-open:daemon-mount-visible-roots`) went through.

**Follow-ups**
- The durable fix is giving the bot token pull-request write access on endojs from this host.
- Once the design is accepted, #1340's phase 4 can switch `makeTreeReadPowers`' `canonical` to use `resolve()`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-mount-root-attenuation-controller.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1873356 cached reads)
- Output: 16312 tokens
- Cost: $1.3805752
- Wall-clock: 2024s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
