#!/bin/bash
# budget-level.sh — deterministic leader-only fleet worker leveling.
# Monks share an apportioned fleet ceiling; clerics share a demand-sized envelope.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=budget-level

: "${GARDEN_BUDGET_LEVEL_MIN:=1}"
: "${GARDEN_BUDGET_LEVEL_KIND:=}"
: "${GARDEN_BUDGET_LEVEL_STEP:=1}"
: "${GARDEN_BUDGET_LEVEL_UP_CONFIRM:=2}"
: "${GARDEN_BUDGET_LEVEL_DOWN_CONFIRM:=1}"
: "${GARDEN_BUDGET_LEVEL_DWELL_DIR:=$GARDEN_STATE/budget-level/dwell}"
: "${GARDEN_BUDGET_LEVEL_SET_WORKERS:=$HERE/set-workers.sh}"
: "${GARDEN_BUDGET_LEVEL_SEND_HOST_OP:=$HERE/send-host-op.sh}"
: "${GARDEN_WORKER_LEVELING_PATH:=config/worker-leveling}"
scheduled=false; [ "$#" -gt 0 ] && scheduled=true
finish() { if $scheduled; then exit 2; else exit 0; fi; }
is_main_host || { log "follower host; budget leveling is leader-only"; finish; }
fleet_draining && { log "fleet draining; budget leveling suspended this tick"; finish; }
[[ "$GARDEN_BUDGET_LEVEL_MIN" =~ ^[1-9][0-9]*$ ]] || die "GARDEN_BUDGET_LEVEL_MIN must be positive"
[[ "$GARDEN_BUDGET_LEVEL_STEP" =~ ^[1-9][0-9]*$ ]] || GARDEN_BUDGET_LEVEL_STEP=1
[[ "$GARDEN_BUDGET_LEVEL_UP_CONFIRM" =~ ^[1-9][0-9]*$ ]] || GARDEN_BUDGET_LEVEL_UP_CONFIRM=2
[[ "$GARDEN_BUDGET_LEVEL_DOWN_CONFIRM" =~ ^[1-9][0-9]*$ ]] || GARDEN_BUDGET_LEVEL_DOWN_CONFIRM=1

_dwell_file() { printf '%s/%s-%s\n' "$GARDEN_BUDGET_LEVEL_DWELL_DIR" "${1//[^A-Za-z0-9._-]/_}" "${2//[^A-Za-z0-9._-]/_}"; }
dwell_bump() { # host kind direction
  local f pd="" ps=0 s; f="$(_dwell_file "$1" "$2")"
  [ ! -f "$f" ] || { pd="$(sed -n 's/^dir=//p' "$f" | head -1)"; ps="$(sed -n 's/^streak=//p' "$f" | head -1)"; [[ "$ps" =~ ^[0-9]+$ ]] || ps=0; }
  [ "$3" = "$pd" ] && s=$((ps+1)) || s=1
  mkdir -p "$(dirname "$f")" 2>/dev/null || true
  if printf 'dir=%s\nstreak=%s\n' "$3" "$s" >"$f.tmp" 2>/dev/null; then mv "$f.tmp" "$f" 2>/dev/null || true; fi
  printf '%s\n' "$s"
}
dwell_reset() { local f; f="$(_dwell_file "$1" "$2")"; mkdir -p "$(dirname "$f")" 2>/dev/null || true; printf 'dir=none\nstreak=0\n' >"$f.tmp" 2>/dev/null && mv "$f.tmp" "$f" 2>/dev/null || true; }
uncalibrated() { case "$(printf %s "${1:-}" | tr '[:upper:]' '[:lower:]')" in ''|-|none|placeholder|uncalibrated|seed|tbd|todo) return 0;; *) return 1;; esac; }
pool_failure() { log "WARN: pool=$1 host=$2 operation=$3 failed exit_status=$4; failure isolated (fail-open)"; }

