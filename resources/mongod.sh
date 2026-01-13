#!/bin/bash

mgoname="mgo-$(openssl rand -hex 4)"

# Parse arguments and build podman command
PODMAN_ARGS=()
MONGOD_ARGS=()
EXTRA_COMMANDS=()

while [[ $# -gt 0 ]]; do
	case "$1" in
	--dbpath)
		# Use internal db path
		shift 2
		;;
	--storageEngine)
		# Override wiredTiger with inMemory
		if [[ "$2" == "wiredTiger" ]]; then
			MONGOD_ARGS+=("$1" "inMemory")
		else
			MONGOD_ARGS+=("$1" "$2")
		fi
		shift 2
		;;
	--keyFile)
		MONGOD_ARGS+=("$1" "/data/db/keyfile")
		EXTRA_COMMANDS+=("podman cp $2 $mgoname:/data/db/keyfile &>/dev/null")
		shift 2
		;;
	--sslPEMKeyFile | --tlsCertificateKeyFile)
		MONGOD_ARGS+=("$1" "/data/db/server.pem")
		EXTRA_COMMANDS+=("podman cp $2 $mgoname:/data/db/server.pem &>/dev/null")
		shift 2
		;;
	--sslCAFile | --tlsCAFile)
		MONGOD_ARGS+=("$1" "/data/db/ca.pem")
		EXTRA_COMMANDS+=("podman cp $2 $mgoname:/data/db/ca.pem &>/dev/null")
		shift 2
		;;
	*)
		# Pass through all other arguments
		MONGOD_ARGS+=("$1")
		shift
		;;
	esac
done

# Create dbpath directory if it doesn't exist
if [[ -n "$dbpath" && ! -d "$dbpath" ]]; then
	mkdir -p "$dbpath"
fi

(setsid --fork sh -c "tail --pid $$ -f /dev/null || true; podman rm -f $mgoname" </dev/null 1>/dev/null 2>/dev/null &) &
(setsid --fork sh -c "tail --pid $PPID -f /dev/null || true; podman rm -f $mgoname" </dev/null 1>/dev/null 2>/dev/null &) &
wait || true

# Run mongod via podman
podman create --rm --name $mgoname --net=host "${PODMAN_ARGS[@]}" \
	docker.io/mongodb/mongodb-enterprise-server:4.4.29-ubuntu2004 \
	"${MONGOD_ARGS[@]}" &>/dev/null

${EXTRA_COMMANDS}

exec podman start -a $mgoname
