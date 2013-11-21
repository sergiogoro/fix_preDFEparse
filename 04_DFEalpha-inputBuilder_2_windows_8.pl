#!/usr/bin/env perl

# Sergio González <sergiogoro86@gmail.com>
# This program will take inputs (define) and create an output file suitable for uploading to DFE-alpha server (ref)
# The inputs will be read by windows, and so, several output files will be created, one for each window.

use strict; use warnings; use feature 'say'; use Getopt::Long; use List::Util qw(sum); use Data::Dumper;

my $help = undef;
my $inputFile;

usage() if (
    @ARGV < 1 or
    !GetOptions(
        'help|h|?'  =>  \$help,
        'input=s'   =>  \$inputFile,
    ) or defined $help);

sub usage {say "Usage: $0 --input <input file> [-help]"};

open (my $inputFile_fh, "<", "$inputFile") or die "Couldn't open $inputFile $!";

my @window_0f = ();
my @window_4f = ();
#my @m_Dmel_0f = ();
#my @m_Dmel_4f = ();
#my @m_Dyak_0f = ();
#my @m_Dyak_4f = ();
#my @totalPol_0f = ();
#my @totalPol_4f = ();
#my @divergents_0f = ();
#my @divergents_4f = ();
my @vectorSFS_0f = ();
my @vectorSFS_4f = ();
my @final_vectorSFS_0f = ();
my @final_vectorSFS_4f = ();
my $counter_0f = 0;
my $counter_4f = 0;
#my @AoA_0f;
#my @AoA_4f;
my ($numElementsVectorSFS_0f, $numElementsVectorSFS_4f) = (0, 0);
my %HoA_0f;
my %HoA_4f;

my @splitted = ();
while (my $line = <$inputFile_fh>) {
  chomp($line);
  @splitted = split "\t" , $line;
  @vectorSFS_0f = ();
  @vectorSFS_4f = ();
  my ($xfold, $chr_state) = (split "-", $splitted[2]);
  if ($xfold == 0) {
    my $window_0f = $splitted[1];
    #say "~~0f~~ $window_0f";
    push @window_0f, $window_0f;
    my ($m_Dmel_0f, $m_Dyak_0f) = (split "-", $splitted[3]);
    #say "\$m_Dmel_0f <$m_Dmel_0f>\t\$m_Dyak_0f <$m_Dyak_0f>";
    #push @m_Dmel_0f, $m_Dmel_0f;
    #push @m_Dyak_0f, $m_Dyak_0f;
    my ($totalPol_0f, $divergents_0f) = (split "-", $splitted[5]);
    #say "\$totalPol_0f <$totalPol_0f>\t\$divergents_0f <$divergents_0f>";
    #push @totalPol_0f, $totalPol_0f;
    #push @divergents_0f, $divergents_0f;
    (@vectorSFS_0f) =  (split ":", $splitted[8]);
    #@{ $AoA_0f[$counter_0f] } = @vectorSFS_0f;

    $HoA_0f{$window_0f} = {
      "m_Dmel_0f"     => $m_Dmel_0f,
      "m_Dyak_0f"     => $m_Dyak_0f,
      "totalPol_0f"   => $totalPol_0f,
      "divergents_0f" => $divergents_0f,
      "vectorSFS_0f" => \@vectorSFS_0f,
    };
    $counter_0f++;

  } elsif ($xfold == 4) {
    my $window_4f = $splitted[1];
    #say "~~4f~~ $window_4f";
    push @window_4f, $window_4f;
    my ($m_Dmel_4f, $m_Dyak_4f) = (split "-", $splitted[3]);
    #say "\$m_Dmel_4f <$m_Dmel_4f>\t\$m_Dyak_4f <$m_Dyak_4f>";
    #push @m_Dmel_4f, $m_Dmel_4f;
    #push @m_Dyak_4f, $m_Dyak_4f;
    my ($totalPol_4f, $divergents_4f) = (split "-", $splitted[5]);
    #say "\$totalPol_4f <$totalPol_4f>\t\$divergents_4f <$divergents_4f>";
    #push @totalPol_4f, $totalPol_4f;
    #push @divergents_4f, $divergents_4f;
    (@vectorSFS_4f) = (split ":", $splitted[8]);
    #@{ $AoA_4f[$counter_4f] } = @vectorSFS_4f;

    $HoA_4f{$window_4f} = {
      "m_Dmel_4f"     => $m_Dmel_4f,
      "m_Dyak_4f"     => $m_Dyak_4f,
      "totalPol_4f"   => $totalPol_4f,
      "divergents_4f" => $divergents_4f,
      "vectorSFS_4f" => \@vectorSFS_4f,
    };
    $counter_4f++;
  }
  #say "-"x10;
}

#say "0";
#print Dumper \%HoA_0f;
#
#say "4";
#print Dumper \%HoA_4f;
#exit;


