"""Synthetic qualification followed by independently opted-in credential stages."""
import datetime
import http.server
import json
import os
import re
import secrets
import ssl
import stat
import threading
import time
import urllib.request

from pilot import NAME, PilotError, require, safe_path, write_json

POLICY = {
    "version": 1,
    "filesystem_policy": {"include_workdir": True,
                          "read_only": ["/bin", "/usr", "/lib", "/proc", "/dev/urandom", "/etc", "/var/log"],
                          "read_write": ["/sandbox", "/tmp", "/dev/null"]},
    "landlock": {"compatibility": "hard_requirement"}, "network_policies": {},
}


def credential_file(value):
    path = safe_path(value)
    descriptor = os.open(path, os.O_RDONLY | os.O_NOFOLLOW)
    with os.fdopen(descriptor) as stream:
        information = os.fstat(stream.fileno())
        require(stat.S_ISREG(information.st_mode) and information.st_uid == os.getuid()
                and stat.S_IMODE(information.st_mode) == 0o600 and information.st_nlink == 1,
                "Throwaway credential must be your regular, non-hardlinked mode-0600 file")
        require(information.st_size <= 16384, "Credential file too large")
        return stream.read().strip()


def bearer_profile(identifier, variable, endpoints, binaries):
    return {"id": identifier, "display_name": identifier, "category": "other",
            "credentials": [{"name": "token", "env_vars": [variable], "required": True,
                             "auth_style": "bearer", "header_name": "authorization"}],
            "endpoints": endpoints, "binaries": binaries}


def endpoint(host, port, rules, **extra):
    return {"host": host, "port": port, "protocol": "rest", "tls": "terminate",
            "enforcement": "enforce", "rules": [{"allow": {"method": method, "path": path}} for method, path in rules], **extra}


class Echo:
    def __init__(self, pilot, secret):
        self.events = []
        events = self.events

        class Handler(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                matched = secrets.compare_digest(self.headers.get("Authorization", ""), "Bearer " + secret)
                events.append((self.command, self.path, matched))
                body = json.dumps({"authenticated": matched}).encode()
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)

            do_POST = do_GET

            def log_message(self, *_arguments):
                pass

        self.server = http.server.ThreadingHTTPServer(("127.0.0.1", 18443), Handler)
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        context.load_cert_chain(pilot.state / "tls/echo.crt", pilot.state / "tls/echo.key")
        self.server.socket = context.wrap_socket(self.server.socket, server_side=True)
        self.denied = http.server.ThreadingHTTPServer(("127.0.0.1", 18444), Handler)
        self.threads = []

    def __enter__(self):
        for server in (self.server, self.denied):
            thread = threading.Thread(target=server.serve_forever, daemon=True)
            thread.start()
            self.threads.append(thread)
        # Positive host control means a workload refusal is not a dead listener.
        opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
        with opener.open("http://127.0.0.1:18444/control", timeout=3) as response:
            require(response.status == 200, "Control endpoint failed")
        self.events.clear()
        return self

    def __exit__(self, *_arguments):
        for server in (self.server, self.denied):
            server.shutdown()
            server.server_close()
        for thread in self.threads:
            thread.join(timeout=3)


