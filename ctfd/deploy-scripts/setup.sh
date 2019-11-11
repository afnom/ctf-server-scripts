#!/bin/bash

# create an admin account
nonce=$(curl -s http://localhost:8000/setup -c cookie | grep 'name="nonce"' | awk '{ print $4 }' | cut -d'"' -f2)
curl "http://localhost:8000/setup" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -b cookie \
    --data-urlencode "nonce=$nonce" \
    --data-urlencode "ctf_name=${CTF_NAME}" \
    --data-urlencode "name=${NAME}" \
    --data-urlencode "email=${EMAIL}" \
    --data-urlencode "password=${PASSWORD}" \
    --data-urlencode "user_mode=users"
