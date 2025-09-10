#!/bin/bash

# ヘルプ表示関数
show_help() {
  echo "Usage: $0 -l <image-list-file> -r <registry-machine> [-p <registry-port>]"
  echo "  -l : イメージリストファイル（必須）"
  echo "  -r : レジストリマシン名（必須）"
  echo "  -p : レジストリポート番号（省略時は5000）"
  exit 1
}

# デフォルトポート
PORT=5000

# 引数解析
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -l)
      LIST_FILE="$2"
      shift; shift
      ;;
    -r)
      REGISTRY="$2"
      shift; shift
      ;;
    -p)
      PORT="$2"
      shift; shift
      ;;
    *)
      show_help
      ;;
  esac
done

# 必須引数チェック
if [ -z "$LIST_FILE" ] || [ -z "$REGISTRY" ]; then
  show_help
fi

# ファイル存在確認
if [ ! -f "$LIST_FILE" ]; then
  echo "❌ イメージリストファイルが見つかりません: $LIST_FILE"
  exit 1
fi

echo "🚀 イメージ登録開始: $LIST_FILE"

# 1行ずつ処理（形式: image_name version または image_name:version）
while read -r LINE; do
  # 空行スキップ
  if [ -z "$LINE" ]; then
    continue
  fi

  # スペース区切りかコロン区切りか判定
  if [[ "$LINE" == *:* ]]; then
    IMAGE_NAME=$(echo "$LINE" | cut -d':' -f1)
    VERSION=$(echo "$LINE" | cut -d':' -f2)
  else
    IMAGE_NAME=$(echo "$LINE" | awk '{print $1}')
    VERSION=$(echo "$LINE" | awk '{print $2}')
  fi

  if [ -z "$IMAGE_NAME" ] || [ -z "$VERSION" ]; then
    echo "⚠️ 無効な行をスキップ: $LINE"
    continue
  fi

  echo "🔄 処理対象: ${IMAGE_NAME}:${VERSION} → ${REGISTRY}:${PORT}/${IMAGE_NAME}:latest"

  # pull（常に実行）
  echo "📥 docker pull ${IMAGE_NAME}:${VERSION}"
  docker pull ${IMAGE_NAME}:${VERSION}
  if [ $? -ne 0 ]; then
    echo "❌ pull失敗: ${IMAGE_NAME}:${VERSION}"
    continue
  fi

  # tag（ローカルにlatestがなければ実行）
  if ! docker image inspect ${REGISTRY}:${PORT}/${IMAGE_NAME}:latest > /dev/null 2>&1; then
    echo "🏷️ docker tag ${IMAGE_NAME}:${VERSION} ${REGISTRY}:${PORT}/${IMAGE_NAME}:latest"
    docker tag ${IMAGE_NAME}:${VERSION} ${REGISTRY}:${PORT}/${IMAGE_NAME}:latest
  else
    echo "ℹ️ ローカルに ${IMAGE_NAME}:latest が既に存在します。tag をスキップします。"
  fi

  # push（常に実行）
  echo "📤 docker push ${REGISTRY}:${PORT}/${IMAGE_NAME}:latest"
  docker push ${REGISTRY}:${PORT}/${IMAGE_NAME}:latest
  if [ $? -ne 0 ]; then
    echo "❌ push失敗: ${IMAGE_NAME}:latest"
    continue
  fi

done < "$LIST_FILE"

echo "✅ 全処理完了"