def resources(pilot, name, profile, credentials, stage, arguments, refresh=None):
    started = time.monotonic()
    profile_path = pilot.state / (name + ".json")
    write_json(profile_path, profile)
    policy_path = pilot.state / "policy.json"
    write_json(policy_path, POLICY)
    provider_created = False
    sandbox_attempted = False
    try:
        pilot.cli("provider", "profile", "lint", "--file", profile_path)
        pilot.cli("provider", "profile", "import", "--file", profile_path)
        environment = dict(pilot.environment, **credentials)
        creation = ["provider", "create", "--name", name, "--type", profile["id"]]
        for variable in credentials:
            creation.extend(["--credential", variable])
        if refresh:
            creation.append("--runtime-credentials")
        pilot.cli(*creation, environment=environment)
        provider_created = True
        if refresh:
            refresh(name)
        sandbox_attempted = True
        pilot.cli("sandbox", "create", "--name", name, "--policy", policy_path, "--provider", name,
                  "--no-auto-providers", "--no-tty", "--detach", "--cpu", "1", "--memory", "512Mi",
                  "--driver-config-json", json.dumps({"podman": {"mounts": [{"type": "tmpfs", "target": "/tmp",
                      "options": ["rw", "noexec", "nosuid", "nodev"], "size_bytes": 67108864, "mode": 1023}]}}),
                  "--env", "AWS_STS_REGIONAL_ENDPOINTS=regional", "--env", "AWS_S3_US_EAST_1_REGIONAL_ENDPOINT=regional",
                  "--env", "AWS_EC2_METADATA_DISABLED=true", "--env", "AWS_MAX_ATTEMPTS=1",
                  "--label", "garden.pilot=true", "--", "/usr/bin/sleep", "infinity", timeout=240)
        for _ in range(60):
            result = pilot.cli("sandbox", "exec", "--name", name, "--timeout", "5", "--no-tty", "--no-login-shell",
                               "--", "/usr/bin/true", check=False, timeout=10)
            if result.returncode == 0:
                break
            time.sleep(1)
        else:
            raise PilotError("Sandbox did not become ready")
        pilot.record(stage + " runtime qualification", True,
                     "v0.1.2 bootstrap actively qualifies Landlock ABI>=3, allow/deny, seccomp notification/ADDFD and task-memory access before accepting exec")
        pilot.record(stage + " startup time", True, f"{time.monotonic() - started:.2f} seconds through first successful exec")
        inspect_runtime(pilot, name, stage)
        output = pilot.cli("sandbox", "exec", "--name", name, "--timeout", "180", "--no-tty", "--no-login-shell",
                           "--", "/usr/bin/python3", "/usr/local/lib/openshell-pilot-workload.py", stage, *arguments,
                           check=False, timeout=200)
        try:
            observation = json.loads(output.stdout)
        except ValueError:
            raise PilotError("Workload did not return structured evidence; output withheld") from None
        require(isinstance(observation.get("checks"), list) and observation["checks"], "Empty workload evidence")
        for row in observation["checks"]:
            pilot.record(row["check"], row["status"] == "PASS", row["detail"])
        logs = pilot.cli("logs", name, "-n", "10000", "--source", "all", check=False)
        pilot.record(stage + " log collection", logs.returncode == 0, "bounded gateway/sandbox logs included in host-side secret scan; raw logs not persisted")
        return output.stdout + output.stderr + logs.stdout + logs.stderr, output.returncode == 0
    finally:
        cleanup_ok = True
        if sandbox_attempted:
            deletion = pilot.cli("sandbox", "delete", name, check=False)
            cleanup_ok = deletion.returncode == 0
            for _ in range(40):
                remaining = pilot.podman("ps", "--all", "--quiet", "--filter", "label=openshell.ai/sandbox-name=" + name)
                if not remaining.stdout.strip():
                    break
                time.sleep(1)
            else:
                cleanup_ok = False
            pilot.record(stage + " sandbox deletion/process cleanup", cleanup_ok, "gateway deletion and no remaining workload/supervisor containers")
        if provider_created:
            for _ in range(40):
                if pilot.cli("provider", "delete", name, check=False).returncode == 0:
                    break
                time.sleep(0.5)
            else:
                cleanup_ok = False
            pilot.record(stage + " provider removal", cleanup_ok, "provider removed after sandbox deletion")
        deleted_profile = pilot.cli("provider", "profile", "delete", profile["id"], check=False)
        pilot.record(stage + " profile removal", deleted_profile.returncode == 0, "temporary stage profile removed")
        profile_path.unlink(missing_ok=True)


def inspect_runtime(pilot, name, stage):
    containers = pilot.podman("ps", "--quiet", "--filter", "label=openshell.ai/sandbox-name=" + name,
                              "--filter", "label=openshell.ai/isolation-role=sandbox").stdout.split()
    require(len(containers) == 1, "Expected one workload container")
    configuration = json.loads(pilot.podman("inspect", containers[0]).stdout)[0]
    host = configuration["HostConfig"]
    pilot.record(stage + " outer network fence", host.get("NetworkMode") == "none", "Podman inspect NetworkMode=none")
    pilot.record(stage + " memory/PID limits", 0 < host.get("Memory", 0) <= 536870912 and 0 < host.get("PidsLimit", 0) <= 128,
                 "Podman inspect memory <=512MiB and PID <=128")
    # API-created mounts are control material/volumes; no garden or host-home mounts.
    mounts = configuration.get("Mounts", [])
    allowed = (str(pilot.state) + "/", str(pilot.runtime) + "/")
    unexpected = [m for m in mounts if m.get("Type") == "bind" and not m.get("Source", "").startswith(allowed)]
    pilot.record(stage + " mount admission", not unexpected, "all bind sources belong to dedicated pilot state/runtime; no host home or socket projected")


