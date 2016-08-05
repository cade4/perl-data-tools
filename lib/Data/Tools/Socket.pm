##############################################################################
#
#  Data::Tools perl module
#  (c) Vladi Belperchinov-Shabanski "Cade" 2013-2016
#  http://cade.datamax.bg
#  <cade@bis.bg> <cade@biscom.net> <cade@datamax.bg> <cade@cpan.org>
#
#  GPL
#
##############################################################################
package Data::Tools::Socket;
use strict;
use Exporter;
use IO::Select;
use Time::HiRes qw( time );

our $VERSION = '1.11';

our @ISA    = qw( Exporter );
our @EXPORT = qw(
                  socket_read
                  socket_write
                  socket_print

                  socket_read_message
                  socket_write_message
                );

##############################################################################

sub socket_read
{
   my $sock    = shift;
   my $data    = shift;
   my $readlen = shift;
   my $timeout = shift || undef;
   
   my $stime = time();

   my $iosel = IO::Select->new();
   $iosel->add( $sock );
   
   my $rlen = $readlen;
#print STDERR "SOCKET_READ: rlen [$rlen]\n";
   while( $rlen > 0 )
     {
     my @ready = $iosel->can_read( $timeout );
     return undef if @ready == 0 or ( $timeout > 0 and time() - $stime > $timeout );
     
     my $part;
     my $plen = $sock->sysread( $part, $rlen );
     
     return undef if $plen <= 0;
     
     $$data .= $part;
     $rlen -= $plen;
#print STDERR "SOCKET_READ: part [$part] [$plen] [$rlen]\n";
     }

#print STDERR "SOCKET_READ: incoming data [$$data]\n";
   
  return $readlen - $rlen;
}

sub socket_write
{
   my $sock     = shift;
   my $data     = shift;
   my $writelen = shift;
   my $timeout  = shift || undef;
   
   my $stime = time();

   my $iosel = IO::Select->new();
   $iosel->add( $sock );
   
#print STDERR "SOCKET_WRITE: outgoing data [$data]\n";
   my $wpos = 0;
   while( $wpos < $writelen )
     {
     my @ready = $iosel->can_write( $timeout );
     return undef if @ready == 0 or ( $timeout > 0 and time() - $stime > $timeout );
 
     my $part;
     my $plen = $sock->syswrite( $data, $writelen - $wpos, $wpos );
#print STDERR "SOCKET_WRITE: part [$plen]\n";
     
     return undef if $plen <= 0;
     
     $wpos += $plen;
     }
   
#print STDERR "SOCKET_WRITE: part [$wpos] == writelen [$writelen]\n";
  return $wpos;
}

sub socket_print
{
   my $sock     = shift;
   my $data     = shift;
   my $timeout  = shift || undef;
   
   socket_write( $sock, $data, length( $data ), $timeout );
}

##############################################################################

sub socket_read_message
{
  my $sock = shift;
   
  my $data_len_N32;
  my $rc_data_len = socket_read( $sock, \$data_len_N32, 4 );
  if( $rc_data_len == 0 )
    {
    # end of comms
    return undef;
    }
  my $data_len = unpack( 'N', $data_len_N32 );
  if( $rc_data_len != 4 or $data_len < 0 or $data_len >= 2**32 )
    {
    # ivalid length
    return undef;
    }
  if( $data_len == 0 )
    {
    return "";
    }

  my $read_data;
  my $res_data_len = socket_read( $sock, \$read_data, $data_len );
  if( $res_data_len != $data_len )
    {
    # invalid data len received
    return undef;
    }
  
  return $data;
}

sub socket_write_message
{
  my $sock = shift;
  my $data = shift;
  
  # FIXME: utf?
  my $data_len = length( $data );
  my $res_data_len = socket_write( $sock, pack( 'N', $data_len ) . $data, 4 + $data_len );
  if( $res_data_len != 4 + $data_len )
    {
    # invalid data len sent
    return undef;
    }

  return 1;
}

##############################################################################
1;
###EOF########################################################################