# Input rows: id, weight, floor, cap. Implements bounded Hamilton apportionment.
apportion() { awk -F '\t' -v total="$1" '
 {id[++n]=$1;w[n]=$2+0;a[n]=$3+0;cap[n]=$4+0;left-=a[n]}
 END { left+=total
  while(left>0){ sw=0; na=0; for(i=1;i<=n;i++)if(a[i]<cap[i]){sw+=w[i];na++} if(!na)break
   if(sw<=0){p=0;for(i=1;i<=n;i++)if(a[i]<cap[i]&&(!p||a[i]<a[p]||(a[i]==a[p]&&id[i]<id[p])))p=i;a[p]++;left--;continue}
   hit=0;for(i=1;i<=n;i++)if(a[i]<cap[i]){q=left*w[i]/sw;x=int(q);room=cap[i]-a[i];if(x>=room&&room>0){a[i]+=room;left-=room;hit=1}}
   if(hit)continue
   gave=0;for(i=1;i<=n;i++)if(a[i]<cap[i]){q=left*w[i]/sw;add[i]=int(q);rem[i]=q-int(q);gave+=add[i]}
   for(i=1;i<=n;i++){a[i]+=add[i];add[i]=0} left-=gave
   while(left>0){p=0;for(i=1;i<=n;i++)if(a[i]<cap[i]&&(!p||rem[i]>rem[p]+1e-12||((rem[i]-rem[p]<1e-12&&rem[p]-rem[i]<1e-12)&&id[i]<id[p])))p=i;if(!p)break;a[p]++;rem[p]=-1;left--}
  } for(i=1;i<=n;i++)print id[i] "\t" a[i]
 }'; }

DIR="${GARDEN_BUDGET_LEVEL_CLONE:-$GARDEN_STATE/budget-level/journal}"
rc=0
snapshot="$({
 ensure_clone "$DIR"; sync_clone "$DIR"
 pools="$(budget_pool_file "$DIR" 2>/dev/null || true)"; [ -n "$pools" ] || exit 3
 cfg="${GARDEN_WORKER_LEVELING_FILE:-$DIR/$GARDEN_WORKER_LEVELING_PATH}"; [ -f "$cfg" ] || exit 4
 while IFS=$'\t ' read -r pool provider host kind cap prov _at _; do case "$pool" in ''|'#'*)continue;;esac; [ "$provider" = anthropic ]&&[ "$kind" = weekly-tokens ]||continue; printf 'P\t%s\t%s\t%s\t%s\n' "$pool" "$host" "$cap" "${prov:-}"; done <"$pools"
 while IFS=$'\t ' read -r type a b c _; do case "$type" in ''|'#'*)continue;; monk-fleet-ceiling|cleric-fleet-ceiling)printf 'C\t%s\t%s\n' "$type" "$a";; host)printf 'H\t%s\t%s\t%s\n' "$a" "$b" "$c";; *)printf 'X\t%s\n' "$type";;esac; done <"$cfg"
 clone_unlock "$DIR"
})" || rc=$?
case "$rc" in 0);;3)log "budget pool config absent; leveling is off";finish;;4)log "WARN: $GARDEN_WORKER_LEVELING_PATH absent; leveling frozen";finish;;"$GARDEN_OFFLINE_RC")log "WARN: budget-level preflight offline (journal clone/sync, rc=$rc); skipping this leveling tick, retry next cadence (fail-open)";finish;;*)log "WARN: budget-level preflight failed (journal clone/sync, rc=$rc); skipping this leveling tick, retry next cadence (fail-open)";finish;;esac

declare -a pools=() phosts=() pcaps=() pprov=() hosts=()
declare -A mcap=() ccap=() mceil=() active=() active_ids=() demand=() ctarget=()
mf=""; cf=""; bad=""
while IFS=$'\t' read -r r a b c d; do case "$r" in P)pools+=("$a");phosts+=("$b");pcaps+=("$c");pprov+=("$d");;C)[ "$a" = monk-fleet-ceiling ]&&mf="$b"||cf="$b";;H)hosts+=("$a");mcap["$a"]="$b";ccap["$a"]="$c";;X)bad="unknown row '$a'";;esac;done <<<"$snapshot"
mf="${GARDEN_MONK_FLEET_CEILING:-$mf}"; cf="${GARDEN_CLERIC_FLEET_CEILING:-$cf}"

