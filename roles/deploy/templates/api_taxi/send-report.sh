#!/bin/sh

(/bin/echo -e 'Subject: Weekly usage report\n\n' ; /usr/bin/docker exec api_taxi flask report) | /usr/sbin/sendmail -F 'le.taxi production' -f 'prod@le.taxi' equipe@le.taxi
