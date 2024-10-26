#!/bin/sh
echo "127.0.0.1 localhost.ticketseller" >> /etc/hosts
exec "$@"