mv=1; n=${#pools[@]}; sum=0
[[ "$mf" =~ ^[1-9][0-9]*$ ]]||{ mv=0;bad="invalid monk fleet ceiling '$mf'"; }; [ "$n" -gt 0 ]||{ mv=0;bad="no enabled Anthropic weekly pools"; }
for((i=0;i<n;i++));do h="${phosts[i]}";c="${pcaps[i]}";p="${pprov[i]}"; [[ "$c" =~ ^[1-9][0-9]*$ ]]||{ mv=0;bad="${pools[i]} invalid cap '$c'";continue;}; uncalibrated "$p"&&{ mv=0;bad="${pools[i]} uncalibrated provenance '${p:-none}'";}; [[ "${mcap[$h]:-}" =~ ^[1-9][0-9]*$ ]]||{ mv=0;bad="${pools[i]} missing/invalid monk physical cap";continue;}; sum=$((sum+mcap[$h]));done
if [[ "$mf" =~ ^[1-9][0-9]*$ ]];then [ "$mf" -ge $((n*GARDEN_BUDGET_LEVEL_MIN)) ]||{ mv=0;bad="monk fleet ceiling below aggregate floor";};[ "$sum" -ge "$mf" ]||{ mv=0;bad="monk fleet ceiling exceeds physical capacity";};fi
if [ "$mv" -eq 1 ];then rows="";for((i=0;i<n;i++));do h="${phosts[i]}";rows+="$h"$'\t'"${pcaps[i]}"$'\t'"$GARDEN_BUDGET_LEVEL_MIN"$'\t'"${mcap[$h]}"$'\n';done;while IFS=$'\t' read -r h x;do mceil["$h"]="$x";done < <(printf %s "$rows"|apportion "$mf");else log "WARN: fleet monk allocation frozen: $bad";alert_maintainer budget-level-monk-preflight "budget-level: fleet monk allocation frozen: $bad. No monk count may rise; only a calibrated host already over its own high-water mark may step down toward the floor.";fi

cutoff="$(meter_window_cutoff anchor 2>/dev/null)"&&cutrc=0||{ cutrc=$?;cutoff=""; }
apply_target(){ # pool host kind current target reason
 local pool="$1" h="$2" kind="$3" cur="$4" target="$5" reason="$6" dir conf streak next id
 [ "$cur" -ne "$target" ]||{ dwell_reset "$h" "$kind";return; }
 if [ "$target" -gt "$cur" ];then dir=up;conf="$GARDEN_BUDGET_LEVEL_UP_CONFIRM";else dir=down;conf="$GARDEN_BUDGET_LEVEL_DOWN_CONFIRM";fi
 streak="$(dwell_bump "$h" "$kind" "$dir")";[ "$streak" -ge "$conf" ]||{ log "budget-level dwell $h $kind $cur->$target ($dir $streak/$conf); holding this tick";return; }
 if [ "$dir" = up ];then next=$((cur+GARDEN_BUDGET_LEVEL_STEP));[ "$next" -le "$target" ]||next="$target";else next=$((cur-GARDEN_BUDGET_LEVEL_STEP));[ "$next" -ge "$target" ]||next="$target";fi
 if [ "$kind" = cleric ]&&[ "$dir" = down ];then for id in ${active_ids[$h]:-};do [ "$id" -le "$next" ]||{ log "cleric shrink deferred on $h: active garden-cleric@$id would be stopped by count=$next";return;};done;fi
 if [ "$h" = "$GARDEN" ];then /bin/bash "$GARDEN_BUDGET_LEVEL_SET_WORKERS" "$kind" "$next"||{ pool_failure "$pool" "$h" set-local-workers "$?";return;};else /bin/bash "$GARDEN_BUDGET_LEVEL_SEND_HOST_OP" "$h" op=set-workers kind="$kind" count="$next" reason="$reason"||{ pool_failure "$pool" "$h" send-host-set-workers "$?";return;};fi
 log "leveled $h $kind $cur->$next (target $target; $reason)";alert_maintainer "budget-level-$kind-$h-$next" "budget-level changed $h $kind workers $cur -> $next (target $target): $reason"
}

for((i=0;i<n;i++));do pool="${pools[i]}";h="${phosts[i]}";cap="${pcaps[i]}";prov="${pprov[i]}";[[ "$cap" =~ ^[1-9][0-9]*$ ]]||continue
 [ "$mv" -eq 1 ]||! uncalibrated "$prov"||continue
 if [ "$h" = "$GARDEN" ];then spend="$(meter_window_total anchor 2>/dev/null)"||{ pool_failure "$pool" "$h" read-local-spend "$?";continue;};elif [[ "$cutoff" =~ ^[0-9]+$ ]];then spend="$(meter_remote_snapshot_total "$DIR" "$pool" "$cap" "$cutoff" 2>/dev/null)"||spend="$(meter_journal_host_tokens "$DIR" "$h" "$cutoff" 2>/dev/null)"||{ pool_failure "$pool" "$h" read-remote-spend "$?";continue;};else pool_failure "$pool" "$h" read-window-cutoff "$cutrc";continue;fi
 [[ "$spend" =~ ^[0-9]+$ ]]||{ pool_failure "$pool" "$h" validate-spend 1;continue;};hf="$DIR/hosts/$h";if [ -n "$GARDEN_BUDGET_LEVEL_KIND" ];then kind="$GARDEN_BUDGET_LEVEL_KIND";else kind="$(anthropic_active_kind "$hf")";fi;key="$(worker_kind_field "$kind" count_key 2>/dev/null||echo gardeners)";cur="$(read_desired_count "$hf" "$key" 2>/dev/null)"||{ pool_failure "$pool" "$h" read-host-workers "$?";continue;}
 if [ "$mv" -ne 1 ];then uncalibrated "$prov"&&continue;awk -v t="$spend" -v q="$cap" -v f="$GARDEN_TOKEN_BACKOFF_FRACTION" 'BEGIN{exit !(t>=q*f)}'||continue;target="$GARDEN_BUDGET_LEVEL_MIN";else hi="${mceil[$h]}";target="$(awk -v t="$spend" -v q="$cap" -v f="$GARDEN_TOKEN_BACKOFF_FRACTION" -v lo="$GARDEN_BUDGET_LEVEL_MIN" -v hi="$hi" 'BEGIN{m=q*f;if(m<=0||t>=m)n=lo;else n=lo+int((1-t/m)*(hi-lo)+.5);if(n<lo)n=lo;if(n>hi)n=hi;print n}')";fi
 apply_target "$pool" "$h" "$kind" "$cur" "$target" "budget pool $pool spend=$spend cap=$cap ceiling=${mceil[$h]:-frozen} target=$target"
done

# A cleric job is counted only on hosts that pass the same static provider/model,
# role, explicit-host, and capability constraints as claim admission. Capability
# facts are intentionally not published; a non-host requirement is therefore
# conservatively ineligible in this leader-side snapshot instead of being guessed.
cleric_eligible(){ local jf="$1" h="$2" p pin tier req
 role_requires_anthropic_posture "$(plan_field "$jf" role)"&&return 1
 if job_provider_is_constrained "$jf";then p="$(job_provider_constraint "$jf" 2>/dev/null)"||return 1;[ "$p" = openai ]||return 1;fi
 tier="$(job_tier "$jf" 2>/dev/null)"||{ [ -z "$(plan_field "$jf" model)" ]&&! job_provider_is_constrained "$jf";return; }
 [ "$tier" != mentat ]||return 1;pin="$(plan_field "$jf" model)"
 if [ -n "$pin" ];then resolve_model_tier openai "$pin" >/dev/null 2>&1||return 1;else tier_model_for_provider "$tier" openai >/dev/null 2>&1||return 1;fi
 while IFS= read -r req;do case "$req" in host=*)[ "${req#host=}" = "$h" ]||return 1;;*)return 1;;esac;done < <(job_requirements "$jf")
}

