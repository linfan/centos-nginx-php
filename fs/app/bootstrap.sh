#!/bin/bash

set -e
set -u

# Supervisord default params
SUPERVISOR_PARAMS='-c /etc/supervisord.conf'

# We have TTY, so probably an interactive container...
if test -t 0; then
  # Run supervisord detached...
  supervisord $SUPERVISOR_PARAMS
  
  # Some command(s) has been passed to container? Execute them and exit.
  if [[ $@ ]]; then 
    eval $@
  # No commands provided? Run bash.
  else 
    export PS1='[\u@\h : \w]\$ '
    /bin/bash
  fi

# For detached mode, run supervisord in foreground, 
# which will stay until container is stopped.
else
  # If some extra params were passed, execute them before.
  if [[ $@ ]]; then 
    eval $@
  fi
  supervisord -n $SUPERVISOR_PARAMS
fi
