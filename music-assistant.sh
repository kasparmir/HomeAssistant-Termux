source "$(dirname "${BASH_SOURCE[0]}")/source.env"
IMAGE_VERSION=2.3.6
IMAGE_NAME="ghcr.io/music-assistant/server:$IMAGE_VERSION"
CONTAINER_NAME="music-assistant"

TZ="Europe/Prague"

STORAGE_PATH="$HOME/container_data/$CONTAINER_NAME"
mkdir -p "$STORAGE_PATH"

case $PORT in
  ''|*[!0-9]*) PORT=8095;;
  *) [ $PORT -gt 1023 ] && [ $PORT -lt 65536 ] || PORT="8095";;
esac

udocker_check

udocker_prune

udocker_create "$CONTAINER_NAME" "$IMAGE_NAME"

if [ -n "$1" ]; then
 udocker_run --entrypoint "ash -c" -p "$PORT:8095" -e LD_PRELOAD="" "$CONTAINER_NAME" "$@"
else
 udocker_run -p "$PORT:8095" -p "3483:3483" -p "9090:9090" -p "9000:9000"  \
	-e TZ="$TZ" \
	   -e LD_PRELOAD="" \
	   -v "$STORAGE_PATH:/data" \
	  "$CONTAINER_NAME" #"ash"
fi
exit $?
