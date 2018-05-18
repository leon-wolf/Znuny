#!/usr/bin/perl
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.GetConfig',
    },
);

# print wanted var
my $Key = shift || '';
if ($Key) {
    chomp $Key;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( ref( $ConfigObject->{$Key} ) eq 'ARRAY' ) {
        for ( @{ $ConfigObject->{$Key} } ) {
            print "$_;";
        }
        print "\n";
    }
    elsif ( ref( $ConfigObject->{$Key} ) eq 'HASH' ) {
        for my $SubKey ( sort keys %{ $ConfigObject->{$Key} } ) {
            print "$SubKey=$ConfigObject->{$Key}->{$SubKey};";
        }
        print "\n";
    }
    else {
        print $Kernel::OM->Get('Kernel::Config')->{$Key} . "\n";
    }
}
else {

    # print all vars
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    for ( sort keys %{$ConfigObject} ) {
        print $_. ":";
        if ( ref( $ConfigObject->{$_} ) eq 'ARRAY' ) {
            for ( @{ $ConfigObject->{$_} } ) {
                print "$_;";
            }
            print "\n";
        }
        elsif ( ref( $ConfigObject->{$_} ) eq 'HASH' ) {
            for my $Key ( sort keys %{ $ConfigObject->{$_} } ) {
                print "$Key=$ConfigObject->{$_}->{$Key};";
            }
            print "\n";
        }
        else {
            print $ConfigObject->{$_} . "\n";
        }
    }
}