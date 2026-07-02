#!/bin/bash
#
# ClaudeCodeAutoSetup — one-command project generator for Claude Code
#
# Interactive usage:
#   ./setup.sh
#
# Remote usage (no clone needed):
#   curl -fsSL https://raw.githubusercontent.com/AgenticAIJP/ClaudeCodeAutoSetup/main/setup.sh | bash
#
# Non-interactive usage (for scripts / CI):
#   ./setup.sh <type-number 1-6> <project-name>
#
# All UI messages are in Japanese (target audience). Code is in English.

set -euo pipefail

REPO_TARBALL="https://github.com/AgenticAIJP/ClaudeCodeAutoSetup/archive/refs/heads/main.tar.gz"
VERSION="1.0.0"

# When piped via `curl | bash`, stdin is the script itself.
# Read user input from /dev/tty instead.
if [ -t 0 ]; then
  INPUT="/dev/stdin"
else
  INPUT="/dev/tty"
fi

say() { printf '%b\n' "$1"; }

say ""
say "┌─────────────────────────────────────────────┐"
say "│  ClaudeCodeAutoSetup v${VERSION}                   │"
say "│  Claude Code プロジェクトを一発生成します    │"
say "└─────────────────────────────────────────────┘"
say ""

# --- 1. Locate templates (local clone or download) -------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || pwd)"
TEMPLATES_DIR=""
TMP_DIR=""

cleanup() { if [ -n "$TMP_DIR" ]; then rm -rf "$TMP_DIR"; fi; }
trap cleanup EXIT

if [ -d "$SCRIPT_DIR/templates/base" ]; then
  TEMPLATES_DIR="$SCRIPT_DIR/templates"
else
  say "📦 テンプレートをダウンロード中..."
  TMP_DIR="$(mktemp -d)"
  if ! curl -fsSL "$REPO_TARBALL" | tar -xz -C "$TMP_DIR"; then
    say "❌ ダウンロードに失敗しました。ネットワークを確認してください。"
    exit 1
  fi
  TEMPLATES_DIR="$(find "$TMP_DIR" -maxdepth 2 -type d -name templates | head -1)"
  if [ -z "$TEMPLATES_DIR" ] || [ ! -d "$TEMPLATES_DIR/base" ]; then
    say "❌ テンプレートが見つかりませんでした。"
    exit 1
  fi
fi

# --- 2. Choose project type -------------------------------------------------

say "プロジェクトのタイプを選んでください:"
say ""
say "  1) 汎用ベース      — まずはこれ。最小のきれいな骨格"
say "  2) Webアプリ型     — frontend / backend 分離"
say "  3) APIサービス型   — routes / services / models"
say "  4) CLIツール型     — commands / handlers"
say "  5) AI Agent型      — agents / skills / tools + MCP"
say "  6) ドキュメント型  — 学習サイト・技術ブログ"
say ""

ARG_TYPE="${1:-}"
ARG_NAME="${2:-}"

TYPE_KEY=""
while [ -z "$TYPE_KEY" ]; do
  if [ -n "$ARG_TYPE" ]; then
    choice="$ARG_TYPE"; ARG_TYPE=""
  else
    printf "番号を入力 [1-6] (デフォルト: 1): "
    read -r choice < "$INPUT" || { say ""; say "❌ 入力を読み取れませんでした。引数指定も使えます: ./setup.sh <1-6> <名前>"; exit 1; }
  fi
  choice="${choice:-1}"
  case "$choice" in
    1) TYPE_KEY="base";      TYPE_LABEL="汎用ベース" ;;
    2) TYPE_KEY="webapp";    TYPE_LABEL="Webアプリ型" ;;
    3) TYPE_KEY="api";       TYPE_LABEL="APIサービス型" ;;
    4) TYPE_KEY="cli";       TYPE_LABEL="CLIツール型" ;;
    5) TYPE_KEY="agent";     TYPE_LABEL="AI Agent型" ;;
    6) TYPE_KEY="docs-site"; TYPE_LABEL="ドキュメント型" ;;
    *) say "⚠️  1〜6 の番号を入力してください。" ;;
  esac
