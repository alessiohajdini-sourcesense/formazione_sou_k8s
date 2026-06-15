#!/bin/bash

NAMESPACE="formazione-sou"
SA="system:serviceaccount:${NAMESPACE}:cluster-reader"
TMP=$(mktemp /tmp/deployments.XXXXXX.yaml)

rimozione_file(){
  rm -f "$TMP"
}

trap rimozione_file EXIT

if ! kubectl get deployments --as=${SA} -n ${NAMESPACE} -o yaml > $TMP; then
  echo "[ERRORE]"
  exit 1
fi

grep -q "livenessProbe:" "$TMP"
LIVENESS=$?

grep -q "readinessProbe:" "$TMP"
READINESS=$?

grep -q "limits:" "$TMP"
LIMITS=$?

grep -q "requests:" "$TMP"
REQUESTS=$?

EXIT_CODE=0

if [ $LIVENESS -eq 1 ]; then
  echo "Manca Liveness"
  EXIT_CODE=1
else
  echo "Liveness OK"
fi

if [ $READINESS -eq 1 ]; then
  echo "Manca Readiness"
  EXIT_CODE=1
else
  echo "Readiness OK"
fi

if [ $LIMITS -eq 1 ]; then
  echo "Manca Limits"
  EXIT_CODE=1
else
  echo "Limits OK"
fi

if [ $REQUESTS -eq 1 ]; then
  echo "Manca Requests"
  EXIT_CODE=1
else
  echo "Requests OK"
fi

exit $EXIT_CODE