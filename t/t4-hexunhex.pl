#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use Data::Tools;
use Data::Tools::Time;
use Time::HiRes qw( time );


my $text = substr( file_bin_load( '/tmp/big.txt' ), 0, 124 );

my $cnt = 1000;
my $hex;

my $s = time;
$hex = Data::Tools::str_hex( $text ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

my $s = time;
$hex = Data::Tools::str_hex2( $text ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

#print Data::Tools::str_hex( $text ). "\n";
#print Data::Tools::str_hex2( $text ). "\n";

print "YES OK 1\n" if Data::Tools::str_hex2( $text ) eq Data::Tools::str_hex( $text );

$hex = uc $hex;
#print "HEX[$hex]\n\n";


my $s = time;
my $text = Data::Tools::str_unhex( $hex ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

my $s = time;
my $text = Data::Tools::str_unhex2( $hex ) for 1..$cnt;
my $e = time() - $s;
print ( str_num_comma( $cnt / $e ) . " cps\n" );

#print Data::Tools::str_unhex( $hex ). "\n";
#print Data::Tools::str_unhex2( $hex ). "\n";

print "YES OK 2\n" if Data::Tools::str_unhex( $hex ) eq Data::Tools::str_unhex2( $hex );
