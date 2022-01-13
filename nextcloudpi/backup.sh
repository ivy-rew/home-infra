#!/bin/bash

ncBaseUri="https://192.168.1.3" # nextCloud base URL

# add to your environment in advance e.g.
# export ncUser=myUser && export ncPass=myPass
auth="${ncUser}:${ncPass}"

# create a local copy of your .ICS 
# ready for restore import it later on into any NC instance 
# (see calendar app > settings > import)
bkpCal() { 
  principal="$1"
  calendar="$2"
  ics="${calendar}.ics"
  echo "copying ${ics}"
  calUri="${ncBaseUri}/remote.php/dav/calendars/${principal}/${calendar}?export"
  curl -u "${auth}" -k -o "${ics}" "${calUri}"
}

# execute
# bkpCal principal calendarname
