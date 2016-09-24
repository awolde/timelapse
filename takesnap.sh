#!/bin/bash 
DESTINATION="192.168.1.10:/buffer/"
PASS="password"
RASPI="192.168.1.50:8080"

while true
do

for x in {0..999}; 
do
  if [ $x -lt 10 ]; then
    zeros='000'
  else
    if [ $x -lt 100 ] && [ $x -ge 10 ]; then
      zeros='00'
    else
      zeros='0'
    fi
  fi 
  wget http://${RASPI}/stream/snapshot.jpeg?delay_s=0 --http-user=admin --http-password=${PASS} -O snapshot$zeros${x}.jpeg; sleep 2; 
done
FILE=timelaspe-$(date +%Y-%m-%d-%H--%M).mp4
avconv -y -r 20 -i snapshot%4d.jpeg -r 20  -vcodec libx264 -q:v 1 -vf scale=iw:ih $FILE
rm snapshot*
scp $FILE  awolde@${DESTINATION}
rm $FILE
done
