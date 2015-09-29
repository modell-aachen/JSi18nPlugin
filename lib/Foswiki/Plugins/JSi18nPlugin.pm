# See bottom of file for default license and copyright information

package Foswiki::Plugins::JSi18nPlugin;

use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = '1.0';

our $RELEASE = '1.0';

our $SHORTDESCRIPTION = 'Translations for JavaScript';

our $NO_PREFS_IN_TOPIC = 1;

our %seen = ();
our %absent = ();

sub initPlugin {
    my ( $topic, $web ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 2.0 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
            __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    Foswiki::Func::registerTagHandler( 'JSI18NID', \&_JSI18NIDTAG );
    Foswiki::Func::registerTagHandler( 'JSI18N', \&_JSI18NTAG );

    # Plugin correctly initialized
    return 1;
}

sub _getFile {
    my($session, $folder, $id) = @_;

    return unless $folder;
    my $file = $folder."/jsi18n.";
    $file .= "$id." if $id;

    my $lang = $session->i18n->language();

    my $prefix = "$Foswiki::cfg{PubDir}/$file";
    foreach my $suffix ( ("$lang.min.js", "$lang.js", 'en.js') ) {
        my $localfile = $prefix.$suffix;
        return $file.$suffix if $seen{$localfile};
        next if $absent{$localfile};
        if ( -e $prefix.$suffix ) {
            $seen{$localfile} = 1;
            return $file.$suffix;
        } else {
            $absent{$localfile} = 1;
        }
    }
}

sub JSI18NByFolder {
    my($session, $folder, $id) = @_;

    my $file = _getFile($session, $folder, $id);
    return unless $file;

    my $addToZoneId = "jsi18n:$folder:$id";

    Foswiki::Func::addToZone('script', $addToZoneId, <<"SCRIPT", 'jsi18nCore');
<script type='text/javascript' src='\%PUBURLPATH\%/$file'></script>
SCRIPT

    return $file;
}

sub JSI18N {
    my($session, $plugin, $id) = @_;

    my $folder = "$Foswiki::cfg{SystemWebName}/$plugin";

    my $file = _getFile($session, $folder, $id);
    return unless $file;

    my $addToZoneId = "jsi18n:$plugin:$id";

    Foswiki::Func::addToZone('script', $addToZoneId, <<"SCRIPT", 'jsi18nCore');
<script type='text/javascript' src='\%PUBURLPATH\%/$file'></script>
SCRIPT

    return $file;
}

sub _JSI18NTAG {
    my($session, $params, $topic, $web, $topicObject) = @_;

    my $plugin = $params->{_DEFAULT};
    my $folder = (($plugin) ? "$Foswiki::cfg{SystemWebName}/$plugin" : $params->{folder});
    my $file = _getFile($session, $folder, $params->{id});

    return '' unless $file;

    my $addToZoneId = "jsi18n:".( ($plugin) ? $plugin : $params->{folder} ).":$params->{id}";

    # Note: we do not use Foswiki::Func::addToZone, so we do not mess with SafeWikiPlugin
    return '%ADDTOZONE{"script" id="'.$addToZoneId.'" requires="%JSI18NID%" text="<script src=\'%PUBURLPATH%/'.$file.'\'></script>"}%';
}

sub _JSI18NIDTAG {
    #my($session, $params, $topic, $web, $topicObject) = @_;

    my $id = 'jsi18nCore';
    Foswiki::Func::addToZone('script', $id, <<'SCRIPT', 'JQUERYPLUGIN::FOSWIKI::PREFERENCES');
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
