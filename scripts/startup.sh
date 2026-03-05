#!/bin/bash
/usr/bin/conky &
sleep 5
killall conky
sleep 5
/usr/bin/conky &
