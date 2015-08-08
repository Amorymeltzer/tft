#!/usr/bin/env perl

use strict;
use warnings;

# Hash Dispatch Table
my %opponents = (
		 titFORtat => \&titFORtat,
		 coOp => \&coOp,
		 defect => \&defect,
		 random => \&random,
		 tranquilizer => \&tranquilizer
		);

# build Reward/Punishment tables
my %rewardTit = (
		 C => {C => 3, D => 0},
		 D => {C => 5, D => 1}
		);

my %rewardOpp = (
		 C => {C => 3, D => 0},
		 D => {C => 5, D => 1}
		);

# titFORtat, coOp, defect, random, tranquilizer
my $opponent = 'tranquilizer';
my $turn = 0;
my $trials = 200;
my $choice = 'C';
my ($titScore, $oppScore) = (0,0);

print "turn\ttFt\t$opponent\n\n";
foreach my $trial (1..$trials) {
  $turn++;
  my $tit = titFORtat($choice);
  $choice = $opponents{$opponent}($choice);
  $titScore = $titScore + $rewardTit{$tit}{$choice};
  $oppScore = $oppScore + $rewardOpp{$choice}{$tit};
  print "$turn\t$tit\t$choice\n";
}
my $diff = $titScore - $oppScore;
print "\nScore:\t$titScore\t$oppScore\t$diff\n";

sub titFORtat
  {
    my $result = shift(@_);
    if ($turn == 1) {
      $result = 'C';
    }
    return $result;
  }

sub coOp
  {
    my $result = 'C';
    return $result;
  }

sub defect
  {
    my $result = 'D';
    return $result;
  }

sub random
  {
    my $result;
    my $rand = rand(1);
    if ($rand <= .5) {
      $result = 'C';
    } else {
      $result = 'D';
    }
    return $result;
  }

sub tranquilizer
  {
    my $result;
    my $threshold = .2;
    my $rand = rand(1);
    if ($turn == 1) {
      $result = 'C';
    } elsif ($rand < $threshold) {
      $result = 'D';
    } elsif ($rand >= $threshold) {
      $result = 'C';
    }
    return $result;
  }
