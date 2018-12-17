.. App::TimeClock documentation master file, created by
   sphinx-quickstart on Mon Sep  1 14:29:14 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

TimeClock User Guide
====================


Introduction
------------

TimeClock [#fullname]_ is a simple time clock reporting tool for the
`GNU/Emacs`_ mode: timeclock_. It's a command line tool that reads a
timelog and prints a report to the console. By default the report
looks something like this::

                     =====================================
                     Daily Report Mon Dec  3 16:52:44 2012
                     =====================================
    
    * Thu 2012/03/15 (08:07:06 - 16:15:14) *
    +--------------------------------------------------------------+-------+
    | Total Daily Hours                                            |  8.14 |
    +--------------------------------------------------------------+-------+
    | Afternoon                                                    |  3.05 |
    +--------------------------------------------------------------+-------+
    | FirstCheckIn                                                 |  4.07 |
    +--------------------------------------------------------------+-------+
    | Lunch                                                        |  1.02 |
    +--------------------------------------------------------------+-------+
    
    TOTAL = 8.14 hours
    PERIOD = 1 days
    AVERAGE = 8.14 hours/day
    

But it is also possible to generate a report formatted as HTML or
CSV.

Installing TimeClock
--------------------

TimeClock is written in Perl_. If you already have Perl installed you
can install TimeClock using CPAN::

    $ cpan App::TimeClock

Configuration
-------------

If you haven't changed your `GNU/Emacs`_ setup, no configuration is
needed. The script will read your timelog file from the default
location which is ``~/.timelog``

If you have changed the location of the timelog file (e.g placing it
in a Dropbox folder), you can create the file ``~/.timeclockrc`` and
define the location of the timelog file there. Example::

    $timelog = "$ENV{HOME}/Dropbox/timelog";


License and Copyright
---------------------

Copyright (C) 2012-2018 Søren Lund

This file is part of App::TimeClock.

App::TimeClock is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

App::TimeClock is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with App::TimeClock.  If not, see <http://www.gnu.org/licenses/>.

.. rubric:: Footnotes

.. [#fullname] The full name of this application is
               **App::TimeClock**, but in most of this documentation
               I'm using the simpler name **TimeClock**.

.. _GNU/Emacs: https://www.gnu.org/software/emacs/
.. _`timeclock`:  http://www.emacswiki.org/emacs/TimeClock
.. _Perl: http://www.perl.org/