cv=1;[[ "$cf" =~ ^[0-9]+$ ]]||{ cv=0;bad="invalid cleric fleet ceiling '$cf'";}; eligible=()
for h in "${hosts[@]}";do [[ "${ccap[$h]:-}" =~ ^[0-9]+$ ]]||{ cv=0;bad="$h invalid cleric physical cap";continue;};[ "${ccap[$h]}" -gt 0 ]&&[ -f "$DIR/hosts/$h" ]&&eligible+=("$h");active["$h"]=0;active_ids["$h"]="";demand["$h"]=0;done
[ "${#eligible[@]}" -gt 0 ]||{ cv=0;bad="no reachable cleric-capable hosts"; }

# Reserve live claims and retain their instance ids. Since scaling removes the
# highest-numbered units first, a sparse active id above the proposed count blocks
# that shrink even when the simple active-count lower bound would look sufficient.
for jf in "$DIR"/jobs/doin/*.md;do [ -f "$jf" ]||continue
 kind="$(awk '/^claim:/{x=1;next}x&&/^  worker_kind:/{v=$2}END{print v}' "$jf")";[ "$kind" = cleric ]||continue
 h="$(awk '/^claim:/{x=1;next}x&&/^  host:/{v=$2}END{print v}' "$jf")";id="$(awk '/^claim:/{x=1;next}x&&/^  gardener:/{v=$2}END{print v}' "$jf")"
 [[ "${active[$h]+yes}" ]]||continue;active["$h"]=$((active[$h]+1));[[ "$id" =~ ^[1-9][0-9]*$ ]]&&active_ids["$h"]+=" $id"
done

Q=0
if [ "$cv" -eq 1 ];then
 for h in "${eligible[@]}";do [ "${active[$h]}" -le "${ccap[$h]}" ]||{ cv=0;bad="$h has ${active[$h]} active clerics above physical cap ${ccap[$h]}";};done
 if [ "$cv" -eq 1 ]&&! provider_cooldown_active openai;then
  for jf in "$DIR"/jobs/todo/*.md;do [ -f "$jf" ]||continue;eh=();for h in "${eligible[@]}";do cleric_eligible "$jf" "$h"&&eh+=("$h");done;[ "${#eh[@]}" -gt 0 ]||continue;Q=$((Q+1));frac="$(awk -v n="${#eh[@]}" 'BEGIN{printf "%.12f",1/n}')";for h in "${eh[@]}";do demand["$h"]="$(awk -v a="${demand[$h]}" -v b="$frac" 'BEGIN{printf "%.12f",a+b}')";done;done
 fi
 [ "$cv" -eq 1 ]||{ log "WARN: cleric allocation frozen: $bad";finish; }
 A=0;capacity=0;for h in "${eligible[@]}";do A=$((A+active[$h]));capacity=$((capacity+ccap[$h]));done
 N=${#eligible[@]};idle=$N;[ "$idle" -le "$cf" ]||idle="$cf";kd=$((A+Q));[ "$kd" -le "$cf" ]||kd="$cf";K="$idle";[ "$K" -ge "$kd" ]||K="$kd";[ "$K" -ge "$A" ]||K="$A";alloc="$K"
 [ "$alloc" -le "$capacity" ]||{ alloc="$capacity";log "WARN: cleric fleet target $K exceeds physical capacity $capacity; allocating to caps";alert_maintainer budget-level-cleric-capacity "budget-level: cleric fleet target $K exceeds physical capacity $capacity; allocated only to physical caps.";}
 slots=$((alloc-A));[ "$slots" -le "$Q" ]||slots="$Q";[ "$slots" -ge 0 ]||slots=0;dt=$((A+slots));rows=""
 for h in "${eligible[@]}";do rows+="$h"$'\t'"${demand[$h]}"$'\t'"${active[$h]}"$'\t'"${ccap[$h]}"$'\n';done
 while IFS=$'\t' read -r h x;do ctarget["$h"]="$x";done < <(printf %s "$rows"|apportion "$dt")
 left=$((alloc-dt));while [ "$left" -gt 0 ];do pick="";for h in "${eligible[@]}";do [ "${ctarget[$h]}" -lt "${ccap[$h]}" ]||continue;if [ -z "$pick" ]||[ "${ctarget[$h]}" -lt "${ctarget[$pick]}" ]||{ [ "${ctarget[$h]}" -eq "${ctarget[$pick]}" ]&&[[ "$h" < "$pick" ]];};then pick="$h";fi;done;[ -n "$pick" ]||break;ctarget["$pick"]=$((ctarget[$pick]+1));left=$((left-1));done
 for h in "${eligible[@]}";do cur="$(read_desired_count "$DIR/hosts/$h" clerics 2>/dev/null)"||{ pool_failure openai-codex-shared "$h" read-host-clerics "$?";continue;};target="${ctarget[$h]}";apply_target openai-codex-shared "$h" cleric "$cur" "$target" "shared cleric demand active=$A queue=$Q fleet-envelope=$cf target=$target";done
else log "WARN: cleric allocation frozen: $bad";fi

finish
