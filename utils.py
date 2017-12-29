#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import os
import warnings
import datetime
from slacker import Slacker

__autor__ = 'Kyosuke Yamamoto (kyon)'
__date__ = '26 Dec 2017'


def save_and_slack_file(fig, filepath, post=True):
    fig.savefig(filepath)
    slack_file(filepath, post=post)


def slack_file(filepath, msg='', channel='#general', post=True):
    ''' Post image to slack '''

    #not post
    if not post:
        return

    slack = Slacker(os.environ['SLACK_API_KYONAWS'])

    try:
        slack.files.upload(filepath,
                           initial_comment=msg,
                           channels=channel,
                           filename=filepath.replace('/', '-'))
    except:
        warnings.warn('slack failed.')


def log(*args):
    msg = ' '.join(map(str, [datetime.datetime.now(), '>'] + list(args)))
    print(msg)
    with open('output/log.txt', 'a') as fd:
        fd.write(msg + '\n')
