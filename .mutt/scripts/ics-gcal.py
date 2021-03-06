#!/usr/bin/python

""" ics-gcal.py (c) 2008, 2010 Matthew Ernisse <mernisse@ub3rgeek.net>

Cobbled together with help from gdata API documentation:
http://code.google.com/apis/calendar/developers_guide_python.html

To Use:
	add the following to your .mailcap and then you can simply
exec the attachment and it will get added to your google calendar.

If the event has a reminder set it will set a reminder using your
default method for 30 minutes prior to the event.

text/calendar;  ics-gcal.py -u <gcal un> -p <gcal pw> -f %s; \
                 copiousoutput; needsterminal

Calendar name can be found on the calendar details page, or based
on your calendar's xml/ical links.

If your XML link is:
http://www.google.com/calendar/feeds/yourname@gmail.com/public/basic

Then your calendar name is yourname@gmail.com

You may also now use a configuration file, NOTE this is not actually any
more secure than using the command line in your .mailcap configuration file
assuming sane permissions.

In ~/.config/ics-gcal.conf you may specify the following tokens:
email = <gcal user>
password = <gcal password>
calendar = "calendar name"

If the command line has these options specified they will OVERRIDE the
config file.  None are required as long as between the config file and
the command like all required options are set.

Requires:
	gdata python bindings
	atom python module
	vobject python module

	Google Calendar account

"""
import getopt
import time
import sys
import os
import vobject

from gdata.calendar.service import *
from gdata.calendar import CalendarEventEntry, Reminder, Recurrence, Where, When

def Usage():
	"""Print usage statement

	Returns:
		None
	
	"""
	print """Usage: %s [-hR] [-c calendar] [-f file] [-p password] [-r 
minutes] [-u username]
	Take a vcalendar stream from a file and insert to it into a Google
	calendar

	Arguments:
	-c <calendar> - Which calendar to upload to, default = 'default'
	-f <file>     - ics file for input
	-h            - Show Usage and exit.
	-p <password> - Google Calendar password
	-r <minutes>  - Number of minutes for reminder length, default = 30
	-R            - Force adding a reminder even if the ics does not have
                         an alarm set.
	-u <username> - Google Calendar username

	""" % (sys.argv[0])

	return None

#def Reply(ics, reply="tentative"):
#
#	if reply == "accept":
#		message = "Event Accepted"
#		subject =
#			
#	elif reply == "tentative":
#		message = "Event Tentativly Accepted"
#		subject =
#
#	elif reply == "deny":
#		message = "Event Declined"
#		subject =
#
#	else:
#		print "Invalid reply specified"
#		return None
#
#

