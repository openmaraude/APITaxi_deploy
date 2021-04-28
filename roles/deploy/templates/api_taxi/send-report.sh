#!/bin/sh

CONTAINER=api_taxi

/bin/echo "\
Subject: Weekly usage report

$(/usr/bin/docker exec $CONTAINER flask report)

$(/usr/bin/docker exec $CONTAINER flask clean_db)

" | /usr/sbin/sendmail -F 'le.taxi production' -f 'prod@le.taxi' equipe@le.taxi