done

# --- 3. Project name ---------------------------------------------------------

PROJECT_NAME=""
while [ -z "$PROJECT_NAME" ]; do
  if [ -n "$ARG_NAME" ]; then
    name="$ARG_NAME"; ARG_NAME=""
  else
    printf "プロジェクト名を入力 (例: my-app): "
    read -r name < "$INPUT" || { say ""; say "❌ 入力を読み取れませんでした。引数指定も使えます: ./setup.sh <1-6> <名前>"; exit 1; }
  fi
  if [ -z "$name" ]; then
    say "⚠️  プロジェクト名を入力してください。"
  elif ! printf '%s' "$name" | grep -Eq '^[A-Za-z0-9][A-Za-z0-9._-]*$'; then
    say "⚠️  英数字・ハイフン・アンダースコア・ドットのみ使えます。"
  elif [ -e "./$name" ]; then
    say "⚠️  「$name」は既に存在します。別の名前を入力してください。"
  else
    PROJECT_NAME="$name"
  fi
done

TARGET="./$PROJECT_NAME"

# --- 4. Generate -------------------------------------------------------------

say ""
say "🔧 生成中: $PROJECT_NAME ($TYPE_LABEL)"

mkdir -p "$TARGET"
cp -R "$TEMPLATES_DIR/base/." "$TARGET/"

if [ "$TYPE_KEY" != "base" ]; then
  # Remove base paths the overlay replaces (listed in overlay's _remove file)
  if [ -f "$TEMPLATES_DIR/$TYPE_KEY/_remove" ]; then
    while IFS= read -r path; do
      case "$path" in
        ""|/*|*..*) continue ;;  # skip empty / absolute / traversal paths
        *) rm -rf "${TARGET:?}/$path" ;;
      esac
    done < "$TEMPLATES_DIR/$TYPE_KEY/_remove"
  fi
  cp -R "$TEMPLATES_DIR/$TYPE_KEY/." "$TARGET/"
fi

# Inject the type-specific section into CLAUDE.md ({{TYPE_SECTION}} marker)
SECTION_FILE="$TARGET/_type-section.md"
if [ -f "$SECTION_FILE" ] && grep -q '{{TYPE_SECTION}}' "$TARGET/CLAUDE.md"; then
  awk -v sf="$SECTION_FILE" '
    /\{\{TYPE_SECTION\}\}/ {
      while ((getline line < sf) > 0) print line
      close(sf)
      next
    }
    { print }
  ' "$TARGET/CLAUDE.md" > "$TARGET/CLAUDE.md.tmp"
  mv "$TARGET/CLAUDE.md.tmp" "$TARGET/CLAUDE.md"
fi

# Drop generator metadata files from the generated project
rm -f "$TARGET/_type-section.md" "$TARGET/_remove"

# Replace {{PROJECT_NAME}} placeholders (portable sed -i)
for f in "$TARGET/CLAUDE.md" "$TARGET/README.md"; do
  [ -f "$f" ] || continue
  sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$f" && rm -f "$f.bak"
done

# Make hook scripts executable
chmod +x "$TARGET"/.claude/hooks/*.sh 2>/dev/null || true

# --- 5. Done -----------------------------------------------------------------

say ""
say "✅ 完成！ 生成された構造:"
say ""
if command -v tree >/dev/null 2>&1; then
  tree -a -I '.git' "$TARGET"
else
  find "$TARGET" -not -path '*/.git/*' | sed "s|^\./||" | sort | sed 's|[^/]*/|  |g'
fi
say ""
say "次の一歩:"
say ""
say "  1. cd $PROJECT_NAME"
say "  2. CLAUDE.md を開き、<!-- TODO --> の3箇所を埋める(概要・技術スタック)"
say "  3. claude を起動して開発開始！"
say ""
say "💡 各設定ファイルの隣にある *.sample.md がその場の解説書です。"
say "   詳しい使い方: https://github.com/AgenticAIJP/ClaudeCodeAutoSetup"
say ""
