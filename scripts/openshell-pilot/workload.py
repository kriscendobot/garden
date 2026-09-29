#!/usr/bin/env python3
"""Runs only in the pilot workload image. Outputs bounded, non-secret evidence."""
import errno
import json
import os
from pathlib import Path
import shutil
import socket
import subprocess
import sys
import traceback

CHECKS = []


def check(name, passed, detail):
    CHECKS.append({"check": name, "status": "PASS" if passed else "FAIL", "detail": detail})


def command(arguments, timeout=30):
    return subprocess.run(arguments, capture_output=True, text=True, timeout=timeout, check=False)


def placeholder(name):
    value = os.environ.get(name, "")
    return value.startswith("openshell:resolve:env:")


def curl(url, method="GET", token="PILOT_TOKEN"):
    # Only opaque placeholders enter the workload argv.
    return command(["/usr/bin/curl", "--silent", "--show-error", "--max-time", "10", "--noproxy", "*",
                    "--request", method, "--header", "Authorization: Bearer " + os.environ.get(token, ""),
                    "--write-out", "\n%{http_code}", url])


def response(result):
    try:
        body, status = result.stdout.rsplit("\n", 1)
        return int(status), json.loads(body)
    except (ValueError, TypeError):
        return 0, {}


def denied_socket(host, port):
    try:
        with socket.create_connection((host, port), timeout=3):
            return False
    except OSError as error:
        return error.errno in (errno.EPERM, errno.EACCES, errno.ENETUNREACH)


def synthetic(host_home, canary_path):
    check("placeholder environment", placeholder("PILOT_TOKEN"), "PILOT_TOKEN has the upstream opaque handle prefix")
    surfaces = [json.dumps(dict(os.environ)), Path("/proc/self/environ").read_bytes().decode(errors="replace"),
                command(["/usr/bin/env"]).stdout]
    fixture = Path("/sandbox/placeholder.txt")
    fixture.write_text(os.environ.get("PILOT_TOKEN", ""))
    surfaces.append(command(["/usr/bin/cat", str(fixture)]).stdout)
    try:
        raise RuntimeError(os.environ.get("PILOT_TOKEN", ""))
    except RuntimeError:
        surfaces.append(traceback.format_exc())
    status, body = response(curl("https://host.openshell.internal:18443/echo"))
    check("synthetic HTTPS injection", status == 200 and body.get("authenticated") is True,
          "local upstream reports exact fake bearer match; does not reflect the bearer")
    status, body = response(curl("https://host.openshell.internal:18443/denied"))
    check("method/path denial", status == 403 and body.get("error") == "policy_denied", "OpenShell policy_denied, not an upstream authorization error")
    status, body = response(curl("https://host.openshell.internal:18443/echo", "POST"))
    check("write method denial", status == 403 and body.get("error") == "policy_denied", "POST /echo denied by policy")
    check("non-allowlisted local egress", denied_socket("127.0.0.1", 18444), "live host control endpoint inaccessible to workload")
    check("binary-bound egress", denied_socket("host.openshell.internal", 18443), "Python has no endpoint grant; the curl positive control uses the same live service")
    check("metadata egress", denied_socket("169.254.169.254", 80), "link-local metadata address denied without issuing a request")
    forbidden = [str(Path(host_home) / suffix) for suffix in (".claude/.credentials.json", ".ssh", ".aws", ".config/gh", ".codex")]
    forbidden += [canary_path, "/forbidden-canary", "/.openshell"]
    for index, path in enumerate(forbidden):
        denied = False
        try:
            descriptor = os.open(path, os.O_RDONLY)
            os.close(descriptor)
        except OSError as error:
            denied = error.errno in (errno.EACCES, errno.EPERM, errno.ENOENT)
        check("filesystem denial " + str(index + 1), denied,
              "known image Landlock canary" if path == "/forbidden-canary" else "protected host/control path; no file contents read")
    executable = Path("/tmp/pilot-true")
    shutil.copyfile("/usr/bin/true", executable)
    executable.chmod(0o700)
    noexec = False
    try:
        command([str(executable)])
    except OSError as error:
        noexec = error.errno in (errno.EPERM, errno.EACCES)
    finally:
        executable.unlink(missing_ok=True)
    check("workload /tmp noexec", noexec, "attempted execution of a copy of /usr/bin/true")
    status = Path("/proc/self/status").read_text()
    values = dict(line.split(":", 1) for line in status.splitlines() if ":" in line)
    check("workload privilege boundary", os.getuid() != 0 and values.get("NoNewPrivs", "").strip() == "1"
          and int(values.get("CapEff", "1").strip(), 16) == 0 and values.get("Seccomp", "").strip() == "2",
          "non-root, zero effective capabilities, no_new_privs, seccomp filter active")
    return surfaces


