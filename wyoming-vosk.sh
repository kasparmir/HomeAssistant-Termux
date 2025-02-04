source "$(dirname "${BASH_SOURCE[0]}")/source.env"
IMAGE_NAME="rhasspy/wyoming-vosk:latest"
CONTAINER_NAME="wyoming-vosk"

# Set timezone, eg, Asia/Seoul. Feel free to change.
TZ="Europe/Prague"

# Check if PORT is a valid number
case $PORT in
  ''|*[!0-9]*) PORT=10300;;
  *) [ $PORT -gt 1023 ] && [ $PORT -lt 65536 ] || PORT="8123";;
esac

udocker_check

udocker_prune

udocker_create "$CONTAINER_NAME" "$IMAGE_NAME"

if [ -n "$1" ]; then
 udocker_run --entrypoint "bash -c" -p "$PORT:10300" "$CONTAINER_NAME" "$@"
else
 udocker_run -p "$PORT:10300" \
   -e TZ="$TZ" \
   -e LD_PRELOAD="" \
  "$CONTAINER_NAME" --data-dir /data --model-for-language cs vosk-model-small-cs-0.4-rhasspy
fi
exit $?
