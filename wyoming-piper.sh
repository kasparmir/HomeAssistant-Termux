source "$(dirname "${BASH_SOURCE[0]}")/source.env"
IMAGE_NAME="rhasspy/wyoming-piper:latest"
CONTAINER_NAME="wyoming-piper"

# Set timezone, eg, Asia/Seoul. Feel free to change.
TZ="Europe/Prague"

# Check if PORT is a valid number
case $PORT in
  ''|*[!0-9]*) PORT=10200;;
  *) [ $PORT -gt 1023 ] && [ $PORT -lt 65536 ] || PORT="8123";;
esac

udocker_check

udocker_prune

udocker_create "$CONTAINER_NAME" "$IMAGE_NAME"

if [ -n "$1" ]; then
 udocker_run --entrypoint "bash -c" -p "$PORT:10200" "$CONTAINER_NAME" "$@"
else
 udocker_run -p "$PORT:10200" \
   -e TZ="$TZ" \
   -e LD_PRELOAD="" \
  "$CONTAINER_NAME" --voice cs_CZ-jirka-low
fi
exit $?
