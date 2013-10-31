# See bottom of file for default license and copyright information

package Foswiki::Plugins::JSi18nPlugin;

use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = '$Rev: 7808 (2010-06-15) $';
#use version; our $VERSION = version->declare("v1.0.0_001");

our $RELEASE = '0.0.1';

our $SHORTDESCRIPTION = 'Translations for JavaScript';

our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my ( $topic, $web ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 2.0 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
            __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    Foswiki::Func::registerTagHandler( 'JSI18NID', \&_JSI18NID );

    # Plugin correctly initialized
    return 1;
}

sub _EXAMPLETAG {
    #my($session, $params, $topic, $web, $topicObject) = @_;

    my $id = 'jsi18nCore';
    Foswiki::Func::addToZone('script', $id, <<'SCRIPT', undef);
<script type='text/javascript' src='%PUBURLPATH%/%SYSTEMWEB%/JSi18nPlugin/jsi18n.js'></script>
SCRIPT

    return $id;
}


1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2013 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
