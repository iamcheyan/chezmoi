#!/usr/bin/env bash
set -euo pipefail

AVD_NAME="${MIYAKO_AVD:-Miyako_Test}"
PACKAGE_NAME="${MIYAKO_PACKAGE:-com.miyako.app}"
ACTIVITY_NAME="${MIYAKO_ACTIVITY:-.MainActivity}"
PROJECT_ROOT="${MIYAKO_PROJECT:-$HOME/Development/music}"
APK_PATH="${MIYAKO_APK:-$PROJECT_ROOT/src-tauri/gen/android/app/build/outputs/apk/universal/debug/app-universal-debug.apk}"

export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

usage() {
  cat <<EOF
Usage: miyako-emulator [open|install|status|stop|apk]

  open     Start $AVD_NAME if needed, then open $PACKAGE_NAME.
  install  Start $AVD_NAME if needed, install debug APK, then open the app.
  status   Show adb devices and app install state.
  stop     Stop the app on the emulator.
  apk      Reveal the debug APK in Finder.
EOF
}

require_tool() {
  command -v "$1" >/dev/null || {
    echo "Missing required tool: $1" >&2
    exit 1
  }
}

emulator_serial() {
  adb devices | awk 'NR > 1 && $1 ~ /^emulator-/ && $2 == "device" { print $1; exit }'
}

start_emulator_if_needed() {
  require_tool adb
  require_tool emulator

  local serial
  serial="$(emulator_serial)"
  if [[ -n "$serial" ]]; then
    echo "$serial"
    return
  fi

  echo "Starting Android emulator: $AVD_NAME" >&2
  nohup emulator -avd "$AVD_NAME" -no-snapshot-load >/tmp/miyako-emulator.log 2>&1 &

  for _ in $(seq 1 120); do
    serial="$(emulator_serial)"
    if [[ -n "$serial" ]]; then
      echo "$serial"
      return
    fi
    sleep 1
  done

  echo "Timed out waiting for emulator. Log: /tmp/miyako-emulator.log" >&2
  exit 1
}

wait_for_boot() {
  local serial="$1"
  for _ in $(seq 1 120); do
    if [[ "$(adb -s "$serial" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]; then
      return
    fi
    sleep 1
  done

  echo "Timed out waiting for Android boot on $serial" >&2
  exit 1
}

open_app() {
  local serial="$1"
  adb -s "$serial" shell am start -n "$PACKAGE_NAME/$ACTIVITY_NAME"
}

install_app() {
  local serial="$1"
  [[ -f "$APK_PATH" ]] || {
    echo "APK not found: $APK_PATH" >&2
    echo "Build it first from $PROJECT_ROOT." >&2
    exit 1
  }

  adb -s "$serial" install -r "$APK_PATH"
}

cmd="${1:-open}"

case "$cmd" in
  open)
    serial="$(start_emulator_if_needed)"
    wait_for_boot "$serial"
    if ! adb -s "$serial" shell pm path "$PACKAGE_NAME" >/dev/null 2>&1; then
      install_app "$serial"
    fi
    open_app "$serial"
    ;;
  install)
    serial="$(start_emulator_if_needed)"
    wait_for_boot "$serial"
    install_app "$serial"
    open_app "$serial"
    ;;
  status)
    require_tool adb
    adb devices -l
    serial="$(emulator_serial)"
    if [[ -n "$serial" ]]; then
      adb -s "$serial" shell pm path "$PACKAGE_NAME" 2>/dev/null || true
    fi
    ;;
  stop)
    require_tool adb
    serial="$(emulator_serial)"
    [[ -n "$serial" ]] || { echo "No running emulator found." >&2; exit 1; }
    adb -s "$serial" shell am force-stop "$PACKAGE_NAME"
    ;;
  apk)
    [[ -f "$APK_PATH" ]] || { echo "APK not found: $APK_PATH" >&2; exit 1; }
    open -R "$APK_PATH"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
