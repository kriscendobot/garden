// github.js — pure client-side GitHub access for the bulletin.
//
// Reads (bulletin README, maintainer inbox) go through the REST Contents API
// unauthenticated when no token is present (the garden repo is public). The
// reply commit is built atomically through the Git Data API so a single commit
// both delivers the reply and archives the original message.
//
// All requests hit https://api.github.com, which returns permissive CORS
// headers, so everything here runs in the browser with no backend.

const GH = (() => {
  const cfg = window.GARDEN_BULLETIN_CONFIG;
  const API = 'https://api.github.com';
  const TOKEN_KEY = 'garden_gh_token';

  // --- token storage (the maintainer's machine only) --------------------------
  const getToken = () => localStorage.getItem(TOKEN_KEY) || '';
  const setToken = (t) => localStorage.setItem(TOKEN_KEY, t.trim());
  const clearToken = () => localStorage.removeItem(TOKEN_KEY);
  const hasToken = () => !!getToken();

  // --- utf-8 <-> base64 (handles non-ASCII bulletin text) ---------------------
  const b64encode = (str) =>
    btoa(String.fromCharCode(...new TextEncoder().encode(str)));
  const b64decode = (b64) =>
    new TextDecoder().decode(
      Uint8Array.from(atob(b64.replace(/\n/g, '')), (c) => c.charCodeAt(0)),
    );

  async function api(path, opts = {}) {
    const headers = {
      Accept: 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      ...(opts.headers || {}),
    };
    const t = getToken();
    if (t) headers.Authorization = `Bearer ${t}`;
    const res = await fetch(API + path, { ...opts, headers });
    if (!res.ok) {
      let detail = '';
      try {
        detail = (await res.json()).message || '';
      } catch (_) {
        /* ignore */
      }
      const err = new Error(`GitHub ${res.status}: ${detail || res.statusText}`);
      err.status = res.status;
      throw err;
    }
    return res.status === 204 ? null : res.json();
  }

  const repoPath = (p) => `/repos/${cfg.owner}/${cfg.repo}${p}`;

  // --- reads ------------------------------------------------------------------

  // Fetch and decode a file on the journal branch. Returns null on 404.
  async function getFile(path, ref = cfg.journalBranch) {
    try {
      const j = await api(repoPath(`/contents/${path}?ref=${ref}`));
      return { text: b64decode(j.content), sha: j.sha };
    } catch (e) {
      if (e.status === 404) return null;
      throw e;
    }
  }

  // List a directory on the journal branch. Returns [] on 404.
  async function listDir(path, ref = cfg.journalBranch) {
    try {
      const j = await api(repoPath(`/contents/${path}?ref=${ref}`));
      return Array.isArray(j) ? j : [];
    } catch (e) {
      if (e.status === 404) return [];
      throw e;
    }
  }

  async function dirExists(path, ref = cfg.journalBranch) {
    try {
      await api(repoPath(`/contents/${path}?ref=${ref}`));
      return true;
    } catch (e) {
      if (e.status === 404) return false;
      throw e;
    }
  }

  // --- atomic reply commit (Git Data API) -------------------------------------
  // Builds one commit on the journal branch that (a) adds `replyPath` with
  // `replyBody` WHEN a reply body is given, (b) copies `unreadPath` to `readPath`
  // (the archive), and (c) deletes `unreadPath`. An empty acknowledgement omits
  // the reply blob and just moves unread -> read (kriskowal #10).
  //
  // The ref PATCH (force:false) is a compare-and-swap: GitHub rejects it with a
  // 422 "Update is not a fast forward" when another writer advanced the branch
  // between our `GET ref` and the `PATCH`. journal2 is hammered by the ~100-
  // gardener fleet, so a single rebuild loses that race constantly. We therefore
  // replicate the garden shell scripts' push protocol (scripts/jobs/common.sh
  // commit_and_push + the seq-1-50 caller loop): on each miss RE-READ the moved
  // head, RECONSTRUCT the change on the fresh tree, and retry — with a RANDOMIZED
  // backoff between attempts so contending writers don't relock-step, and a
  // generous attempt budget so a busy branch eventually drains. Without the
  // backoff (the prior 6 immediate retries) every attempt re-collides on the
  // same instant and the user sees the raw 422 (kriskowal #10).

  // Exponential backoff with full jitter, mirroring common.sh `backoff()` (per
  // kriskowal #10, "use exponential back-off with full jitter, generally"). Each
  // retry sleeps a FRESH uniform draw in [0, window], where window grows as
  // min(CAP_MS, BASE_MS * 2^attempt). The full-jitter draw (a new random span
  // every attempt, not a fixed band) is what breaks the lockstep with the ~100-
  // gardener fleet hammering journal2: writers that collide on attempt N spread
  // across an independently-sampled, widening interval on attempt N+1 instead of
  // re-colliding. This is the canonical AWS "exponential backoff and jitter".
  const ATTEMPTS = 50;
  const BASE_MS = 50;
  const CAP_MS = 2000;
  const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
  const backoff = (attempt) => {
    const window = Math.min(CAP_MS, BASE_MS * 2 ** attempt);
    return sleep(Math.floor(Math.random() * (window + 1)));
  };

  async function commitReply({ replyPath, replyBody, unreadPath, readPath, origSha, message }) {
    const branch = cfg.journalBranch;
    for (let attempt = 0; attempt < ATTEMPTS; attempt++) {
      const ref = await api(repoPath(`/git/ref/heads/${branch}`));
      const headSha = ref.object.sha;
      const headCommit = await api(repoPath(`/git/commits/${headSha}`));

      const tree = [];
      // Add the reply blob only when a reply body was given (empty
      // acknowledgement = mark-as-read only, no reply file).
      if (replyPath && replyBody) {
        const blob = await api(repoPath('/git/blobs'), {
          method: 'POST',
          body: JSON.stringify({ content: b64encode(replyBody), encoding: 'base64' }),
        });
        tree.push({ path: replyPath, mode: '100644', type: 'blob', sha: blob.sha });
      }
      // Archive the original (move unread -> read) when we were given one.
      if (unreadPath && readPath && origSha) {
        tree.push({ path: readPath, mode: '100644', type: 'blob', sha: origSha });
        tree.push({ path: unreadPath, mode: '100644', type: 'blob', sha: null });
      }

      const newTree = await api(repoPath('/git/trees'), {
        method: 'POST',
        body: JSON.stringify({ base_tree: headCommit.tree.sha, tree }),
      });
      const newCommit = await api(repoPath('/git/commits'), {
        method: 'POST',
        body: JSON.stringify({
          message,
          tree: newTree.sha,
          parents: [headSha],
        }),
      });
      try {
        await api(repoPath(`/git/refs/heads/${branch}`), {
          method: 'PATCH',
          body: JSON.stringify({ sha: newCommit.sha, force: false }),
        });
        return newCommit.sha;
      } catch (e) {
        // 422 == the branch moved under us (not a fast forward). Back off, then
        // re-read the new head and reconstruct the change on the next iteration.
        if (e.status === 422 && attempt < ATTEMPTS - 1) {
          await backoff(attempt);
          continue;
        }
        throw e;
      }
    }
    throw new Error(
      `reply commit failed after ${ATTEMPTS} fast-forward retries (journal2 kept moving)`,
    );
  }

  return {
    cfg,
    getToken,
    setToken,
    clearToken,
    hasToken,
    getFile,
    listDir,
    dirExists,
    commitReply,
  };
})();