def uploadToGoogle(ics, email, password, calendar="default", reminder=30, \
                    forceReminder=False):
	""" Upload to your Google Calendar.

	Arguments:
		ics - vobject vevent object.
		email - string, your gcal account name
		password - string, your gcal password
		calendar - string, which calendar to upload to.
		reminder - integer, number of minutes to set
			   reminder for.  Default 30
		forceReminder - boolean, If true, always set a
			        reminder.

	Returns:
		True on success, None on failure

	"""
	# sucks that gdata won't take a timetuple or a isoformat :(
	# it seems that sometimes vobject doesn't give me a
	# datetime object and instead gives me a unicode string.
	# it'd be nice to handle that.
	if type(u' ') == type(ics.vevent.dtstart.value):
		start = time.strptime(ics.vevent.dtstart.value,
			"%Y%m%dT%H%M%S")
		start = time.strftime("%Y-%m-%dT%H:%M:%S.000Z",
			start)
	else:
		start = time.strftime("%Y-%m-%dT%H:%M:%S.000Z",
			ics.vevent.dtstart.value.utctimetuple())

	if type(u' ') == type(ics.vevent.dtend.value):
		end = time.strptime(ics.vevent.dtend.value,
			"%Y%m%dT%H%M%S")
		end = time.strftime("%Y-%m-%dT%H:%M:%S.000Z",
			end)
	else:
		end = time.strftime("%Y-%m-%dT%H:%M:%S.000Z",
			ics.vevent.dtend.value.utctimetuple())

	event = CalendarEventEntry()
	event.title = atom.Title(text=ics.vevent.summary.value)
	if getattr(ics.vevent, "description", None):
		event.content = atom.Content(text=ics.vevent.description.value)
	else:
		event.content = atom.Content(text="")

	if getattr(ics.vevent, "location", None):
		event.where.append(
			Where(value_string=ics.vevent.location.value)
		)
	else:
		event.where.append(Where(value_string=""))


	# an alarm is set, so go ahead and set a reminder
	if 'valarm' in ics.vevent.contents:
		for when in event.when:
			if len(when.reminder) > 0:
				when.reminder[0].minutes = reminder
			else:
				when.reminder.append(Reminder(minutes=reminder))
	elif forceReminder:
		for when in event.when:
			when.reminder.append(Reminder(minutes=reminder))

	if getattr(ics.vevent, "rrule", None):
		try:
			event.recurrence = Recurrence(text=("%s\r\n%s\r\n%s\r\n") % (
				"DTSTART:%s" % (
					time.strftime("%Y%m%dT%H%M%S",ics.vevent.dtstart.value.utctimetuple())
					),
				"DTEND:%s" % (
					time.strftime("%Y%m%dT%H%M%S",ics.vevent.dtend.value.utctimetuple())
					),
				"RRULE:%s" % (
					ics.vevent.rrule.value
					)
				)
			)
		except Exception, e:
			print "could not add Recurrence to event, %s" % (str(e))
			return None

	else:
		event.when.append(When(start_time=start, end_time=end))

	try:
		cal = CalendarService()
		cal.email = email
		cal.password = password
		cal.source = "ASDF"
		cal.ProgrammaticLogin()
	except Exception, e:
		print "cannot login to Google Calendar: %s"  % ( str(e) )
		return None

	try:
		new_event = cal.InsertEvent(event, '/calendar/feeds/%s/private/full' % 
(calendar))
	except Exception, e:
		print "cannot upload event to Google Calendar: %s"  % ( str(e) )
		return None

	print 'New single event inserted: %s' % (new_event.id.text,)
	print '\tEvent edit URL: %s' % (new_event.GetEditLink().href,)
	print '\tEvent HTML URL: %s' % (new_event.GetHtmlLink().href,)

	return True

def Main(argv = None):
	if not argv:
		argv = sys.argv[1:]

	if not len(argv) >= 1:
		Usage()
		return 2

	try:
		optlist, args = getopt.getopt(argv, "hRu:p:f:c:r:")
	except getopt.GetoptError, e:
		print str(e)
		Usage()
		return 2

	calendar = "default"
	email = None
	fd = None
	force = None
	password = None
	reminder = 30

	try:
		fd = open(os.path.expanduser('~/.config/ics-gcal.conf'))
		for line in fd.readlines():
			try:
				token, value = line.split(r'=', 2)
			except ValueError:
				pass

			token = token.strip().lower()
			value = value.strip()

			if token == 'email':
				email = value	
			elif token == 'password':
				password = value
			elif token == 'calendar':
				calendar = value

		fd.close()
		fd = None

	except (OSError, IOError):
		pass

	for o,v in optlist:
		if o == "-c":
			calendar = v

		elif o == "-f":
			try:
				fd = open(v)
			except IOError, e:
				print str(e)
				return 1
		elif o == "-h":
			Usage()
			return 0

		elif o == "-p":
			password = v

		elif o == "-r":
			reminder = int(v)

		elif o == "-R":
			force = True

		elif o == "-u":
			email = v

	if not email or not password or not fd:
		print "You did not specify the required arguments (username, password and file)"
		Usage()
		return 2

	try:
		ics = vobject.readOne(fd)
		fd.close()
	except Exception, e:
		print "cannot parse vcal input file: %s"  % ( str(e) )
		return 1

	if not uploadToGoogle(ics, email, password, calendar, reminder, force):
		return 1

	return 0

if __name__ == "__main__":
	sys.exit(Main(sys.argv[1:]))
