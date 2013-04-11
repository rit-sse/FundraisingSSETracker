#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

psql < $DIR/dbteardown.psql
psql < $DIR/dbsetup.psql
