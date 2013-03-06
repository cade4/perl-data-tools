##############################################################################
#
#  Data::Tools perl module
#  (c) Vladi Belperchinov-Shabanski "Cade" 2013
#  http://cade.datamax.bg
#  <cade@bis.bg> <cade@biscom.net> <cade@datamax.bg> <cade@cpan.org>
#
#  GPL
#
##############################################################################
package Data::Tools;

use Exporter;
@ISA    = qw( Exporter );
@EXPORT = qw(
              file_save
              file_load
              
              dir_path_make
              dir_path_ensure

              str2hash 
              hash2str
              
              hash_save
              hash_load

              str_url_escape 
              str_url_unescape 
              str_hex 
              str_unhex
              
              url2hash
              
              perl_package_to_file

            );
use strict;

##############################################################################

sub load_file
{
  my $fn = shift; # file name
  
  my $i;
  open( $i, $fn ) or return undef;
  local $/ = undef;
  my $s = <$i>;
  close $i;
  return $s;
}

sub save_file
{
  my $fn = shift; # file name

  my $o;
  open( $o, ">$fn" ) or return 0;
  print $o @_;
  close $o;
  return 1;
}

##############################################################################

sub dir_path_make
{
  my $path = shift;
  my %opt = @_;

  my $mask = $opt{ 'MASK' } || oct('700');
  
  my $abs;

  $path =~ s/\/+$/\//o;
  $abs = '/' if $path =~ s/^\/+//o;

  my @path = split /\/+/, $path;

  $path = $abs;
  for my $p ( @path )
    {
    $path .= "$p/";
    next if -d $path;
    mkdir( $path, $mask ) or return 0;
    }
  return 1;
}

sub dir_path_ensure
{
  my $dir = shift;
  my %opt = @_;

  dir_path_make( $dir, $opt{ 'MASK' } ) unless -d $dir;
  return undef unless -d $dir;
  return $dir;
}

##############################################################################
#   url-style escape & hex escape
##############################################################################

our $URL_ESCAPES_DONE;
our %URL_ESCAPES;
our %URL_ESCAPES_HEX;

sub __url_escapes_init
{
  return if $URL_ESCAPES_DONE;
  for ( 0 .. 255 ) { $URL_ESCAPES{ chr( $_ )     } = sprintf("%%%02X", $_); }
  for ( 0 .. 255 ) { $URL_ESCAPES_HEX{ chr( $_ ) } = sprintf("%02X",   $_); }
  $URL_ESCAPES_DONE = 1;
}

sub str_url_escape
{
  my $text = shift;
  
  $text =~ s/([^ -\$\&-<>-~])/$URL_ESCAPES{$1}/gs;
  return $text;
}

sub str_url_unescape
{
  my $text = shift;
  
  $text =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/ge;
  return $text;
}

sub str_hex
{
  my $text = shift;
  
  $text =~ s/(.)/$URL_ESCAPES_HEX{$1}/gs;
  return $text;
}

sub str_unhex
{
  my $text = shift;
  
  $text =~ s/([0-9A-F][0-9A-F])/chr(hex($1))/ge;
  return $text;
}

##############################################################################

sub str2hash
{
  my $str = shift;
  
  my %h;
  for( split( /\n/, $str ) )
    {
    $h{ str_unescape( $1 ) } = str_unescape( $2 ) if ( /^([^=]+)=(.*)$/ );
    }
  return \%h;
}

sub hash2str
{
  my $hr = shift; # hash reference

  my $s = "";
  while( my ( $k, $v ) = each %$hr )
    {
    $k = str_escape( $k );
    $v = str_escape( $v );
    $s .= "$k=$v\n";
    }
  return $s;
}

##############################################################################

sub hash_save
{
  my $fn = shift;
  # @_ array of hash references
  my $data;
  $data .= hash2str( $_ ) for @_;
  return save_file( $fn, $data );
}

sub hash_load
{
  my $fn = shift;
  
  return str2hash( load_file( $fn ) );
}

##############################################################################

sub perl_package_to_file
{
  my $s = shift;
  $s =~ s/::/\//g;
  $s .= '.pm';
  return $s;
}

##############################################################################

BEGIN { __url_escapes_init(); }
INIT  { __url_escapes_init(); }

##############################################################################

=pod



=cut

##############################################################################
1;
