#!/usr/bin/env python2

from twisted.internet.defer import inlineCallbacks
from alot.buffers import ThreadBuffer
import urllib2
import logging
import re

@inlineCallbacks
def pre_envelope_send(ui, dbm=None, cmd=None):
    e = ui.current_buffer.envelope
    if (re.match('.*[Aa]ttach', e.body, re.DOTALL) or\
        re.match('.*angehängt', e.body, re.DOTALL)    ) and\
       not e.attachments:
        msg = 'no attachments. send anyway?'
        if not (yield ui.choice(msg, select='yes')) == 'yes':
            raise Exception()

#def msg_focused(ui, msg):
#     github_mark_read(ui, msg)

def github_mark_read(ui, msg=None):
    if msg is None:
        msg = ui.current_buffer.get_selected_message()
    msgtext = str(msg.get_email())
    r = r"(https://github.com/notifications/beacon/[a-zA-Z0-9_-]*.gif)"
    beacons = re.findall(r, msgtext)
    if beacons:
        logging.debug("beacons to open: %s", beacons[0])
        urllib2.urlopen(beacons[0])
        ui.notify('removed from github notifications:\n %s' % beacons[0])