# Open & print to output files
my $counter_out_0f = 0;
my $counter_out_4f = 0;

my @arr = ( scalar(@window_0f) <= scalar (@window_4f) )     # Ensure to select the smaller one. (To work only with windows shared between 0f and 4f)
  ? (@window_0f)
  : (@window_4f);

#foreach my $window (@window_0f) {          # This line would mess up things in case: (number of 0f windows) != (number of 4f windows).
foreach my $window (@arr) {                 # This line works, will traverse all the windows that have 0f and 4f. Discarding those that have one but not the other
  #say "WINDOW: <$window>";
  my $outputFile = $inputFile . "_DFE-alpha_" . $window;
  open my $outputFile_fh, '>', $outputFile or die "Couldn't open output file '$outputFile' $!\n";

  say $outputFile_fh "1";
  say $outputFile_fh "1";
  say $outputFile_fh "128";
  say $outputFile_fh "1";

  # Print Total Selective
  #say $outputFile_fh $m_Dyak_0f[$counter_out_0f];
  #say $outputFile_fh $totalPol_0f[$counter_out_0f];
  say $outputFile_fh $HoA_0f{$window}{totalPol_0f};

  # Print Divergents Selective
  #say $outputFile_fh $divergents_0f[$counter_out_0f];
  say $outputFile_fh $HoA_0f{$window}{divergents_0f};

  # Print Total neutral # SUM m_Dyak_4f
  #say $outputFile_fh $m_Dyak_4f[$counter_out_4f];
  #say $outputFile_fh $totalPol_4f[$counter_out_4f];
  say $outputFile_fh $HoA_4f{$window}{totalPol_4f};

  # Print Divergents Neutral
  #say $outputFile_fh $divergents_4f[$counter_out_4f];
  say $outputFile_fh $HoA_4f{$window}{divergents_4f};

  # Calculate header Selective
  my $sumVectorSFS_0f = 0;
  #foreach (@{ $AoA_0f[$counter_out_0f] } ) {
  foreach ( @{ $HoA_0f{$window}{vectorSFS_0f} } ) {
    $sumVectorSFS_0f += $_;
  }
  #my $header_0f = ($m_Dmel_0f[$counter_out_0f]) - $sumVectorSFS_0f;
  my $header_0f = ($HoA_0f{$window}{m_Dmel_0f}) - $sumVectorSFS_0f;

  # Print header Selective   # not newline, header followed by SFSselective vector
  print $outputFile_fh $header_0f ;

  # Format Selective SFS vector
  @final_vectorSFS_0f = ();
  @final_vectorSFS_0f = ( (0) x 128 );    # First, fill vector with 127 zeros!
  foreach my $j ( 0 .. scalar(@{ $HoA_0f{$window}{vectorSFS_0f} })-1 ) {   # Then, fill vector with corresponding values
    #$final_vectorSFS_0f[$j] = $vectorSFS_0f[$j];
    $final_vectorSFS_0f[$j] = $HoA_0f{$window}{vectorSFS_0f}[$j];
  }

  # Print Selective SFS vector
  foreach (@final_vectorSFS_0f) {
    print $outputFile_fh " $_";
  }
  print $outputFile_fh " \n";

  # Calculate header Neutral
  my $sumVectorSFS_4f = 0;
  #foreach ( @{ $AoA_4f[$counter_out_4f] } ) {
  foreach ( @{ $HoA_4f{$window}{vectorSFS_4f} } ) {
    $sumVectorSFS_4f += $_;
  }
  #my $header_4f = ($m_Dmel_4f[$counter_out_4f]) - $sumVectorSFS_4f;
  my $header_4f = ($HoA_4f{$window}{m_Dmel_4f}) - $sumVectorSFS_4f;

  # Print header Neutral   # not newline, header followed by SFSselective vector
  print $outputFile_fh $header_4f ;

  # Format Neutral SFS vector
  @final_vectorSFS_4f = ();
  @final_vectorSFS_4f = ( (0) x 128 );    # First, fill vector with 127 zeros!
  #foreach my $k ( 0 .. scalar(@vectorSFS_4f)-1 ) {   # Then, fill vector with corresponding values
  foreach my $k ( 0 .. scalar(@{ $HoA_4f{$window}{vectorSFS_4f} })-1 ) {   # Then, fill vector with corresponding values
    #$final_vectorSFS_4f[$k] = $vectorSFS_4f[$k];
    $final_vectorSFS_0f[$k] = $HoA_0f{$window}{vectorSFS_0f}[$k];
  }
  # Print Neutral SFS vector
  foreach (@final_vectorSFS_4f) {
    print $outputFile_fh " $_";
  }
  print $outputFile_fh " \n";

  $counter_out_0f++;
  $counter_out_4f++;
  close $outputFile_fh;
}