def github(login, repository):
    check("GitHub placeholder", placeholder("GH_TOKEN"), "GH_TOKEN is opaque")
    user = command(["/usr/bin/gh", "api", "user"])
    try:
        identity = json.loads(user.stdout).get("login")
    except ValueError:
        identity = None
    check("GitHub /user", user.returncode == 0 and identity == login, "returned identity matches explicitly supplied test account")
    read = command(["/usr/bin/git", "-c", "credential.helper=!f() { echo username=x-access-token; echo password=$GH_TOKEN; }; f",
                    "ls-remote", "https://github.com/" + repository + ".git"], timeout=45)
    check("GitHub HTTPS repository read", read.returncode == 0, "git ls-remote of the disposable repository")
    status, body = response(curl("https://github.com/" + repository + ".git/git-receive-pack", "POST", "GH_TOKEN"))
    check("GitHub git-receive-pack denied", status == 403 and body.get("error") == "policy_denied",
          "empty POST refused by OpenShell; no git pack or ref update submitted")
    return [user.stdout, user.stderr, read.stdout, read.stderr, json.dumps(dict(os.environ))]


def aws(region, role_arn, bucket):
    check("AWS placeholders", all(placeholder(key) for key in ("AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_SESSION_TOKEN")),
          "all three AWS environment values are opaque")
    base = ["/usr/bin/aws", "--region", region, "--no-cli-pager"]
    identity = command(base + ["sts", "get-caller-identity", "--output", "json"])
    try:
        arn = json.loads(identity.stdout).get("Arn", "")
    except ValueError:
        arn = ""
    role_name = role_arn.rsplit("/", 1)[-1]
    account = role_arn.split(":")[4]
    check("AWS STS SigV4", identity.returncode == 0 and arn.startswith(f"arn:aws:sts::{account}:assumed-role/{role_name}/"),
          "gateway assumed the requested role and re-signed GetCallerIdentity")
    listing = command(base + ["s3api", "list-objects-v2", "--bucket", bucket, "--max-keys", "1", "--output", "json"])
    check("AWS scoped bucket read", listing.returncode == 0, "ListObjectsV2, max one key; response contents discarded")
    ssm = command(base + ["ssm", "describe-instance-information", "--max-results", "5", "--output", "json"])
    check("aws ssm caveat denial", ssm.returncode != 0 and any(value in ssm.stderr.lower() for value in
          ("operation not permitted", "permission denied", "policy_denied")),
          "SSM has no allowlist entry; requires a recognizable denial. This does not qualify Session Manager/websocket/chunk signing")
    return [identity.stdout, identity.stderr, listing.stdout, listing.stderr, ssm.stdout, ssm.stderr, json.dumps(dict(os.environ))]


if __name__ == "__main__":
    surfaces = []
    try:
        surfaces = {"synthetic": synthetic, "github": github, "aws": aws}[sys.argv[1]](*sys.argv[2:])
    except Exception as error:
        check("workload execution", False, type(error).__name__)
    # Host checks these surfaces against the known secret without uploading the secret.
    print(json.dumps({"checks": CHECKS, "surfaces": surfaces}))
    sys.exit(0 if CHECKS and all(c["status"] == "PASS" for c in CHECKS) else 1)
