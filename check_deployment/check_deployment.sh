#!/bin/bash

kubectl describe deployments --as=system:serviceaccount:formazione-sou:cluster-reader -n formazione-sou > deployments.txt

