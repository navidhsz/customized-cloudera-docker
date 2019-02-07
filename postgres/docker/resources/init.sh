#!/usr/bin/env bash

function startPostgres ()
{
  su - postgres -c "/usr/pgsql-9.4/bin/pg_ctl -D /pgsql/data -w start"
  echo '######################## DATABASE IS READY ########################'
  while true; do sleep 5000; done
}

startPostgres