def github_stage(pilot, options):
    require(re.fullmatch(r"[A-Za-z0-9-]+", options.github_login), "Invalid test login")
    require(re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", options.github_repository), "Invalid disposable repository")
    token = credential_file(options.github_token_file)
    require(token.startswith("github_pat_") and not any(c.isspace() for c in token), "Only fine-grained throwaway GitHub PATs are accepted")
    name = NAME + "-github-" + secrets.token_hex(4)
    repository_path = "/" + options.github_repository + ".git"
    profile = bearer_profile(name, "GH_TOKEN", [
        endpoint("api.github.com", 443, [("GET", "/user")]),
        endpoint("github.com", 443, [("GET", repository_path + "/info/refs"), ("POST", repository_path + "/git-upload-pack")]),
    ], ["/usr/bin/gh", "/usr/bin/git", "/usr/bin/curl"])
    output, passed = resources(pilot, name, profile, {"GH_TOKEN": token}, "github", [options.github_login, options.github_repository])
    pilot.record("GitHub raw secret scan", token not in output, "host compared captured workload env/output with supplied throwaway token; no raw output persisted")
    require(passed, "GitHub stage failed")


def aws_stage(pilot, options):
    require(re.fullmatch(r"arn:aws:iam::[0-9]{12}:role/[A-Za-z0-9/+=,.@_-]+", options.aws_role_arn), "Invalid scoped test role ARN")
    require(re.fullmatch(r"[a-z]{2}-[a-z]+-[0-9]", options.aws_region), "Invalid AWS region")
    require(re.fullmatch(r"[a-z0-9][a-z0-9-]{1,61}[a-z0-9]", options.aws_bucket), "Use a disposable non-dotted bucket name")
    material = json.loads(credential_file(options.aws_credentials_file))
    required = {"AccessKeyId", "SecretAccessKey", "SessionToken", "Expiration"}
    require(set(material) == required and all(isinstance(v, str) and v for v in material.values()), "Use only temporary STS JSON fields: " + ", ".join(sorted(required)))
    require(material["AccessKeyId"].startswith("ASIA"), "Long-lived AWS keys are refused")
    expiry = datetime.datetime.fromisoformat(material["Expiration"].replace("Z", "+00:00"))
    require(expiry.tzinfo is not None, "STS Expiration must include a timezone")
    remaining = (expiry - datetime.datetime.now(datetime.timezone.utc)).total_seconds()
    require(300 < remaining <= 3600, "Throwaway source STS credentials must expire within one hour and have >5 minutes remaining")
    name = NAME + "-aws-" + secrets.token_hex(4)
    profile = {"id": name, "display_name": name, "category": "other", "credentials": [
        {"name": "access_key_id", "env_vars": ["AWS_ACCESS_KEY_ID"], "required": True, "refresh": {
            "strategy": "aws_sts_assume_role", "refresh_before_seconds": 300, "max_lifetime_seconds": 900,
            "additional_outputs": [{"output": "secret_access_key", "credential": "secret_access_key"},
                                   {"output": "session_token", "credential": "session_token"}],
            "material": [{"name": key, "required": True, "secret": key.startswith("aws_") and key != "aws_region"}
                         for key in ("role_arn", "aws_region", "aws_access_key_id", "aws_secret_access_key", "aws_session_token")]}},
        {"name": "secret_access_key", "env_vars": ["AWS_SECRET_ACCESS_KEY"], "required": True},
        {"name": "session_token", "env_vars": ["AWS_SESSION_TOKEN"], "required": True}],
        "endpoints": [endpoint(f"sts.{options.aws_region}.amazonaws.com", 443, [("POST", "/")],
                               credential_signing="sigv4", signing_service="sts", signing_region=options.aws_region),
                      endpoint(f"{options.aws_bucket}.s3.{options.aws_region}.amazonaws.com", 443, [("GET", "/")],
                               credential_signing="sigv4", signing_service="s3", signing_region=options.aws_region)],
        "binaries": ["/usr/bin/aws", "/usr/bin/python3", "/usr/bin/python3.12"]}

    def refresh(provider):
        environment = dict(pilot.environment, PILOT_AWS_ACCESS=material["AccessKeyId"],
                           PILOT_AWS_SECRET=material["SecretAccessKey"], PILOT_AWS_SESSION=material["SessionToken"])
        pilot.cli("provider", "refresh", "configure", provider, "--credential-key", "AWS_ACCESS_KEY_ID",
                  "--strategy", "aws-sts-assume-role", "--material", "role_arn=" + options.aws_role_arn,
                  "--material", "aws_region=" + options.aws_region,
                  "--secret-material-env", "aws_access_key_id=PILOT_AWS_ACCESS",
                  "--secret-material-env", "aws_secret_access_key=PILOT_AWS_SECRET",
                  "--secret-material-env", "aws_session_token=PILOT_AWS_SESSION", environment=environment)
        pilot.cli("provider", "refresh", "rotate", provider, "--credential-key", "AWS_ACCESS_KEY_ID")

    output, passed = resources(pilot, name, profile, {}, "aws", [options.aws_region, options.aws_role_arn, options.aws_bucket], refresh=refresh)
    pilot.record("AWS source secret scan", all(material[key] not in output for key in ("AccessKeyId", "SecretAccessKey", "SessionToken")),
                 "source STS values absent from workload env/output; gateway-issued values checked for placeholder shape")
    require(passed, "AWS stage failed")


def test(pilot, options):
    pilot.checks = []
    completion = {"check": "test completion", "status": "RUNNING", "detail": "incomplete until this run finishes"}
    pilot.checks.append(completion)
    for stage in ("github", "aws"):
        if not getattr(options, stage):
            pilot.checks.append({"check": stage, "status": "SKIP", "detail": "not explicitly enabled; no credentials loaded"})
    pilot.checks.append({"check": "extended upstream conformance", "status": "NOT RUN",
                         "detail": "DNS rebinding, reload races, rotation latency, full crash/core and Session Manager transports remain separate security qualification; this kit runs the bounded pilot checks below"})
    pilot.save("test")
    try:
        pilot.installed()
        require(pilot.health(), "Run up and require healthy authenticated gateway before test")
        token = "synthetic-only-" + secrets.token_hex(32)
        name = NAME + "-synthetic-" + secrets.token_hex(4)
        profile = bearer_profile(name, "PILOT_TOKEN", [endpoint("host.openshell.internal", 18443, [("GET", "/echo")])], ["/usr/bin/curl"])
        canary = pilot.state / "host-home-canary"
        canary.write_text("synthetic-host-only")
        with Echo(pilot, token) as echo:
            output, passed = resources(pilot, name, profile, {"PILOT_TOKEN": token}, "synthetic", [str(pilot.home), str(canary)])
            pilot.record("upstream fake-secret receipt", echo.events == [("GET", "/echo", True)],
                         "only admitted GET /echo reached the live TLS listener with the exact fake bearer")
        pilot.record("synthetic raw secret scan", token not in output,
                     "host searched workload file/env/proc/child/exception output for the fake secret without copying it into workload")
        canary.unlink(missing_ok=True)
        require(passed and not any(c["status"] == "FAIL" for c in pilot.checks), "Synthetic qualification failed; real credential stages blocked")
        if options.github:
            github_stage(pilot, options)
            require(not any(c["status"] == "FAIL" for c in pilot.checks), "GitHub stage failed; AWS stage blocked")
        if options.aws:
            aws_stage(pilot, options)
        require(not any(c["status"] == "FAIL" for c in pilot.checks), "Pilot has failing checks")
        completion.update(status="PASS", detail="all requested bounded pilot stages completed")
    except Exception as error:
        completion.update(status="FAIL", detail=type(error).__name__ + ": stage did not complete; real stages stopped")
        raise
    finally:
        pilot.save("test")
        pilot.report()
